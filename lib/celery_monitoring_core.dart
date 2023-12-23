library celery_monitoring_core;

import 'package:flutter/material.dart';
import 'package:celery_monitoring_core/screens/pane_screen.dart';
import 'package:celery_monitoring_core/services/data_source.dart';

class CeleryMonitoringCore extends StatelessWidget {
  final DataSource dataSource;

  const CeleryMonitoringCore({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return PaneScreen(dataSource: dataSource);
  }
}
