import 'package:celeryviz_frontend_core/celeryviz_frontend_core.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
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
    return CeleryMonitoringCore(
      dataSource: dataSource,
    );
  }
}
