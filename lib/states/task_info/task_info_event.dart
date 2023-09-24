import 'package:next_flower/models/task_info.dart';

abstract class TaskInfoEvent {
  const TaskInfoEvent();
}

class ShowTaskInfo extends TaskInfoEvent {
  final TaskInfo taskInfo;

  const ShowTaskInfo(this.taskInfo);
}

class CloseTaskInfo extends TaskInfoEvent {
  const CloseTaskInfo();
}
