import 'dart:collection';
import 'dart:math';

import 'package:celery_monitoring_core/colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:celery_monitoring_core/models/event.dart';
import 'package:celery_monitoring_core/models/task_info.dart';

class TaskData extends Equatable {
  final SplayTreeMap<double, CeleryEventBase> _events =
      SplayTreeMap<double, CeleryEventBase>();
  final String taskId;
  final Color color = getTaskColor(backgroudColor);

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

Color getTaskColor(Color baseColor) {
  /// Todo: Optimise this to do it in single go.

  final random = Random();
  const contrastThreshold =
      128; // Adjust this value to control the contrast level

  // Calculate the luminance of the base color
  final baseColorLuminance =
      0.299 * baseColor.red + 0.587 * baseColor.green + 0.114 * baseColor.blue;

  // Generate random RGB values until a contrasting color is found
  while (true) {
    final randomColor = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    // Calculate the luminance of the random color
    final randomColorLuminance = 0.299 * randomColor.red +
        0.587 * randomColor.green +
        0.114 * randomColor.blue;

    // Check if the random color has sufficient contrast with the base color
    if ((randomColorLuminance - baseColorLuminance).abs() < contrastThreshold) {
      return randomColor;
    }
  }
}
