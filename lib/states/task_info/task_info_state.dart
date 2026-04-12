/// Module for defining states for the task info side sheet.
library;

import 'package:equatable/equatable.dart';
import 'package:celeryviz_frontend_core/models/task_info.dart';

/// State for the task info side sheet.
///
/// It holds the data of the task clicked by the user and whether the side
/// sheet is visible or not.
class TaskInfoState extends Equatable {
  final TaskInfo? taskInfo;
  final bool isVisible;

  const TaskInfoState({this.taskInfo, this.isVisible = false});

  /// Shows the task info side sheet with the given task info.
  TaskInfoState show(TaskInfo taskInfo) {
    return copyWith(taskInfo: taskInfo, isVisible: true);
  }

  /// Hides the task info side sheet.
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
