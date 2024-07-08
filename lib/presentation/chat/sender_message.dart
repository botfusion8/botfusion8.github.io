import 'package:chatbot_text_tool/utils/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SenderMessage extends StatelessWidget {
  final String text;
  final Timestamp timestamp;

  SenderMessage({required this.text, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFDB91B9), Color(0xFF39D2C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              dateTime.toFormattedTime(timestamp.seconds, timestamp.nanoseconds),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
