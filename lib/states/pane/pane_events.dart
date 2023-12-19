abstract class PaneEvent {
  const PaneEvent();
}

class PaneStart extends PaneEvent {
  const PaneStart();
}

class PaneStop extends PaneEvent {
  const PaneStop();
}

class PaneDataReceived extends PaneEvent {
  final Map<String, dynamic> eventJson;

  const PaneDataReceived({required this.eventJson});
}
