import 'package:react_dom/react_dom.dart';

import '../models/celery.dart';
import '../utils.dart';

/// Displays a task status. The icon is represented by a text glyph so this
/// component has no runtime dependency on lucide-react.
ReactNode taskStatusBadgeComponent(TaskStatus status, {String? className}) {
  final (label, glyph, tone) = switch (status) {
    TaskStatus.pending => ('Pending', '◷', 'bg-pending/10 text-pending'),
    TaskStatus.received => ('Received', '⇥', 'bg-muted text-muted-foreground'),
    TaskStatus.started => ('Started', '▶', 'bg-running/10 text-running'),
    TaskStatus.success => ('Success', '✓', 'bg-success/10 text-success'),
    TaskStatus.failure => ('Failure', '×', 'bg-failed/10 text-failed'),
    TaskStatus.revoked => ('Revoked', '⊘', 'bg-muted text-muted-foreground'),
    TaskStatus.retry => ('Retrying', '↻', 'bg-warning/10 text-warning'),
  };

  return span(
    className: cn([
      'inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-medium',
      tone,
      className,
    ]),
    children: [Text('$glyph  $label')],
  );
}

/// Displays queue lifecycle state.
ReactNode queueStatusBadgeComponent(QueueStatus status, {String? className}) {
  final (glyph, tone) = switch (status) {
    QueueStatus.active => ('▶', 'bg-success/10 text-success'),
    QueueStatus.paused => ('Ⅱ', 'bg-warning/10 text-warning'),
    QueueStatus.draining => ('◷', 'bg-pending/10 text-pending'),
  };
  return span(
    className: cn([
      'inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-medium',
      tone,
      className,
    ]),
    children: [Text('$glyph ${status.label}')],
  );
}

/// Displays worker connectivity state.
ReactNode workerStatusBadgeComponent(WorkerStatus status, {String? className}) {
  final (glyph, tone) = switch (status) {
    WorkerStatus.online => ('●', 'bg-success/10 text-success'),
    WorkerStatus.offline => ('○', 'bg-muted text-muted-foreground'),
    WorkerStatus.heartbeatLost => ('!', 'bg-warning/10 text-warning'),
  };
  return span(
    className: cn([
      'inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-medium',
      tone,
      className,
    ]),
    children: [Text('$glyph ${status.label}')],
  );
}
