import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celery_monitoring_core/constants.dart';
import 'package:celery_monitoring_core/models/event.dart';
import 'package:celery_monitoring_core/models/task_data.dart';
import 'package:celery_monitoring_core/states/task_info/task_info_bloc.dart';
import 'package:celery_monitoring_core/states/task_info/task_info_event.dart';
import 'package:celery_monitoring_core/widgets/pane/panable_area/event_widgets.dart';
import 'package:celery_monitoring_core/widgets/pane/panable_area/helpers.dart';

class TaskColumn extends StatelessWidget {
  final TaskData taskData;
  final double timestampOffset;
  final double currentTimestamp;

  const TaskColumn({
    Key? key,
    required this.taskData,
    required this.timestampOffset,
    required this.currentTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: paneEventMultiplier,
      height: (currentTimestamp - timestampOffset) * paneTimestampMultiplier +
          paneTimestampOffsetY,
      child: Stack(
        children: [
          Positioned(
            top: boardYCoord(
                taskData.startTimestamp ?? currentTimestamp, timestampOffset),
            left: (paneEventMultiplier) / 2 - eventLineWidth * 2,
            child: TaskLine(
                taskData: taskData,
                startTimestamp: taskData.startTimestamp ?? currentTimestamp,
                endTimestamp: taskData.endTimestamp ?? currentTimestamp,
                color: taskData.color),
          ),
          ..._getEvents()
        ],
      ),
    );
  }

  List<Widget> _getEvents() {
    List<Widget> events = [];
    for (CeleryEventBase event in taskData.eventsList) {
      Widget evt = Positioned(
        left: (paneEventMultiplier) / 2 - eventDotRadius,
        top: boardYCoord(event.timestamp, timestampOffset) - eventDotRadius,
        child: TaskEvent(
          color: taskData.color,
          event: event,
        ),
      );
      events.add(evt);
    }

    return events;
  }
}

class TaskLine extends StatefulWidget {
  final TaskData taskData;
  final double startTimestamp;
  final double endTimestamp;
  final Color color;

  const TaskLine({
    Key? key,
    required this.taskData,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.color,
  }) : super(key: key);

  @override
  State<TaskLine> createState() => _TaskLineState();
}

class _TaskLineState extends State<TaskLine> {
  bool isShadowed = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) => setState(() => isShadowed = value),
      onTap: () => BlocProvider.of<TaskInfoBloc>(context)
          .add(ShowTaskInfo(widget.taskData.taskInfo)),
      child: SizedBox(
        height: _getHeight(),
        width: eventLineWidth * 4,
        child: Center(
          child: Container(
            width: eventLineWidth,
            height: _getHeight(),
            decoration: BoxDecoration(
              color: widget.color,
              boxShadow: isShadowed
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  double _getHeight() {
    return (widget.endTimestamp - widget.startTimestamp) *
        paneTimestampMultiplier;
  }
}

class TaskEvent extends StatelessWidget {
  final CeleryEventBase event;
  final Color color;

  const TaskEvent({
    Key? key,
    required this.event,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getEventWidget(event, color);
  }
}
