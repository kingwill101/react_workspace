import 'package:react_dom/react_dom.dart';

import '../models/workflow.dart';
import '../utils.dart';

/// Displays a workflow or job status using the reference dashboard palette.
ReactNode statusBadgeComponent(JobStatus status, {String? className}) {
  final tone = switch (status) {
    JobStatus.completed =>
      'bg-success/15 text-success border-success/30 glow-success',
    JobStatus.running => 'bg-running/15 text-running border-running/30 glow-running animate-pulse-glow',
    JobStatus.failed => 'bg-destructive/15 text-destructive border-destructive/30 glow-destructive',
    JobStatus.pending => 'bg-muted text-muted-foreground border-border',
    JobStatus.retrying => 'bg-warning/15 text-warning border-warning/30 glow-warning animate-pulse-glow',
  };

  return span(
    className: cn([
      'inline-flex items-center gap-1.5 rounded-full border px-2.5 py-1 text-xs font-medium',
      tone,
      className,
    ]),
    children: [
      span(className: 'h-1.5 w-1.5 rounded-full bg-current'),
      Text(status.label),
    ],
  );
}
