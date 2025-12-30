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
  final List<Map<String, dynamic>> eventsJson;

  const PaneDataReceived({required this.eventsJson});
}
