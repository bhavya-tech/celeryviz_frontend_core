/// Events for the [PaneScreenBloc].
abstract class PaneScreenEvent {
  const PaneScreenEvent();
}

/// Event to trigger the [DataSource.setup] method.
class PaneScreenLoadStart extends PaneScreenEvent {
  const PaneScreenLoadStart();
}

/// Event fired after the [DataSource.setup] method runs successfully.
class PaneScreenLoadSuccess extends PaneScreenEvent {
  const PaneScreenLoadSuccess();
}

/// Event fired after the [DataSource.setup] method fails.
class PaneScreenLoadFailure extends PaneScreenEvent {
  const PaneScreenLoadFailure();
}
