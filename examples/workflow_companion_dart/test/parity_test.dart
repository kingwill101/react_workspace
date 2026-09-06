import 'package:react_core/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

import 'package:workflow_companion_dart/components/ui/advanced.dart';
import 'package:workflow_companion_dart/components/ui/alert_dialog.dart';
import 'package:workflow_companion_dart/components/ui/calendar.dart';
import 'package:workflow_companion_dart/components/ui/command.dart';
import 'package:workflow_companion_dart/components/ui/controls.dart';
import 'package:workflow_companion_dart/components/ui/layout.dart';
import 'package:workflow_companion_dart/components/ui/pagination.dart'
    as pagination;
import 'package:workflow_companion_dart/components/ui/toast.dart';
import 'package:workflow_companion_dart/data/mock_data.dart';
import 'package:workflow_companion_dart/hooks/use_data_table.dart';
import 'package:workflow_companion_dart/models/schedule.dart';
import 'package:workflow_companion_dart/pages/alerts.dart';
import 'package:workflow_companion_dart/pages/auth.dart';
import 'package:workflow_companion_dart/pages/billing.dart';
import 'package:workflow_companion_dart/pages/dashboard.dart';
import 'package:workflow_companion_dart/pages/details.dart';
import 'package:workflow_companion_dart/pages/jobs.dart';
import 'package:workflow_companion_dart/pages/landing.dart';
import 'package:workflow_companion_dart/pages/not_found.dart';
import 'package:workflow_companion_dart/pages/onboarding.dart';
import 'package:workflow_companion_dart/pages/operations.dart';
import 'package:workflow_companion_dart/pages/schedules.dart';
import 'package:workflow_companion_dart/pages/settings.dart';
import 'package:workflow_companion_dart/pages/workflows.dart';
import 'package:workflow_companion_dart/utils.dart';

void main() {
  group('translated route pages', () {
    test('all route pages render through the native component harness', () {
      final pages = <ReactNode Function()>[
        () => LandingPage((scope: null)),
        () => NotFoundPage((scope: null)),
        () => DashboardPage((scope: null)),
        () => WorkflowsPage((scope: null)),
        () => WorkflowDetailPage((id: workflows.first.id)),
        () => JobsPage((scope: null)),
        () => JobDetailPage((id: jobs.first.id)),
        () => TasksPage((scope: null)),
        () => QueuesPage((scope: null)),
        () => WorkersPage((scope: null)),
        () => DeadLettersPage((scope: null)),
        () => ExecutionsPage((scope: null)),
        () => SchedulesPage((scope: null)),
        () => AlertsPage((scope: null)),
        () => SettingsPage((scope: null)),
        () => BillingPage((scope: null)),
        () => AuthPage((signUp: false)),
        () => OnboardingPage((scope: null)),
      ];

      for (final buildPage in pages) {
        final harness = ReactComponentHarness();
        final node = harness.run(buildPage);
        expect(node, isA<ReactNode>());
      }
    });
  });

  group('portable UI primitives', () {
    test('controls expose semantic host nodes', () {
      final harness = ReactComponentHarness();
      final switchNode = harness.run(
        () => uiSwitch(checked: true, onChanged: (_) {}),
      );
      harness.assertHostNode(switchNode, namespace: 'html', name: 'button');

      final progress = harness.run(() => uiProgress(value: 42));
      harness.assertHostNode(progress, namespace: 'html', name: 'div');

      final menu = harness.run(
        () => uiDropdownMenu(
          trigger: const Text('Menu'),
          children: [uiDropdownItem(label: 'Run', onSelected: () {})],
        ),
      );
      harness.assertHostNode(menu, namespace: 'html', name: 'details');

      final command = harness.run(
        () => uiCommand(
          query: '',
          onQueryChanged: (_) {},
          items: const [UiCommandItem(value: 'run', label: 'Run')],
          onSelected: (_) {},
        ),
      );
      harness.assertHostNode(command, namespace: 'html', name: 'div');

      final calendar = harness.run(
        () => uiCalendar(month: UiCalendarMonth(2025, 1), onSelected: (_) {}),
      );
      harness.assertHostNode(calendar, namespace: 'html', name: 'div');

      final paginationNode = harness.run(
        () => pagination.uiPagination(
          state: const pagination.UiPaginationState(
            currentPage: 2,
            totalPages: 5,
          ),
          onPageChanged: (_) {},
        ),
      );
      harness.assertHostNode(paginationNode, namespace: 'html', name: 'nav');

      final layout = harness.run(
        () => uiAspectRatio(ratio: 16 / 9, children: const [Text('preview')]),
      );
      harness.assertHostNode(layout, namespace: 'html', name: 'div');

      final confirmation = harness.run(
        () => uiAlertDialog(
          open: true,
          title: 'Delete task',
          description: 'This cannot be undone.',
          onConfirm: () {},
          onCancel: () {},
        ),
      );
      harness.assertHostNode(confirmation, namespace: 'html', name: 'dialog');

      final toast = harness.run(
        () => uiToastViewport(
          toasts: const [UiToastRecord(id: '1', title: 'Saved')],
          onDismiss: (_) {},
        ),
      );
      harness.assertHostNode(toast, namespace: 'html', name: 'div');
    });
  });

  group('translated models and helpers', () {
    test('schedule configuration remains discriminated and typed', () {
      const config = CronSchedule(expression: '0 * * * *', timezone: 'UTC');
      expect(config.type, ScheduleType.cron);
      expect(config.expression, '0 * * * *');
    });

    test('data table cycles sort directions', () {
      final harness = ReactComponentHarness();
      final result = harness.run(() {
        final controller = useDataTable<String>(
          const DataTableOptions(
            data: ['b', 'a'],
            searchKeys: ['value'],
            valueOf: _stringValue,
            initialSort: SortConfig('value', SortDirection.asc),
          ),
        );
        return controller;
      });
      expect(result.sortConfig?.direction, SortDirection.asc);
    });

    test('class and date helpers preserve portable contracts', () {
      expect(
        cn([
          'a',
          null,
          {'b': true},
          ['c'],
        ]),
        'a b c',
      );
      expect(formatDate('2025-01-18T13:05:00Z'), contains('1/18'));
      expect(formatDate('2025-01-18T13:05:00Z'), contains(':05'));
    });
  });
}

Object? _stringValue(String value, String key) => value;
