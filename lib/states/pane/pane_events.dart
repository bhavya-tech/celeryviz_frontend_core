abstract class PaneEvent {
  const PaneEvent();
}

class PaneLoadStart extends PaneEvent {
  const PaneLoadStart();
}

class PaneLoadSuccess extends PaneEvent {
  const PaneLoadSuccess();
}

class PaneLoadFailure extends PaneEvent {
  const PaneLoadFailure();
}
