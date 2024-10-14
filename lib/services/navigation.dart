import 'dart:math';

import 'package:flutter/material.dart';

class NavigationTransformationController extends TransformationController {
  double maxX = 0.0;
  double maxY = 0.0;

  void navigate(Offset offset) {
    final Matrix4 matrix = value.clone();
    matrix.translate(-offset.dx, -offset.dy);

    matrix[12] = max(min(matrix[12], 0), maxX);
    matrix[13] = max(min(matrix[13], 0), maxY);

    value = matrix;
  }

  void updateBounds(double newX, double newY) {
    maxX = -newX;
    maxY = -newY;
  }
}
