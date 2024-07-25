import 'package:chatbot_text_tool/presentation/auth/login.dart';
import 'package:chatbot_text_tool/presentation/chat/chat_screen.dart';
import 'package:chatbot_text_tool/presentation/settings/settings_screen.dart';
import 'package:chatbot_text_tool/presentation/share/shared_chat_screen.dart';
import 'package:chatbot_text_tool/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

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
  setPathUrlStrategy();
  final currentUrl = Uri.base;
  final redirect = currentUrl.queryParameters['redirect'];

  if (redirect != null && redirect.isNotEmpty) {
    runApp(MyApp(initialRoute: redirect));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, this.initialRoute = '/'});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        bool isLoggedIn = snapshot.data ?? false;
        return MaterialApp(
          title: 'FusionBot',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AppColors.primaryColor
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name != null) {
              final Uri uri = Uri.parse(settings.name!);
              if (uri.pathSegments.length == 1 &&
                  uri.pathSegments.first == 'shared-chat') {
                final String? token = uri.queryParameters['token'];
                if (token != null) {
                  isLoggedIn =true;
                  return MaterialPageRoute(
                    builder: (context) => SharedChatScreen(token: token),
                  );
                }
              }
            }
            return MaterialPageRoute(
              builder: (context) => HomeScreen(isLoggedIn: isLoggedIn),
            );
          },
          routes: {
            '/login': (context) => const LoginScreen(),
            '/chat': (context) => const ChatScreen(),
          },
        );
      }
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    return uid != null && uid.isNotEmpty;
  }
}


class HomeScreen extends StatelessWidget {
  final bool isLoggedIn;

  const HomeScreen({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? const ChatScreen() : const LoginScreen();
  }
}
