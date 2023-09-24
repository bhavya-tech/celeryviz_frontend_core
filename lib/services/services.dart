import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:celery_monitoring_core/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

void initSocket(io.Socket socket, void Function(Map<String, dynamic>) onEvent) {
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  logger.i('Connecting to socket.io server...');
  socket.connect();
  socket.onConnect((data) => logger.i('Connected'));
  socket.onDisconnect((data) => logger.i('Disconnected'));
  socket.onConnectError((err) => logger.e(err));
  socket.onError((err) => logger.e(err));

  socket.on(socketioServerDataEvent, (data) => onEvent(data));
}

Future<List<dynamic>> loadFromNDJson() async {
  String path = 'assets/recording.ndjson';
  String jsonString = await rootBundle.loadString(path);

  return const LineSplitter()
      .convert(jsonString)
      .map((e) => json.decode(e))
      .toList();
}

String? timestampToHumanReadable(double? timestamp, DateFormat format) {
  try {
    return (timestamp == null)
        ? null
        : format.format(
            DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt()));
  } catch (e) {
    return null;
  }
}
