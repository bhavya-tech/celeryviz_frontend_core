import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:celeryviz_frontend_core/models/pane_data.dart';

/// State for the [PaneBloc].
///
/// It holds the [PaneData] which has the events grouped by their task id.
///
/// Apart from that, it holds the data required to render the pane.
class PaneState extends Equatable {
  /// Whether the data source is started.
  final bool isStarted;

  /// Whether the first event has been received.
  final bool isFirstEventReceived;

  /// The [PaneData] which has the events grouped by their task id.
  final PaneData data;

  /// The minimum timestamp of the events (used as the start of
  /// the verticle timeline).
  final double? minTimestamp;

  /// The maximum timestamp of the events (used as the end of
  /// the verticle timeline).
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

    double newMinTimestamp = minTimestamp ?? double.infinity;
    double newMaxTimestamp = maxTimestamp ?? double.negativeInfinity;

    for (var eventJson in eventJsons) {
      newMinTimestamp = min(newMinTimestamp, eventJson['timestamp']);
      newMaxTimestamp = max(newMaxTimestamp, eventJson['timestamp']);
      data.addEvent(eventJson);
    }

    // So that a single event will get shown properly
    if (newMinTimestamp == newMaxTimestamp) {
      newMaxTimestamp += 1;
    }

    return copyWith(
        data: data,
        minTimestamp: newMinTimestamp,
        maxTimestamp: newMaxTimestamp,
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
