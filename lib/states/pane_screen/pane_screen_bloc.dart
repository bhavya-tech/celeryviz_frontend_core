import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:celeryviz_frontend_core/states/pane_screen/pane_screen_events.dart';
import 'package:celeryviz_frontend_core/states/pane_screen/pane_screen_state.dart';

/// Bloc for managing the pane screen.
///
/// It handles the events for setting up the data source.
class PaneScreenBloc extends Bloc<PaneScreenEvent, PaneScreenState> {
  final DataSource dataSource;
  PaneScreenBloc({required this.dataSource})
      : super(PaneScreenState(dataSource: dataSource)) {
    /// On receiving the [PaneScreenLoadStart] event, it triggers data source to
    /// start sending the events to the BLoC.
    on<PaneScreenLoadStart>((event, emit) async {
      await _onLoadStart(event, emit);
    });

    /// On receiving the [PaneScreenLoadSuccess] event, it updates the state to
    /// loaded.
    on<PaneScreenLoadSuccess>((event, emit) {
      _onLoadSuccess(event, emit);
    });

    /// On receiving the [PaneScreenLoadFailure] event, it updates the state to
    /// load failed.
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
