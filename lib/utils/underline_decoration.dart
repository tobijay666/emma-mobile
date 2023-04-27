import 'package:flutter/material.dart';
import 'package:emma01/utils/brandcolor.dart';

class UnderlineDecoration extends Decoration {
  final Color decorationColor;
  final TextDecorationStyle decorationStyle;

  const UnderlineDecoration({
    required this.decorationColor,
    this.decorationStyle = TextDecorationStyle.solid,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
    );
  }
}

class _UnderlinePainter extends BoxPainter {
  final Color decorationColor;
  final TextDecorationStyle decorationStyle;

  _UnderlinePainter({
    required this.decorationColor,
    required this.decorationStyle,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint()
      ..color = decorationColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.right, rect.bottom),
      paint..style = PaintingStyle.stroke,
    );
  }
}
