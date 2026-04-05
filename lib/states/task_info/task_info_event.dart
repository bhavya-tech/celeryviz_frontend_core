import 'package:celeryviz_frontend_core/models/task_info.dart';

abstract class TaskInfoEvent {
  const TaskInfoEvent();
}

/// Event for showing the task info side sheet.
class ShowTaskInfo extends TaskInfoEvent {
  final TaskInfo taskInfo;

  const ShowTaskInfo(this.taskInfo);
}

/// Event for closing the task info side sheet.
class CloseTaskInfo extends TaskInfoEvent {
  const CloseTaskInfo();
}

/// Event for updating the task info side sheet with new task.
class TaskInfoUpdated extends TaskInfoEvent {
  final TaskInfo taskInfo;

  const TaskInfoUpdated(this.taskInfo);
}
