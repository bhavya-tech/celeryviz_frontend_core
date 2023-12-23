abstract class PaneScreenEvent {
  const PaneScreenEvent();
}

class PaneScreenLoadStart extends PaneScreenEvent {
  const PaneScreenLoadStart();
}

class PaneScreenLoadSuccess extends PaneScreenEvent {
  const PaneScreenLoadSuccess();
}

class PaneScreenLoadFailure extends PaneScreenEvent {
  const PaneScreenLoadFailure();
}
