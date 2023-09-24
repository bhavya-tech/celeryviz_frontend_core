import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celery_monitoring_core/constants.dart';
import 'package:celery_monitoring_core/states/task_info/task_info_bloc.dart';
import 'package:celery_monitoring_core/states/task_info/task_info_state.dart';
import 'package:celery_monitoring_core/widgets/pane/task_info/task_info_area.dart';

class TaskInfoContainer extends StatelessWidget {
  const TaskInfoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskInfoBloc, TaskInfoState>(builder: (context, state) {
      return AnimatedContainer(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        alignment: Alignment.centerRight,
        duration: const Duration(milliseconds: 600),
        curve: Curves.linear,
        transform: Matrix4.translationValues(
          state.isVisible
              ? MediaQuery.of(context).size.width - taskInfoAreaWidth - 128
              : MediaQuery.of(context).size.width,
          0,
          0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        width: taskInfoAreaWidth,
        child: (state.taskInfo == null)
            ? const Placeholder()
            : TaskInfoArea(taskInfo: state.taskInfo!),
      );
    });
  }
}
