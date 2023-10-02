import 'package:celery_monitoring_core/celery_monitoring_core.dart';
import 'package:celery_monitoring_core/services/data_source.dart';
import 'package:celery_monitoring_core/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final DataSource dataSource =
      NDJsonDataSource(filePath: "assets/recording.ndjson");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: defaultTheme,
      home: Scaffold(
        body: Center(
          child: CeleryMonitoringCore(
            dataSource: dataSource,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
