library celeryviz_frontend_core;

import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';
import 'package:celeryviz_frontend_core/config/celeryviz_options_config.dart';
import 'package:celeryviz_frontend_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/screens/pane_screen.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';

mixin CeleryvizOptionsInitializer {
  void initializeOptions(CeleryvizOptionsConfig config) {
    CeleryvizOptions.initialize(config);
  }
}

class CeleryMonitoringCore extends StatelessWidget
    with CeleryvizOptionsInitializer {
  final DataSource dataSource;
  final CeleryvizOptionsConfig config;

  CeleryMonitoringCore({
    super.key,
    required this.dataSource,
    this.config = const CeleryvizOptionsConfig(),
  }) {
    initializeOptions(config);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: defaultTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: PaneScreen(dataSource: dataSource)));
  }
}
