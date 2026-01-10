import 'package:celeryviz_frontend_core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/colors.dart';
import 'package:celeryviz_frontend_core/constants.dart';
import 'package:celeryviz_frontend_core/models/event.dart';

EventWidget getEventWidget(CeleryEventBase event, Color color) {
  switch (event.runtimeType) {
    case CeleryEventStarted:
      return EventStarted(color: color);
    // case CelelryEventFailed:
    //   return EventFailed(color: color);
    case CeleryEventSucceeded:
      return EventFinished(color: color);
    case CeleryEventLog:
      event = event as CeleryEventLog;
      return EventLog(
        color: color,
        message: event.msg,
        logLevelNumber: event.levelno,
      );
    default:
      return EventWidget(color: color);
  }
}

class EventWidget extends StatelessWidget {
  final Color color;
  const EventWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: eventDotRadius * 2,
      height: eventDotRadius * 2,
      child: Center(
        child: Icon(
          Icons.circle,
          color: color,
          size: eventDotRadius * 2,
        ),
      ),
    );
  }
}

class EventIconScaffold extends StatelessWidget {
  final IconData? icon;
  final Color color;

  const EventIconScaffold({super.key, this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: eventDotRadius * 2,
      height: eventDotRadius * 2,
      child: Center(
        child: Stack(
          children: [
            const Icon(
              Icons.circle,
              color: backgroudColor,
              size: eventDotRadius * 2,
            ),
            Icon(
              icon,
              color: color,
              size: eventDotRadius * 2,
            ),
          ],
        ),
      ),
    );
  }
}

class EventFailed extends EventWidget {
  const EventFailed({super.key, required super.color});

  @override
  Widget build(BuildContext context) {
    return EventIconScaffold(icon: Icons.error, color: color);
  }
}

class EventStarted extends EventWidget {
  const EventStarted({super.key, required super.color});

  @override
  Widget build(BuildContext context) {
    return EventIconScaffold(
      icon: Icons.play_circle_fill,
      color: color,
    );
  }
}

class EventFinished extends EventWidget {
  const EventFinished({super.key, required super.color});

  @override
  Widget build(BuildContext context) {
    return EventIconScaffold(
      icon: Icons.check_circle,
      color: color,
    );
  }
}

class EventLog extends EventWidget {
  final String message;
  final int logLevelNumber;
  static Map<String, IconData?> logLevelIconMap = {
    'debug': Icons.bug_report_outlined,
    'info': Icons.info_outline_rounded,
    'warn': Icons.warning_amber_rounded,
    'error': Icons.error_outline_rounded,
    'critical': Icons.emergency_outlined,
    'notset': null
  };

  const EventLog(
      {super.key,
      required super.color,
      required this.message,
      required this.logLevelNumber});

  @override
  Widget build(BuildContext context) {
    final icon = logLevelIconMap[logLevelNumberToString[logLevelNumber]];
    return Tooltip(
      preferBelow: false,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      textStyle: TextStyle(color: color),
      message: message,
      child: EventIconScaffold(
        icon: icon,
        color: color,
      ),
    );
  }
}
