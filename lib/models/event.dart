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

  CeleryEventBase(
    this.hostname,
    this.utcoffset,
    this.pid,
    this.clock,
    this.uuid,
    this.timestamp,
    this.type,
    this.localReceived,
  );

  factory CeleryEventBase.fromJson(Map<String, dynamic> json) {
    return CeleryEventBase(
      json['hostname'],
      json['utcoffset'],
      json['pid'],
      json['clock'],
      json['uuid'],
      json['timestamp'],
      json['type'],
      json['local_received'],
    );
  }
}

class CeleryEventScheduled extends CeleryEventBase {
  // Represents the spawned task.
  String parentId;
  String name;
  String? args;
  String? kwargs;
  CeleryEventScheduled(
    String hostname,
    int utcoffset,
    int pid,
    int clock,
    String uuid,
    double timestamp,
    String type,
    double localReceived,
    this.name,
    this.parentId,
    this.args,
    this.kwargs,
  ) : super(
          hostname,
          utcoffset,
          pid,
          clock,
          uuid,
          timestamp,
          type,
          localReceived,
        );

  factory CeleryEventScheduled.fromJson(Map<String, dynamic> json) {
    String eta = json['eta'];
    DateTime etaDateTime = DateTime.parse(eta);
    double etaTimestamp = etaDateTime.millisecondsSinceEpoch / 1000;
    return CeleryEventScheduled(
      json['hostname'],
      json['utcoffset'],
      json['pid'],
      json['clock'],
      json['uuid'],
      etaTimestamp,
      "task-scheduled",
      json['local_received'],
      json['name'],
      json['parentId'] ?? json['uuid'],
      json['args'],
      json['kwargs'],
    );
  }
}

class CeleryEventSpawned extends CeleryEventBase {
  String childId;
  CeleryEventSpawned(
    String hostname,
    int utcoffset,
    int pid,
    int clock,
    String uuid,
    double timestamp,
    String type,
    double localReceived,
    this.childId,
  ) : super(
          hostname,
          utcoffset,
          pid,
          clock,
          uuid,
          timestamp,
          type,
          localReceived,
        );

  factory CeleryEventSpawned.fromJson(Map<String, dynamic> json) {
    return CeleryEventSpawned(
      json['hostname'],
      json['utcoffset'],
      json['pid'],
      json['clock'],
      json['parent_id'] ?? json['uuid'],
      json['timestamp'],
      "task-spawned",
      json['local_received'],
      json['uuid'],
    );
  }
}

class CeleryEventStarted extends CeleryEventBase {
  CeleryEventStarted(
    String hostname,
    int utcoffset,
    int pid,
    int clock,
    String uuid,
    double timestamp,
    String type,
    double localReceived,
  ) : super(
          hostname,
          utcoffset,
          pid,
          clock,
          uuid,
          timestamp,
          type,
          localReceived,
        );

  factory CeleryEventStarted.fromJson(Map<String, dynamic> json) {
    return CeleryEventStarted(
      json['hostname'],
      json['utcoffset'],
      json['pid'],
      json['clock'],
      json['uuid'],
      json['timestamp'],
      json['type'],
      json['local_received'],
    );
  }

  @override
  String toString() {
    return 'CeleryEventStarted{hostname: $hostname, utcoffset: $utcoffset, pid: $pid, clock: $clock, uuid: $uuid, timestamp: $timestamp, type: $type, localReceived: $localReceived}';
  }
}

class CeleryEventSucceeded extends CeleryEventBase {
  String result;
  double runtime;

  CeleryEventSucceeded(
    String hostname,
    int utcoffset,
    int pid,
    int clock,
    String uuid,
    double timestamp,
    String type,
    double localReceived,
    this.result,
    this.runtime,
  ) : super(
          hostname,
          utcoffset,
          pid,
          clock,
          uuid,
          timestamp,
          type,
          localReceived,
        );

  factory CeleryEventSucceeded.fromJson(Map<String, dynamic> json) {
    return CeleryEventSucceeded(
      json['hostname'],
      json['utcoffset'],
      json['pid'],
      json['clock'],
      json['uuid'],
      json['timestamp'],
      json['type'],
      json['local_received'],
      json['result'],
      json['runtime'],
    );
  }

  @override
  String toString() {
    return 'CeleryEventSucceeded{hostname: $hostname, utcoffset: $utcoffset, pid: $pid, clock: $clock, uuid: $uuid, timestamp: $timestamp, type: $type, localReceived: $localReceived, result: $result, runtime: $runtime}';
  }
}

class CeleryEventLog extends CeleryEventBase {
  final String msg;
  final int levelno;
  final String pathname;
  final int lineno;
  final String name;
  final dynamic excInfo; // ! Need to change as needed

  CeleryEventLog(
    String hostname,
    int utcoffset,
    int pid,
    int clock,
    String uuid,
    double timestamp,
    String type,
    double localReceived,
    this.msg,
    this.levelno,
    this.pathname,
    this.lineno,
    this.name,
    this.excInfo,
  ) : super(
          hostname,
          utcoffset,
          pid,
          clock,
          uuid,
          timestamp,
          type,
          localReceived,
        );

  factory CeleryEventLog.fromJson(Map<String, dynamic> json) {
    return CeleryEventLog(
      json['hostname'],
      json['utcoffset'],
      json['pid'],
      json['clock'],
      json['uuid'],
      json['timestamp'],
      json['type'],
      json['local_received'],
      json['msg'],
      json['levelno'],
      json['pathname'],
      json['lineno'],
      json['name'],
      json['exc_info'],
    );
  }
}
