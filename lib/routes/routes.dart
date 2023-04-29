// import 'package:emma01/chat/pages/chat_page.dart';
import 'package:emma01/chat_page.dart';
import 'package:emma01/chat_page2.dart';
import 'package:emma01/login.dart';
import 'package:emma01/pages/login_page2.dart';
import 'package:emma01/pages/signup_page2.dart';
import 'package:emma01/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String chat = '/chat';
  // static const String register = '/register';
  static const String register2 = '/register2';
  // static const String login = '/login';
  static const String login2 = '/login2';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => LoginPage2());
      case chat:
        // final user = settings.arguments as User?;
        // return MaterialPageRoute(builder: (context) => ChatPage(user: user!));
        return MaterialPageRoute(builder: (context) => ChatPage());
      // case register:
      //   return MaterialPageRoute(builder: (context) => RegisterPage());
      case register2:
        return MaterialPageRoute(builder: (context) => SignUpPage());
      // case login:
      //   return MaterialPageRoute(builder: (context) => LoginPage());
      case login2:
        return MaterialPageRoute(builder: (context) => LoginPage2());
      default:
        // throw Exception('Invalid route: ${settings.name}');
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
