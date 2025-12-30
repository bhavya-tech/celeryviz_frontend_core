import 'package:celeryviz_frontend_core/celeryviz_frontend_core.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:celeryviz_frontend_core/services/services.dart'
    show loadFromNDJson;
import 'package:flutter/material.dart';

void main() {
  runApp(const SnapshotView());
}

// Stream the event objects based on their timestamps so that the
// rendering behaves as it would in a live streaming.

class NdjsonStream extends StatelessWidget {
  NdjsonStream({Key? key}) : super(key: key);
  final DataSource dataSource =
      NDJsonDataSource(filePath: "assets/recording.ndjson");

  @override
  Widget build(BuildContext context) {
    return CeleryMonitoringCore(
      dataSource: dataSource,
    );
  }
}

// A widget to show all the events rendered directly rather than faking
// a live stream. Faster for developing and testing rendering code.

class SnapshotView extends StatefulWidget {
  const SnapshotView({super.key});

  @override
  State<SnapshotView> createState() => _SnapshotViewState();
}

class _SnapshotViewState extends State<SnapshotView> {
  List<JsonObject>? _events;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final data = await loadFromNDJson('assets/recording.ndjson');
      setState(() {
        _events = List<JsonObject>.from(data);
      });
    } catch (e) {
      setState(() {
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return const Center(child: Text('Failed to load events'));
    }

    if (_events == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return CeleryMonitoringCore(
      dataSource: SnapshotDataSource(eventsJson: _events!),
    );
  }
}
