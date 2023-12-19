import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:celery_monitoring_core/services/data_source.dart';
import 'package:celery_monitoring_core/states/pane_screen/pane_screen_events.dart';
import 'package:celery_monitoring_core/states/pane_screen/pane_screen_state.dart';

class PaneScreenBloc extends Bloc<PaneScreenEvent, PaneScreenState> {
  final DataSource dataSource;
  PaneScreenBloc({required this.dataSource})
      : super(PaneScreenState(dataSource: dataSource)) {
    on<PaneScreenLoadStart>((event, emit) async {
      await _onLoadStart(event, emit);
    });
  }

  Future _onLoadStart(
      PaneScreenLoadStart event, Emitter<PaneScreenState> emit) async {
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
