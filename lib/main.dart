import 'package:chatbot_text_tool/presentation/auth/login.dart';
import 'package:chatbot_text_tool/presentation/chat/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBImXvC9KNtEyYLizHE4oVIfnrtnEv3dcg",
      projectId: "apitesttool-b21bf",
      messagingSenderId: "649900765132",
      appId: "1:649900765132:web:9f06a7ab44a9a06a71f769",
          databaseURL: "https://apitesttool-b21bf.firebaseio.com", // Update with your database URL
          storageBucket: "apitesttool-b21bf.appspot.com",
        ));
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          bool isLoggedIn = snapshot.data ?? false;
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: isLoggedIn ? const ChatScreen() : const LoginScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
            },
          );
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    return uid != null && uid.isNotEmpty;
  }
}
