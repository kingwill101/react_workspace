import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

import '../components/dialogs.dart';
import '../components/page_layout.dart';
import '../components/ui/button.dart';
import '../components/ui/controls.dart';
import '../components/ui/dialog.dart';
import '../components/ui/input.dart';
import '../components/ui/label.dart';
import '../contexts/tenant_context.dart';
import '../contexts/theme_context.dart';
import '../models/tenant.dart';
import '../router.dart' as router;
import '../utils.dart';

/// The settings page for organization, access, notifications, and appearance.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode SettingsPage(({String? scope}) props) {
  final tenant = useTenant();
  final theme = useTheme();
  final organization = tenant.currentOrganization;
  final (orgName, setOrgName) = useState(organization?.name ?? '');
  final (orgSlug, setOrgSlug) = useState(organization?.slug ?? '');
  final (hasChanges, setHasChanges) = useState(false);
  final (inviteOpen, setInviteOpen) = useState(false);
  final (apiKeyOpen, setApiKeyOpen) = useState(false);
  final (confirmation, setConfirmation) = useState<String?>(null);

  void saveOrganization() {
    if (organization == null) return;
    tenant.updateOrganization(
      organization.id,
      Organization(
        id: organization.id,
        name: orgName.trim(),
        slug: orgSlug.trim(),
        createdAt: organization.createdAt,
        logoUrl: organization.logoUrl,
      ),
    );
    setHasChanges(false);
  }

  void cancelOrganization() {
    setOrgName(organization?.name ?? '');
    setOrgSlug(organization?.slug ?? '');
    setHasChanges(false);
  }

  void updateNotifications({
    bool? workflowFailures,
    bool? jobRetriesExceeded,
    bool? weeklySummary,
  }) {
    final current = tenant.notificationSettings;
    tenant.updateNotificationSettings(
      NotificationSettings(
        workflowFailures: workflowFailures ?? current.workflowFailures,
        jobRetriesExceeded: jobRetriesExceeded ?? current.jobRetriesExceeded,
        weeklySummary: weeklySummary ?? current.weeklySummary,
      ),
    );
  }

  void updateSecurity({bool? twoFactorEnabled, bool? apiAccessLogging}) {
    final current = tenant.securitySettings;
    tenant.updateSecuritySettings(
      SecuritySettings(
        twoFactorEnabled: twoFactorEnabled ?? current.twoFactorEnabled,
        apiAccessLogging: apiAccessLogging ?? current.apiAccessLogging,
      ),
    );
  }

  void confirmAction() {
    final request = confirmation;
    if (request == null) return;
    if (request.startsWith('key:')) {
      tenant.revokeApiKey(request.substring(4));
    } else if (request.startsWith('member:')) {
      tenant.removeTeamMember(request.substring(7));
    }
    setConfirmation(null);
  }

  final confirmTitle = confirmation?.startsWith('key:') == true
      ? 'Revoke API Key'
      : 'Remove Team Member';
  final confirmDescription = confirmation?.startsWith('key:') == true
      ? 'This permanently revokes the key. Applications using it will stop working.'
      : 'This removes the member from the active organization.';

  return pageLayoutComponent(
    activePath: '/settings',
    title: 'Settings',
    subtitle: 'Manage your organization and application preferences',
    body: div(
      className: 'mx-auto max-w-4xl space-y-8',
      children: [
        _settingsSection(
          glyph: '▣',
          title: 'Organization',
          description: 'Manage your organization details',
          children: [
            div(
              className: 'grid gap-4',
              children: [
                div(
                  className: 'grid gap-2',
                  children: [
                    uiLabel(text: 'Organization Name', htmlFor: 'org-name'),
                    uiInput(
                      id: 'org-name',
                      value: orgName,
                      onChanged: (event) {
                        setOrgName((event.target as HTMLInputElement).value);
                        setHasChanges(true);
                      },
                      className: 'max-w-md',
                    ),
                  ],
                ),
                div(
                  className: 'grid gap-2',
                  children: [
                    uiLabel(text: 'Slug', htmlFor: 'org-slug'),
                    uiInput(
                      id: 'org-slug',
                      value: orgSlug,
                      onChanged: (event) {
                        setOrgSlug(
                          (event.target as HTMLInputElement).value
                              .toLowerCase()
                              .replaceAll(RegExp(r'\s+'), '-'),
                        );
                        setHasChanges(true);
                      },
                      className: 'max-w-md font-mono',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        _settingsSection(
          glyph: '♢',
          title: 'Notifications',
          description: 'Configure alert preferences',
          children: [
            _settingToggle(
              title: 'Workflow Failures',
              description: 'Get notified when a workflow fails',
              value: tenant.notificationSettings.workflowFailures,
              onChanged: (value) =>
                  updateNotifications(workflowFailures: value),
            ),
            _settingsDivider(),
            _settingToggle(
              title: 'Job Retries Exceeded',
              description: 'Alert when max retries are reached',
              value: tenant.notificationSettings.jobRetriesExceeded,
              onChanged: (value) =>
                  updateNotifications(jobRetriesExceeded: value),
            ),
            _settingsDivider(),
            _settingToggle(
              title: 'Weekly Summary',
              description: 'Receive weekly execution reports',
              value: tenant.notificationSettings.weeklySummary,
              onChanged: (value) => updateNotifications(weeklySummary: value),
            ),
          ],
        ),
        _settingsSection(
          glyph: '◇',
          title: 'Security',
          description: 'Manage security settings',
          children: [
            _settingToggle(
              title: 'Two-Factor Authentication',
              description: 'Require 2FA for all users',
              value: tenant.securitySettings.twoFactorEnabled,
              onChanged: (value) => updateSecurity(twoFactorEnabled: value),
            ),
            _settingsDivider(),
            _settingToggle(
              title: 'API Access Logging',
              description: 'Log all API requests',
              value: tenant.securitySettings.apiAccessLogging,
              onChanged: (value) => updateSecurity(apiAccessLogging: value),
            ),
          ],
        ),
        _settingsSection(
          glyph: '⌁',
          title: 'API Keys',
          description: 'Manage API access tokens',
          children: [
            for (final key in tenant.apiKeys)
              div(
                key: key.id,
                className: 'flex items-center justify-between gap-4 rounded-lg bg-muted/50 p-3',
                children: [
                  div(
                    className: 'min-w-0',
                    children: [
                      p(
                        className: 'text-sm font-medium',
                        children: [Text(key.name)],
                      ),
                      p(
                        className: 'font-mono text-xs text-muted-foreground',
                        children: [Text(key.maskedKey)],
                      ),
                      p(
                        className: 'mt-1 text-xs text-muted-foreground',
                        children: [
                          Text(
                            'Created ${key.createdAt}${key.lastUsed == null ? '' : ' · Last used ${key.lastUsed}'}',
                          ),
                        ],
                      ),
                    ],
                  ),
                  uiButton(
                    label: 'Revoke',
                    variant: UiButtonVariant.outline,
                    size: UiButtonSize.sm,
                    onPressed: (_) => setConfirmation('key:${key.id}'),
                  ),
                ],
              ),
            uiButton(
              label: 'Generate New API Key',
              variant: UiButtonVariant.outline,
              onPressed: (_) => setApiKeyOpen(true),
              className: 'w-full',
            ),
          ],
        ),
        _settingsSection(
          glyph: '♙',
          title: 'Team Members',
          description: 'Manage organization access',
          children: [
            for (final member in tenant.teamMembers)
              div(
                key: member.id,
                className: 'flex items-center justify-between gap-4 rounded-lg bg-muted/50 p-3',
                children: [
                  div(
                    className: 'flex min-w-0 items-center gap-3',
                    children: [
                      uiAvatar(name: member.name, className: 'h-8 w-8'),
                      div(
                        className: 'min-w-0',
                        children: [
                          div(
                            className: 'flex items-center gap-2',
                            children: [
                              p(
                                className: 'truncate font-medium',
                                children: [Text(member.name)],
                              ),
                              if (member.status == 'pending')
                                span(
                                  className: 'rounded bg-warning/10 px-2 py-0.5 text-xs text-warning',
                                  children: const [Text('Pending')],
                                ),
                            ],
                          ),
                          p(
                            className: 'truncate text-xs text-muted-foreground',
                            children: [Text(member.email)],
                          ),
                        ],
                      ),
                    ],
                  ),
                  div(
                    className: 'flex shrink-0 items-center gap-2',
                    children: [
                      span(
                        className: 'rounded bg-primary/10 px-2 py-1 text-xs capitalize text-primary',
                        children: [Text(member.role.name)],
                      ),
                      if (member.role != MemberRole.admin)
                        uiButton(
                          label: '×',
                          variant: UiButtonVariant.ghost,
                          size: UiButtonSize.icon,
                          onPressed: (_) =>
                              setConfirmation('member:${member.id}'),
                        ),
                    ],
                  ),
                ],
              ),
            uiButton(
              label: 'Invite Team Member',
              variant: UiButtonVariant.outline,
              onPressed: (_) => setInviteOpen(true),
              className: 'w-full',
            ),
          ],
        ),
        _settingsSection(
          glyph: '☼',
          title: 'Appearance',
          description: 'Customize the interface',
          children: [
            _settingToggle(
              title: 'Dark theme',
              description: theme.theme == ThemeMode.dark
                  ? 'Dark theme is enabled'
                  : 'Light theme is enabled',
              value: theme.theme == ThemeMode.dark,
              onChanged: (value) =>
                  theme.setTheme(value ? ThemeMode.dark : ThemeMode.light),
            ),
          ],
        ),
        _settingsSection(
          glyph: '↪',
          title: 'Sign Out',
          description: 'End your current session',
          className: 'border-destructive/20',
          children: [
            div(
              className: 'flex items-center justify-between gap-4',
              children: [
                p(
                  className: 'text-sm text-muted-foreground',
                  children: const [
                    Text('You are signed in to this workspace.'),
                  ],
                ),
                router.navLink(
                  to: '/signin',
                  className: cn([
                    'inline-flex h-10 items-center justify-center rounded-md px-4 py-2 text-sm font-medium',
                    'bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90',
                  ]),
                  children: const [Text('Sign Out')],
                ),
              ],
            ),
          ],
        ),
        if (hasChanges)
          div(
            className: 'sticky bottom-4 flex items-center justify-end gap-3 rounded-lg border border-border bg-background/95 p-4 shadow-lg backdrop-blur',
            children: [
              div(
                className: 'mr-auto text-sm text-muted-foreground',
                children: const [Text('You have unsaved changes')],
              ),
              uiButton(
                label: 'Cancel',
                variant: UiButtonVariant.outline,
                onPressed: (_) => cancelOrganization(),
              ),
              uiButton(
                label: 'Save Changes',
                onPressed: (_) => saveOrganization(),
              ),
            ],
          ),
        inviteTeamDialog(open: inviteOpen, onOpenChange: setInviteOpen.call),
        generateApiKeyDialog(
          open: apiKeyOpen,
          onOpenChange: setApiKeyOpen.call,
        ),
        uiDialog(
          open: confirmation != null,
          title: confirmTitle,
          description: confirmDescription,
          onOpenChange: (open) {
            if (!open) setConfirmation(null);
          },
          children: const [],
          footer: [
            uiButton(
              label: 'Cancel',
              variant: UiButtonVariant.outline,
              onPressed: (_) => setConfirmation(null),
            ),
            uiButton(
              label: confirmTitle,
              variant: UiButtonVariant.destructive,
              onPressed: (_) => confirmAction(),
            ),
          ],
        ),
      ],
    ),
  );
}

ReactNode _settingsSection({
  required String glyph,
  required String title,
  required String description,
  required ReactChildren children,
  String? className,
}) => section(
  className: cn(['rounded-lg border border-border bg-card p-6', className]),
  children: [
    div(
      className: 'mb-6 flex items-center gap-3',
      children: [
        div(
          className: 'flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-lg text-primary',
          children: [Text(glyph)],
        ),
        div(
          children: [
            h2(className: 'text-lg font-semibold', children: [Text(title)]),
            p(
              className: 'text-sm text-muted-foreground',
              children: [Text(description)],
            ),
          ],
        ),
      ],
    ),
    div(className: 'space-y-4', children: children),
  ],
);

ReactNode _settingToggle({
  required String title,
  required String description,
  required bool value,
  required void Function(bool) onChanged,
}) => div(
  className: 'flex items-center justify-between gap-4',
  children: [
    div(
      children: [
        p(className: 'font-medium', children: [Text(title)]),
        p(
          className: 'text-sm text-muted-foreground',
          children: [Text(description)],
        ),
      ],
    ),
    uiSwitch(checked: value, onChanged: onChanged, label: title),
  ],
);

ReactNode _settingsDivider() => uiSeparator();
