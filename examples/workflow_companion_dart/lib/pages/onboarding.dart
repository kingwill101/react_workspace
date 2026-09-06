import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement, HTMLSelectElement;

import '../components/ui/button.dart';
import '../components/ui/card.dart';
import '../components/ui/input.dart';
import '../components/ui/select.dart';
import '../contexts/tenant_context.dart';
import '../models/tenant.dart';

enum OnboardingStep { organization, team, apiKey, complete }

final class PendingInvite {
  const PendingInvite(this.email, this.role);

  final String email;
  final MemberRole role;
}

/// Multi-step workspace onboarding flow translated from the reference page.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode OnboardingPage(({String? scope}) props) {
  final tenant = useTenant();
  final (step, setStep) = useState(OnboardingStep.organization);
  final (loading, setLoading) = useState(false);
  final (orgName, setOrgName) = useState('');
  final (orgSlug, setOrgSlug) = useState('');
  final (invites, setInvites) = useState<List<PendingInvite>>([]);
  final (inviteEmail, setInviteEmail) = useState('');
  final (inviteRole, setInviteRole) = useState(MemberRole.member);
  final (keyName, setKeyName) = useState('Production');
  final (generatedKey, setGeneratedKey) = useState<String?>(null);
  final (notice, setNotice) = useState<String?>(null);

  final stepIndex = step.index;
  final steps = const [
    (OnboardingStep.organization, 'Create Organization', '⌂'),
    (OnboardingStep.team, 'Invite Team', '♙'),
    (OnboardingStep.apiKey, 'Generate API Key', '⚿'),
    (OnboardingStep.complete, 'Complete', '✓'),
  ];

  Future<void> createOrganization() async {
    if (orgName.trim().isEmpty) {
      setNotice('Please enter an organization name.');
      return;
    }
    setLoading(true);
    await tenant.createOrganization(
      orgName,
      orgSlug.isEmpty ? orgName : orgSlug,
    );
    setLoading(false);
    setNotice(null);
    setStep(OnboardingStep.team);
  }

  void addInvite() {
    if (!inviteEmail.contains('@')) {
      setNotice('Please enter a valid email.');
      return;
    }
    if (invites.any((invite) => invite.email == inviteEmail)) {
      setNotice('This email is already in the list.');
      return;
    }
    setInvites([...invites, PendingInvite(inviteEmail, inviteRole)]);
    setInviteEmail('');
    setNotice(null);
  }

  Future<void> sendInvites() async {
    setLoading(true);
    for (final invite in invites) {
      await tenant.inviteTeamMember(invite.email, invite.role);
    }
    setLoading(false);
    setStep(OnboardingStep.apiKey);
  }

  Future<void> createKey() async {
    if (keyName.trim().isEmpty) {
      setNotice('Please enter a key name.');
      return;
    }
    setLoading(true);
    final key = await tenant.generateApiKey(keyName);
    setGeneratedKey(key.key);
    setLoading(false);
  }

  ReactNode stepRail() => aside(
    className: 'hidden w-80 border-r border-border bg-card p-8 lg:block',
    children: [
      div(
        className: 'mb-8',
        children: [
          div(
            className: 'mb-2 flex items-center gap-2',
            children: [
              span(
                className: 'text-xl text-primary',
                children: const [Text('✦')],
              ),
              span(
                className: 'text-xl font-bold',
                children: const [Text('StemCloud')],
              ),
            ],
          ),
          p(
            className: 'text-sm text-muted-foreground',
            children: const [Text("Let's get your workspace set up")],
          ),
        ],
      ),
      nav(
        className: 'space-y-2',
        children: [
          for (final (item, label, glyph) in steps)
            div(
              className: item == step
                  ? 'flex items-center gap-3 rounded-lg bg-primary/10 p-3 text-primary'
                  : item.index < stepIndex
                  ? 'flex items-center gap-3 rounded-lg p-3 text-muted-foreground'
                  : 'flex items-center gap-3 rounded-lg p-3 text-muted-foreground/50',
              children: [
                div(
                  className: item.index <= stepIndex
                      ? 'flex h-8 w-8 items-center justify-center rounded-full bg-primary text-primary-foreground'
                      : 'flex h-8 w-8 items-center justify-center rounded-full bg-muted',
                  children: [Text(item.index < stepIndex ? '✓' : glyph)],
                ),
                span(className: 'text-sm font-medium', children: [Text(label)]),
              ],
            ),
        ],
      ),
    ],
  );

  ReactNode content;
  switch (step) {
    case OnboardingStep.organization:
      content = _onboardingCard(
        glyph: '⌂',
        title: 'Create your organization',
        subtitle: 'This will be your workspace for managing workflows',
        children: [
          uiInput(
            value: orgName,
            placeholder: 'Acme Corporation',
            onChanged: (event) =>
                setOrgName((event.target as HTMLInputElement).value),
          ),
          div(
            className: 'flex items-center gap-2',
            children: [
              span(
                className: 'text-sm text-muted-foreground',
                children: const [Text('stemcloud.io/')],
              ),
              uiInput(
                value: orgSlug,
                placeholder: 'acme',
                onChanged: (event) =>
                    setOrgSlug((event.target as HTMLInputElement).value),
                className: 'font-mono',
              ),
            ],
          ),
          uiButton(
            label: loading ? 'Creating...' : 'Continue →',
            disabled: loading || orgName.trim().isEmpty,
            onPressed: (_) => createOrganization(),
            className: 'w-full',
          ),
        ],
      );
    case OnboardingStep.team:
      content = _onboardingCard(
        glyph: '♙',
        title: 'Invite your team',
        subtitle: 'Collaborate with your team on workflows',
        children: [
          div(
            className: 'flex gap-2',
            children: [
              uiInput(
                value: inviteEmail,
                placeholder: 'colleague@company.com',
                onChanged: (event) =>
                    setInviteEmail((event.target as HTMLInputElement).value),
                className: 'flex-1',
              ),
              uiSelect(
                value: inviteRole.name,
                options: const [
                  UiSelectOption('admin', 'Admin'),
                  UiSelectOption('member', 'Member'),
                  UiSelectOption('viewer', 'Viewer'),
                ],
                onChanged: (event) => setInviteRole(
                  MemberRole.values.firstWhere(
                    (item) =>
                        item.name == (event.target as HTMLSelectElement).value,
                  ),
                ),
                className: 'w-28',
              ),
              uiButton(
                label: '+',
                variant: UiButtonVariant.outline,
                onPressed: (_) => addInvite(),
              ),
            ],
          ),
          if (invites.isNotEmpty)
            div(
              className: 'space-y-2 rounded-lg bg-muted/30 p-3',
              children: [
                for (final invite in invites)
                  div(
                    className: 'flex items-center justify-between py-2',
                    children: [
                      div(
                        children: [
                          p(
                            className: 'text-sm font-medium',
                            children: [Text(invite.email)],
                          ),
                          p(
                            className: 'text-xs text-muted-foreground',
                            children: [Text(invite.role.name)],
                          ),
                        ],
                      ),
                      uiButton(
                        label: '×',
                        variant: UiButtonVariant.ghost,
                        size: UiButtonSize.icon,
                        onPressed: (_) => setInvites(
                          invites
                              .where((item) => item.email != invite.email)
                              .toList(),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          div(
            className: 'flex gap-3',
            children: [
              uiButton(
                label: 'Skip for now',
                variant: UiButtonVariant.outline,
                onPressed: (_) => setStep(OnboardingStep.apiKey),
                className: 'flex-1',
              ),
              uiButton(
                label: loading
                    ? 'Sending...'
                    : invites.isEmpty
                    ? 'Continue'
                    : 'Send ${invites.length} Invite(s)',
                disabled: loading,
                onPressed: (_) => sendInvites(),
                className: 'flex-1',
              ),
            ],
          ),
        ],
      );
    case OnboardingStep.apiKey:
      content = _onboardingCard(
        glyph: '⚿',
        title: 'Generate an API key',
        subtitle: "You'll need this to authenticate with our API",
        children: [
          uiInput(
            value: keyName,
            placeholder: 'Production',
            disabled: generatedKey != null,
            onChanged: (event) =>
                setKeyName((event.target as HTMLInputElement).value),
          ),
          if (generatedKey == null)
            uiButton(
              label: loading ? 'Generating...' : 'Generate API Key',
              disabled: loading,
              onPressed: (_) => createKey(),
              className: 'w-full',
            )
          else
            div(
              className: 'space-y-3',
              children: [
                div(
                  className:
                      'break-all rounded-lg bg-muted/50 p-4 font-mono text-sm',
                  children: [Text(generatedKey)],
                ),
                p(
                  className: 'text-center text-xs text-muted-foreground',
                  children: const [
                    Text(
                      "⚠️ Save this key now. You won't be able to see it again.",
                    ),
                  ],
                ),
              ],
            ),
          div(
            className: 'flex gap-3',
            children: [
              uiButton(
                label: 'Skip for now',
                variant: UiButtonVariant.outline,
                onPressed: (_) => setStep(OnboardingStep.complete),
                className: 'flex-1',
              ),
              uiButton(
                label: 'Continue',
                disabled: generatedKey == null,
                onPressed: (_) => setStep(OnboardingStep.complete),
                className: 'flex-1',
              ),
            ],
          ),
        ],
      );
    case OnboardingStep.complete:
      content = _onboardingCard(
        glyph: '✓',
        title: "You're all set!",
        subtitle: "Your workspace is ready. Let's start building workflows.",
        children: [
          div(
            className: 'rounded-lg bg-muted/30 p-4 text-left',
            children: [
              h3(
                className: 'font-medium',
                children: const [Text('Quick tips:')],
              ),
              p(
                className: 'mt-2 text-sm text-muted-foreground',
                children: const [
                  Text(
                    '✓ Create your first workflow from the dashboard\n✓ Monitor executions in real-time\n✓ Set up alerts for failures and retries',
                  ),
                ],
              ),
            ],
          ),
          uiButton(
            label: 'Go to Dashboard →',
            onPressed: (_) {
              tenant.setHasCompletedOnboarding(true);
            },
            className: 'w-full',
          ),
        ],
      );
  }

  return div(
    className: 'flex min-h-screen bg-background',
    children: [
      stepRail(),
      main(
        className: 'flex flex-1 items-center justify-center p-8',
        children: [
          div(
            className: 'w-full max-w-lg',
            children: [
              if (notice != null)
                div(
                  className: 'mb-3 rounded-md bg-destructive/10 p-3 text-sm text-destructive',
                  children: [Text(notice)],
                ),
              content,
            ],
          ),
        ],
      ),
    ],
  );
}

ReactNode _onboardingCard({
  required String glyph,
  required String title,
  required String subtitle,
  required ReactChildren children,
}) => uiCard(
  children: [
    uiCardHeader(
      children: [
        div(
          className: 'text-center',
          children: [
            div(
              className: 'mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-3xl text-primary',
              children: [Text(glyph)],
            ),
            h1(className: 'text-2xl font-bold', children: [Text(title)]),
            p(
              className: 'mt-2 text-muted-foreground',
              children: [Text(subtitle)],
            ),
          ],
        ),
      ],
    ),
    uiCardContent(
      children: [div(className: 'space-y-4', children: children)],
    ),
  ],
);
