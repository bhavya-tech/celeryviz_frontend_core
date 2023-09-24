import 'package:equatable/equatable.dart';
import 'package:next_flower/models/pane_data.dart';

class PaneBoardState extends Equatable {
  final PaneStateStatus status;
  final PaneData data;
  final double timestampOffset;
  final double currentTimestamp;

  PaneBoardState.initial(double timestampOffset)
      : this._(data: PaneData(), timestampOffset: timestampOffset);

  const PaneBoardState._({
    this.status = PaneStateStatus.inactive,
    required this.timestampOffset,
    this.currentTimestamp = 0.0,
    required this.data,
  });

  @override
  get props => [status, data, currentTimestamp, identityHashCode(this)];

  void addEvent(Map<String, dynamic> event) {
    data.addEvent(event);
  }

  PaneBoardState asEventAdded(double currentTimestamp) {
    return copyWith(
        status: PaneStateStatus.loaded,
        data: data,
        currentTimestamp: currentTimestamp);
  }

  PaneBoardState asLoaded(double timestampOffset, double currentTimestamp) {
    return copyWith(
        status: PaneStateStatus.loaded,
        timestampOffset: timestampOffset,
        currentTimestamp: currentTimestamp);
  }

  PaneBoardState copyWith({
    PaneStateStatus? status,
    PaneData? data,
    double? timestampOffset,
    double? currentTimestamp,
  }) {
    return PaneBoardState._(
        status: status ?? this.status,
        timestampOffset: timestampOffset ?? this.timestampOffset,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        data: data ?? this.data);
  }
}

enum PaneStateStatus { inactive, loaded }
