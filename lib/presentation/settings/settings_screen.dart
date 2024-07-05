import 'package:chatbot_text_tool/utils/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import '../../models/user.dart';
import '../../service/shared_pref_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          FutureBuilder<UserModel?>(
            future: SessionManager.getUser(),
            builder: (context, snapshot) {
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [Color(0xFFDB91B9), Color(0xFF39D2C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(snapshot.data?.name ?? "N/A"),
                accountEmail: Text(snapshot.data?.email ?? 'N/A'),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white54,
                  child: Text(
                    'JD',
                    style: TextStyle(fontSize: 40.0, color: Colors.white),
                  ),
                ),
              );
            }),
          const SizedBox(height: 30,),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy Policy'),
            onTap: () {
              _showPrivacyPolicy(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Reset Password'),
            onTap: () {
              context.showCustomSnackBar('Feature coming soon!');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.rule_sharp),
            title: const Text('Terms & Conditions'),
            onTap: () {
              context.showCustomSnackBar('Feature coming soon!');
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
                'Your privacy policy content goes here. You can add detailed information about your privacy practices.'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}