import 'package:cloud_firestore/cloud_firestore.dart';

class SharedChatMessage {
  final String message;
  final Timestamp? createdTime;
  final String sharedChatId;
  final dynamic createdBy;
  final bool isBotMessage;

  SharedChatMessage({
    required this.message,
    this.createdTime,
    required this.sharedChatId,
    required this.createdBy,
    required this.isBotMessage,
  });

  factory SharedChatMessage.fromMap(Map<String, dynamic> map) {
    return SharedChatMessage(
      message: map['message'] ?? '',
      createdTime: map['createdTime'] ?? null,
      sharedChatId: map['sharedChatId'] ?? null,
      createdBy: map['createdBy'] ?? null,
      isBotMessage: map['isBotMessage'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'createdTime': createdTime ?? null,
      'sharedChatId': sharedChatId,
      'createdBy': createdBy,
      'isBotMessage': isBotMessage,
    };
  }
}
