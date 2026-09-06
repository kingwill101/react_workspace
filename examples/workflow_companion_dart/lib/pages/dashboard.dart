import 'package:react_dom/react_dom.dart';

import '../components/dialogs.dart';
import '../components/empty_state.dart';
import '../components/execution_timeline.dart';
import '../components/metric_card.dart';
import '../components/page_layout.dart';
import '../components/workflow_card.dart';
import '../contexts/tenant_context.dart';
import '../data/mock_data.dart';
import '../components/ui/button.dart';
import '../models/workflow.dart';
import '../router.dart' as router;

/// Dashboard metric definition kept as data, just like the reference page.
final class DashboardMetric {
  const DashboardMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.glyph,
    required this.trend,
    this.positive = true,
  });

  final String title;
  final Object value;
  final String subtitle;
  final String glyph;
  final int trend;
  final bool positive;
}

const _metrics = <DashboardMetric>[
  DashboardMetric(
    title: 'Active Workflows',
    value: 24,
    subtitle: '8 running now',
    glyph: '◉',
    trend: 12,
  ),
  DashboardMetric(
    title: 'Completed Today',
    value: 847,
    subtitle: '99.2% success rate',
    glyph: '✓',
    trend: 8,
  ),
  DashboardMetric(
    title: 'Avg. Duration',
    value: '2.4s',
    subtitle: '↓ 0.3s from yesterday',
    glyph: '◷',
    trend: 11,
  ),
  DashboardMetric(
    title: 'Failed',
    value: 7,
    subtitle: '3 require attention',
    glyph: '!',
    trend: 2,
    positive: false,
  ),
];

/// The translated dashboard route, including gateway empty state and cards.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode DashboardPage(({String? scope}) props) {
  final tenant = useTenant();
  final (showFilters, setShowFilters) = useState(false);
  final (lastRefresh, setLastRefresh) = useState<DateTime?>(null);
  final (localWorkflows, setLocalWorkflows) = useState<List<Workflow>>(
    List.of(workflows),
  );
  final (newWorkflowOpen, setNewWorkflowOpen) = useState(false);
  final workflowDialog = newWorkflowDialog(
    open: newWorkflowOpen,
    onOpenChange: setNewWorkflowOpen.call,
    onCreated: (workflow) =>
        setLocalWorkflows.update((items) => [workflow, ...items]),
  );

  final body = !tenant.isGatewayConnected
      ? gatewayConnectionEmptyState(
          onConnect: () => tenant.setIsGatewayConnected(true),
          learnMoreHref: '/settings',
        )
      : fragment([
          if (showFilters)
            div(
              className: 'rounded-lg border border-primary/30 bg-primary/5 p-3 text-sm text-muted-foreground',
              children: const [
                Text('Showing live workflow activity for all queues.'),
              ],
            ),
          div(
            className: 'grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-4',
            children: [
              for (final metric in _metrics)
                metricCardComponent(
                  key: metric.title,
                  title: metric.title,
                  value: metric.value,
                  subtitle: metric.subtitle,
                  glyph: metric.glyph,
                  trend: metric.trend,
                  positive: metric.positive,
                ),
            ],
          ),
          div(
            className: 'grid grid-cols-1 gap-6 lg:grid-cols-3',
            children: [
              section(
                className: 'space-y-4 lg:col-span-2',
                children: [
                  div(
                    className: 'flex items-center justify-between',
                    children: [
                      h2(
                        className: 'text-lg font-semibold',
                        children: const [Text('Active Workflows')],
                      ),
                      router.navLink(
                        to: '/workflows',
                        className: 'text-sm text-primary hover:underline',
                        children: const [Text('View all →')],
                      ),
                    ],
                  ),
                  div(
                    className: 'grid grid-cols-1 gap-4 md:grid-cols-2',
                    children: [
                      for (final workflow in localWorkflows)
                        workflowCardComponent(workflow, key: workflow.id),
                    ],
                  ),
                ],
              ),
              section(
                className: 'space-y-4',
                children: [
                  div(
                    className: 'flex items-center justify-between',
                    children: [
                      h2(
                        className: 'text-lg font-semibold',
                        children: const [Text('Recent Executions')],
                      ),
                      a(
                        additionalProps: {'href': '/executions'},
                        className: 'text-sm text-primary hover:underline',
                        children: const [Text('View all →')],
                      ),
                    ],
                  ),
                  div(
                    className: 'rounded-xl border border-border bg-card p-2',
                    children: [executionTimelineComponent(recentExecutions)],
                  ),
                ],
              ),
            ],
          ),
        ]);

  return pageLayoutComponent(
    activePath: '/dashboard',
    title: 'Dashboard',
    subtitle: 'Monitor and manage your durable workflows',
    body: div(
      children: [
        div(
          className: 'mb-5 flex flex-wrap justify-end gap-3',
          children: [
            uiButton(
              label: lastRefresh == null ? '↻  Refresh' : '↻  Refreshed',
              variant: UiButtonVariant.ghost,
              onPressed: (_) => setLastRefresh(DateTime.now()),
            ),
            uiButton(
              label: showFilters ? '×  Hide Filter' : '≡  Filter',
              variant: UiButtonVariant.ghost,
              onPressed: (_) => setShowFilters(!showFilters),
            ),
            uiButton(
              label: '+  New Workflow',
              onPressed: (_) => setNewWorkflowOpen(true),
            ),
          ],
        ),
        body,
        workflowDialog,
      ],
    ),
  );
}
