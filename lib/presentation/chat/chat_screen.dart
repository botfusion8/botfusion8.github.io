import 'package:chatbot_text_tool/models/messages.dart';
import 'package:chatbot_text_tool/models/user.dart';
import 'package:chatbot_text_tool/presentation/chat/receiver_message.dart';
import 'package:chatbot_text_tool/presentation/chat/sender_message.dart';
import 'package:chatbot_text_tool/presentation/chat/workspace_dialog.dart';
import 'package:chatbot_text_tool/presentation/settings/settings_screen.dart';
import 'package:chatbot_text_tool/utils/captalize_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/slammie_bot_response.dart';
import '../../service/ApiService.dart';
import '../../service/shared_pref_service.dart';
import '../../service/user_service.dart';
import '../common/app_logo_horizontal.dart';
import '../common/nothing_to_show.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserModel? currentUser;
  final TextEditingController _controller = TextEditingController();
  late ApiService apiService;
  SlammieBotResponse? response;
  bool isLoading = false;
  String errorMessage = '';
  late DocumentSnapshot<Object?>? currentWorkspace;

  @override
  void initState() {
    _getCurrentUser();
    apiService = ApiService();
    super.initState();
  }

  Future<void> fetchResponse(String message) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final workspaceData = currentWorkspace!.data() as Map<String, dynamic>;
      debugPrint('${workspaceData.containsKey('chatId')} workspace Data list');

      final result = await apiService.slammieChatBot(message,
          url: currentWorkspace?['url'],
          authToken: currentWorkspace?['tokenHeader'],
          sessionId: workspaceData.containsKey('chatId') ? currentWorkspace!['chatId'] : '');
      setState(() async {
        response = result;
        final messageData = Message(
          chatId: response?.chatId ?? "",
          message: response?.text ?? "",
          createdTime: Timestamp.now(),
          chatSessionRef: currentUser?.primaryWorkSpace,
          createdBy: UserService().getUserReference(),
          isBotMessage: true,
        );

        try {
          await FirebaseFirestore.instance
              .collection('messages')
              .add(messageData.toMap());

          debugPrint('Message sent successfully!');


          if (!workspaceData.containsKey('chatId')) {
            await currentWorkspace!.reference.update({
              'chatId': response?.chatId ?? "",
            });
            debugPrint('Key updated successfully!');
          }
        } catch (e) {
          debugPrint('Error sending message: $e');
        }
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getCurrentUser() async {
    currentUser = await SessionManager.getUser();
    if (currentUser != null) {
      setState(() {});
    }
  }

  Future<void> sendMessage() async {
    final messageText = _controller.text;

    if (messageText.isEmpty) {
      return;
    }

    final messageData = Message(
      chatId: '',
      message: messageText,
      createdTime: Timestamp.now(),
      chatSessionRef: currentUser?.primaryWorkSpace,
      createdBy: UserService().getUserReference(),
      isBotMessage: false,
    );

    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .add(messageData.toMap());
      fetchResponse(_controller.text);
      _controller.clear();
      debugPrint('Message sent successfully!');
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: SessionManager.getUser(),
      builder: (context, snapshot) {
        return snapshot.data?.primaryWorkSpace?.isNotEmpty == true
            ? mainBody(snapshot.data!.primaryWorkSpace ?? "")
            : _emptyWorkflowWidget();
      },
    );
  }

  Widget mainBody(String primaryWorkSpaceID) {
    return FutureBuilder<DocumentSnapshot?>(
      future: FirebaseFirestore.instance
          .collection('workspaces')
          .doc(primaryWorkSpaceID)
          .get(),
      builder: (context, snapshot) {
        final workSpaceName = snapshot.data?["name"] ?? "";
        final workSpaceColor = snapshot.data?["workSpaceColor"] ?? "0xFF000000";
        currentWorkspace = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            elevation: 5,
            centerTitle: true,
            backgroundColor: Color(int.parse(workSpaceColor)),
            title: Text(
              workSpaceName.toString().capitalize()!,
            ),
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(Icons.edit_note,size: 35,),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return WorkspaceDialog(
                          name: snapshot.data?["name"],
                          url: snapshot.data?['url'],
                          authentication: snapshot.data?['authentication'],
                          workspaceColor: snapshot.data?['workSpaceColor'],
                          workspaceId: snapshot.data?.id,
                        );
                      },
                    );
                  },
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.only(right: 10),
              //   child: IconButton(
              //     icon: const Icon(Icons.delete_outlined),
              //     onPressed: deleteChats,
              //   ),
              // ),
            ],
          ),
          drawer: _buildDrawer(),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .where('chatSessionRef', isEqualTo:currentUser?.primaryWorkSpace)
                      .orderBy('createdTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error fetching data'),
                      );
                    }else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No messages to show'),
                      );
                    }else{
                      if (snapshot.data!.docs.isEmpty) {
                        return const NothingToShow();
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final message = Message.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                          return message.isBotMessage
                              ? ReceiverMessage(
                            text: message.message,
                            timestamp: message.createdTime!,
                          )
                              : SenderMessage(
                            text: message.message,
                            timestamp: message.createdTime!,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onSubmitted: (value) {
                          sendMessage();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: sendMessage,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _emptyWorkflowWidget() {
    return Scaffold(
      appBar: AppBar(elevation: 5, centerTitle: true),
      drawer: _buildDrawer(),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFF39D2C0).withAlpha(30),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Colors.grey.withAlpha(70),
              )),
          padding: const EdgeInsets.all(32.0),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const AppLogoHorizontal(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'You don\'t have any workflows yet!\n'
                'Please create one to start testing your Chat bot APIs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30.0),
              InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return WorkspaceDialog(workspaceId: null);
                    },
                  );
                },
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF39D2C0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    'Create first workspace',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDB91B9), Color(0xFF39D2C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bug_report, size: 60, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    'ChatTestify',
                    style: GoogleFonts.playball(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black87,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return WorkspaceDialog(workspaceId: null);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create workspace',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.add, color: Colors.black87),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('workspaces')
                  .where("userRef", isEqualTo:UserService().getUserReference())
                  .orderBy("lastUpdatedTime",descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                }else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const NothingToShow();
                }else{
                  if (snapshot.data!.docs.isEmpty) {
                    return const NothingToShow();
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color:
                            currentUser?.primaryWorkSpace == doc.reference.id
                                ? const Color(0Xff39d2c0).withAlpha(100)
                                : Colors.transparent,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              final workspaceId = doc.id;
                              final workspaceRef = FirebaseFirestore.instance
                                  .collection('workspaces')
                                  .doc(workspaceId);
                              final userRef = UserService().getUserReference();
                              try {
                                await userRef.update({
                                  'primaryWorkSpace': workspaceRef,
                                });
                                await SessionManager.updateUserWorkSpace(
                                    workSpaceReferance: workspaceRef.id);
                                Navigator.pop(context);
                                setState(() {
                                  _getCurrentUser();
                                });
                              } catch (e) {
                                print("Error updating workspace: $e");
                              }
                            },
                            child: ListTile(
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                              title: Text(
                                    doc["name"]
                                    .toString()
                                    .capitalize() ??
                                    "",
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                setState(() {
                  SessionManager.clearUser();
                });
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteChats() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              "Are you sure you want to delete all chats? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
