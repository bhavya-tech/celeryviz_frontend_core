import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:next_flower/constants.dart';
import 'package:next_flower/services/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef JsonObject = Map<String, dynamic>;
typedef SendEventToBloc = void Function(Map<String, dynamic> event);

abstract class DataSource {
  late SendEventToBloc _sendEventToBloc;
  bool _isStarted = false;

  double get currentTimestamp;
  double get initialTimestamp;

  Future setup();
  void start(SendEventToBloc sendEventToBloc);
  void stop();
}

class NDJsonDataSource extends DataSource {
  Queue<JsonObject> _eventsQueue = Queue();
  double _initialTimestamp = 0;
  late Timer _timerSubscription;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  double get currentTimestamp =>
      _initialTimestamp + _stopwatch.elapsed.inSeconds;

  @override
  double get initialTimestamp => _initialTimestamp;

  @override
  Future setup() async {
    List<dynamic> data = await loadFromNDJson();
    _eventsQueue = Queue.from(data);
    _initialTimestamp = _eventsQueue.first['timestamp'];
  }

  @override
  void start(SendEventToBloc sendEventToBloc) {
    if (_isStarted) {
      return;
    }
    _sendEventToBloc = sendEventToBloc;
    _doStart();
    _isStarted = true;
  }

  @override
  void stop() {
    _timerSubscription.cancel();
  }

  void _doStart() {
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
      _sendEventToBloc(_eventsQueue.removeFirst());
    }

    if (_eventsQueue.isEmpty) {
      stop();
    }
  }
}

class SocketIODataSource extends DataSource {
  double _initialTimestamp = 0;
  late io.Socket _socket;
  final _logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  double get currentTimestamp =>
      DateTime.now().millisecondsSinceEpoch.toDouble() / 1000;

  @override
  double get initialTimestamp => _initialTimestamp;

  @override
  Future setup() async {
    _initSocket();
  }

  @override
  void start(SendEventToBloc sendEventToBloc) {
    if (_isStarted) {
      return;
    }
    _sendEventToBloc = sendEventToBloc;
    _initialTimestamp = DateTime.now().millisecondsSinceEpoch.toDouble() / 1000;
    _isStarted = true;
  }

  @override
  void stop() {
    _socket.disconnect();
  }

  Future _initSocket() async {
    _socket = io.io(socketioServerURL, <String, dynamic>{
      'transports': ['websocket'],
    });

    _logger.i('Connecting to socket.io server...');
    _socket.connect();
    _socket.onConnect((data) => _logger.i('Connected'));
    _socket.onDisconnect((data) => _logger.i('Disconnected'));
    _socket.onConnectError((err) => _logger.e(err));
    _socket.onError((err) => _logger.e(err));

    _socket.on(socketioServerDataEvent, (data) => _sendEventToBloc(data));
  }
}
