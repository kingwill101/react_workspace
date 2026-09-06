/// Workflow and job records used by the dashboard mock.
enum JobStatus { completed, running, failed, pending, retrying }

extension JobStatusLabel on JobStatus {
  String get label => switch (this) {
    JobStatus.completed => 'Completed',
    JobStatus.running => 'Running',
    JobStatus.failed => 'Failed',
    JobStatus.pending => 'Pending',
    JobStatus.retrying => 'Retrying',
  };
}

class Job {
  const Job({
    required this.id,
    required this.name,
    required this.status,
    required this.duration,
    required this.retries,
    required this.startedAt,
    this.completedAt,
    this.workflowId,
    this.worker,
    this.input,
    this.output,
    this.error,
  });

  final String id;
  final String name;
  final JobStatus status;
  final String duration;
  final int retries;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? workflowId;
  final String? worker;
  final Map<String, Object?>? input;
  final Map<String, Object?>? output;
  final String? error;
}

class WorkflowStep {
  const WorkflowStep({
    required this.id,
    required this.name,
    required this.jobId,
    required this.status,
    required this.duration,
    required this.order,
  });

  final String id;
  final String name;
  final String jobId;
  final JobStatus status;
  final String duration;
  final int order;
}

class Workflow {
  const Workflow({
    required this.id,
    required this.name,
    required this.status,
    required this.duration,
    required this.retries,
    required this.lastRun,
    required this.steps,
    this.description,
    this.history = const [],
  });

  final String id;
  final String name;
  final JobStatus status;
  final String duration;
  final int retries;
  final String lastRun;
  final List<WorkflowStep> steps;
  final String? description;
  final List<Execution> history;
}

/// A historical workflow execution and its step snapshots.
class Execution {
  const Execution({
    required this.id,
    required this.workflowName,
    required this.status,
    required this.timestamp,
    required this.duration,
    this.workflowId,
    this.startedAt,
    this.completedAt,
    this.steps = const [],
  });

  final String id;
  final String workflowName;
  final JobStatus status;
  final String timestamp;
  final String duration;
  final String? workflowId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final List<WorkflowStep> steps;
}

/// Alias retaining the name used by the TypeScript source.
typedef WorkflowExecution = Execution;
