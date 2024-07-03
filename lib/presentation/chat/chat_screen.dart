import 'package:chatbot_text_tool/models/user.dart';
import 'package:chatbot_text_tool/presentation/chat/receiver_message.dart';
import 'package:chatbot_text_tool/presentation/chat/sender_message.dart';
import 'package:chatbot_text_tool/presentation/chat/workflow_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/shared_pref_service.dart';
import '../../service/user_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserModel? currentUser;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  Future<void> _getCurrentUser() async {
    currentUser = await SessionManager.getUser();
    if (currentUser != null) {} else {}
  }

  final List<Map<String, String>> messages = [
    {
      'text': 'Hello! How are you?',
      'sender': 'receiver',
      'timestamp': '10:00 AM',
    },
    {
      'text': 'I\'m good, thanks! How about you?',
      'sender': 'user',
      'timestamp': '10:01 AM',
    },
  ];

  final TextEditingController _controller = TextEditingController();
  static const String _user = 'user';
  static const String _timestamp =
      '10:02 AM'; // Static timestamp for simplicity

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      messages.add({
        'text': text,
        'sender': _user,
        'timestamp': _timestamp,
      });
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: _buildDrawer(),
      body: FutureBuilder<UserModel?>(
        future: SessionManager.getUser(),
        builder: (context, snapshot){
          return snapshot.data?.primaryWorkSpace?.isNotEmpty == true ? mainBody() : _emptyWorkflowWidget();
        },
      )
    );
  }

  Widget mainBody(){
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isUser = message['sender'] == _user;
              return isUser
                  ? SenderMessage(
                text: message['text']!,
                timestamp: message['timestamp']!,
              )
                  : ReceiverMessage(
                text: message['text']!,
                timestamp: message['timestamp']!,
              );
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
                    _sendMessage();
                  },
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: _sendMessage,
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyWorkflowWidget(){
    return Container(
      padding: const EdgeInsets.all(32.0),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You don\'t have any workflows yet!\n'
                'Please create one to start testing your Chat bot APIs.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // background color
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            ),
            child: const Text(
              'Create First Workspace',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const DrawerHeader(
              decoration: BoxDecoration(
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
                      fontSize: 18,
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
                    return const WorkflowDialog();
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
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('workspaces').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/nothing_to_show.jpg",
                          width: 300,
                          height: 200,
                        ),
                        const Text(
                          'Nothing to show',
                          style: TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                      ],
                    ),
                  );
                }

                // Filter the documents where userRef matches
                final filteredDocs = snapshot.data!.docs.where((doc) {
                  return doc["userRef"] == UserService().getUserReference();
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/nothing_to_show.jpg",
                          width: 300,
                          height: 200,
                        ),
                        const Text(
                          'Nothing to show',
                          style: TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                      ],
                    ),
                  );
                }

                // If there are matching documents, display the list
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      print("chatbot value ${doc.reference.id}");
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: currentUser?.primaryWorkSpace == doc.reference.id
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
                              //this will update in firebase
                              await userRef.update({
                                'primaryWorkSpace': workspaceRef,
                              });
                              //local storage
                              await SessionManager.updateUserWorkSpace(
                                  workSpaceReferance: workspaceRef.id);
                              // Pop the current screen
                              Navigator.pop(context);
                              // Update the current user state
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
                            title: Text(filteredDocs[index]["name"] ?? ""),
                          ),
                        ),
                      );
                    },
                  ),
                );

              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
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
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                // Perform logout actions here
                // Clear the list of messages
                setState(() {
                  SessionManager.clearUser();
                  messages.clear();
                });
                // Navigate to the login page (replace with your login route)
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}