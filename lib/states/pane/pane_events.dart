abstract class PaneEvent {
  const PaneEvent();
}

/// Triggers the [DataSource.start] method.
class PaneStart extends PaneEvent {
  const PaneStart();
}

/// Triggers the [DataSource.stop] method.
class PaneStop extends PaneEvent {
  const PaneStop();
}

/// Triggered by the [DataSource] on receiving an event.
class PaneDataReceived extends PaneEvent {
  final List<Map<String, dynamic>> eventsJson;

  const PaneDataReceived({required this.eventsJson});
}
