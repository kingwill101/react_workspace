import 'package:react_dom/react_dom.dart';

import '../contexts/tenant_context.dart';
import '../.generated/components/dashboard_sidebar.react.dart' as sidebar;

/// Authenticated page frame used by every dashboard route.
ReactNode pageLayoutComponent({
  required String activePath,
  required String title,
  required String subtitle,
  required ReactNode body,
  ReactNode? headerActions,
}) {
  final tenant = useTenant();
  return div(
    className: 'flex min-h-screen bg-background',
    children: [
      sidebar.DashboardSidebar(activePath: activePath),
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
                  div(
                    className: 'flex items-center gap-4',
                    children: [
                      ?headerActions,
                      div(
                        className: 'hidden items-center gap-2 text-xs text-muted-foreground sm:flex',
                        children: [
                          span(
                            className: 'h-2 w-2 rounded-full bg-success',
                            children: const [],
                          ),
                          Text(
                            'Live · ${tenant.currentOrganization?.name ?? 'Workspace'}',
                          ),
                        ],
                      ),
                    ],
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
}
