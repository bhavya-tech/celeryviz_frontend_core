import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_event.dart';
import 'package:celeryviz_frontend_core/states/task_info/task_info_state.dart';

class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  TaskInfoBloc() : super(const TaskInfoState()) {
    on<ShowTaskInfo>((event, emit) {
      _onShow(event, emit);
    });
    on<CloseTaskInfo>((event, emit) {
      _onClose(event, emit);
    });
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
