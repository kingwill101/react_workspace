import 'package:react_dom/react_dom.dart';

import '../contexts/tenant_context.dart';
import '../contexts/theme_context.dart';
import '../router.dart' as router;
import '../ui/ui.dart' show cx;
import '../.generated/components/organization_switcher.react.dart'
    as organization_switcher;
import 'ui/button.dart';
import 'ui/input.dart';

final class _NavigationItem {
  const _NavigationItem(this.glyph, this.label, this.path, [this.badge]);

  final String glyph;
  final String label;
  final String path;
  final int? badge;
}

const _navigationItems = <_NavigationItem>[
  _NavigationItem('▦', 'Dashboard', '/dashboard'),
  _NavigationItem('⑂', 'Workflows', '/workflows', 12),
  _NavigationItem('⚙', 'Jobs', '/jobs', 10),
  _NavigationItem('☷', 'Tasks', '/tasks', 8),
  _NavigationItem('◈', 'Queues', '/queues'),
  _NavigationItem('▣', 'Workers', '/workers', 6),
  _NavigationItem('◷', 'Schedules', '/schedules', 8),
  _NavigationItem('☠', 'Dead Letters', '/dead-letters', 7),
  _NavigationItem('◌', 'Executions', '/executions'),
  _NavigationItem('♢', 'Alerts', '/alerts', 3),
  _NavigationItem('\$', 'Billing', '/billing'),
  _NavigationItem('⚙', 'Settings', '/settings'),
];

/// The collapsible navigation rail shared by authenticated pages.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode DashboardSidebar(({String activePath}) props) {
  final (collapsed, setCollapsed) = useState(false);
  final tenant = useTenant();
  final theme = useTheme();
  final user = tenant.currentUser;
  final initials = user == null
      ? 'U'
      : user.name
            .split(' ')
            .where((part) => part.isNotEmpty)
            .map((part) => part[0])
            .take(2)
            .join()
            .toUpperCase();

  return aside(
    className: cx(
      'sticky top-0 flex h-screen shrink-0 flex-col border-r border-sidebar-border bg-sidebar transition-all duration-300',
      collapsed ? 'w-16' : 'w-64',
    ),
    children: [
      div(
        className: 'flex items-center justify-between border-b border-sidebar-border p-4',
        children: [
          div(
            className: cx(
              'flex items-center gap-3',
              collapsed ? 'w-full justify-center' : null,
            ),
            children: [
              div(
                className: 'flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground glow-primary',
                children: const [Text('✦')],
              ),
              if (!collapsed)
                span(
                  className: 'font-semibold text-foreground',
                  children: const [Text('StemCloud')],
                ),
            ],
          ),
          if (!collapsed)
            uiButton(
              label: '‹',
              variant: UiButtonVariant.ghost,
              size: UiButtonSize.icon,
              onPressed: (_) => setCollapsed(true),
              className: 'h-8 w-8 text-muted-foreground',
            ),
        ],
      ),
      if (!collapsed)
        div(
          className: 'space-y-3 p-3',
          children: [
            organization_switcher.OrganizationSwitcher(compact: false),
            uiInput(
              placeholder: 'Search workflows...',
              className: 'border-transparent bg-sidebar-accent text-foreground',
            ),
          ],
        ),
      if (collapsed)
        uiButton(
          label: '›',
          variant: UiButtonVariant.outline,
          size: UiButtonSize.icon,
          onPressed: (_) => setCollapsed(false),
          className:
              'absolute -right-4 top-6 h-8 w-8 rounded-full bg-card shadow-lg',
        ),
      nav(
        className: 'flex-1 space-y-1 overflow-auto p-3',
        children: [
          for (final item in _navigationItems)
            router.navLink(
              key: item.path,
              to: item.path,
              end: item.path == '/dashboard',
              className: cx(
                'flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-all duration-200',
                props.activePath == item.path ? 'bg-primary/10 text-primary' : 'text-sidebar-foreground hover:bg-sidebar-accent hover:text-foreground',
                collapsed ? 'justify-center' : null,
              ),
              children: [
                span(
                  className: 'w-5 shrink-0 text-center text-base',
                  children: [Text(item.glyph)],
                ),
                if (!collapsed) ...[
                  span(
                    className: 'flex-1 text-left',
                    children: [Text(item.label)],
                  ),
                  if (item.badge != null)
                    span(
                      className: 'rounded-full bg-primary/20 px-2 py-0.5 text-xs text-primary',
                      children: [Text('${item.badge}')],
                    ),
                ],
              ],
            ),
        ],
      ),
      div(
        className: cx(
          'border-t border-sidebar-border p-3',
          collapsed ? 'px-2' : null,
        ),
        children: [
          uiButton(
            label: collapsed
                ? (theme.theme == ThemeMode.dark ? '☀' : '☾')
                : (theme.theme == ThemeMode.dark ? 'Light Mode' : 'Dark Mode'),
            variant: UiButtonVariant.ghost,
            onPressed: (_) => theme.toggleTheme(),
            className: cx(
              'mb-3 w-full justify-start text-sidebar-foreground',
              collapsed ? 'px-2' : null,
            ),
          ),
          div(
            className: cx(
              'flex items-center gap-3 rounded-lg p-2',
              collapsed ? 'justify-center' : null,
            ),
            children: [
              div(
                className: 'flex h-8 w-8 items-center justify-center rounded-full bg-gradient-to-br from-primary to-running text-xs font-semibold text-primary-foreground',
                children: [Text(initials)],
              ),
              if (!collapsed)
                div(
                  className: 'min-w-0 flex-1',
                  children: [
                    p(
                      className: 'truncate text-sm font-medium',
                      children: [Text(user?.name ?? 'User')],
                    ),
                    p(
                      className: 'truncate text-xs text-muted-foreground',
                      children: [Text(user?.email ?? 'user@example.com')],
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
