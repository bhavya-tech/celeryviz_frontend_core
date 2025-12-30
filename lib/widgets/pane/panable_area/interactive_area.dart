import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/models/task_data.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/task_column.dart';

class InteractiveArea extends StatelessWidget {
  final Map<String, TaskData> tasksMap;
  final double timestampOffset;
  final double maxTimestamp;

  const InteractiveArea({
    Key? key,
    required this.tasksMap,
    required this.timestampOffset,
    required this.maxTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasksMap.entries
          .where(
              (element) => element.value.firstRenderTimestamp <= maxTimestamp)
          .map((MapEntry<String, TaskData> entry) {
        return TaskColumn(
          taskData: entry.value,
          maxTimestamp: maxTimestamp,
          timestampOffset: timestampOffset,
        );
      }).toList(),
    );
  }
}
