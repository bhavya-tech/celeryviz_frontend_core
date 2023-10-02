import 'package:bloc/bloc.dart';
import 'package:celery_monitoring_core/services/data_source.dart';
import 'package:celery_monitoring_core/states/pane_board/pane_board_events.dart';
import 'package:celery_monitoring_core/states/pane_board/pane_board_state.dart';

class PaneBoardBloc extends Bloc<PaneBoardEvent, PaneBoardState> {
  DataSource dataSource;

  PaneBoardBloc({required this.dataSource}) : super(PaneBoardState.initial()) {
    on<PaneDataReceived>((event, emit) {
      _onDataReceived(event, emit);
    });
    on<PaneBoardStart>((event, emit) {
      _onStart(event, emit);
    });

    on<PaneBoardStop>((event, emit) {
      _onStop(event, emit);
    });
  }

  get currentTimestamp => dataSource.currentTimestamp;

  @override
  Future<void> close() {
    dataSource.stop();
    return super.close();
  }

  void _onDataReceived(PaneDataReceived event, Emitter<PaneBoardState> emit) {
    state.addEvent(event.eventJson);
    emit(state.asEventAdded(currentTimestamp));
  }

  void _onStart(PaneBoardEvent event, Emitter<PaneBoardState> emit) {
    dataSource.start(_sendEventToBloc);
    emit(state.asLoaded(dataSource.initialTimestamp, currentTimestamp));
  }

  void _onStop(PaneBoardEvent event, Emitter<PaneBoardState> emit) {
    dataSource.stop();
  }

  void _sendEventToBloc(Map<String, dynamic> event) {
    add(PaneDataReceived(eventJson: event));
  }
}
