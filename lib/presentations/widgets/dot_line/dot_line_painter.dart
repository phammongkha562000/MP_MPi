import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Paint _paint;

  DottedLinePainter({
    required this.dashWidth,
    required this.dashSpace,
    required Color color,
  }) : _paint = Paint()
          ..color = color
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final double y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), _paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
