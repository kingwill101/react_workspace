import 'package:react_dom/react_dom.dart';

import '../models/workflow.dart';
import '../utils.dart';

/// Renders the compact execution activity list used on dashboard pages.
ReactNode executionTimelineComponent(
  Iterable<Execution> executions, {
  String? className,
  void Function(Execution execution)? onSelect,
}) => div(
  className: cn(['space-y-1', className]),
  children: [
    for (final (index, execution) in executions.indexed)
      div(
        key: execution.id,
        className: 'group flex items-center gap-4 rounded-lg p-3 transition-colors hover:bg-secondary/50',
        onClick: onSelect == null ? null : (_) => onSelect(execution),
        style: {'animationDelay': '${index * 50}ms'},
        children: [
          div(
            className: cn([
              'rounded-lg p-2',
              switch (execution.status) {
                JobStatus.completed => 'bg-success/10 text-success',
                JobStatus.running => 'bg-running/10 text-running animate-pulse',
                JobStatus.failed => 'bg-destructive/10 text-destructive',
                JobStatus.pending => 'bg-muted text-muted-foreground',
                JobStatus.retrying => 'bg-warning/10 text-warning',
              },
            ]),
            children: [
              Text(switch (execution.status) {
                JobStatus.completed => '✓',
                JobStatus.running => '◌',
                JobStatus.failed => '×',
                JobStatus.pending => '◷',
                JobStatus.retrying => '↻',
              }),
            ],
          ),
          div(
            className: 'min-w-0 flex-1',
            children: [
              p(
                className:
                    'truncate text-sm font-medium group-hover:text-primary',
                children: [Text(execution.workflowName)],
              ),
              p(
                className: 'font-mono text-xs text-muted-foreground',
                children: [Text(execution.id)],
              ),
            ],
          ),
          div(
            className: 'text-right',
            children: [
              p(
                className: 'text-xs text-muted-foreground',
                children: [Text(execution.timestamp)],
              ),
              p(
                className: 'font-mono text-xs text-muted-foreground',
                children: [Text(execution.duration)],
              ),
            ],
          ),
        ],
      ),
  ],
);
