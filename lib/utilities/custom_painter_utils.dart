import 'dart:math';

import 'package:flutter/material.dart';

class TickPainter extends CustomPainter {
  final LONG_TICK = 14.0;
  final SHORT_TICK = 7.0;

  final tickCount;
  final tickPerSection;
  final tickInset;
  final tickPaint;
  final textPainter;
  final textStyle;
  TickPainter({
    this.tickCount = 35,
    this.tickPerSection = 5,
    this.tickInset = 0.0,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ) {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5;
  }
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();
    final radius = size.width / 2;
    for (int i = 0; i < tickCount; ++i) {
      final tickLenght = i % tickPerSection == 0 ? LONG_TICK : SHORT_TICK;

      canvas.drawLine(
        Offset(0.0, -radius),
        Offset(0.0, -radius - tickLenght),
        tickPaint,
      );

      // The text
      if (i % tickPerSection == 0) {
        // text
        canvas.save();

        canvas.translate(0.0, -(size.width / 2) - 30.0);
        textPainter.text = TextSpan(
          text: '$i',
          style: textStyle,
        );

        // figure out the text quadrant
        final tickPercent = i / tickCount;
        var quadrant;
        if (tickPercent < 0.25) {
          quadrant = 1;
        } else if (tickPercent < 0.5) {
          quadrant = 4;
        } else if (tickPercent < 0.75) {
          quadrant = 3;
        } else {
          quadrant = 2;
        }

        switch (quadrant) {
          case 4:
            canvas.rotate(-pi / 2);
            break;
          case 2:
          case 3:
            canvas.rotate(pi / 2);
            break;
        }

        // Layout the text
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            -textPainter.width / 2,
            -textPainter.height / 2,
          ),
        );

        canvas.restore();
      }

      canvas.rotate(2 * pi / tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPainter;
  final double rotationPercent;

  ArrowPainter({
    this.rotationPercent,
  }) : dialArrowPainter = new Paint() {
    dialArrowPainter.color = Colors.black;
    dialArrowPainter.style = PaintingStyle.fill;
  }
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final radius = size.height / 2;
    canvas.translate(radius, radius);
    canvas.rotate(2 * pi * rotationPercent);

    Path path = new Path();
    path.moveTo(0.0, -radius - 10.0);
    path.lineTo(10.0, -radius + 5.0);
    path.lineTo(-10.0, -radius + 5.0);
    path.close();

    canvas.drawPath(path, dialArrowPainter);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
