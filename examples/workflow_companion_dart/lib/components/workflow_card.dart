import 'package:react_dom/react_dom.dart';

import '../models/workflow.dart';
import '../router.dart' as router;
import '../utils.dart';
import 'status_badge.dart';

/// A clickable workflow summary card.
ReactNode workflowCardComponent(
  Workflow workflow, {
  String? className,
  String? key,
}) {
  final total = workflow.steps.length;
  final completed = workflow.steps
      .where((step) => step.status == JobStatus.completed)
      .length;
  final percentage = total == 0 ? 0 : (completed / total * 100).round();

  return div(
    key: key,
    className: cn([
      'group rounded-xl border border-border bg-card p-5 transition-all duration-300 hover:border-primary/40 hover:bg-card/80',
      className,
    ]),
    children: [
      div(
        className: 'mb-4 flex items-start justify-between',
        children: [
          div(
            className: 'space-y-1',
            children: [
              p(
                className: 'font-mono text-xs text-muted-foreground',
                children: [Text(workflow.id)],
              ),
              h3(
                className: 'font-semibold group-hover:text-primary',
                children: [Text(workflow.name)],
              ),
            ],
          ),
          statusBadgeComponent(workflow.status),
        ],
      ),
      div(
        className: 'mb-4',
        children: [
          div(
            className: 'mb-1.5 flex items-center justify-between text-xs text-muted-foreground',
            children: [const Text('Progress'), Text('$completed/$total steps')],
          ),
          div(
            className: 'h-1.5 overflow-hidden rounded-full bg-secondary',
            children: [
              div(
                className: cn([
                  'h-full rounded-full transition-all duration-500',
                  switch (workflow.status) {
                    JobStatus.completed => 'bg-success',
                    JobStatus.running => 'bg-running',
                    JobStatus.failed => 'bg-destructive',
                    JobStatus.pending => 'bg-muted-foreground',
                    JobStatus.retrying => 'bg-warning',
                  },
                ]),
                style: {'width': '$percentage%'},
              ),
            ],
          ),
        ],
      ),
      div(
        className:
            'flex items-center justify-between text-xs text-muted-foreground',
        children: [
          span(children: [Text('◷ ${workflow.duration}')]),
          span(children: [Text(workflow.lastRun)]),
        ],
      ),
      div(
        className: 'mt-4 flex items-center justify-between border-t border-border pt-4 opacity-70 group-hover:opacity-100',
        children: [
          router.navLink(
            to: '/workflows/${workflow.id}',
            className: 'flex flex-1 items-center justify-between text-xs text-muted-foreground hover:text-primary',
            children: const [Text('View details'), Text('→')],
          ),
        ],
      ),
    ],
  );
}
