import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSession {
  String sessionId;
  String name;
  Timestamp createdAt;
  List<String> users;
  bool isGroupChat;
  String createdBy;

  ChatSession({
    required this.sessionId,
    required this.name,
    required this.createdAt,
    required this.users,
    required this.isGroupChat,
    required this.createdBy,
  });

  factory ChatSession.fromDocument(DocumentSnapshot doc) {
    return ChatSession(
      sessionId: doc['sessionId'],
      name: doc['name'],
      createdAt: doc['createdAt'],
      users: List<String>.from(doc['users']),
      isGroupChat: doc['isGroupChat'],
      createdBy: doc['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'name': name,
      'createdAt': createdAt,
      'users': users,
      'isGroupChat': isGroupChat,
      'createdBy': createdBy,
    };
  }
}
