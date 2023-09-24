import 'package:flutter/material.dart';
import 'package:next_flower/models/task_data.dart';
import 'package:next_flower/widgets/pane/panable_area/task_column.dart';

class InteractiveArea extends StatelessWidget {
  final Map<String, TaskData> tasksMap;
  final double timestampOffset;
  final double currentTimestamp;

  const InteractiveArea({
    Key? key,
    required this.tasksMap,
    required this.timestampOffset,
    required this.currentTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasksMap.entries
          .where((element) =>
              element.value.firstRenderTimestamp <= currentTimestamp)
          .map((MapEntry<String, TaskData> entry) {
        return TaskColumn(
          taskData: entry.value,
          currentTimestamp: currentTimestamp,
          timestampOffset: timestampOffset,
        );
      }).toList(),
    );
  }
}
