/// Configuration for the Celeryviz application.
library;

import 'package:flutter/foundation.dart';

@immutable
class CeleryvizOptionsConfig {
  /// Radius of the dot which represents a Celery event on the task line.
  final double eventDotRadius;

  /// Thickness of the verticle line connecting the events of a task.
  final double eventLineWidth;

  /// The width of the [TaskColumn] in the pane.
  ///
  /// Represents how spaced out the tasks are in the x-direction.
  final double paneEventMultiplier;

  /// The horizontal distance from the time ruler to the first task.
  ///
  /// By default it is half of the [paneEventMultiplier] for symmetry.
  final double paneEventOffsetX;

  /// Maximum scale factor for the zooming in the pane.
  final double paneMaxScale;

  /// Minimum scale factor for the zooming out the pane.
  final double paneMinScale;

  /// The height of one second in the verticle time ruler.
  final double paneTimestampMultiplier;

  /// Verticle offset for how much time is shown on the top of the pane before
  /// the first event.
  ///
  /// Rendering the event at the exact top crops the first event's dot. So we
  /// leave some buffer.
  final double paneTimestampOffsetY;

  // Height and width of the markings of the ruler
  final double rulerScaleHeight;
  final double rulerScaleWidth;

  /// Width of the verticle time ruler
  final double rulerWidth;

  /// The event name for the socket.io server to send data on.
  ///
  /// Defaults to 'celery_events_data' which is the one set in the backend
  /// library code.
  final String socketioServerDataEvent;

  /// The endpoint for the socket.io client to connect to.
  ///
  /// Defaults to '/client' which is the one set in the backend library code.
  final String socketioClientEndpoint;

  /// Height of the horizontal taskname bar at the top.
  final double tasknameBarHeight;

  /// Width of the task info area sidesheet that opens when a task is clicked.
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

  // Add equal comparator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CeleryvizOptionsConfig &&
          runtimeType == other.runtimeType &&
          eventDotRadius == other.eventDotRadius &&
          eventLineWidth == other.eventLineWidth &&
          paneEventMultiplier == other.paneEventMultiplier &&
          paneEventOffsetX == other.paneEventOffsetX &&
          paneMaxScale == other.paneMaxScale &&
          paneMinScale == other.paneMinScale &&
          paneTimestampMultiplier == other.paneTimestampMultiplier &&
          paneTimestampOffsetY == other.paneTimestampOffsetY &&
          rulerScaleHeight == other.rulerScaleHeight &&
          rulerScaleWidth == other.rulerScaleWidth &&
          rulerWidth == other.rulerWidth &&
          socketioServerDataEvent == other.socketioServerDataEvent &&
          socketioClientEndpoint == other.socketioClientEndpoint &&
          tasknameBarHeight == other.tasknameBarHeight &&
          taskInfoAreaWidth == other.taskInfoAreaWidth;

  @override
  int get hashCode => Object.hash(
        eventDotRadius,
        eventLineWidth,
        paneEventMultiplier,
        paneEventOffsetX,
        paneMaxScale,
        paneMinScale,
        paneTimestampMultiplier,
        paneTimestampOffsetY,
        rulerScaleHeight,
        rulerScaleWidth,
        rulerWidth,
        socketioServerDataEvent,
        socketioClientEndpoint,
        tasknameBarHeight,
        taskInfoAreaWidth,
      );
}
