import 'dart:collection';
import 'dart:math';

import 'package:celeryviz_frontend_core/colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/models/event.dart';
import 'package:celeryviz_frontend_core/models/task_info.dart';

class TaskData extends Equatable {
  final SplayTreeMap<double, CeleryEventBase> _events =
      SplayTreeMap<double, CeleryEventBase>();
  final String taskId;
  final Color color = _assignTaskColor(backgroudColor);

  final TaskInfo taskInfo = TaskInfo();

  TaskData({required this.taskId}) {
    taskInfo.taskId = taskId;
  }

  List<CeleryEventBase> get eventsList => _events.values.toList();

  @override
  List<Object?> get props => [taskId, _events];

  double? get startTimestamp => taskInfo.startTimestamp;
  double? get endTimestamp => taskInfo.endTimestamp;

  double get firstRenderTimestamp => _events.firstKey() ?? double.infinity;

  void addEvent(dynamic event) {
    _events[event.timestamp] = event;
    taskInfo.extractData(event);
  }
}

Color _assignTaskColor(Color baseColor) {
  /// Todo: Optimise this to do it in single go.

  final random = Random();
  const contrastDifferenceThreshold = 128;

  // Calculate the luminance of the base color
  final baseColorLuminance = _calculateLuminance(baseColor);

  // Generate random RGB values until a contrasting color is found
  while (true) {
    final randomColor = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    // Calculate the luminance of the random color
    final randomColorLuminance = _calculateLuminance(randomColor);

    // Check if the random color has sufficient contrast with the base color
    if ((randomColorLuminance - baseColorLuminance).abs() <
        contrastDifferenceThreshold) {
      return randomColor;
    }
  }
}

double _calculateLuminance(Color color) {
  return 0.299 * (color.r * 255.0) +
      0.587 * (color.g * 255.0) +
      0.114 * (color.b * 255.0);
}
