/// The dahsed lines between the parent task's task-spawned event and the
/// child task's received event.
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';
import 'package:celeryviz_frontend_core/models/event.dart';
import 'package:celeryviz_frontend_core/models/task_data.dart';
import 'package:path_drawing/path_drawing.dart';

/// Draws the curved dashed lines between the parent task's task-spawned event
/// and the child task's received event.
///
/// This is used to show the parent-child relationship between tasks.
class SpawnedTaskLinesPainter extends CustomPainter {
  final Map<String, TaskData> tasks;
  final double minTimestamp;
  final double maxTimestamp;

  SpawnedTaskLinesPainter(
      {required this.tasks,
      required this.minTimestamp,
      required this.maxTimestamp});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    for (CustomPainter painter in _getSpawnedTaskLines()) {
      painter.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// Returns a list of [TaskSpawnedLine] painters for all the spawned tasks.
  ///
  /// - Finds the scheduler event and the task received events.
  /// - Determines their
  ///   - x coordiante using the task's index in the tasks list.
  ///   - y coordiante using the timestamp of the event.
  /// - Creates a list of [TaskSpawnedLine] painters for all the start and end
  ///   points.
  List<CustomPainter> _getSpawnedTaskLines() {
    List<CustomPainter> spawnedTaskLines = [];
    List<CeleryEventBase> events = [
      for (TaskData task in tasks.values) ...task.eventsList
    ];

    for (CeleryEventBase event in events) {
      if (event.type == 'task-spawned') {
        final CeleryEventSpawned task = event as CeleryEventSpawned;
        final childTasksList = tasks[task.childId]?.eventsList;

        if (childTasksList == null || childTasksList.isEmpty) {
          continue;
        }

        Offset start = Offset(
            _taskIdToX(event.uuid),
            (event.timestamp - minTimestamp) *
                    CeleryvizOptions.config.paneTimestampMultiplier +
                CeleryvizOptions.config.paneTimestampOffsetY);

        Offset end = Offset(
            _taskIdToX(task.childId),
            min(
                (childTasksList[0].timestamp - minTimestamp) *
                        CeleryvizOptions.config.paneTimestampMultiplier +
                    CeleryvizOptions.config.paneTimestampOffsetY,
                maxTimestamp));

        spawnedTaskLines
            .add(TaskSpawnedLine(start: start, end: end, color: Colors.grey));
      }
    }

    return spawnedTaskLines;
  }

  double _taskIdToX(String taskId) {
    final tasksList = tasks.values.toList();
    final int index = tasksList.indexWhere((task) => task.taskId == taskId);
    return index * CeleryvizOptions.config.paneEventMultiplier +
        CeleryvizOptions.config.paneEventOffsetX;
  }
}

/// Draws a single curved dashed line between the start and end points.
///
/// The curve is drawn using a cubic bezier curve.
class TaskSpawnedLine extends CustomPainter {
  final Color color;
  final Offset start;
  final Offset end;

  TaskSpawnedLine({
    required this.color,
    required this.start,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = CeleryvizOptions.config.eventLineWidth;

    canvas.drawPath(
      dashPath(
        _getPath2(),
        dashArray: CircularIntervalList<double>(<double>[5.0, 5.0]),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path _getPath2() {
    // Use Path.cubicTo to draw a curve starting from startX, startY
    // and ending at endX, endY.
    double controlX1 = start.dx + (end.dy - start.dy) / 4;
    double controlY1 = (start.dy + end.dy) / 2;
    double controlX2 = end.dx - (end.dy - start.dy) / 4;
    double controlY2 = (start.dy + end.dy) / 2;

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(controlX1, controlY1, controlX2, controlY2, end.dx, end.dy);
    return path;
  }
}
