import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? primaryWorkSpace;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.primaryWorkSpace
  });
}
