import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:celeryviz_frontend_core/constants.dart';
import 'package:celeryviz_frontend_core/services/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef JsonObject = Map<String, dynamic>;
typedef SendEventsToBloc = void Function(List<Map<String, dynamic>> events);

abstract class DataSource {
  late SendEventsToBloc _sendEventsToBloc;
  bool _isStarted = false;

  String get dataSourceFailureMessage => 'Failed to load data source';

  Future setup(void Function() onSetupComplete, void Function() onSetupFailed);
  void start(SendEventsToBloc sendEventsToBloc);
  void stop();
}

abstract class QueriableDataSource extends DataSource {
  void seek(double timestamp);
}

class NDJsonDataSource extends DataSource {
  Queue<JsonObject> _eventsQueue = Queue();
  late Timer _timerSubscription;
  late double _initialTimestamp;
  final Stopwatch _stopwatch = Stopwatch();
  final String filePath;

  @override
  String get dataSourceFailureMessage => 'Failed to load NDJson data source';

  NDJsonDataSource({required this.filePath});

  @override
  Future setup(
      void Function() onSetupComplete, void Function() onSetupFailed) async {
    try {
      List<dynamic> data = await loadFromNDJson(filePath);
      _eventsQueue = Queue.from(data);
      _initialTimestamp = _eventsQueue.first['timestamp'];
      onSetupComplete();
    } catch (e) {
      onSetupFailed();
    }
  }

  @override
  void start(SendEventsToBloc sendEventsToBloc) {
    if (_isStarted) {
      return;
    }
    _sendEventsToBloc = sendEventsToBloc;
    _isStarted = true;
    _startEvents();
  }

  @override
  void stop() {
    _timerSubscription.cancel();
  }

  void _startEvents() {
    _stopwatch.reset();
    _stopwatch.start();
    _timerSubscription = Timer.periodic(const Duration(seconds: 3), (_) {
      _sendData();
    });
  }

  void _sendData() {
    final currentTime = _initialTimestamp + _stopwatch.elapsed.inSeconds;

    while (_eventsQueue.isNotEmpty &&
        _eventsQueue.first['timestamp'] < currentTime) {
      _sendEventsToBloc([_eventsQueue.removeFirst()]);
    }

    if (_eventsQueue.isEmpty) {
      stop();
    }
  }
}

class SocketIODataSource extends DataSource {
  final io.Socket _socket;
  final _logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  String get dataSourceFailureMessage =>
      'Unable to connect to socket.io data source';

  SocketIODataSource(String socketioServerLocation)
      : _socket = io.io(
            socketioServerLocation + socketioClientEndpoint, <String, dynamic>{
          'transports': ['websocket'],
        });

  @override
  Future setup(
      void Function() onSetupComplete, void Function() onSetupFailed) async {
    try {
      _logger.i('Connecting to socket.io server...');
      _socket.onConnect((data) => {
            _logger.i('Connected'),
            onSetupComplete(),
          });
      _socket.onDisconnect((data) => _logger.i('Disconnected'));
      _socket.onConnectError((err) => {
            _logger.e(err),
            onSetupFailed(),
          });
      _socket.onError((err) => {
            _logger.e(err),
            onSetupFailed(),
          });

      _socket.on(socketioServerDataEvent, (data) => _sendEventsToBloc([data]));
      _socket.connect();
    } catch (e) {
      _logger.e(e);
      onSetupFailed();
    }
  }

  @override
  void start(SendEventsToBloc sendEventsToBloc) {
    if (_isStarted) {
      throw Error();
    }
    _sendEventsToBloc = sendEventsToBloc;
    _isStarted = true;
  }

  @override
  void stop() {
    _socket.disconnect();
  }
}

class SnapshotDataSource extends DataSource {
  final List<JsonObject> eventsJson;

  SnapshotDataSource({required this.eventsJson});

  @override
  Future setup(
      void Function() onSetupComplete, void Function() onSetupFailed) async {
    onSetupComplete();
  }

  @override
  void start(SendEventsToBloc sendEventsToBloc) {
    _sendEventsToBloc = sendEventsToBloc;
    _isStarted = true;
    sendEventsToBloc(eventsJson);
  }

  @override
  void stop() {}
}

class BackendQueriableDataSource extends QueriableDataSource {
  final double initialTimestamp;
  final Uri _endpointUri;
  final _client = http.Client();
  final _timestampWindowSize = const Duration(seconds: 60);

  BackendQueriableDataSource(
      {required this.initialTimestamp, required endpoint})
      : _endpointUri = Uri.parse(endpoint);

  @override
  Future setup(
      void Function() onSetupComplete, void Function() onSetupFailed) async {
    try {
      // Send a HEAD request to check if the backend is reachable.
      final response = await _client.head(_endpointUri);
      if (response.statusCode != 200) {
        throw Exception(
            'Backend not reachable, status code: ${response.statusCode}, body: ${response.body}');
      }
      onSetupComplete();
    } catch (e) {
      onSetupFailed();
    }
  }

  @override
  void start(SendEventsToBloc sendEventsToBloc) {
    _sendEventsToBloc = sendEventsToBloc;
    _isStarted = true;
    seek(initialTimestamp);
  }

  @override
  void stop() {
    _client.close();
  }

  @override
  void seek(double timestamp) async {
    final DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
        (timestamp * 1000).toInt(),
        isUtc: true);
    final String startTimeStr = startTime.toIso8601String();
    final String endTimeStr =
        startTime.add(_timestampWindowSize).toIso8601String();

    final events = await _getEvents(startTimeStr, endTimeStr);
    _sendEventsToBloc(events);
  }

  Future<List<JsonObject>> _getEvents(String startTime, String endTime) async {
    final Uri uriWithParams = _endpointUri.replace(queryParameters: {
      'start_time': startTime,
      'end_time': endTime,
    });
    final response = await _client.get(uriWithParams);
    if (response.statusCode == 200) {
      final List<JsonObject> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Failed to fetch data, status code: ${response.statusCode}, body: ${response.body}');
    }
  }
}
