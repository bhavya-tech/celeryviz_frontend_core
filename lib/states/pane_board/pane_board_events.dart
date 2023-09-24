abstract class PaneBoardEvent {
  const PaneBoardEvent();
}

class PaneBoardStart extends PaneBoardEvent {
  const PaneBoardStart();
}

class PaneBoardStop extends PaneBoardEvent {
  const PaneBoardStop();
}

class PaneDataReceived extends PaneBoardEvent {
  final Map<String, dynamic> eventJson;

  const PaneDataReceived({required this.eventJson});
}
