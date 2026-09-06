import 'package:react_dom/react_dom.dart';

import '../models/celery.dart';
import '../models/workflow.dart';
import '../router.dart' as router;
import '../utils.dart';

/// Small composition helpers used while the shadcn/Radix primitives are
/// translated. They deliberately return the generated `react_dom` host
/// shapes, so the application remains portable between browser and SSR.
String cx(Object? first, [Object? second, Object? third]) =>
    cn([first, second, third]);

ReactNode icon(String glyph, {String? className}) => span(
  className: cx('inline-flex items-center justify-center', className),
  role: 'img',
  children: [Text(glyph)],
);

ReactNode appButton({
  required String label,
  String? href,
  String variant = 'default',
  void Function(ReactMouseEvent)? onClick,
  ReactChildren children = const [],
}) {
  final hasChildren = children.isNotEmpty;
  final content = [...children, if (hasChildren) Text(' '), Text(label)];
  if (href != null) {
    return router.navLink(
      to: href,
      className: cx(
        'inline-flex items-center justify-center rounded-lg px-3 py-2 text-sm font-medium transition-colors',
        variant == 'outline'
            ? 'border border-border bg-background hover:bg-secondary'
            : variant == 'ghost'
            ? 'text-muted-foreground hover:bg-secondary hover:text-foreground'
            : 'bg-primary text-primary-foreground hover:bg-primary/90 glow-primary',
      ),
      children: content,
    );
  }
  return button(
    className: cx(
      'inline-flex items-center justify-center rounded-lg px-3 py-2 text-sm font-medium transition-colors',
      variant == 'outline'
          ? 'border border-border bg-background hover:bg-secondary'
          : variant == 'ghost'
          ? 'text-muted-foreground hover:bg-secondary hover:text-foreground'
          : 'bg-primary text-primary-foreground hover:bg-primary/90 glow-primary',
    ),
    onClick: onClick,
    children: content,
  );
}

ReactNode statusBadge(JobStatus status) {
  final className = switch (status) {
    JobStatus.completed =>
      'bg-success/15 text-success border-success/30 glow-success',
    JobStatus.running => 'bg-running/15 text-running border-running/30 glow-running animate-pulse-glow',
    JobStatus.failed => 'bg-destructive/15 text-destructive border-destructive/30 glow-destructive',
    JobStatus.pending => 'bg-muted text-muted-foreground border-border',
    JobStatus.retrying => 'bg-warning/15 text-warning border-warning/30 glow-warning animate-pulse-glow',
  };
  return span(
    className: cx(
      'inline-flex items-center gap-1.5 rounded-full border px-2.5 py-1 text-xs font-medium',
      className,
    ),
    children: [
      span(
        className: 'h-1.5 w-1.5 rounded-full bg-current',
        children: const [],
      ),
      Text(status.label),
    ],
  );
}

ReactNode taskStatusBadge(TaskStatus status) {
  final label = switch (status) {
    TaskStatus.success => 'Success',
    TaskStatus.started => 'Started',
    TaskStatus.received => 'Received',
    TaskStatus.retry => 'Retrying',
    TaskStatus.failure => 'Failure',
    TaskStatus.revoked => 'Revoked',
    TaskStatus.pending => 'Pending',
  };
  final tone = switch (status) {
    TaskStatus.success => 'text-success bg-success/15 border-success/30',
    TaskStatus.started => 'text-running bg-running/15 border-running/30',
    TaskStatus.retry => 'text-warning bg-warning/15 border-warning/30',
    TaskStatus.failure =>
      'text-destructive bg-destructive/15 border-destructive/30',
    _ => 'text-muted-foreground bg-muted border-border',
  };
  return span(
    className:
        'inline-flex rounded-full border px-2.5 py-1 text-xs font-medium $tone',
    children: [Text(label)],
  );
}

ReactNode metricCard({
  required String title,
  required Object value,
  required String subtitle,
  required String glyph,
  required String trend,
  bool positive = true,
}) => div(
  className: 'relative rounded-xl border border-border bg-card p-5 transition-all duration-300 hover:border-primary/30 gradient-border',
  children: [
    div(
      className: 'flex items-start justify-between',
      children: [
        div(
          className: 'space-y-1',
          children: [
            p(
              className: 'text-sm font-medium text-muted-foreground',
              children: [Text(title)],
            ),
            p(
              className: 'text-3xl font-semibold tracking-tight',
              children: [Text('$value')],
            ),
            p(
              className: 'text-xs text-muted-foreground',
              children: [Text(subtitle)],
            ),
          ],
        ),
        div(
          className: 'rounded-lg bg-primary/10 p-2.5 text-primary',
          children: [icon(glyph, className: 'text-xl')],
        ),
      ],
    ),
    div(
      className: 'mt-3 flex items-center gap-1.5',
      children: [
        span(
          className: positive
              ? 'text-xs font-medium text-success'
              : 'text-xs font-medium text-destructive',
          children: [Text(trend)],
        ),
        span(
          className: 'text-xs text-muted-foreground',
          children: const [Text('from last hour')],
        ),
      ],
    ),
  ],
);

ReactNode workflowCard(
  Workflow workflow, {
  void Function(ReactMouseEvent)? onOpen,
}) {
  final total = workflow.steps.isEmpty ? 5 : workflow.steps.length;
  final completed = workflow.steps
      .where((step) => step.status == JobStatus.completed)
      .length;
  return div(
    className: 'group rounded-xl border border-border bg-card p-5 transition-all hover:border-primary/40 hover:shadow-lg',
    children: [
      div(
        className: 'mb-4 flex items-start justify-between gap-3',
        children: [
          div(
            className: 'min-w-0',
            children: [
              p(
                className: 'truncate font-medium',
                children: [Text(workflow.name)],
              ),
              p(
                className: 'mt-1 font-mono text-xs text-muted-foreground',
                children: [Text(workflow.id)],
              ),
            ],
          ),
          statusBadge(workflow.status),
        ],
      ),
      div(
        className: 'mb-4 flex items-center justify-between text-sm text-muted-foreground',
        children: [
          span(children: [Text('Duration ${workflow.duration}')]),
          span(children: [Text(workflow.lastRun)]),
        ],
      ),
      div(
        className: 'mb-4 h-1.5 overflow-hidden rounded-full bg-muted',
        children: [
          div(
            className: 'h-full rounded-full bg-primary transition-all',
            style: {'width': '${(completed / total * 100).round()}%'},
          ),
        ],
      ),
      div(
        className: 'flex items-center justify-between',
        children: [
          span(
            className: 'text-xs text-muted-foreground',
            children: [Text('$completed / $total steps')],
          ),
          appButton(label: 'Open', variant: 'ghost', onClick: onOpen),
        ],
      ),
    ],
  );
}

ReactNode executionTimeline(Iterable<Execution> executions) => div(
  className: 'divide-y divide-border',
  children: [
    for (final execution in executions)
      div(
        key: execution.id,
        className: 'flex items-center gap-3 px-3 py-3',
        children: [
          span(
            className:
                'h-2 w-2 shrink-0 rounded-full ${switch (execution.status) {
                  JobStatus.completed => 'bg-success',
                  JobStatus.running => 'bg-running animate-pulse',
                  JobStatus.failed => 'bg-destructive',
                  JobStatus.retrying => 'bg-warning',
                  JobStatus.pending => 'bg-muted-foreground',
                }}',
            children: const [],
          ),
          div(
            className: 'min-w-0 flex-1',
            children: [
              p(
                className: 'truncate text-sm font-medium',
                children: [Text(execution.workflowName)],
              ),
              p(
                className: 'text-xs text-muted-foreground',
                children: [Text(execution.timestamp)],
              ),
            ],
          ),
          span(
            className: 'font-mono text-xs text-muted-foreground',
            children: [Text(execution.duration)],
          ),
        ],
      ),
  ],
);

ReactNode dashboardSidebar({
  required String activePath,
  required String userName,
  required String userEmail,
}) {
  const items = [
    ('▦', 'Dashboard', '/dashboard'),
    ('⑂', 'Workflows', '/workflows'),
    ('⚙', 'Jobs', '/jobs'),
    ('☷', 'Tasks', '/tasks'),
    ('◈', 'Queues', '/queues'),
    ('▣', 'Workers', '/workers'),
    ('◷', 'Schedules', '/schedules'),
    ('☠', 'Dead Letters', '/dead-letters'),
    ('◌', 'Executions', '/executions'),
    ('♢', 'Alerts', '/alerts'),
    ('\$', 'Billing', '/billing'),
    ('⚙', 'Settings', '/settings'),
  ];
  const badges = <String, int>{
    '/workflows': 12,
    '/jobs': 10,
    '/tasks': 8,
    '/workers': 6,
    '/schedules': 8,
    '/dead-letters': 7,
    '/alerts': 3,
  };
  return aside(
    className: 'sticky top-0 flex h-screen w-64 shrink-0 flex-col border-r border-sidebar-border bg-sidebar',
    children: [
      div(
        className: 'flex items-center gap-3 border-b border-sidebar-border p-4',
        children: [
          div(
            className: 'flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground glow-primary',
            children: const [Text('✦')],
          ),
          span(
            className: 'font-semibold text-foreground',
            children: const [Text('StemCloud')],
          ),
        ],
      ),
      div(
        className: 'space-y-3 p-3',
        children: [
          div(
            className: 'flex items-center gap-2 rounded-lg border border-border/50 bg-muted/30 p-3',
            children: [
              div(
                className: 'flex h-8 w-8 items-center justify-center rounded-md bg-primary/20 text-primary',
                children: const [Text('⌂')],
              ),
              div(
                className: 'min-w-0',
                children: [
                  p(
                    className: 'truncate text-sm font-medium',
                    children: const [Text('Acme Corp')],
                  ),
                  p(
                    className: 'truncate text-xs text-muted-foreground',
                    children: const [Text('acme')],
                  ),
                ],
              ),
            ],
          ),
          input(
            placeholder: 'Search workflows...',
            className: 'w-full rounded-lg border border-transparent bg-sidebar-accent px-3 py-2 text-sm text-foreground outline-none focus:border-primary/50',
          ),
        ],
      ),
      nav(
        className: 'flex-1 space-y-1 overflow-auto p-3',
        children: [
          for (final item in items)
            router.navLink(
              to: item.$3,
              end: item.$3 == '/dashboard',
              className: cx(
                'flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-all',
                activePath == item.$3 ? 'bg-primary/10 text-primary' : 'text-sidebar-foreground hover:bg-sidebar-accent hover:text-foreground',
              ),
              children: [
                span(
                  className: 'w-5 text-center text-base',
                  children: [Text(item.$1)],
                ),
                span(className: 'flex-1', children: [Text(item.$2)]),
                if (badges[item.$3] case final count?)
                  span(
                    className: 'rounded-full bg-primary/20 px-2 py-0.5 text-xs text-primary',
                    children: [Text('$count')],
                  ),
              ],
            ),
        ],
      ),
      div(
        className: 'border-t border-sidebar-border p-3',
        children: [
          div(
            className:
                'mb-3 flex items-center gap-2 text-sm text-sidebar-foreground',
            children: [Text('☾  Dark Mode')],
          ),
          div(
            className: 'flex items-center gap-3 rounded-lg p-2',
            children: [
              div(
                className: 'flex h-8 w-8 items-center justify-center rounded-full bg-gradient-to-br from-primary to-running text-xs font-semibold text-primary-foreground',
                children: [Text('AM')],
              ),
              div(
                className: 'min-w-0 flex-1',
                children: [
                  p(
                    className: 'truncate text-sm font-medium',
                    children: [Text(userName)],
                  ),
                  p(
                    className: 'truncate text-xs text-muted-foreground',
                    children: [Text(userEmail)],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

ReactNode pageLayout({
  required String activePath,
  required String title,
  required String subtitle,
  required ReactNode body,
}) => div(
  className: 'flex min-h-screen bg-background',
  children: [
    dashboardSidebar(
      activePath: activePath,
      userName: 'Alex Morgan',
      userEmail: 'admin@acme.com',
    ),
    main(
      className: 'min-w-0 flex-1 overflow-auto',
      children: [
        header(
          className: 'sticky top-0 z-10 border-b border-border bg-background/80 backdrop-blur-sm',
          children: [
            div(
              className: 'flex items-center justify-between px-6 py-4',
              children: [
                div(
                  children: [
                    h1(
                      className: 'text-2xl font-semibold tracking-tight',
                      children: [Text(title)],
                    ),
                    p(
                      className: 'mt-0.5 text-sm text-muted-foreground',
                      children: [Text(subtitle)],
                    ),
                  ],
                ),
                span(
                  className: 'hidden text-xs text-muted-foreground sm:block',
                  children: const [Text('Live · Acme Corp')],
                ),
              ],
            ),
          ],
        ),
        div(className: 'space-y-6 p-6', children: [body]),
      ],
    ),
  ],
);

ReactNode pageSection({
  required String title,
  required ReactChildren children,
}) => section(
  className: 'space-y-4',
  children: [
    h2(className: 'text-lg font-semibold', children: [Text(title)]),
    ...children,
  ],
);

ReactNode emptyState({
  required String glyph,
  required String title,
  required String description,
  String? action,
  void Function(ReactMouseEvent)? onAction,
}) => div(
  className: 'flex flex-col items-center justify-center rounded-xl border border-dashed border-border bg-muted/20 px-4 py-16 text-center',
  children: [
    div(
      className: 'mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-muted text-3xl',
      children: [Text(glyph)],
    ),
    h3(className: 'mb-2 text-lg font-semibold', children: [Text(title)]),
    p(
      className: 'mb-6 max-w-md text-muted-foreground',
      children: [Text(description)],
    ),
    if (action != null) appButton(label: action, onClick: onAction),
  ],
);
