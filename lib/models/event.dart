CeleryEventBase getCeleryEventFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'task-received':
      return CeleryEventSpawned.fromJson(json);
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

class CeleryEventSpawned extends CeleryEventBase {
  // Represents the event of a task spawning other task.
  // From celery side, this event is called "task-received".
  // Celery treats that event as event of the spawned child task, however as of this app, we will treat it as event of the parent task.
  String childId;
  String childName;
  String? childArgs;
  String? childKwargs;
  String? childEta;
  CeleryEventSpawned(
      {required this.childName,
      required this.childArgs,
      required this.childKwargs,
      required this.childId,
      required super.hostname,
      required super.utcoffset,
      required super.pid,
      required super.clock,
      required super.uuid,
      required super.timestamp,
      required super.type,
      required super.localReceived});

  CeleryEventSpawned.fromJson(Map<String, dynamic> json)
      : childName = json['name'],
        childId = json['uuid'],
        childArgs = json['args'],
        childKwargs = json['kwargs'],
        childEta = json['eta'],
        super.fromJson(_modifyJson(json));

  static Map<String, dynamic> _modifyJson(Map<String, dynamic> json) {
    json['uuid'] = json['parent_id'];
    return json;
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
