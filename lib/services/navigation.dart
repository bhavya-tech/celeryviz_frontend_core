import 'dart:math';

import 'package:celeryviz_frontend_core/constants.dart';
import 'package:flutter/material.dart';

class NavigationTransformationController extends TransformationController {
  double maxX = 0.0;
  double maxY = 0.0;
  final TickerProvider vsync;
  late final AnimationController _animationController;
  final Curve _curve = Curves.easeOutQuad;

  NavigationTransformationController({required this.vsync}) {
    _animationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 300));
  }

  void navigate(Offset delta) {
    // 1. Capture the current translation
    final Matrix4 startMatrix = value;

    // 2. Calculate the end matrix by adding the delta to the current position
    // Note: We use storage[12] and [13] for x and y translation
    final dx = delta.dx * paneEventOffsetX / 2;
    final dy = delta.dy * paneTimestampOffsetY;
    final double endX = max(min(startMatrix.storage[12] + dx, 0.0), maxX);
    final double endY = max(min(startMatrix.storage[13] + dy, 0.0), maxY);

    final Matrix4 endMatrix = startMatrix.clone()
      ..setTranslationRaw(endX, endY, 0.0);

    // 3. Create and trigger the animation
    final Animation<Matrix4> animation = Matrix4Tween(
      begin: startMatrix,
      end: endMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: _curve,
    ));

    void listener() => value = animation.value;

    animation.addListener(listener);

    _animationController.forward(from: 0).whenCompleteOrCancel(() {
      animation.removeListener(listener);
    });
  }

  void updateBounds(double newX, double newY) {
    maxX = -newX;
    maxY = -newY;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
