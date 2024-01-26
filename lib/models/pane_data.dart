import 'dart:collection';

import 'package:celery_monitoring_core/models/worker_data.dart';
import 'package:equatable/equatable.dart';

class PaneData extends Equatable {
  final LinkedHashMap<String, WorkerData> workers = LinkedHashMap();

  @override
  List<Object?> get props => [workers];

  // Override get operator
  WorkerData? operator [](String workerName) => workers[workerName];

  List<String> get taskIds => [
        for (var worker in workers.values) ...worker.taskIds,
      ];

  List<String> get workerNames => workers.keys.toList();

  void addEvent(Map<String, dynamic> eventJson) {
    String hostname = eventJson['hostname'];
    int pid = eventJson['pid'];
    workers.putIfAbsent(eventJson['hostname'], () => WorkerData(hostname, pid));
    workers[eventJson['hostname']]!.addEvent(eventJson);
  }
}
