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

  PaneState asEventsAdded(List<Map<String, dynamic>> eventJsons) {
    if (eventJsons.isEmpty) {
      return this;
    }

    double minTimestamp = double.infinity;
    double maxTimestamp = double.negativeInfinity;

    for (var eventJson in eventJsons) {
      minTimestamp = min(minTimestamp, eventJson['timestamp']);
      maxTimestamp = max(maxTimestamp, eventJson['timestamp']);
      data.addEvent(eventJson);
    }

    // So that a single event will get shown properly
    if (minTimestamp == maxTimestamp) {
      maxTimestamp += 1;
    }

    return copyWith(
        data: data,
        minTimestamp: minTimestamp,
        maxTimestamp: maxTimestamp,
        isFirstEventReceived: true);
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
