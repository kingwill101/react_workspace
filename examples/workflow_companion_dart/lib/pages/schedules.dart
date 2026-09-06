import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement, HTMLSelectElement;

import '../components/dialogs.dart';
import '../components/page_layout.dart';
import '../components/ui/badge.dart';
import '../components/ui/button.dart';
import '../components/ui/card.dart';
import '../components/ui/input.dart';
import '../components/ui/select.dart';
import '../components/ui/table.dart';
import '../contexts/tenant_context.dart';
import '../data/mock_data.dart';
import '../models/schedule.dart';
import '../utils.dart';

String scheduleTypeLabel(ScheduleConfig config) => switch (config) {
  CronSchedule(:final expression) => expression,
  SolarSchedule(:final event, :final offset) =>
    '${event.name}${offset == null ? '' : ' ($offset)'}',
  WebhookSchedule(:final method) => method.name.toUpperCase(),
};

String scheduleTypeGlyph(ScheduleType type) => switch (type) {
  ScheduleType.cron => '◷',
  ScheduleType.solar => '☼',
  ScheduleType.webhook => '↗',
};

Schedule _withEnabled(Schedule schedule, bool enabled) => Schedule(
  id: schedule.id,
  name: schedule.name,
  description: schedule.description,
  enabled: enabled,
  targetType: schedule.targetType,
  targetId: schedule.targetId,
  targetName: schedule.targetName,
  type: schedule.type,
  config: schedule.config,
  lastRun: schedule.lastRun,
  nextRun: schedule.nextRun,
  runCount: schedule.runCount,
  failureCount: schedule.failureCount,
  createdAt: schedule.createdAt,
  updatedAt: schedule.updatedAt,
);

/// Schedule management page translated from the reference data table.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode SchedulesPage(({String? scope}) props) {
  final tenant = useTenant();
  final (items, setItems) = useState<List<Schedule>>(List.of(schedules));
  final (query, setQuery) = useState('');
  final (type, setType) = useState('all');
  final (status, setStatus) = useState('all');
  final (notice, setNotice) = useState<String?>(null);
  final (createOpen, setCreateOpen) = useState(false);
  final scheduleDialog = createScheduleDialog(
    open: createOpen,
    onOpenChange: setCreateOpen.call,
    onCreated: (schedule) => setItems.update((items) => [schedule, ...items]),
  );

  final filtered = items.where((schedule) {
    final search = query.toLowerCase();
    final matchesSearch =
        search.isEmpty ||
        schedule.name.toLowerCase().contains(search) ||
        schedule.targetName.toLowerCase().contains(search);
    final matchesType = type == 'all' || schedule.config.type.name == type;
    final matchesStatus =
        status == 'all' ||
        (status == 'enabled' && schedule.enabled) ||
        (status == 'disabled' && !schedule.enabled);
    return matchesSearch && matchesType && matchesStatus;
  }).toList();
  final stats = (
    total: items.length,
    enabled: items.where((item) => item.enabled).length,
    cron: items.where((item) => item.type == ScheduleType.cron).length,
    solar: items.where((item) => item.type == ScheduleType.solar).length,
    webhook: items.where((item) => item.type == ScheduleType.webhook).length,
  );

  ReactNode statCard(String label, Object value, String glyph) => uiCard(
    className: 'p-4',
    children: [
      div(
        className: 'flex items-center justify-between',
        children: [
          div(
            children: [
              p(
                className: 'text-sm text-muted-foreground',
                children: [Text(label)],
              ),
              p(className: 'text-2xl font-bold', children: [Text('$value')]),
            ],
          ),
          span(className: 'text-2xl text-primary/60', children: [Text(glyph)]),
        ],
      ),
    ],
  );

  if (!tenant.isGatewayConnected) {
    return pageLayoutComponent(
      activePath: '/schedules',
      title: 'Schedules',
      subtitle:
          'Schedule workflows and tasks with cron, solar events, or webhooks',
      body: div(
        children: [
          div(
            className: 'mb-6 flex items-center justify-between',
            children: [
              p(
                className: 'text-sm text-muted-foreground',
                children: [Text('Automate recurring workflow work.')],
              ),
              uiButton(
                label: '+ New Schedule',
                onPressed: (_) => tenant.setIsGatewayConnected(true),
              ),
            ],
          ),
          div(
            className: 'grid grid-cols-2 gap-4 md:grid-cols-5',
            children: [
              statCard('Total', stats.total, '◫'),
              statCard('Enabled', stats.enabled, '✓'),
              statCard('Cron', stats.cron, '◷'),
              statCard('Solar', stats.solar, '☼'),
              statCard('Webhooks', stats.webhook, '↗'),
            ],
          ),
          scheduleDialog,
        ],
      ),
    );
  }

  return pageLayoutComponent(
    activePath: '/schedules',
    title: 'Schedules',
    subtitle:
        'Schedule workflows and tasks with cron, solar events, or webhooks',
    body: div(
      children: [
        if (notice != null)
          div(
            className: 'mb-3 rounded-md bg-primary/10 p-3 text-sm text-primary',
            children: [Text(notice)],
          ),
        div(
          className: 'mb-6 flex items-center justify-between',
          children: [
            p(
              className: 'text-sm text-muted-foreground',
              children: [
                Text('${stats.enabled} of ${stats.total} schedules enabled'),
              ],
            ),
            uiButton(
              label: '+ New Schedule',
              onPressed: (_) => setCreateOpen(true),
            ),
          ],
        ),
        div(
          className: 'mb-6 grid grid-cols-2 gap-4 md:grid-cols-5',
          children: [
            statCard('Total', stats.total, '◫'),
            statCard('Enabled', stats.enabled, '✓'),
            statCard('Cron', stats.cron, '◷'),
            statCard('Solar', stats.solar, '☼'),
            statCard('Webhooks', stats.webhook, '↗'),
          ],
        ),
        div(
          className: 'mb-4 flex flex-wrap items-center gap-3',
          children: [
            uiInput(
              value: query,
              placeholder: 'Search schedules...',
              onChanged: (event) =>
                  setQuery((event.target as HTMLInputElement).value),
              className: 'max-w-sm flex-1',
            ),
            uiSelect(
              value: type,
              options: const [
                UiSelectOption('all', 'All Types'),
                UiSelectOption('cron', 'Cron'),
                UiSelectOption('solar', 'Solar'),
                UiSelectOption('webhook', 'Webhook'),
              ],
              onChanged: (event) =>
                  setType((event.target as HTMLSelectElement).value),
              className: 'w-36',
            ),
            uiSelect(
              value: status,
              options: const [
                UiSelectOption('all', 'All Status'),
                UiSelectOption('enabled', 'Enabled'),
                UiSelectOption('disabled', 'Disabled'),
              ],
              onChanged: (event) =>
                  setStatus((event.target as HTMLSelectElement).value),
              className: 'w-36',
            ),
          ],
        ),
        uiCard(
          children: [
            uiTable(
              children: [
                uiTableHeader(
                  children: [
                    uiTableRow(
                      children: [
                        uiTableHead('Active'),
                        uiTableHead('Schedule'),
                        uiTableHead('Type'),
                        uiTableHead('Target'),
                        uiTableHead('Last Run'),
                        uiTableHead('Next Run'),
                        uiTableHead('Runs'),
                        uiTableHead('Actions'),
                      ],
                    ),
                  ],
                ),
                uiTableBody(
                  children: [
                    if (filtered.isEmpty)
                      uiTableRow(
                        children: [
                          uiTableCell(children: [Text('No schedules found')]),
                        ],
                      ),
                    for (final schedule in filtered)
                      uiTableRow(
                        key: schedule.id,
                        children: [
                          uiTableCell(
                            children: [
                              input(
                                type: 'checkbox',
                                checked: schedule.enabled,
                                onChange: (_) => setItems.update(
                                  (items) => items
                                      .map(
                                        (item) => item.id == schedule.id
                                            ? _withEnabled(item, !item.enabled)
                                            : item,
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          uiTableCell(
                            children: [
                              div(
                                children: [
                                  p(
                                    className: 'font-medium',
                                    children: [Text(schedule.name)],
                                  ),
                                  if (schedule.description != null)
                                    p(
                                      className: 'max-w-[260px] truncate text-xs text-muted-foreground',
                                      children: [
                                        Text(schedule.description ?? ''),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                          uiTableCell(
                            children: [
                              div(
                                className: 'flex items-center gap-2',
                                children: [
                                  uiBadge(
                                    label:
                                        '${scheduleTypeGlyph(schedule.type)} ${schedule.type.name}',
                                  ),
                                  span(
                                    className: 'font-mono text-xs text-muted-foreground',
                                    children: [
                                      Text(scheduleTypeLabel(schedule.config)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          uiTableCell(
                            children: [
                              span(
                                className: 'text-sm hover:text-primary',
                                children: [Text(schedule.targetName)],
                              ),
                            ],
                          ),
                          uiTableCell(
                            children: [
                              Text(
                                schedule.lastRun == null
                                    ? 'Never'
                                    : formatDate(schedule.lastRun),
                              ),
                            ],
                          ),
                          uiTableCell(
                            children: [
                              Text(schedule.enabled ? schedule.nextRun : '—'),
                            ],
                          ),
                          uiTableCell(children: [Text('${schedule.runCount}')]),
                          uiTableCell(
                            children: [
                              div(
                                className: 'flex gap-1',
                                children: [
                                  uiButton(
                                    label: 'Run',
                                    variant: UiButtonVariant.ghost,
                                    size: UiButtonSize.sm,
                                    onPressed: (_) => setNotice(
                                      'Running ${schedule.name} now.',
                                    ),
                                  ),
                                  uiButton(
                                    label: 'Delete',
                                    variant: UiButtonVariant.ghost,
                                    size: UiButtonSize.sm,
                                    onPressed: (_) => setItems.update(
                                      (items) => items
                                          .where(
                                            (item) => item.id != schedule.id,
                                          )
                                          .toList(),
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
            ),
          ],
        ),
        scheduleDialog,
      ],
    ),
  );
}
