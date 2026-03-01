import 'package:flutter/foundation.dart';

@immutable
class CeleryvizOptionsConfig {
  // Event markings
  final double eventDotRadius;
  final double eventLineWidth;

  // Pane event(x direction)
  final double paneEventMultiplier;
  final double paneEventOffsetX;

  // Panable area
  final double paneMaxScale;
  final double paneMinScale;

  // Pane time(y direction)
  final double paneTimestampMultiplier;
  final double paneTimestampOffsetY;

  // Ruler
  final double rulerScaleHeight;
  final double rulerScaleWidth;
  final double rulerWidth;

  // Socket IO
  final String socketioServerDataEvent;
  final String socketioClientEndpoint;

  // Taskname bar
  final double tasknameBarHeight;

  // Task info
  final double taskInfoAreaWidth;

  const CeleryvizOptionsConfig({
    this.eventDotRadius = 10.0,
    this.eventLineWidth = 4.5,
    this.paneEventMultiplier = 80.0,
    this.paneEventOffsetX = 40.0, // paneEventMultiplier / 2
    this.paneMaxScale = 5.0,
    this.paneMinScale = 0.8,
    this.paneTimestampMultiplier = 40.0,
    this.paneTimestampOffsetY = 10.0,
    this.rulerScaleHeight = 2.0,
    this.rulerScaleWidth = 10.0,
    this.rulerWidth = 100.0,
    this.socketioServerDataEvent = 'celery_events_data',
    this.socketioClientEndpoint = '/client',
    this.tasknameBarHeight = 40.0,
    this.taskInfoAreaWidth = 300.0,
  });
}
