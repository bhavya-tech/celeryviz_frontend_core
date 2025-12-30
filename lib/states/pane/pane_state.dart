import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:celeryviz_frontend_core/models/pane_data.dart';

class PaneState extends Equatable {
  final bool isStarted;
  final PaneData data;
  final double? timestampOffset;
  final double? maxTimestamp;

  PaneState.initial() : this._(data: PaneData());

  const PaneState._({
    this.isStarted = false,
    this.timestampOffset,
    this.maxTimestamp,
    required this.data,
  });

  @override
  get props => [isStarted, data, maxTimestamp, identityHashCode(this)];

  void addEvent(Map<String, dynamic> event) {
    data.addEvent(event);
  }

  PaneState asEventAdded(double eventTimestamp) {
    if (timestampOffset == null) {
      return copyWith(
          data: data,
          timestampOffset: data.timestampOffset,
          maxTimestamp: eventTimestamp);
    } else {
      return copyWith(
          data: data, maxTimestamp: max(maxTimestamp!, eventTimestamp));
    }
  }

  PaneState asStarted() {
    return copyWith(isStarted: true);
  }

  PaneState copyWith({
    bool? isStarted,
    PaneData? data,
    double? timestampOffset,
    double? maxTimestamp,
  }) {
    return PaneState._(
        isStarted: isStarted ?? this.isStarted,
        timestampOffset: timestampOffset ?? this.timestampOffset,
        maxTimestamp: maxTimestamp ?? this.maxTimestamp,
        data: data ?? this.data);
  }
}
