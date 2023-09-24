library celery_monitoring_core;

import 'package:flutter/material.dart';
import 'package:next_flower/screens/pane.dart';
import 'package:next_flower/services/data_source.dart';

class CeleryMonitoringCore extends StatelessWidget {
  final DataSource dataSource;

  const CeleryMonitoringCore({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return Pane(dataSource: dataSource);
  }
}
