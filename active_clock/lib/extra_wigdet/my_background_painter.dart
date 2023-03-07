import 'package:flutter/material.dart';

import '../elements/my_color.dart';

class MyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    drawCircle(canvas: canvas, position: Offset(20.0, -20.0), radius: 120);
    drawCircle(
        canvas: canvas,
        position: Offset(size.width + 50, size.height * 0.25),
        radius: 150);
    drawCircle(
        canvas: canvas,
        position: Offset(size.width * 0.3, size.height * 0.35),
        radius: 80.0);
    drawCircle(
        canvas: canvas,
        position: Offset(size.width * 0.90, size.height * 0.65),
        radius: 50.0);
    drawCircle(
        canvas: canvas,
        position: Offset(100.0, size.height * 0.68),
        radius: 30.0);
    drawCircle(
        canvas: canvas,
        position: Offset(50.0, size.height + 20.0),
        radius: 150.0);

    drawCircle(
        canvas: canvas,
        position: Offset(size.width * 0.70, size.height * 0.8),
        radius: 40.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = MyColors.greyWhite;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);

    drawCircle(
        canvas: canvas,
        position: Offset(0, -size.height * 0.5),
        radius: size.height);
    drawCircle(
        canvas: canvas,
        position: Offset(size.width * 0.7, size.height * 1.55),
        radius: size.width * 0.5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void drawCircle(
    {required Canvas canvas,
    required Offset position,
    required double radius}) {
  return canvas.drawCircle(
      position,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 254, 254),
            Color.fromARGB(255, 254, 253, 253),
            Color.fromARGB(255, 254, 250, 250),
            Color.fromARGB(255, 253, 244, 244),
            Color.fromARGB(255, 253, 232, 233),
            Color.fromARGB(255, 252, 208, 210),
            Color.fromARGB(255, 252, 161, 164),
            MyColors.red,
          ],
        ).createShader(
            Rect.fromCircle(center: position, radius: radius * 1.15)));
}
