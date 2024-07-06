import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:celeryviz_frontend_core/states/pane_screen/pane_screen_events.dart';
import 'package:celeryviz_frontend_core/states/pane_screen/pane_screen_state.dart';

class PaneScreenBloc extends Bloc<PaneScreenEvent, PaneScreenState> {
  final DataSource dataSource;
  PaneScreenBloc({required this.dataSource})
      : super(PaneScreenState(dataSource: dataSource)) {
    on<PaneScreenLoadStart>((event, emit) async {
      await _onLoadStart(event, emit);
    });
    on<PaneScreenLoadSuccess>((event, emit) {
      _onLoadSuccess(event, emit);
    });
    on<PaneScreenLoadFailure>((event, emit) {
      _onLoadFailure(event, emit);
    });
  }

  Future _onLoadStart(
      PaneScreenLoadStart event, Emitter<PaneScreenState> emit) async {
    emit(state.asLoading());

    void onSetupComplete() {
      add(const PaneScreenLoadSuccess());
    }

    void onSetupFailed() {
      add(const PaneScreenLoadFailure());
    }

    await state.dataSource.setup(onSetupComplete, onSetupFailed);
  }

  void _onLoadSuccess(
      PaneScreenLoadSuccess event, Emitter<PaneScreenState> emit) {
    emit(state.asLoaded());
  }

  void _onLoadFailure(
      PaneScreenLoadFailure event, Emitter<PaneScreenState> emit) {
    emit(state.asLoadFailed());
  }
}
