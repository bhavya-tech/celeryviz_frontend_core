import 'dart:collection';
import 'dart:math';

import 'package:celeryviz_frontend_core/models/worker_data.dart';
import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/constants.dart';
import 'package:celeryviz_frontend_core/models/event.dart';
import 'package:path_drawing/path_drawing.dart';

class SpawnedTaskLinesPainter extends CustomPainter {
  final LinkedHashMap<String, WorkerData> workers;
  final double timestampOffset;
  final double currentTimestamp;

  SpawnedTaskLinesPainter(
      {required this.workers,
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
    List<CeleryEventSpawned> events = [
      for (var worker in workers.values)
        for (var task in worker.tasks.values)
          for (var event in task.eventsList)
            if (event is CeleryEventSpawned) event
    ];

    for (CeleryEventSpawned spawnedEvent in events) {
      CeleryEventBase? firstEventOfChildTask;

      for (var worker in workers.values) {
        firstEventOfChildTask = worker.tasks[spawnedEvent.childId]?.firstEvent;
        if (firstEventOfChildTask != null) break;
      }

      Offset start = Offset(
          _taskIdToX(spawnedEvent.uuid),
          (spawnedEvent.timestamp - timestampOffset) * paneTimestampMultiplier +
              paneTimestampOffsetY);

      Offset end;

      // If the child task is not yet spawned, draw a line to the current timestamp
      if (firstEventOfChildTask == null) {
        end = Offset(
            _taskIdToX(spawnedEvent.uuid) + paneEventMultiplier / 2,
            (currentTimestamp - timestampOffset) * paneTimestampMultiplier +
                paneTimestampOffsetY);
      } else {
        end = Offset(
            _taskIdToX(firstEventOfChildTask.uuid),
            min(
                (firstEventOfChildTask.timestamp - timestampOffset) *
                        paneTimestampMultiplier +
                    paneTimestampOffsetY,
                currentTimestamp));
      }

      spawnedTaskLines
          .add(TaskSpawnedLine(start: start, end: end, color: Colors.grey));
    }

    return spawnedTaskLines;
  }

  double _taskIdToX(String taskId) {
    int index = -1;
    for (int i = 0; i < workers.length; i++) {
      if (workers.keys.contains(taskId)) {
        index = i;
        break;
      }
    }
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
