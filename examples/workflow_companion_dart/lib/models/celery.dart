/// Celery-compatible dashboard records.
enum TaskStatus { pending, received, started, success, failure, revoked, retry }

enum QueueStatus { active, paused, draining }

enum WorkerStatus { online, offline, heartbeatLost }

enum DeadLetterReason {
  maxRetries,
  expired,
  rejected,
  unroutable,
  processingError,
}

extension TaskStatusLabel on TaskStatus {
  String get label => switch (this) {
    TaskStatus.pending => 'Pending',
    TaskStatus.received => 'Received',
    TaskStatus.started => 'Started',
    TaskStatus.success => 'Success',
    TaskStatus.failure => 'Failure',
    TaskStatus.revoked => 'Revoked',
    TaskStatus.retry => 'Retrying',
  };
}

extension QueueStatusLabel on QueueStatus {
  String get label => switch (this) {
    QueueStatus.active => 'Active',
    QueueStatus.paused => 'Paused',
    QueueStatus.draining => 'Draining',
  };
}

extension WorkerStatusLabel on WorkerStatus {
  String get label => switch (this) {
    WorkerStatus.online => 'Online',
    WorkerStatus.offline => 'Offline',
    WorkerStatus.heartbeatLost => 'Heartbeat lost',
  };
}

extension DeadLetterReasonLabel on DeadLetterReason {
  String get label => switch (this) {
    DeadLetterReason.maxRetries => 'Max retries',
    DeadLetterReason.expired => 'Expired',
    DeadLetterReason.rejected => 'Rejected',
    DeadLetterReason.unroutable => 'Unroutable',
    DeadLetterReason.processingError => 'Processing error',
  };
}

class Task {
  const Task({
    required this.id,
    required this.name,
    required this.status,
    required this.queue,
    required this.retries,
    this.args = '',
    this.kwargs = '',
    this.worker,
    this.eta,
    this.expires,
    this.receivedAt,
    this.startedAt,
    this.succeededAt,
    this.failedAt,
    this.runtime,
    this.result,
    this.exception,
    this.traceback,
  });

  final String id;
  final String name;
  final TaskStatus status;
  final String queue;
  final int retries;
  final String args;
  final String kwargs;
  final String? worker;
  final String? eta;
  final String? expires;
  final String? receivedAt;
  final String? startedAt;
  final String? succeededAt;
  final String? failedAt;
  final String? runtime;
  final String? result;
  final String? exception;
  final String? traceback;
}

class Queue {
  const Queue({
    required this.id,
    required this.name,
    required this.status,
    required this.pendingTasks,
    required this.consumers,
    required this.messageRate,
    required this.avgProcessingTime,
    this.maxLength,
  });

  final String id;
  final String name;
  final QueueStatus status;
  final int pendingTasks;
  final int consumers;
  final double messageRate;
  final String avgProcessingTime;
  final int? maxLength;
}

class Worker {
  const Worker({
    required this.id,
    required this.hostname,
    required this.status,
    required this.queues,
    required this.concurrency,
    required this.activeTasks,
    required this.completedTasks,
    required this.failedTasks,
    required this.uptime,
    this.lastHeartbeat = '',
    this.loadAvg = const [],
    this.memoryUsage = 0,
    this.pid = 0,
  });

  final String id;
  final String hostname;
  final WorkerStatus status;
  final List<String> queues;
  final int concurrency;
  final int activeTasks;
  final int completedTasks;
  final int failedTasks;
  final String uptime;
  final String lastHeartbeat;
  final List<double> loadAvg;
  final double memoryUsage;
  final int pid;
}

class DeadLetter {
  const DeadLetter({
    required this.id,
    required this.taskName,
    required this.queue,
    required this.reason,
    required this.retries,
    required this.requeued,
    this.originalTaskId = '',
    this.args = '',
    this.kwargs = '',
    this.exception,
    this.traceback,
    this.originalReceivedAt = '',
    this.deadLetteredAt = '',
  });

  final String id;
  final String taskName;
  final String queue;
  final DeadLetterReason reason;
  final String originalTaskId;
  final String args;
  final String kwargs;
  final String? exception;
  final String? traceback;
  final int retries;
  final String originalReceivedAt;
  final String deadLetteredAt;
  final bool requeued;
}
