import 'package:emma01/chat_page2.dart';
import 'package:emma01/login.dart';
import 'package:emma01/registration.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String chat = '/chat';
  static const String register = '/register';
  static const String login = '/login';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case chat:
        return MaterialPageRoute(builder: (context) => ChatPage2());
      case register:
        return MaterialPageRoute(builder: (context) => RegisterPage());
      case login:
        return MaterialPageRoute(builder: (context) => LoginPage());
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