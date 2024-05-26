import 'package:equatable/equatable.dart';
import 'package:celeryviz_frontend_core/models/pane_data.dart';

class PaneState extends Equatable {
  final bool isStarted;
  final PaneData data;
  final double? timestampOffset;
  final double? currentTimestamp;

  PaneState.initial() : this._(data: PaneData());

  const PaneState._({
    this.isStarted = false,
    this.timestampOffset,
    this.currentTimestamp,
    required this.data,
  });

  @override
  get props => [isStarted, data, currentTimestamp, identityHashCode(this)];

  void addEvent(Map<String, dynamic> event) {
    data.addEvent(event);
  }

  PaneState asEventAdded(double currentTimestamp) {
    return copyWith(
        isStarted: true,
        data: data,
        currentTimestamp: currentTimestamp,
        timestampOffset: timestampOffset);
  }

  PaneState asLoaded(double timestampOffset, double currentTimestamp) {
    return copyWith(
        isStarted: true,
        timestampOffset: timestampOffset,
        currentTimestamp: currentTimestamp);
  }

  PaneState copyWith({
    bool? isStarted,
    PaneData? data,
    double? timestampOffset,
    double? currentTimestamp,
  }) {
    return PaneState._(
        isStarted: isStarted ?? this.isStarted,
        timestampOffset: timestampOffset ?? this.timestampOffset,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        data: data ?? this.data);
  }
}
