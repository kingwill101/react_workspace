import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart'
    show HTMLInputElement, HTMLSelectElement, HTMLTextAreaElement;

import '../contexts/tenant_context.dart';
import '../data/mock_data.dart';
import '../data/schedule_catalog.dart';
import '../models/schedule.dart';
import '../models/tenant.dart';
import '../models/workflow.dart';
import 'ui/button.dart';
import 'ui/dialog.dart';
import 'ui/input.dart';
import 'ui/label.dart';
import 'ui/select.dart';
import 'ui/textarea.dart';

/// Callback used by modal forms after a successful submission.
typedef DialogComplete<T> = void Function(T value);

/// Dialog for creating a workflow definition.
ReactNode newWorkflowDialog({
  required bool open,
  required void Function(bool) onOpenChange,
  DialogComplete<Workflow>? onCreated,
}) {
  final (name, setName) = useState('');
  final (description, setDescription) = useState('');
  final (stepName, setStepName) = useState('');
  final (stepNames, setStepNames) = useState<List<String>>([]);
  final (loading, setLoading) = useState(false);
  if (!open) return fragment(const []);

  void addStep() {
    if (stepName.trim().isEmpty) {
      return;
    }
    setStepNames([...stepNames, stepName.trim()]);
    setStepName('');
  }

  void create() {
    if (name.trim().isEmpty) return;
    setLoading(true);
    final now = DateTime.now();
    final workflow = Workflow(
      id: 'wf-${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}',
      name: name.trim(),
      description: description.trim(),
      status: JobStatus.pending,
      duration: '—',
      retries: 0,
      lastRun: 'Not run yet',
      steps: [
        for (final (index, step) in stepNames.indexed)
          WorkflowStep(
            id: 'new-step-$index',
            name: step,
            jobId: 'new-job-$index',
            status: JobStatus.pending,
            duration: '—',
            order: index + 1,
          ),
      ],
      history: [],
    );
    // The short delay keeps the loading transition observable in the demo.
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      setLoading(false);
      onCreated?.call(workflow);
      onOpenChange(false);
    });
    // Keep the local timestamp in the implementation so the modal mirrors
    // the asynchronous creation path used by the reference app.
    now;
  }

  return uiDialog(
    open: open,
    title: 'Create Workflow',
    description: 'Define a new multi-step background workflow.',
    onOpenChange: onOpenChange,
    children: [
      div(
        className: 'space-y-4 py-2',
        children: [
          div(
            className: 'space-y-2',
            children: [
              uiLabel(text: 'Workflow Name', htmlFor: 'workflow-name'),
              uiInput(
                id: 'workflow-name',
                value: name,
                placeholder: 'Order processing',
                onChanged: (event) =>
                    setName((event.target as HTMLInputElement).value),
              ),
            ],
          ),
          div(
            className: 'space-y-2',
            children: [
              uiLabel(text: 'Description', htmlFor: 'workflow-description'),
              uiTextarea(
                id: 'workflow-description',
                value: description,
                placeholder: 'What does this workflow do?',
                rows: 3,
                onChanged: (event) =>
                    setDescription((event.target as HTMLTextAreaElement).value),
              ),
            ],
          ),
          div(
            className: 'space-y-2',
            children: [
              uiLabel(text: 'Steps', htmlFor: 'workflow-step'),
              div(
                className: 'flex gap-2',
                children: [
                  uiInput(
                    id: 'workflow-step',
                    value: stepName,
                    placeholder: 'Validate order',
                    onChanged: (event) =>
                        setStepName((event.target as HTMLInputElement).value),
                    className: 'flex-1',
                  ),
                  uiButton(
                    label: 'Add',
                    variant: UiButtonVariant.outline,
                    onPressed: (_) => addStep(),
                  ),
                ],
              ),
              if (stepNames.isNotEmpty)
                div(
                  className: 'space-y-1 rounded-md bg-muted/50 p-3',
                  children: [
                    for (final (index, step) in stepNames.indexed)
                      div(
                        className: 'flex items-center justify-between text-sm',
                        children: [
                          Text('${index + 1}. $step'),
                          uiButton(
                            label: '×',
                            variant: UiButtonVariant.ghost,
                            size: UiButtonSize.icon,
                            onPressed: (_) => setStepNames(
                              stepNames.where((item) => item != step).toList(),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ],
    footer: [
      uiButton(
        label: 'Cancel',
        variant: UiButtonVariant.outline,
        onPressed: (_) => onOpenChange(false),
      ),
      uiButton(
        label: loading ? 'Creating...' : 'Create Workflow',
        disabled: loading || name.trim().isEmpty,
        onPressed: (_) => create(),
      ),
    ],
  );
}

/// Dialog for creating a tenant organization.
ReactNode createOrganizationDialog({
  required bool open,
  required void Function(bool) onOpenChange,
}) {
  final tenant = useTenant();
  final (name, setName) = useState('');
  final (slug, setSlug) = useState('');
  final (loading, setLoading) = useState(false);
  return uiDialog(
    open: open,
    title: 'Create Organization',
    description: 'Create a new organization workspace.',
    onOpenChange: onOpenChange,
    children: [
      div(
        className: 'space-y-4 py-2',
        children: [
          div(
            className: 'space-y-2',
            children: [
              uiLabel(text: 'Organization Name', htmlFor: 'organization-name'),
              uiInput(
                id: 'organization-name',
                value: name,
                placeholder: 'Acme Corporation',
                onChanged: (event) {
                  final value = (event.target as HTMLInputElement).value;
                  setName(value);
                  if (slug.isEmpty) {
                    setSlug(
                      value.toLowerCase().replaceAll(RegExp(r'\s+'), '-'),
                    );
                  }
                },
              ),
            ],
          ),
          div(
            className: 'space-y-2',
            children: [
              uiLabel(text: 'URL Slug', htmlFor: 'organization-slug'),
              uiInput(
                id: 'organization-slug',
                value: slug,
                placeholder: 'acme',
                onChanged: (event) => setSlug(
                  (event.target as HTMLInputElement).value
                      .toLowerCase()
                      .replaceAll(RegExp(r'\s+'), '-'),
                ),
                className: 'font-mono',
              ),
            ],
          ),
        ],
      ),
    ],
    footer: [
      uiButton(
        label: 'Cancel',
        variant: UiButtonVariant.outline,
        onPressed: (_) => onOpenChange(false),
      ),
      uiButton(
        label: loading ? 'Creating...' : 'Create Organization',
        disabled: loading || name.trim().isEmpty,
        onPressed: (_) async {
          setLoading(true);
          await tenant.createOrganization(name, slug.isEmpty ? name : slug);
          setLoading(false);
          onOpenChange(false);
        },
      ),
    ],
  );
}

/// Dialog for inviting one member to the active tenant.
ReactNode inviteTeamDialog({
  required bool open,
  required void Function(bool) onOpenChange,
}) {
  final tenant = useTenant();
  final (email, setEmail) = useState('');
  final (role, setRole) = useState(MemberRole.member);
  final (loading, setLoading) = useState(false);
  return uiDialog(
    open: open,
    title: 'Invite Team Member',
    description: 'Send an invitation to collaborate on workflows.',
    onOpenChange: onOpenChange,
    children: [
      div(
        className: 'space-y-4 py-2',
        children: [
          div(
            className: 'space-y-2',
            children: [
              uiLabel(text: 'Email Address', htmlFor: 'invite-email'),
              uiInput(
                id: 'invite-email',
                type: 'email',
                value: email,
                placeholder: 'colleague@company.com',
                onChanged: (event) =>
                    setEmail((event.target as HTMLInputElement).value),
              ),
            ],
          ),
          div(
            className: 'space-y-2',
            children: [
              uiLabel(text: 'Role', htmlFor: 'invite-role'),
              uiSelect(
                id: 'invite-role',
                value: role.name,
                options: const [
                  UiSelectOption('admin', 'Admin'),
                  UiSelectOption('member', 'Member'),
                  UiSelectOption('viewer', 'Viewer'),
                ],
                onChanged: (event) => setRole(
                  MemberRole.values.firstWhere(
                    (item) =>
                        item.name == (event.target as HTMLSelectElement).value,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    footer: [
      uiButton(
        label: 'Cancel',
        variant: UiButtonVariant.outline,
        onPressed: (_) => onOpenChange(false),
      ),
      uiButton(
        label: loading ? 'Sending...' : 'Send Invitation',
        disabled: loading || !email.contains('@'),
        onPressed: (_) async {
          setLoading(true);
          await tenant.inviteTeamMember(email, role);
          setLoading(false);
          onOpenChange(false);
        },
      ),
    ],
  );
}

/// Dialog that creates and reveals a new API key once.
ReactNode generateApiKeyDialog({
  required bool open,
  required void Function(bool) onOpenChange,
}) {
  final tenant = useTenant();
  final (name, setName) = useState('Production');
  final (key, setKey) = useState<ApiKey?>(null);
  final (loading, setLoading) = useState(false);
  return uiDialog(
    open: open,
    title: 'Generate API Key',
    description: 'Keys authenticate SDK requests for this workspace.',
    onOpenChange: onOpenChange,
    children: [
      if (key == null)
        uiInput(
          value: name,
          placeholder: 'Production',
          onChanged: (event) =>
              setName((event.target as HTMLInputElement).value),
        )
      else ...[
        div(
          className: 'break-all rounded-lg bg-muted/50 p-4 font-mono text-sm',
          children: [Text(key.key)],
        ),
        p(
          className: 'text-xs text-muted-foreground',
          children: const [
            Text(
              "Save this key now. It will not be shown again after closing the dialog.",
            ),
          ],
        ),
      ],
    ],
    footer: key == null
        ? [
            uiButton(
              label: 'Cancel',
              variant: UiButtonVariant.outline,
              onPressed: (_) => onOpenChange(false),
            ),
            uiButton(
              label: loading ? 'Generating...' : 'Generate API Key',
              disabled: loading || name.trim().isEmpty,
              onPressed: (_) async {
                setLoading(true);
                final created = await tenant.generateApiKey(name);
                setKey(created);
                setLoading(false);
              },
            ),
          ]
        : [uiButton(label: 'Done', onPressed: (_) => onOpenChange(false))],
  );
}

/// A small visual cron expression builder shared by schedule creation.
ReactNode visualCronBuilder({
  required String value,
  required void Function(String) onChange,
}) {
  final (frequency, setFrequency) = useState('hour');
  final (minute, setMinute) = useState(0);
  final (hour, setHour) = useState(9);
  final expression = switch (frequency) {
    'minute' => '* * * * *',
    'hour' => '$minute * * * *',
    'day' => '$minute $hour * * *',
    'week' => '$minute $hour * * 1',
    'month' => '$minute $hour 1 * *',
    _ => value,
  };
  // Calling the parent updater during render is avoided: the value is shown
  // immediately and the parent receives it from each control callback.
  ReactNode choose(String next) => uiButton(
    label: next[0].toUpperCase() + next.substring(1),
    variant: frequency == next
        ? UiButtonVariant.defaultAction
        : UiButtonVariant.outline,
    size: UiButtonSize.sm,
    onPressed: (_) {
      setFrequency(next);
      onChange(switch (next) {
        'minute' => '* * * * *',
        'hour' => '$minute * * * *',
        'day' => '$minute $hour * * *',
        'week' => '$minute $hour * * 1',
        'month' => '$minute $hour 1 * *',
        _ => value,
      });
    },
  );
  return div(
    className: 'space-y-4 rounded-lg border border-border bg-muted/20 p-4',
    children: [
      div(
        className: 'flex items-center justify-between',
        children: [
          p(
            className: 'text-sm font-medium',
            children: const [Text('Run frequency')],
          ),
          uiButton(
            label: 'Reset',
            variant: UiButtonVariant.ghost,
            size: UiButtonSize.sm,
            onPressed: (_) {
              setFrequency('hour');
              setMinute(0);
              setHour(9);
              onChange('0 * * * *');
            },
          ),
        ],
      ),
      div(
        className: 'flex flex-wrap gap-2',
        children: [
          for (final item in const ['minute', 'hour', 'day', 'week', 'month'])
            choose(item),
        ],
      ),
      if (frequency == 'hour' ||
          frequency == 'day' ||
          frequency == 'week' ||
          frequency == 'month')
        div(
          className: 'flex items-center gap-2',
          children: [
            uiSelect(
              value: '$hour',
              options: [
                for (var item = 0; item < 24; item++)
                  UiSelectOption('$item', item.toString().padLeft(2, '0')),
              ],
              onChanged: (event) {
                final selected = int.parse(
                  (event.target as HTMLSelectElement).value,
                );
                setHour(selected);
                onChange(
                  frequency == 'hour'
                      ? '$minute * * * *'
                      : '$minute $selected * * *',
                );
              },
              className: 'w-24',
            ),
            const Text(':'),
            uiSelect(
              value: '$minute',
              options: [
                for (var item = 0; item < 60; item++)
                  UiSelectOption('$item', item.toString().padLeft(2, '0')),
              ],
              onChanged: (event) {
                final selected = int.parse(
                  (event.target as HTMLSelectElement).value,
                );
                setMinute(selected);
                onChange(
                  frequency == 'hour'
                      ? '$selected * * * *'
                      : '$selected $hour * * *',
                );
              },
              className: 'w-24',
            ),
          ],
        ),
      div(
        className: 'rounded bg-muted p-3 font-mono text-sm',
        children: [Text(expression)],
      ),
    ],
  );
}

/// Dialog for creating cron, solar, and webhook schedules.
///
/// The reference uses Radix tabs and selects. This implementation keeps the
/// same state model and interaction flow while using portable HTML controls,
/// so the form can be rendered by SSR and exercised by the native harness.
ReactNode createScheduleDialog({
  required bool open,
  required void Function(bool) onOpenChange,
  DialogComplete<Schedule>? onCreated,
}) {
  final (scheduleType, setScheduleType) = useState(ScheduleType.cron);
  final (name, setName) = useState('');
  final (description, setDescription) = useState('');
  final (targetType, setTargetType) = useState('workflow');
  final (targetId, setTargetId) = useState('');
  final (cronExpression, setCronExpression) = useState('0 * * * *');
  final (timezone, setTimezone) = useState('UTC');
  final (enableCallback, setEnableCallback) = useState(false);
  final (callbackUrl, setCallbackUrl) = useState('');
  final (callbackMethod, setCallbackMethod) = useState(ScheduleHttpMethod.post);
  final (solarEvent, setSolarEvent) = useState(SolarEvent.sunrise);
  final (latitude, setLatitude) = useState('40.7128');
  final (longitude, setLongitude) = useState('-74.006');
  final (offset, setOffset) = useState('');
  final (webhookMethod, setWebhookMethod) = useState(ScheduleHttpMethod.post);
  final (notice, setNotice) = useState<String?>(null);
  final cronBuilder = visualCronBuilder(
    value: cronExpression,
    onChange: setCronExpression.call,
  );

  final targetItems = targetType == 'workflow'
      ? [
          for (final workflow in workflows)
            (id: workflow.id, name: workflow.name),
        ]
      : [for (final job in jobs) (id: job.id, name: job.name)];
  final target = targetItems.where((item) => item.id == targetId);
  final targetName = target.isEmpty ? 'Unknown' : target.first.name;
  final webhookUrl =
      'https://api.durable.io/webhooks/${_slug(name.isEmpty ? 'new-schedule' : name)}';

  void reset() {
    setScheduleType(ScheduleType.cron);
    setName('');
    setDescription('');
    setTargetType('workflow');
    setTargetId('');
    setCronExpression('0 * * * *');
    setTimezone('UTC');
    setEnableCallback(false);
    setCallbackUrl('');
    setCallbackMethod(ScheduleHttpMethod.post);
    setSolarEvent(SolarEvent.sunrise);
    setLatitude('40.7128');
    setLongitude('-74.006');
    setOffset('');
    setWebhookMethod(ScheduleHttpMethod.post);
    setNotice(null);
  }

  void create() {
    if (name.trim().isEmpty) {
      setNotice('Please enter a schedule name.');
      return;
    }
    if (targetId.isEmpty) {
      setNotice('Please select a target workflow or task.');
      return;
    }
    final config = switch (scheduleType) {
      ScheduleType.cron => CronSchedule(
        expression: cronExpression,
        timezone: timezone,
        callbackUrl: enableCallback && callbackUrl.trim().isNotEmpty
            ? callbackUrl.trim()
            : null,
        callbackMethod: enableCallback && callbackUrl.trim().isNotEmpty
            ? callbackMethod
            : null,
      ),
      ScheduleType.solar => SolarSchedule(
        event: solarEvent,
        latitude: double.tryParse(latitude) ?? 0,
        longitude: double.tryParse(longitude) ?? 0,
        offset: offset.trim().isEmpty ? null : offset.trim(),
      ),
      ScheduleType.webhook => WebhookSchedule(
        url: webhookUrl,
        method: webhookMethod,
      ),
    };
    final schedule = Schedule(
      id: 'sched-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      enabled: true,
      targetType: targetType,
      targetId: targetId,
      targetName: targetName,
      type: scheduleType,
      config: config,
      nextRun: scheduleType == ScheduleType.webhook
          ? 'On request'
          : 'Calculating...',
      runCount: 0,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    onCreated?.call(schedule);
    onOpenChange(false);
    reset();
  }

  return uiDialog(
    open: open,
    title: 'Create Schedule',
    description: 'Schedule a workflow or task to run automatically.',
    onOpenChange: onOpenChange,
    className: 'max-h-[90vh] overflow-y-auto sm:max-w-[600px]',
    children: [
      div(
        className: 'space-y-6 py-4',
        children: [
          if (notice != null)
            div(
              className:
                  'rounded-md bg-destructive/10 p-3 text-sm text-destructive',
              children: [Text(notice)],
            ),
          _scheduleField(
            label: 'Schedule Name',
            child: uiInput(
              id: 'schedule-name',
              value: name,
              placeholder: 'e.g. Daily Backup',
              onChanged: (event) =>
                  setName((event.target as HTMLInputElement).value),
            ),
          ),
          _scheduleField(
            label: 'Description (optional)',
            child: uiTextarea(
              id: 'schedule-description',
              value: description,
              placeholder: 'What does this schedule do?',
              rows: 2,
              onChanged: (event) =>
                  setDescription((event.target as HTMLTextAreaElement).value),
            ),
          ),
          _scheduleField(
            label: 'Target',
            child: div(
              className: 'flex gap-2',
              children: [
                uiSelect(
                  value: targetType,
                  options: const [
                    UiSelectOption('workflow', 'Workflow'),
                    UiSelectOption('task', 'Task'),
                  ],
                  onChanged: (event) {
                    setTargetType((event.target as HTMLSelectElement).value);
                    setTargetId('');
                  },
                  className: 'w-36',
                ),
                uiSelect(
                  value: targetId,
                  options: [
                    const UiSelectOption('', 'Select a target...'),
                    for (final item in targetItems)
                      UiSelectOption(item.id, item.name),
                  ],
                  onChanged: (event) =>
                      setTargetId((event.target as HTMLSelectElement).value),
                  className: 'flex-1',
                ),
              ],
            ),
          ),
          div(
            className: 'grid grid-cols-3 gap-2 rounded-lg bg-muted/50 p-1',
            children: [
              for (final item in ScheduleType.values)
                uiButton(
                  label:
                      '${_scheduleTypeGlyph(item)} ${item.name.capitalize()}',
                  variant: scheduleType == item
                      ? UiButtonVariant.defaultAction
                      : UiButtonVariant.ghost,
                  size: UiButtonSize.sm,
                  onPressed: (_) {
                    setScheduleType(item);
                    setNotice(null);
                  },
                ),
            ],
          ),
          if (scheduleType == ScheduleType.cron) ...[
            cronBuilder,
            _scheduleField(
              label: 'Preset',
              child: uiSelect(
                value:
                    cronPresets.any(
                      (preset) => preset.expression == cronExpression,
                    )
                    ? cronExpression
                    : '',
                options: [
                  const UiSelectOption('', 'Choose a preset...'),
                  for (final preset in cronPresets)
                    UiSelectOption(preset.expression, preset.label),
                ],
                onChanged: (event) => setCronExpression(
                  (event.target as HTMLSelectElement).value,
                ),
              ),
            ),
            _scheduleField(
              label: 'Timezone',
              child: uiSelect(
                value: timezone,
                options: [
                  for (final value in scheduleTimezones)
                    UiSelectOption(value, value),
                ],
                onChanged: (event) =>
                    setTimezone((event.target as HTMLSelectElement).value),
              ),
            ),
            _scheduleToggle(
              label: 'Call an external URL',
              description: 'Make an HTTP request when this cron triggers.',
              value: enableCallback,
              onChanged: setEnableCallback.call,
            ),
            if (enableCallback) ...[
              _scheduleField(
                label: 'Callback URL',
                child: uiInput(
                  value: callbackUrl,
                  placeholder: 'https://example.com/hook',
                  onChanged: (event) =>
                      setCallbackUrl((event.target as HTMLInputElement).value),
                ),
              ),
              _scheduleField(
                label: 'Callback method',
                child: uiSelect(
                  value: callbackMethod.name,
                  options: const [
                    UiSelectOption('get', 'GET'),
                    UiSelectOption('post', 'POST'),
                    UiSelectOption('put', 'PUT'),
                    UiSelectOption('delete', 'DELETE'),
                  ],
                  onChanged: (event) => setCallbackMethod(
                    ScheduleHttpMethod.values.firstWhere(
                      (method) =>
                          method.name ==
                          (event.target as HTMLSelectElement).value,
                    ),
                  ),
                ),
              ),
            ],
          ] else if (scheduleType == ScheduleType.solar) ...[
            _scheduleField(
              label: 'Solar event',
              child: uiSelect(
                value: solarEvent.name,
                options: [
                  for (final option in solarEventOptions)
                    UiSelectOption(option.event.name, option.label),
                ],
                onChanged: (event) => setSolarEvent(
                  SolarEvent.values.firstWhere(
                    (item) =>
                        item.name == (event.target as HTMLSelectElement).value,
                  ),
                ),
              ),
            ),
            p(
              className: 'text-xs text-muted-foreground',
              children: [
                Text(
                  solarEventOptions
                      .firstWhere((option) => option.event == solarEvent)
                      .description,
                ),
              ],
            ),
            div(
              className: 'grid gap-4 sm:grid-cols-3',
              children: [
                _scheduleField(
                  label: 'Latitude',
                  child: uiInput(
                    value: latitude,
                    onChanged: (event) =>
                        setLatitude((event.target as HTMLInputElement).value),
                  ),
                ),
                _scheduleField(
                  label: 'Longitude',
                  child: uiInput(
                    value: longitude,
                    onChanged: (event) =>
                        setLongitude((event.target as HTMLInputElement).value),
                  ),
                ),
                _scheduleField(
                  label: 'Offset',
                  child: uiInput(
                    value: offset,
                    placeholder: '+30m',
                    onChanged: (event) =>
                        setOffset((event.target as HTMLInputElement).value),
                  ),
                ),
              ],
            ),
          ] else ...[
            div(
              className: 'rounded-lg bg-muted/50 p-4',
              children: [
                p(
                  className: 'text-sm font-medium',
                  children: const [Text('Generated webhook URL')],
                ),
                p(
                  className:
                      'mt-2 break-all font-mono text-xs text-muted-foreground',
                  children: [Text(webhookUrl)],
                ),
              ],
            ),
            _scheduleField(
              label: 'Webhook method',
              child: uiSelect(
                value: webhookMethod.name,
                options: const [
                  UiSelectOption('get', 'GET'),
                  UiSelectOption('post', 'POST'),
                  UiSelectOption('put', 'PUT'),
                ],
                onChanged: (event) => setWebhookMethod(
                  ScheduleHttpMethod.values.firstWhere(
                    (item) =>
                        item.name == (event.target as HTMLSelectElement).value,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ],
    footer: [
      uiButton(
        label: 'Cancel',
        variant: UiButtonVariant.outline,
        onPressed: (_) => onOpenChange(false),
      ),
      uiButton(label: 'Create Schedule', onPressed: (_) => create()),
    ],
  );
}

ReactNode _scheduleField({required String label, required ReactNode child}) =>
    div(
      className: 'space-y-2',
      children: [
        uiLabel(text: label),
        child,
      ],
    );

ReactNode _scheduleToggle({
  required String label,
  required String description,
  required bool value,
  required void Function(bool) onChanged,
}) => div(
  className:
      'flex items-center justify-between gap-4 border-t border-border pt-4',
  children: [
    div(
      children: [
        p(className: 'text-sm font-medium', children: [Text(label)]),
        p(
          className: 'text-xs text-muted-foreground',
          children: [Text(description)],
        ),
      ],
    ),
    uiButton(
      label: value ? 'On' : 'Off',
      variant: value ? UiButtonVariant.defaultAction : UiButtonVariant.outline,
      size: UiButtonSize.sm,
      onPressed: (_) => onChanged(!value),
    ),
  ],
);

String _slug(String value) => value
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-|-$'), '');

String _scheduleTypeGlyph(ScheduleType type) => switch (type) {
  ScheduleType.cron => '◷',
  ScheduleType.solar => '☼',
  ScheduleType.webhook => '↗',
};

extension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
