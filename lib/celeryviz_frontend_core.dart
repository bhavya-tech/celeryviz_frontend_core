library celeryviz_frontend_core;

import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/screens/pane_screen.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';

class CeleryMonitoringCore extends StatelessWidget {
  final DataSource dataSource;

  const CeleryMonitoringCore({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return PaneScreen(dataSource: dataSource);
  }
}
