import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:celeryviz_frontend_core/models/pane_data.dart';

class PaneState extends Equatable {
  final bool isStarted;
  final bool isFirstEventReceived;
  final PaneData data;
  final double? minTimestamp;
  final double? maxTimestamp;

  PaneState.initial() : this._(data: PaneData());

  const PaneState._({
    this.isStarted = false,
    this.isFirstEventReceived = false,
    this.minTimestamp,
    this.maxTimestamp,
    required this.data,
  });

  @override
  get props => [isStarted, data, maxTimestamp, identityHashCode(this)];

  PaneState asEventAdded(Map<String, dynamic> eventJson) {
    data.addEvent(eventJson);

    if (isFirstEventReceived) {
      return copyWith(
          data: data,
          maxTimestamp: max(maxTimestamp!, eventJson['timestamp']),
          minTimestamp: min(minTimestamp!, eventJson['timestamp']));
    } else {
      return copyWith(
          data: data,
          minTimestamp: eventJson['timestamp'],
          maxTimestamp:
              eventJson['timestamp'] + 1, // So that the first event gets shown
          isFirstEventReceived: true);
    }
  }

  PaneState asStarted() {
    return copyWith(isStarted: true);
  }

  PaneState copyWith({
    bool? isStarted,
    bool? isFirstEventReceived,
    PaneData? data,
    double? minTimestamp,
    double? maxTimestamp,
  }) {
    return PaneState._(
        isStarted: isStarted ?? this.isStarted,
        isFirstEventReceived: isFirstEventReceived ?? this.isFirstEventReceived,
        minTimestamp: minTimestamp ?? this.minTimestamp,
        maxTimestamp: maxTimestamp ?? this.maxTimestamp,
        data: data ?? this.data);
  }
}
