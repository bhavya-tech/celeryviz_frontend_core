import 'package:flutter/foundation.dart';
import 'package:celery_monitoring_core/services/data_source.dart';
import 'package:equatable/equatable.dart';

enum PaneStateStatus {
  loading,
  loaded,
  error,
  inactive,
}

@immutable
class PaneState extends Equatable {
  final DataSource dataSource;
  final PaneStateStatus status;

  const PaneState({
    required this.dataSource,
    PaneStateStatus? status,
  }) : status = status ?? PaneStateStatus.inactive;

  PaneState asLoading() {
    return PaneState(
      dataSource: dataSource,
      status: PaneStateStatus.loading,
    );
  }

  PaneState asLoaded() {
    return PaneState(
      dataSource: dataSource,
      status: PaneStateStatus.loaded,
    );
  }

  PaneState asLoadFailed() {
    return PaneState(
      dataSource: dataSource,
      status: PaneStateStatus.error,
    );
  }

  PaneState copyWith({
    DataSource? dataSource,
  }) {
    return PaneState(
      dataSource: dataSource ?? this.dataSource,
    );
  }

  @override
  List<Object?> get props => [
        dataSource,
        status,
      ];
}
