import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String chatId;
  final String message;
  final Timestamp? createdTime; // Make sure it's nullable if null is possible
  final dynamic chatSessionRef;
  final dynamic createdBy;
  final bool isBotMessage;

  Message({
    required this.chatId,
    required this.message,
    this.createdTime,
    required this.chatSessionRef,
    required this.createdBy,
    required this.isBotMessage,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      chatId: map['chatId'] ?? '',
      message: map['message'] ?? '',
      createdTime: map['createdTime'] ?? null, // Ensure null safety here
      chatSessionRef: map['chatSessionRef'] ?? null,
      createdBy: map['createdBy'] ?? null,
      isBotMessage: map['isBotMessage'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'message': message,
      'createdTime': createdTime ?? null, // Ensure null safety here
      'chatSessionRef': chatSessionRef,
      'createdBy': createdBy,
      'isBotMessage': isBotMessage,
    };
  }
}
