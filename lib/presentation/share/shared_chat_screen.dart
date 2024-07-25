import 'package:chatbot_text_tool/models/shared_chat_message.dart';
import 'package:chatbot_text_tool/presentation/chat/receiver_message.dart';
import 'package:chatbot_text_tool/presentation/chat/sender_message.dart';
import 'package:chatbot_text_tool/presentation/common/nothing_to_show.dart';
import 'package:chatbot_text_tool/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/slammie_bot_response.dart';
import '../../models/user.dart';
import '../../service/ApiService.dart';
import '../../service/shared_pref_service.dart';
import '../../service/user_service.dart';

class SharedChatScreen extends StatefulWidget {

  final bool fromDashboard;
  final String? token;
  const SharedChatScreen({super.key, this.fromDashboard = false, this.token});

  @override
  State<SharedChatScreen> createState() => _SharedChatScreenState();
}

class _SharedChatScreenState extends State<SharedChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _chatCollection = FirebaseFirestore.instance.collection('shared_chat_message');


  UserModel? currentUser;
  late ApiService apiService;
  bool isLoading = false;
  String errorMessage = '';
  Map<String,dynamic>? currentWorkSpace= {};

  @override
  void initState(){
    _getCurrentUser();
    apiService = ApiService();
    super.initState();
  }


  Future<Map<String, dynamic>?> _getCurrentSharedChat() async{
      try{
        final result=  await FirebaseFirestore.instance
            .collection('shared_chats')
            .doc(widget.token)
            .get();
        return result.data();
      }catch(e){
        return null;
      }
  }

  Future<Map<String, dynamic>?> _getCurrentWorkSpace(String id) async{
    try{
      final result=  await FirebaseFirestore.instance
          .collection('workspaces')
          .doc(id)
          .get();
      return result.data();
    }catch(e){
      return null;
    }
  }

  Future<void> _getCurrentUser() async {
    currentUser = await SessionManager.getUser();
    if (currentUser != null) {
      setState(() {});
    }
  }

  Future<void> fetchResponse(String message) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
       final response = await apiService.slammieChatBot(message,
          url: currentWorkSpace?['url'],
          authentication: currentWorkSpace?['authentication']);

        final messageData = SharedChatMessage(
          message: response.text ?? "",
          createdTime: Timestamp.now(),
          createdBy: UserService().getUserReference(),
          isBotMessage: true,
          sharedChatId: widget.token ?? "",
        );

        try {
          await FirebaseFirestore.instance
              .collection('shared_chat_message')
              .add(messageData.toMap());

        } catch (e) {
          debugPrint('Error sending message: $e');
        }
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

  Future<void> sendMessage() async {
    final messageText = _controller.text;

    if (messageText.isEmpty) {
      return;
    }

    final messageData = SharedChatMessage(
      message: messageText,
      createdTime: Timestamp.now(),
      createdBy: UserService().getUserReference(),
      isBotMessage: false,
      sharedChatId: widget.token ?? "",
    );

    try {
      await FirebaseFirestore.instance
          .collection('shared_chat_message')
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

    return FutureBuilder(future: _getCurrentSharedChat(), builder: (context, currentSharedChatObj){
      return currentSharedChatObj.data != null ? FutureBuilder(
          future: _getCurrentWorkSpace(currentSharedChatObj.data?['workspaceRef'] ?? ""),
          builder: (context, currentWorkSpaceObj){
            currentWorkSpace = currentWorkSpaceObj.data;
            final workSpaceColor = currentWorkSpaceObj.data?["workSpaceColor"] ?? "0xFF000000";

            return currentSharedChatObj.data != null ?
            Scaffold(
              appBar: AppBar(
                elevation: 5,
                centerTitle: true,
                backgroundColor: Color(int.parse(workSpaceColor)),
                title: Text(currentWorkSpaceObj.data?['name'] ?? "Shared Chat"),
              ),
              body: Container(color: AppColors.backgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _chatCollection
                            .where("sharedChatId", isEqualTo: widget.token ?? "")
                            .orderBy('createdTime', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return  Center(
                                child: Text('Error fetching data ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No messages to show'),
                              );
                            } else {
                              final messages =
                                  snapshot.data!.docs.map((doc) {
                                return SharedChatMessage.fromMap(doc
                                    .data() as Map<String, dynamic>);
                              }).toList();

                              return ListView.builder(
                                reverse: true,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index];
                                  if (!message.isBotMessage) {
                                    return SenderMessage(
                                      text: message.message,
                                      timestamp: message.createdTime!,
                                    );
                                  } else {
                                    return ReceiverMessage(
                                      text: message.message,
                                      timestamp: message.createdTime!,
                                    );
                                  }
                                },
                              );
                            }
                          },
                      ),
                    ),
                    if (!widget.fromDashboard &&
                        (widget.token != null && widget.token?.isNotEmpty == true) &&
                        currentSharedChatObj.data?['status'] == true
                        && currentWorkSpaceObj.data?['url'] != null
                    )
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
              ),
            ): const Center(
              child: CircularProgressIndicator(),
            );
          }
      ) : const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}