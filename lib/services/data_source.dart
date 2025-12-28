import 'dart:async';
import 'dart:collection';
import 'dart:math';

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
  double get currentTimestamp;

  Future setup(void Function() onSetupComplete, void Function() onSetupFailed);
  void start(SendEventsToBloc sendEventsToBloc);
  void stop();
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
  double get currentTimestamp =>
      _initialTimestamp + _stopwatch.elapsed.inSeconds;

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
  double get currentTimestamp =>
      DateTime.now().millisecondsSinceEpoch.toDouble() / 1000;

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
  double get currentTimestamp {
    return eventsJson
        .map((event) => event['timestamp'] as double)
        .reduce((a, b) => max(a, b));
  }

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
