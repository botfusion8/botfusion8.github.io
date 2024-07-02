class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory UserModel.fromFirebase(UserModel user) {
    return UserModel(
      uid: user.uid,
      name: user.name ?? '',
      email: user.email ?? '',
    );
  }
}
