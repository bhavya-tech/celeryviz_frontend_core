import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';
import 'package:celeryviz_frontend_core/models/task_data.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_bloc.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_event.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/event_widgets.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/helpers.dart';

class TaskColumn extends StatelessWidget {
  final TaskData taskData;
  final double minTimestamp;
  final double maxTimestamp;

  const TaskColumn({
    Key? key,
    required this.taskData,
    required this.minTimestamp,
    required this.maxTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CeleryvizOptions.config.paneEventMultiplier,
      child: Stack(
        children: [
          Positioned(
            top: boardYCoord(taskData.firstRenderTimestamp, minTimestamp),
            left: (CeleryvizOptions.config.paneEventMultiplier -
                    CeleryvizOptions.config.eventLineWidth) /
                2,
            child: TaskLine(
              taskData: taskData,
              maxTimestamp: maxTimestamp,
            ),
          ),
          ..._getEvents()
        ],
      ),
    );
  }

  List<Widget> _getEvents() {
    List<Widget> events = taskData.eventsList
        .map((event) => Positioned(
              left: (CeleryvizOptions.config.paneEventMultiplier) / 2 -
                  CeleryvizOptions.config.eventDotRadius,
              top: boardYCoord(event.timestamp, minTimestamp) -
                  CeleryvizOptions.config.eventDotRadius,
              child: getEventWidget(event, taskData.color),
            ))
        .toList();

    return events;
  }
}

class TaskLine extends StatefulWidget {
  final TaskData taskData;
  final double maxTimestamp;

  const TaskLine({
    Key? key,
    required this.taskData,
    required this.maxTimestamp,
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
        width: CeleryvizOptions.config.eventLineWidth,
        padding: EdgeInsets.symmetric(
            horizontal: 1.5 * CeleryvizOptions.config.eventLineWidth),
        height: _getHeight(),
        decoration: BoxDecoration(
          color: widget.taskData.color,
          boxShadow: isShadowed
              ? [
                  BoxShadow(
                    color: widget.taskData.color.withValues(alpha: 128),
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
    final end = widget.taskData.endTimestamp ?? widget.maxTimestamp;
    return (end - widget.taskData.firstRenderTimestamp) *
        CeleryvizOptions.config.paneTimestampMultiplier;
  }
}
