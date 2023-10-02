import 'package:equatable/equatable.dart';
import 'package:celery_monitoring_core/models/pane_data.dart';

class PaneBoardState extends Equatable {
  final bool isStarted;
  final PaneData data;
  final double? timestampOffset;
  final double? currentTimestamp;

  PaneBoardState.initial() : this._(data: PaneData());

  const PaneBoardState._({
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

  PaneBoardState asEventAdded(double currentTimestamp) {
    return copyWith(
        isStarted: true,
        data: data,
        currentTimestamp: currentTimestamp,
        timestampOffset: timestampOffset);
  }

  PaneBoardState asLoaded(double timestampOffset, double currentTimestamp) {
    return copyWith(
        isStarted: true,
        timestampOffset: timestampOffset,
        currentTimestamp: currentTimestamp);
  }

  PaneBoardState copyWith({
    bool? isStarted,
    PaneData? data,
    double? timestampOffset,
    double? currentTimestamp,
  }) {
    return PaneBoardState._(
        isStarted: isStarted ?? this.isStarted,
        timestampOffset: timestampOffset ?? this.timestampOffset,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        data: data ?? this.data);
  }
}
