import 'dart:math';

import 'package:flutter/material.dart';
import 'package:celery_monitoring_core/constants.dart';
import 'package:celery_monitoring_core/models/event.dart';
import 'package:celery_monitoring_core/models/task_data.dart';
import 'package:path_drawing/path_drawing.dart';

class SpawnedTaskLinesPainter extends CustomPainter {
  final Map<String, TaskData> tasks;
  final double timestampOffset;
  final double currentTimestamp;

  SpawnedTaskLinesPainter(
      {required this.tasks,
      required this.timestampOffset,
      required this.currentTimestamp});

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

  List<CustomPainter> _getSpawnedTaskLines() {
    List<CustomPainter> spawnedTaskLines = [];
    List<CeleryEventBase> events = [
      for (TaskData task in tasks.values) ...task.eventsList
    ];

    for (CeleryEventBase event in events) {
      if (event.type == 'task-spawned') {
        final CeleryEventSpawned task = event as CeleryEventSpawned;
        final childTasksList = tasks[task.childId]?.eventsList;

        Offset start = Offset(
            _taskIdToX(event.uuid),
            (event.timestamp - timestampOffset) * paneTimestampMultiplier +
                paneTimestampOffsetY);

        Offset end = Offset(
            _taskIdToX(task.childId),
            min(
                (childTasksList![0].timestamp - timestampOffset) *
                        paneTimestampMultiplier +
                    paneTimestampOffsetY,
                currentTimestamp));

        spawnedTaskLines
            .add(TaskSpawnedLine(start: start, end: end, color: Colors.grey));
      }
    }

    return spawnedTaskLines;
  }

  double _taskIdToX(String taskId) {
    final tasksList = tasks.values.toList();
    final int index = tasksList.indexWhere((task) => task.taskId == taskId);
    return index * paneEventMultiplier + paneEventOffsetX;
  }
}

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
      ..strokeWidth = eventLineWidth;

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
