import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLSelectElement;

import '../contexts/tenant_context.dart';
import 'dialogs.dart';
import 'ui/button.dart';
import 'ui/select.dart';

/// Organization selector used by the dashboard navigation rail.
///
/// Switching and creation are kept in [TenantContextValue], so this component
/// remains a presentation boundary and can be replaced by a server-backed
/// tenant provider without changing the sidebar.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode OrganizationSwitcher(({bool compact}) props) {
  final tenant = useTenant();
  final (createOpen, setCreateOpen) = useState(false);
  final organization = tenant.currentOrganization;
  final dialog = createOrganizationDialog(
    open: createOpen,
    onOpenChange: setCreateOpen.call,
  );

  if (props.compact) {
    return div(
      className: 'flex justify-center',
      children: [
        div(
          className: 'flex h-8 w-8 items-center justify-center rounded-md bg-primary/20 text-primary',
          children: [Text(_initial(organization?.name ?? 'Workspace'))],
        ),
        dialog,
      ],
    );
  }

  return div(
    className: 'space-y-2 rounded-lg border border-border/50 bg-muted/30 p-3',
    children: [
      p(
        className:
            'text-xs font-medium uppercase tracking-wide text-muted-foreground',
        children: const [Text('Organization')],
      ),
      uiSelect(
        value: organization?.id ?? '',
        options: [
          for (final item in tenant.organizations)
            UiSelectOption(item.id, item.name),
        ],
        onChanged: (event) => tenant.switchOrganization(
          (event.target as HTMLSelectElement).value,
        ),
      ),
      uiButton(
        label: '+ Create organization',
        variant: UiButtonVariant.ghost,
        size: UiButtonSize.sm,
        onPressed: (_) => setCreateOpen(true),
        className: 'w-full justify-start px-0',
      ),
      dialog,
    ],
  );
}

String _initial(String name) => name.isEmpty ? '?' : name[0].toUpperCase();
