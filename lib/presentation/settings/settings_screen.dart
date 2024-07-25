import 'package:chatbot_text_tool/utils/colors.dart';
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
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            FutureBuilder<UserModel?>(
                future: SessionManager.getUser(),
                builder: (context, snapshot) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: AppColors.primaryColor.withAlpha(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white54,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          height: 80,
                          width: 80,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'JD',
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.black),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data?.name ?? "N/A",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                snapshot.data?.email ?? 'N/A',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textFieldBgColor),
                child: const Icon(Icons.lock),
              ),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showPrivacyPolicy(context);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textFieldBgColor),
                child: const Icon(Icons.lock_reset),
              ),
              title: const Text('Reset Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.showCustomSnackBar('Feature coming soon!');
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textFieldBgColor),
                child: const Icon(Icons.rule_sharp),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Terms & Conditions'),
              onTap: () {
                context.showCustomSnackBar('Feature coming soon!');
              },
            ),
          ],
        ),
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
