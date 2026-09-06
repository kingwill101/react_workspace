import 'package:react_dom/react_dom.dart';

import '../.generated/pages/dashboard.react.dart' as dashboard;
import '../.generated/pages/alerts.react.dart' as alerts;
import '../.generated/pages/auth.react.dart' as auth;
import '../.generated/pages/billing.react.dart' as billing;
import '../.generated/pages/details.react.dart' as details;
import '../.generated/pages/jobs.react.dart' as jobs;
import '../.generated/pages/landing.react.dart' as landing;
import '../.generated/pages/not_found.react.dart' as not_found;
import '../.generated/pages/onboarding.react.dart' as onboarding;
import '../.generated/pages/operations.react.dart' as operations;
import '../.generated/pages/schedules.react.dart' as schedules;
import '../.generated/pages/settings.react.dart' as settings;
import '../.generated/pages/workflows.react.dart' as workflow_index;
import '../router.dart' as router;

/// Root component for the Dart port of Workflow Companion.
///
/// The route table intentionally mirrors the reference `App.tsx` route map.
/// State is kept in Dart and passed through the route tree; it will move into
/// a typed tenant context as that reference file is translated.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode App(({String title}) props) {
  return router.browserRouter(
    children: [
      router.routes(
        children: [
          router.route(
            key: 'home',
            path: '/',
            element: landing.LandingPage(scope: null),
          ),
          router.route(
            key: 'dashboard',
            path: '/dashboard',
            element: dashboard.DashboardPage(scope: null),
          ),
          router.route(
            key: 'signin',
            path: '/signin',
            element: auth.AuthPage(signUp: false),
          ),
          router.route(
            key: 'signup',
            path: '/signup',
            element: auth.AuthPage(signUp: true),
          ),
          router.route(
            key: 'onboarding',
            path: '/onboarding',
            element: onboarding.OnboardingPage(scope: null),
          ),
          router.route(
            key: 'workflows',
            path: '/workflows',
            element: workflow_index.WorkflowsPage(scope: null),
          ),
          router.route(
            key: 'workflow-detail',
            path: '/workflows/:id',
            element: details.WorkflowDetailRoute(scope: null),
          ),
          router.route(
            key: 'jobs',
            path: '/jobs',
            element: jobs.JobsPage(scope: null),
          ),
          router.route(
            key: 'job-detail',
            path: '/jobs/:id',
            element: details.JobDetailRoute(scope: null),
          ),
          router.route(
            key: 'tasks',
            path: '/tasks',
            element: operations.TasksPage(scope: null),
          ),
          router.route(
            key: 'queues',
            path: '/queues',
            element: operations.QueuesPage(scope: null),
          ),
          router.route(
            key: 'workers',
            path: '/workers',
            element: operations.WorkersPage(scope: null),
          ),
          router.route(
            key: 'dead-letters',
            path: '/dead-letters',
            element: operations.DeadLettersPage(scope: null),
          ),
          router.route(
            key: 'executions',
            path: '/executions',
            element: operations.ExecutionsPage(scope: null),
          ),
          router.route(
            key: 'schedules',
            path: '/schedules',
            element: schedules.SchedulesPage(scope: null),
          ),
          router.route(
            key: 'alerts',
            path: '/alerts',
            element: alerts.AlertsPage(scope: null),
          ),
          router.route(
            key: 'settings',
            path: '/settings',
            element: settings.SettingsPage(scope: null),
          ),
          router.route(
            key: 'billing',
            path: '/billing',
            element: billing.BillingPage(scope: null),
          ),
          router.route(
            key: 'not-found',
            path: '*',
            element: not_found.NotFoundPage(scope: null),
          ),
        ],
      ),
    ],
  );
}
