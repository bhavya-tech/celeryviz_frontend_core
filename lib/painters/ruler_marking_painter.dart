import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';

class RulerMarkingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final halfSecondMarkingPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = CeleryvizOptions.config.rulerScaleHeight / 2
      ..style = PaintingStyle.stroke;

    final fullSecondMarkinPaint = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width - CeleryvizOptions.config.rulerScaleWidth / 2, 0);

    canvas.drawPath(fullSecondMarkinPaint, halfSecondMarkingPaint);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = CeleryvizOptions.config.rulerScaleHeight
      ..style = PaintingStyle.stroke;

    final path2 = Path()
      ..moveTo(size.width, size.height / 2)
      ..lineTo(size.width - CeleryvizOptions.config.rulerScaleWidth,
          size.height / 2);

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
