import 'dart:collection';

import 'package:celeryviz_frontend_core/models/event.dart';
import 'package:celeryviz_frontend_core/models/task_data.dart';

class WorkerData {
  final LinkedHashMap<String, TaskData> tasks = LinkedHashMap();
  final WorkerInfo _workerInfo;

  get taskIds => tasks.keys.toList();
  get workerName => _workerInfo.hostname;

  void addEvent(Map<String, dynamic> eventJson) {
    CeleryEventBase event = getCeleryEventFromJson(eventJson);
    tasks.putIfAbsent(event.uuid, () => TaskData(taskId: event.uuid));
    tasks[event.uuid]!.addEvent(event);
  }

  WorkerData(String hostname, int pid)
      : _workerInfo = WorkerInfo(hostname: hostname, pid: pid);
}

class WorkerInfo {
  String hostname;
  int pid;

  WorkerInfo({required this.hostname, required this.pid});
}
