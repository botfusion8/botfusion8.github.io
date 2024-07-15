import 'package:chatbot_text_tool/presentation/auth/login.dart';
import 'package:chatbot_text_tool/presentation/chat/chat_screen.dart';
import 'package:chatbot_text_tool/presentation/share/shared_chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBjAe_zRe0UiiXLzPmM9sYgwiJXrwi5QKE",
      projectId: "chattestify",
      messagingSenderId: "205307791603",
      appId: "1:205307791603:web:66d82d84116b143e998f86",
          databaseURL: "https://chattestify.firebaseio.com", // Update with your database URL
          storageBucket: "chattestify.appspot.com",
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
            onGenerateRoute: (settings) {
              final Uri uri = Uri.parse(settings.name!);
              if (uri.pathSegments.length == 1 && uri.pathSegments.first == 'shared-chat') {
                final String? token = uri.queryParameters['token'];
                if (token != null) {
                  return MaterialPageRoute(
                    builder: (context) => SharedChatScreen(token: token),
                  );
                }
              }
              return null;
            },
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
