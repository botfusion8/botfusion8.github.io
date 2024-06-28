import 'package:chatbot_text_tool/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class PinConfirmationScreen extends StatefulWidget {
  const PinConfirmationScreen({super.key});

  @override
  State createState() => _PinConfirmationScreenState();
}

class _PinConfirmationScreenState extends State<PinConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showScreenLockDialog(context));
  }

  void _showScreenLockDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return ScreenLock(
          correctString: '1234',
          onUnlocked: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => _showScreenLockDialog(context),
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
