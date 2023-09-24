import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:next_flower/services/data_source.dart';
import 'package:next_flower/states/pane/pane_events.dart';
import 'package:next_flower/states/pane/pane_state.dart';

class PaneBloc extends Bloc<PaneEvent, PaneState> {
  final DataSource dataSource;
  PaneBloc({required this.dataSource})
      : super(PaneState(dataSource: dataSource)) {
    on<PaneLoadStart>((event, emit) async {
      await _onLoadStart(event, emit);
    });
  }

  Future _onLoadStart(PaneLoadStart event, Emitter<PaneState> emit) async {
    emit(state.asLoading());
    try {
      await state.dataSource.setup();
      emit(state.asLoaded());
    } catch (e) {
      Logger().e(e);
      emit(state.asLoadFailed());
    }
  }
}
