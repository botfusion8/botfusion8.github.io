import 'package:cloud_firestore/cloud_firestore.dart';

class SharedChat {
  final String clientName;
  final String clientEmail;
  final Timestamp createdAt;
  final Timestamp modifiedAt;
  final String workspaceRef;
  final bool status;

  SharedChat({
    required this.clientName,
    required this.clientEmail,
    required this.createdAt,
    required this.modifiedAt,
    required this.workspaceRef,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'clientEmail': clientEmail,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'workspaceRef': workspaceRef,
      'status': status,
    };
  }
}
