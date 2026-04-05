import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_event.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_state.dart';

/// Bloc for managing the task info side sheet.
///
/// It handles the events for showing and closing the task info side sheet.
/// The [TaskInfoState] holds the data of the task clicked by the user.
class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  TaskInfoBloc() : super(const TaskInfoState()) {
    /// On receiving the [ShowTaskInfo] event, it shows the task info side
    /// sheet.
    on<ShowTaskInfo>((event, emit) {
      _onShow(event, emit);
    });

    /// On receiving the [CloseTaskInfo] event, it closes the task info side
    /// sheet.
    on<CloseTaskInfo>((event, emit) {
      _onClose(event, emit);
    });

    /// On receiving the [TaskInfoUpdated] event, it updates the task info
    /// if the task info side sheet is visible and the task id matches.
    on<TaskInfoUpdated>((event, emit) {
      _onTaskInfoUpdated(event, emit);
    });
  }

  void _onShow(ShowTaskInfo event, Emitter<TaskInfoState> emit) {
    emit(state.show(event.taskInfo));
  }

  void _onClose(CloseTaskInfo event, Emitter<TaskInfoState> emit) {
    emit(state.close());
  }

  void _onTaskInfoUpdated(TaskInfoUpdated event, Emitter<TaskInfoState> emit) {
    if (state.isVisible && state.taskInfo?.taskId == event.taskInfo.taskId) {
      emit(state.show(event.taskInfo));
    }
  }
}
