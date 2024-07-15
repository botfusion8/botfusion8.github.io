import 'package:chatbot_text_tool/models/shared_chat.dart';
import 'package:chatbot_text_tool/utils/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClientInfoDialog extends StatefulWidget {
  final String currentWorkspace;

  const ClientInfoDialog({Key? key, required this.currentWorkspace})
      : super(key: key);

  @override
  _ClientInfoDialogState createState() => _ClientInfoDialogState();
}

class _ClientInfoDialogState extends State<ClientInfoDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _generatedLink = '';

  Future<void> _addSharedChat() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      context.showCustomSnackBar('Name and Email cannot be empty!');
      return;
    }

    final sharedChat = SharedChat(
        clientName: _nameController.text,
        clientEmail: _emailController.text,
        createdAt: Timestamp.now(),
        modifiedAt: Timestamp.now(),
        workspaceRef: widget.currentWorkspace,
        status: true);

    try {
      final result = await FirebaseFirestore.instance
          .collection('shared_chats')
          .add(sharedChat.toMap());
      _nameController.clear();
      _emailController.clear();
      setState(() {
        _generatedLink = 'https://botfusion8.github.io/shared-chat?token=${result.id}';
      });

      context.showCustomSnackBar('Share link created successfully!');
    } catch (e) {
      context.showCustomSnackBar('$e');
    }
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: _generatedLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Client Info'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                if(_generatedLink.isEmpty){
                  _addSharedChat();
                }
              },
              child: Container(
                height: 35,
                alignment: Alignment.center,
                width: 150,
                decoration: BoxDecoration(
                  color:_generatedLink.isEmpty ? const Color(0xFF39D2C0) : const Color(
                      0xFFBDFCEE),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: const Text(
                  'Generate Link',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_generatedLink.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _generatedLink,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyLink,
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
