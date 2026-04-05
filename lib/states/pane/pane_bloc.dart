import 'package:bloc/bloc.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_events.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_state.dart';

/// Bloc for updating the pane area when a new event is received.
class PaneBloc extends Bloc<PaneEvent, PaneState> {
  DataSource dataSource;

  PaneBloc({required this.dataSource}) : super(PaneState.initial()) {
    /// On receiving the [PaneDataReceived] event, it updates the pane area with
    /// the new events.
    on<PaneDataReceived>((event, emit) {
      _onDataReceived(event, emit);
    });

    /// On receiving the [PaneStart] event, it triggers data source to start
    /// sending the events to the BLoC.
    on<PaneStart>((event, emit) {
      _onStart(event, emit);
    });

    /// On receiving the [PaneStop] event, it triggers data source to stop
    /// sending the events.
    on<PaneStop>((event, emit) {
      _onStop(event, emit);
    });
  }

  @override
  Future<void> close() {
    dataSource.stop();
    return super.close();
  }

  void _onDataReceived(PaneDataReceived event, Emitter<PaneState> emit) {
    emit(state.asEventsAdded(event.eventsJson));
  }

  void _onStart(PaneEvent event, Emitter<PaneState> emit) {
    dataSource.start(_sendEventsToBloc);
    emit(state.asStarted());
  }

  void _onStop(PaneEvent event, Emitter<PaneState> emit) {
    dataSource.stop();
  }

  /// This wrapper method is provided to the [DataSource.start] to use it as a
  /// callback on receiving an event.
  void _sendEventsToBloc(List<Map<String, dynamic>> event) {
    add(PaneDataReceived(eventsJson: event));
  }
}
