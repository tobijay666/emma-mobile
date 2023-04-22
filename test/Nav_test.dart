import 'package:emma01/chat_page2.dart';
import 'package:emma01/login.dart';
import 'package:emma01/registration.dart';
import 'package:emma01/utils/brandcolor.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'EmmaApp should navigate to RegisterPage when /register is pushed',
      (WidgetTester tester) async {
    await tester.pumpWidget(EmmaApp());

    // Wait for the Navigator to initialize
    await tester.pumpAndSettle();

    // Navigate to the RegisterPage
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    // Verify that the RegisterPage is displayed
    expect(find.text('Register Page'), findsOneWidget);
  });

  // testWidgets('EmmaApp should display LoginPage by default',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(EmmaApp());

  //   expect(find.byType(LoginPage), findsOneWidget);
  //   expect(find.byType(ChatPage2), findsNothing);
  //   expect(find.byType(RegisterPage), findsNothing);
  // });

  // testWidgets('EmmaApp should navigate to ChatPage2 when /chat is pushed',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(EmmaApp());

  //   await tester.tap(find
  //       .byType(ElevatedButton)); // tap the button that navigates to ChatPage2
  //   await tester.pumpAndSettle();

  //   expect(find.byType(ChatPage2), findsOneWidget);
  //   expect(find.byType(LoginPage), findsNothing);
  //   expect(find.byType(RegisterPage), findsNothing);
  // });

  // testWidgets(
  //     'EmmaApp should navigate to RegisterPage when /register is pushed',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(EmmaApp());

  //   await tester.tap(find
  //       .byType(TextButton)); // tap the button that navigates to RegisterPage
  //   await tester.pumpAndSettle();

  //   expect(find.byType(RegisterPage), findsOneWidget);
  //   expect(find.byType(LoginPage), findsNothing);
  //   expect(find.byType(ChatPage2), findsNothing);
  // });
}

class EmmaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EMMA",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: BrandColor.primary),
      ),
      home: LoginPage(),
      routes: {
        '/chat': (context) => ChatPage2(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
