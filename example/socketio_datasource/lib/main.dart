import 'package:celeryviz_frontend_core/celeryviz_frontend_core.dart';
import 'package:flutter/material.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final DataSource dataSource = SocketIODataSource();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
