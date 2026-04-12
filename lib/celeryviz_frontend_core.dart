/// Core module for the Celeryviz frontend.
library;

import 'package:celeryviz_frontend_core/config/celeryviz_options.dart';
import 'package:celeryviz_frontend_core/config/celeryviz_options_config.dart';
import 'package:celeryviz_frontend_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/screens/pane_screen.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';

/// Mixin for initializing Celeryviz options.
///
/// This ensures that Celeryviz options are initialized before the application
/// as these options is a Singleton which is used across the application.
mixin CeleryvizOptionsInitializer {
  void initializeOptions(CeleryvizOptionsConfig config) {
    CeleryvizOptions.initialize(config);
  }
}

/// Main widget for the Celeryviz frontend.
///
/// This widget is the root of the Celeryviz frontend and is used to
/// display the Celeryviz UI.
///
/// It uses [DataSource] to fetch data and [CeleryvizOptionsConfig] to
/// configure the Celeryviz frontend.
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
