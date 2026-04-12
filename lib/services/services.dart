/// General services used by the application.
library;

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

Future<List<dynamic>> loadFromNDJson(String filePath) async {
  String jsonString = await rootBundle.loadString(filePath);

  return const LineSplitter()
      .convert(jsonString)
      .map((e) => json.decode(e))
      .toList();
}

String? timestampToHumanReadable(double? timestamp, DateFormat format) {
  return (timestamp == null)
      ? null
      : format.format(
          DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt()));
}
