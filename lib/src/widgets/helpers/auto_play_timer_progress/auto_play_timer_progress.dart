import 'dart:math';
import 'package:flutter/material.dart';

class FlickAutoPlayTimerProgressPainter extends CustomPainter {
  FlickAutoPlayTimerProgressPainter({
    this.animation,
  }) : super(repaint: animation);

  final Animation<double>? animation;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = Color.fromARGB(255, 205, 0, 14);
    double progress = (1.0 - animation!.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(FlickAutoPlayTimerProgressPainter old) {
    return false;
  }
}
