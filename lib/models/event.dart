CeleryEventBase getCeleryEventFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'task-spawned':
      return CeleryEventSpawned.fromJson(json);
    case 'task-scheduled':
      return CeleryEventScheduled.fromJson(json);
    case 'task-started':
      return CeleryEventStarted.fromJson(json);
    case 'task-succeeded':
      return CeleryEventSucceeded.fromJson(json);
    case 'task-log':
      return CeleryEventLog.fromJson(json);
    default:
      return CeleryEventBase.fromJson(json);
  }
}

class CeleryEventBase {
  String hostname;
  int utcoffset;
  int pid;
  int clock;
  String uuid;
  double timestamp;
  String type;
  double localReceived;

  CeleryEventBase({
    required this.hostname,
    required this.utcoffset,
    required this.pid,
    required this.clock,
    required this.uuid,
    required this.timestamp,
    required this.type,
    required this.localReceived,
  });

  CeleryEventBase.fromJson(Map<String, dynamic> json)
      : hostname = json['hostname'],
        utcoffset = json['utcoffset'],
        pid = json['pid'],
        clock = json['clock'],
        uuid = json['uuid'],
        timestamp = json['timestamp'],
        type = json['type'],
        localReceived = json['local_received'];
}

class CeleryEventScheduled extends CeleryEventBase {
  // Represents the spawned task.
  String parentId;
  String name;
  String? args;
  String? kwargs;
  CeleryEventScheduled(
      {required this.name,
      required this.parentId,
      required this.args,
      required this.kwargs,
      required super.hostname,
      required super.utcoffset,
      required super.pid,
      required super.clock,
      required super.uuid,
      required super.timestamp,
      required super.type,
      required super.localReceived});

  CeleryEventScheduled.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        parentId = json['parent_id'] ?? json['uuid'],
        args = json['args'],
        kwargs = json['kwargs'],
        super.fromJson(_modifyJson(json));

  static Map<String, dynamic> _modifyJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.from(json);
    String eta = json['eta'];
    DateTime etaDateTime = DateTime.parse(eta);
    double etaTimestamp = etaDateTime.millisecondsSinceEpoch / 1000;
    jsonCopy['timestamp'] = etaTimestamp;
    jsonCopy['type'] = "task-scheduled";
    return jsonCopy;
  }
}

class CeleryEventSpawned extends CeleryEventBase {
  String childId;
  CeleryEventSpawned({
    required super.hostname,
    required super.utcoffset,
    required super.pid,
    required super.clock,
    required super.uuid,
    required super.timestamp,
    required super.type,
    required super.localReceived,
    required this.childId,
  });

  CeleryEventSpawned.fromJson(Map<String, dynamic> json)
      : childId = json['uuid'],
        super.fromJson(_modifyJson(json));

  static Map<String, dynamic> _modifyJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.from(json);
    jsonCopy['type'] = "task-spawned";
    jsonCopy['uuid'] = json['parent_id'] ?? json['uuid'];
    return jsonCopy;
  }
}

class CeleryEventStarted extends CeleryEventBase {
  CeleryEventStarted({
    required super.hostname,
    required super.utcoffset,
    required super.pid,
    required super.clock,
    required super.uuid,
    required super.timestamp,
    required super.type,
    required super.localReceived,
  });
  CeleryEventStarted.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class CeleryEventSucceeded extends CeleryEventBase {
  String result;
  double runtime;

  CeleryEventSucceeded({
    required super.hostname,
    required super.utcoffset,
    required super.pid,
    required super.clock,
    required super.uuid,
    required super.timestamp,
    required super.type,
    required super.localReceived,
    required this.result,
    required this.runtime,
  });

  CeleryEventSucceeded.fromJson(Map<String, dynamic> json)
      : result = json['result'],
        runtime = json['runtime'],
        super.fromJson(json);
}

class CeleryEventLog extends CeleryEventBase {
  final String msg;
  final int levelno;
  final String pathname;
  final int lineno;
  final String name;
  final dynamic excInfo;

  CeleryEventLog({
    required super.hostname,
    required super.utcoffset,
    required super.pid,
    required super.clock,
    required super.uuid,
    required super.timestamp,
    required super.type,
    required super.localReceived,
    required this.msg,
    required this.levelno,
    required this.pathname,
    required this.lineno,
    required this.name,
    required this.excInfo,
  });

  CeleryEventLog.fromJson(Map<String, dynamic> json)
      : msg = json['msg'],
        levelno = json['levelno'],
        pathname = json['pathname'],
        lineno = json['lineno'],
        name = json['name'],
        excInfo = json['exc_info'],
        super.fromJson(json);
}
