import 'package:bloc/bloc.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_events.dart';
import 'package:celeryviz_frontend_core/states/pane/pane_state.dart';

class PaneBloc extends Bloc<PaneEvent, PaneState> {
  DataSource dataSource;

  PaneBloc({required this.dataSource}) : super(PaneState.initial()) {
    on<PaneDataReceived>((event, emit) {
      _onDataReceived(event, emit);
    });
    on<PaneStart>((event, emit) {
      _onStart(event, emit);
    });

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
    state.addEvent(event.eventJson);
    emit(state.asEventAdded(event.eventJson['timestamp']));
  }

  void _onStart(PaneEvent event, Emitter<PaneState> emit) {
    dataSource.start(_sendEventToBloc);
    emit(state.asStarted());
  }

  void _onStop(PaneEvent event, Emitter<PaneState> emit) {
    dataSource.stop();
  }

  void _sendEventToBloc(Map<String, dynamic> event) {
    add(PaneDataReceived(eventJson: event));
  }
}
