import 'package:flutter/material.dart';

class AppDashLine extends CustomPainter {
  final Paint _paint;

  AppDashLine(this._paint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}