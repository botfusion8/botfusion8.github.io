import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String chatId;
  String message;
  Timestamp createdTime;
  DocumentReference chatSessionRef;
  String createdBy;
  bool isBotMessage;

  Message({
    required this.chatId,
    required this.message,
    required this.createdTime,
    required this.chatSessionRef,
    required this.createdBy,
    required this.isBotMessage,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      chatId: doc['chatId'],
      message: doc['message'],
      createdTime: doc['created_time'],
      chatSessionRef: doc['chatSessionRef'],
      createdBy: doc['createdBy'],
      isBotMessage: doc['isBotMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'message': message,
      'created_time': createdTime,
      'chatSessionRef': chatSessionRef,
      'createdBy': createdBy,
      'isBotMessage': isBotMessage,
    };
  }
}
