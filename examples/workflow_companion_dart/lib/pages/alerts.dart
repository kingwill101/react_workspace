import 'package:react_dom/react_dom.dart';

import '../components/empty_state.dart';
import '../components/page_layout.dart';
import '../components/ui/button.dart';
import '../contexts/tenant_context.dart';
import '../data/mock_data.dart';
import '../models/workflow.dart';
import '../utils.dart';

enum AlertType { error, warning, info, success }

final class DashboardAlert {
  const DashboardAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.source,
    required this.timestamp,
    this.acknowledged = false,
  });

  final String id;
  final AlertType type;
  final String title;
  final String message;
  final String source;
  final String timestamp;
  final bool acknowledged;
}

List<DashboardAlert> _alerts() => [
  for (final workflow in workflows.where(
    (item) => item.status == JobStatus.failed,
  ))
    DashboardAlert(
      id: 'alert-${workflow.id}',
      type: AlertType.error,
      title: 'Workflow Failed',
      message: '${workflow.name} failed after ${workflow.retries} retries',
      source: 'workflow',
      timestamp: workflow.lastRun,
    ),
  for (final workflow in workflows.where(
    (item) => item.status == JobStatus.retrying,
  ))
    DashboardAlert(
      id: 'retry-${workflow.id}',
      type: AlertType.warning,
      title: 'Workflow Retrying',
      message: '${workflow.name} is on retry attempt ${workflow.retries}',
      source: 'workflow',
      timestamp: workflow.lastRun,
    ),
  const DashboardAlert(
    id: 'system-maintenance',
    type: AlertType.info,
    title: 'Scheduled Maintenance',
    message: 'System maintenance scheduled for tonight at 2:00 AM UTC',
    source: 'system',
    timestamp: '2025-01-18T02:00:00Z',
    acknowledged: true,
  ),
  const DashboardAlert(
    id: 'deployment-complete',
    type: AlertType.success,
    title: 'Deployment Complete',
    message: 'New workflow version deployed successfully',
    source: 'system',
    timestamp: '2025-01-17T18:00:00Z',
    acknowledged: true,
  ),
];

/// Operational alerts page with acknowledgement state.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode AlertsPage(({String? scope}) props) {
  final tenant = useTenant();
  final (alerts, setAlerts) = useState<List<DashboardAlert>>(_alerts());
  final errors = alerts.where((alert) => alert.type == AlertType.error).length;
  final warnings = alerts
      .where((alert) => alert.type == AlertType.warning)
      .length;
  final unacknowledged = alerts.where((alert) => !alert.acknowledged).length;
  (String, String) styleFor(AlertType type) => switch (type) {
    AlertType.error => (
      '×',
      'bg-destructive/10 text-destructive border-destructive/30',
    ),
    AlertType.warning => ('!', 'bg-warning/10 text-warning border-warning/30'),
    AlertType.info => ('i', 'bg-primary/10 text-primary border-primary/30'),
    AlertType.success => ('✓', 'bg-success/10 text-success border-success/30'),
  };

  if (!tenant.isGatewayConnected) {
    return pageLayoutComponent(
      activePath: '/alerts',
      title: 'Alerts',
      subtitle: 'System notifications, failures, and important events',
      body: gatewayConnectionEmptyState(
        onConnect: () => tenant.setIsGatewayConnected(true),
      ),
    );
  }
  return pageLayoutComponent(
    activePath: '/alerts',
    title: 'Alerts',
    subtitle: 'System notifications, failures, and important events',
    body: div(
      children: [
        div(
          className: 'mb-8 grid grid-cols-2 gap-4 md:grid-cols-4',
          children: [
            _alertStat('Errors', errors, '×', 'text-destructive'),
            _alertStat('Warnings', warnings, '!', 'text-warning'),
            _alertStat('Total Alerts', alerts.length, '◉', 'text-primary'),
            _alertStat(
              'Unacknowledged',
              unacknowledged,
              '◷',
              'text-muted-foreground',
            ),
          ],
        ),
        div(
          className: 'space-y-3',
          children: [
            for (final alert in alerts)
              () {
                final (glyph, tone) = styleFor(alert.type);
                return div(
                  key: alert.id,
                  className:
                      'rounded-lg border bg-card p-4 ${alert.acknowledged ? 'opacity-60' : ''} $tone',
                  children: [
                    div(
                      className: 'flex items-start gap-4',
                      children: [
                        div(
                          className: 'rounded-lg p-2 text-lg',
                          children: [Text(glyph)],
                        ),
                        div(
                          className: 'min-w-0 flex-1',
                          children: [
                            div(
                              className: 'mb-1 flex items-center gap-2',
                              children: [
                                h3(
                                  className: 'font-semibold',
                                  children: [Text(alert.title)],
                                ),
                                if (!alert.acknowledged)
                                  span(
                                    className: 'rounded-full bg-primary/20 px-2 py-0.5 text-xs text-primary',
                                    children: const [Text('New')],
                                  ),
                              ],
                            ),
                            p(
                              className: 'mb-2 text-sm text-muted-foreground',
                              children: [Text(alert.message)],
                            ),
                            p(
                              className: 'text-xs text-muted-foreground',
                              children: [
                                Text(
                                  '${alert.source} · ${formatDate(alert.timestamp)}',
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (!alert.acknowledged)
                          uiButton(
                            label: 'Acknowledge',
                            variant: UiButtonVariant.ghost,
                            size: UiButtonSize.sm,
                            onPressed: (_) => setAlerts.update(
                              (items) => items
                                  .map(
                                    (item) => item.id == alert.id
                                        ? DashboardAlert(
                                            id: item.id,
                                            type: item.type,
                                            title: item.title,
                                            message: item.message,
                                            source: item.source,
                                            timestamp: item.timestamp,
                                            acknowledged: true,
                                          )
                                        : item,
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              }(),
          ],
        ),
      ],
    ),
  );
}

ReactNode _alertStat(String label, int value, String glyph, String tone) => div(
  className: 'rounded-lg border border-border bg-card p-4',
  children: [
    div(
      className: 'flex items-center gap-3',
      children: [
        span(className: 'text-xl $tone', children: [Text(glyph)]),
        div(
          children: [
            p(className: 'text-2xl font-bold', children: [Text('$value')]),
            p(
              className: 'text-sm text-muted-foreground',
              children: [Text(label)],
            ),
          ],
        ),
      ],
    ),
  ],
);
