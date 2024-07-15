import 'package:cloud_firestore/cloud_firestore.dart';

class SharedHistory {
  final String name;
  final String email;
  final DateTime createdDate;
  final String id;
  bool enabled;

  SharedHistory({
    required this.id,
    required this.name,
    required this.email,
    required this.createdDate,
    required this.enabled,
  });

  factory SharedHistory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SharedHistory(
      id: doc.id,
      name: data['clientName'] ?? '',
      email: data['clientEmail'] ?? '',
      createdDate: (data['createdAt'] as Timestamp).toDate(),
      enabled: data['status'] ?? false,
    );
  }
}
