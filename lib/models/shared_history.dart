import 'package:cloud_firestore/cloud_firestore.dart';

class SharedHistory {
  final String name;
  final String email;
  final DateTime createdDate;
  bool enabled;

  SharedHistory({
    required this.name,
    required this.email,
    required this.createdDate,
    required this.enabled,
  });

  factory SharedHistory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SharedHistory(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      createdDate: (data['createdDate'] as Timestamp).toDate(),
      enabled: data['enabled'] ?? false,
    );
  }
}
