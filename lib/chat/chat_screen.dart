import 'package:chatbot_text_tool/chat/receiver_message.dart';
import 'package:chatbot_text_tool/chat/sender_message.dart';
import 'package:chatbot_text_tool/chat/workflow_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                  Icon(Icons.bug_report, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'ChatTestify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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
                      'Add new workspace',
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
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
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
                // If there are data, display your list or other content
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // Use snapshot.data!.docs[index] to access document data
                      // Example: String name = snapshot.data!.docs[index]['name'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(onTap: (){
                          Navigator.pop(context);
                        },
                          child: ListTile(trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
                            title: Text((snapshot.data!.docs[index]["name"] ?? "")),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: _buildDrawer(),
      body: Column(
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
      ),
    );
  }
}
