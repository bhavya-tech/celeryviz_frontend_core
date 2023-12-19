import 'package:flutter/foundation.dart';
import 'package:celery_monitoring_core/services/data_source.dart';
import 'package:equatable/equatable.dart';

enum PaneScreenStateStatus {
  loading,
  loaded,
  error,
  inactive,
}

@immutable
class PaneScreenState extends Equatable {
  final DataSource dataSource;
  final PaneScreenStateStatus status;

  const PaneScreenState({
    required this.dataSource,
    PaneScreenStateStatus? status,
  }) : status = status ?? PaneScreenStateStatus.inactive;

  PaneScreenState asLoading() {
    return PaneScreenState(
      dataSource: dataSource,
      status: PaneScreenStateStatus.loading,
    );
  }

  PaneScreenState asLoaded() {
    return PaneScreenState(
      dataSource: dataSource,
      status: PaneScreenStateStatus.loaded,
    );
  }

  PaneScreenState asLoadFailed() {
    return PaneScreenState(
      dataSource: dataSource,
      status: PaneScreenStateStatus.error,
    );
  }

  @override
  List<Object?> get props => [
        dataSource,
        status,
      ];
}
