import 'package:equatable/equatable.dart';
import 'package:celeryviz_frontend_core/models/task_info.dart';

class TaskInfoState extends Equatable {
  final TaskInfo? taskInfo;
  final bool isVisible;

  const TaskInfoState({this.taskInfo, this.isVisible = false});

  TaskInfoState show(TaskInfo taskInfo) {
    return copyWith(taskInfo: taskInfo, isVisible: true);
  }

  TaskInfoState close() {
    return copyWith(isVisible: false);
  }

  TaskInfoState copyWith({TaskInfo? taskInfo, bool? isVisible}) {
    return TaskInfoState(
      taskInfo: taskInfo ?? this.taskInfo,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  get props => [taskInfo, isVisible, identityHashCode(this)];
}
