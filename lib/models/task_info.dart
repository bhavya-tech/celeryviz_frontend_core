import 'package:intl/intl.dart';
import 'package:celery_monitoring_core/models/event.dart';
import 'package:celery_monitoring_core/services/services.dart';

enum TaskStatus {
  scheduled,
  running,
  success,
  failed,
}

class TaskInfo {
  double? etaTimestamp;
  double? startTimestamp;
  double? endTimestamp;
  String? taskId;
  TaskStatus status = TaskStatus.scheduled;
  String? name;
  String? args;
  String? kwargs;
  String? result;

  TaskInfo({
    this.etaTimestamp,
    this.startTimestamp,
    this.endTimestamp,
    this.taskId,
  });

  Map<String, String> toMap() {
    final timeFormat = DateFormat('HH:mm:ss dd/MM/yyyy');
    return {
      'Name': name ?? 'N/A',
      'Task ID': taskId ?? 'N/A',
      'ETA': timestampToHumanReadable(etaTimestamp, timeFormat) ?? 'N/A',
      'Start': timestampToHumanReadable(startTimestamp, timeFormat) ?? 'N/A',
      'End': timestampToHumanReadable(endTimestamp, timeFormat) ?? 'N/A',
      'Status': status.name,
      'Args': args ?? 'N/A',
      'Kwargs': kwargs ?? 'N/A',
      'Result': result ?? 'N/A',
    };
  }

  void extractData(CeleryEventBase event) {
    taskId ??= event.uuid;

    if (event is CeleryEventSpawned) {
      // etaTimestamp = event.timestamp;
      // name = event.name;
      // args = event.args;
      // kwargs = event.kwargs;
    } else if (event is CeleryEventStarted) {
      startTimestamp = event.timestamp;
      status = TaskStatus.running;
    } else if (event is CeleryEventSucceeded) {
      endTimestamp = event.timestamp;
      status = TaskStatus.success;
      result = event.result;
    }
  }
}
