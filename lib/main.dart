import 'package:emma01/chat_page.dart';
import 'package:emma01/chat_page2.dart';
import 'package:emma01/login.dart';
import 'package:emma01/registration.dart';
import 'package:emma01/utils/brandcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EmmaApp());
}

class EmmaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "EMMA",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.light(primary: BrandColor.primary)),
      // home: ChatPage2(),
      home: LoginPage(),
      // home: RegisterPage(),
      routes: {
        '/chat': (context) => ChatPage2(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
