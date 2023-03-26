import 'package:emma01/chat_page.dart';
import 'package:emma01/login.dart';
import 'package:emma01/utils/brandcolor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EmmaApp());
}

class EmmaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "EMMA",
      theme: ThemeData(
          colorScheme: ColorScheme.light(primary: BrandColor.primary)),
      // home: ChatPage(),
      home: LoginPage(),
      routes: {
        '/chat': (context) => ChatPage(),
      },
    );
  }
}
