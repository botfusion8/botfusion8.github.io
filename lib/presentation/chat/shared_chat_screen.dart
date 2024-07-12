import 'package:chatbot_text_tool/models/shared_chat_message.dart';
import 'package:chatbot_text_tool/presentation/chat/receiver_message.dart';
import 'package:chatbot_text_tool/presentation/chat/sender_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/slammie_bot_response.dart';
import '../../models/user.dart';
import '../../service/ApiService.dart';
import '../../service/shared_pref_service.dart';
import '../../service/user_service.dart';

class SharedChatScreen extends StatefulWidget {
  const SharedChatScreen({super.key});

  @override
  State<SharedChatScreen> createState() => _SharedChatScreenState();
}

class _SharedChatScreenState extends State<SharedChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _chatCollection = FirebaseFirestore.instance.collection('shared_chat_message');


  UserModel? currentUser;
  late ApiService apiService;
  SlammieBotResponse? response;
  bool isLoading = false;
  String errorMessage = '';
  late DocumentSnapshot<Object?>? currentWorkspace;
  //late DocumentSnapshot<Object?>? currentSharedChat;
  Map<String, dynamic> currentSharedChat = {};

  @override
  void initState() {
    _getCurrentUser();
    apiService = ApiService();
    _getCurrentSharedChat();
    super.initState();
  }


  Future<void> _getCurrentSharedChat() async{
    setState(() async{
      final result=  await FirebaseFirestore.instance
          .collection('shared_chat')
          .doc('wRgioe5YwAbtOIzEavHx')
          .get();
      currentSharedChat =  result.data() as Map<String,dynamic>;
    });
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

      final result = await apiService.slammieChatBot(message,
          url: "https://fusionflow.maslow.ai/api/v1/prediction/4bddea5e-c392-4dbe-bd05-3ef2aa60942d",
          authentication:{
             "key" : "Authorization",
            "token":"vWxybfzjsUPjB2i4+/uoLrC6BMxvfXUD71o8hZWnf9Y=",
            "type":"Bearer"
          });
      print("resultResponse $result");
      setState(() async {
        response = result;
        final messageData = SharedChatMessage(
          message: response?.text ?? "",
          createdTime: Timestamp.now(),
          createdBy: UserService().getUserReference(),
          isBotMessage: true,
          sharedChatId: 'wRgioe5YwAbtOIzEavHx',
        );

        try {
          await FirebaseFirestore.instance
              .collection('shared_chat_message')
              .add(messageData.toMap());

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
      sharedChatId: 'wRgioe5YwAbtOIzEavHx',
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
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title: const Text('Shared Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatCollection.orderBy('createdTime', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs.map((doc) {
                  return SharedChatMessage.fromMap(doc.data() as Map<String, dynamic>);
                }).toList();

                return ListView.builder(
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
  }
}