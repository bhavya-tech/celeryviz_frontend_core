import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationTransformationController extends TransformationController {
  double maxX = 0.0;
  double maxY = 0.0;

  final double singleUnit = 50; //Value can be adjusted as per desired sensitivity.

  void navigate(Offset offset) {
    final Matrix4 matrix = value.clone();
    matrix.translate(-offset.dx, -offset.dy);

    matrix[12] = max(min(matrix[12], 0), maxX);
    matrix[13] = max(min(matrix[13], 0), maxY);

    value = matrix;
  }

  void navigateViaKeyboard(KeyEvent event) {
    double dy = 0;
    double dx = 0;
    if (event.physicalKey == PhysicalKeyboardKey.arrowLeft || event.physicalKey == PhysicalKeyboardKey.keyA) {
      dx = -singleUnit;
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowUp || event.physicalKey == PhysicalKeyboardKey.keyW) {
      dy = -singleUnit;
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowRight || event.physicalKey == PhysicalKeyboardKey.keyD) {
      dx = singleUnit;
    } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown || event.physicalKey == PhysicalKeyboardKey.keyS) {
      dy = singleUnit;
    }
    Offset kOffset = Offset(dx, dy);
    navigate(kOffset);
  }

  void updateBounds(double newX, double newY) {
    maxX = -newX;
    maxY = -newY;
  }
}
