import 'package:celeryviz_frontend_core/models/worker_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/constants.dart';
import 'package:celeryviz_frontend_core/models/task_data.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_bloc.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_event.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/event_widgets.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/helpers.dart';

class WorkerColumn extends StatelessWidget {
  final WorkerData workerData;
  final double timestampOffset;
  final double currentTimestamp;

  const WorkerColumn({
    Key? key,
    required this.workerData,
    required this.timestampOffset,
    required this.currentTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: paneEventMultiplier,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 2,
              color: Colors.white30,
            ),
          ),
          ..._getTasks(),
        ],
      ),
    );
  }

  List<Widget> _getTasks() {
    List<Widget> events = workerData.tasks.values
        .map((task) => Positioned(
              left: (paneEventMultiplier) / 2 - eventDotRadius / 4,
              top: boardYCoord(task.startTimestamp ?? 0.0, timestampOffset),
              child: TaskColumn(
                taskData: task,
              ),
            ))
        .toList();

    return events;
  }
}

class TaskColumn extends StatelessWidget {
  final TaskData taskData;

  const TaskColumn({
    Key? key,
    required this.taskData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: paneEventMultiplier,
      child: Stack(
        children: [
          TaskLine(
            taskData: taskData,
          ),
          ..._getEvents(),
        ],
      ),
    );
  }

  List<Widget> _getEvents() {
    List<Widget> events = taskData.eventsList
        .map((event) => Positioned(
              left: 0 - eventDotRadius,
              top: boardYCoord(event.timestamp, taskData.startTimestamp ?? 0) -
                  eventDotRadius,
              child: getEventWidget(event, taskData.color),
            ))
        .toList();

    return events;
  }
}

class TaskLine extends StatefulWidget {
  final TaskData taskData;

  const TaskLine({
    Key? key,
    required this.taskData,
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
      child: Container(
        width: eventLineWidth,
        padding: const EdgeInsets.symmetric(horizontal: 1.5 * eventLineWidth),
        height: _getHeight(),
        decoration: BoxDecoration(
          color: widget.taskData.color,
          boxShadow: isShadowed
              ? [
                  BoxShadow(
                    color: widget.taskData.color.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  double _getHeight() {
    return (widget.taskData.endTimestamp ??
            500.0 - widget.taskData.startTimestamp!) *
        paneTimestampMultiplier;
  }
}
