import 'package:emma01/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Spacing Utils', () {
    testWidgets('should render a vertical space with specified height',
        (WidgetTester tester) async {
      final double height = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: verticleSpace(height),
          ),
        ),
      );

      final SizedBox space = tester.widget(find.byType(SizedBox));

      expect(space.height, height);
    });

    testWidgets('should render a horizontal space with specified width',
        (WidgetTester tester) async {
      final double width = 10.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: horizontalSpace(width),
          ),
        ),
      );

      final SizedBox space = tester.widget(find.byType(SizedBox));

      expect(space.width, width);
    });
  });
}
