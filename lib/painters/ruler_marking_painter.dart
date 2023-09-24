import 'package:flutter/material.dart';
import 'package:celery_monitoring_core/constants.dart';

class RulerMarkingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final halfSecondMarkingPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = rulerScaleHeight / 2
      ..style = PaintingStyle.stroke;

    final fullSecondMarkinPaint = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width - rulerScaleWidth / 2, 0);

    canvas.drawPath(fullSecondMarkinPaint, halfSecondMarkingPaint);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = rulerScaleHeight
      ..style = PaintingStyle.stroke;

    final path2 = Path()
      ..moveTo(size.width, size.height / 2)
      ..lineTo(size.width - rulerScaleWidth, size.height / 2);

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
