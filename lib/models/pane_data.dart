import 'package:equatable/equatable.dart';
import 'package:celeryviz_frontend_core/models/event.dart';
import 'package:celeryviz_frontend_core/models/task_data.dart';

class PaneData extends Equatable {
  final Map<String, TaskData> tasks = {};

  @override
  List<Object?> get props => [tasks];

  List<String> get taskIds => tasks.keys.toList();
  double? get minTimestamp {
    if (tasks.isEmpty) {
      return null;
    }

    return tasks.values
        .map((task) => task.firstRenderTimestamp)
        .reduce((a, b) => a < b ? a : b);
  }

  void addEvent(Map<String, dynamic> eventJson) {
    // If the type is task-received, we need to add two events to the task
    // data: the task-received event and the task-scheduled event.
    if (eventJson['type'] == "task-received") {
      CeleryEventSpawned eventSpawned = CeleryEventSpawned.fromJson(eventJson);
      if (tasks[eventSpawned.uuid] == null) {
        tasks[eventSpawned.uuid] = TaskData(taskId: eventSpawned.uuid);
      }
      tasks[eventSpawned.uuid]!.addEvent(eventSpawned);

      if (eventJson["eta"] != null) {
        CeleryEventScheduled eventScheduled =
            CeleryEventScheduled.fromJson(eventJson);
        if (tasks[eventScheduled.uuid] == null) {
          tasks[eventScheduled.uuid] = TaskData(taskId: eventScheduled.uuid);
        }
        tasks[eventScheduled.uuid]!.addEvent(eventScheduled);
      }
    } else {
      CeleryEventBase event = getCeleryEventFromJson(eventJson);
      if (tasks[event.uuid] == null) {
        tasks[event.uuid] = TaskData(taskId: event.uuid);
      }
      tasks[event.uuid]!.addEvent(event);
    }
  }
}
