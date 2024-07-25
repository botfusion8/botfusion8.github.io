import 'package:chatbot_text_tool/utils/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/colors.dart'; // import the markdown package

class ReceiverMessage extends StatelessWidget {
  final String text;
  final Timestamp timestamp;

  const ReceiverMessage({super.key, required this.text, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: const BoxDecoration(
          // color: Colors.grey[300],
          color: AppColors.messageBgColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8)
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Render the markdown text
            MarkdownBody(
              data: text,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              dateTime.toFormattedTime(timestamp.seconds, timestamp.nanoseconds),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
