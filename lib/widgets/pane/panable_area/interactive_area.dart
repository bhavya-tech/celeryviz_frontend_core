import 'package:celeryviz_frontend_core/models/worker_data.dart';
import 'package:celeryviz_frontend_core/widgets/pane/panable_area/worker_column.dart';
import 'package:flutter/material.dart';

class InteractiveArea extends StatelessWidget {
  final Map<String, WorkerData> workersMap;
  final double timestampOffset;
  final double currentTimestamp;

  const InteractiveArea({
    Key? key,
    required this.workersMap,
    required this.timestampOffset,
    required this.currentTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workersMap.entries
          .map(
            (entry) => WorkerColumn(
              workerData: entry.value,
              timestampOffset: timestampOffset,
              currentTimestamp: currentTimestamp,
            ),
          )
          .toList(),
    );
  }
}
