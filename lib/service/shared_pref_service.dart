import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class SessionManager {
  static const String _keyUid = 'uid';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUid, user.uid);
    prefs.setString(_keyName, user.name);
    prefs.setString(_keyEmail, user.email);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_keyUid);
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);

    if (uid != null && name != null && email != null) {
      return UserModel(uid: uid, name: name, email: email);
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
