import 'package:react_dom/react_dom.dart' hide Worker;
import 'package:react_web/web.dart' show HTMLInputElement, HTMLSelectElement;

import '../components/data_table.dart';
import '../components/empty_state.dart';
import '../components/live_indicator.dart';
import '../components/mini_sparkline.dart';
import '../components/page_layout.dart';
import '../components/task_status_badge.dart';
import '../components/ui/button.dart';
import '../components/ui/controls.dart';
import '../components/ui/advanced.dart';
import '../components/ui/input.dart';
import '../components/ui/select.dart';
import '../components/ui/table.dart';
import '../contexts/tenant_context.dart';
import '../data/mock_data.dart';
import '../hooks/use_data_table.dart';
import '../hooks/use_real_time_data.dart';
import '../models/celery.dart';
import '../models/workflow.dart';
import '../utils.dart';

ReactNode _liveRefreshControls<T>(RealTimeData<T> live) => div(
  className: 'flex items-center gap-3',
  children: [
    liveIndicator(
      lastUpdated: formatTimeSince(live.lastUpdated),
      refreshing: live.isRefreshing,
    ),
    uiButton(
      label: '↻ Refresh',
      variant: UiButtonVariant.outline,
      size: UiButtonSize.sm,
      disabled: live.isRefreshing,
      onPressed: (_) => live.refresh(),
    ),
  ],
);

ReactNode _filterBar({
  required String search,
  required void Function(String) onSearch,
  String? searchPlaceholder,
  required List<UiSelectOption> options,
  required String selected,
  required void Function(String) onSelect,
  String? secondSelected,
  List<UiSelectOption>? secondOptions,
  void Function(String)? onSecondSelect,
  void Function()? onClear,
}) => div(
  className: 'mb-4 flex flex-wrap items-center gap-3',
  children: [
    uiInput(
      value: search,
      placeholder: searchPlaceholder ?? 'Search...',
      onChanged: (event) => onSearch((event.target as HTMLInputElement).value),
      className: 'max-w-sm flex-1',
    ),
    uiSelect(
      value: selected,
      options: options,
      onChanged: (event) => onSelect((event.target as HTMLSelectElement).value),
      className: 'w-40',
    ),
    if (secondOptions != null &&
        secondSelected != null &&
        onSecondSelect != null)
      uiSelect(
        value: secondSelected,
        options: secondOptions,
        onChanged: (event) =>
            onSecondSelect((event.target as HTMLSelectElement).value),
        className: 'w-40',
      ),
    if (onClear case final clear?)
      uiButton(
        label: '× Clear filters',
        variant: UiButtonVariant.ghost,
        size: UiButtonSize.sm,
        onPressed: (_) => clear(),
      ),
  ],
);

/// Live task table with status/queue filters and typed pagination.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode TasksPage(({String? scope}) props) {
  final tenant = useTenant();
  final (statusFilter, setStatusFilter) = useState('all');
  final (queueFilter, setQueueFilter) = useState('all');
  final (notice, setNotice) = useState<String?>(null);
  final live = useRealTimeData<Task>(
    RealTimeDataOptions(data: tasks, interval: const Duration(seconds: 5)),
  );
  final queueNames = live.data.map((task) => task.queue).toSet().toList();
  final filtered = live.data.where((task) {
    final statusMatches =
        statusFilter == 'all' || task.status.name == statusFilter;
    final queueMatches = queueFilter == 'all' || task.queue == queueFilter;
    return statusMatches && queueMatches;
  }).toList();
  final table = useDataTable<Task>(
    DataTableOptions(
      data: filtered,
      pageSize: 10,
      searchKeys: const ['id', 'name', 'worker'],
      valueOf: (task, key) => switch (key) {
        'id' => task.id,
        'name' => task.name,
        'worker' => task.worker,
        'retries' => task.retries,
        _ => null,
      },
    ),
  );

  if (!tenant.isGatewayConnected) {
    return pageLayoutComponent(
      activePath: '/tasks',
      title: 'Tasks',
      subtitle: 'Individual Celery task executions',
      headerActions: _liveRefreshControls(live),
      body: gatewayConnectionEmptyState(
        onConnect: () => tenant.setIsGatewayConnected(true),
      ),
    );
  }

  return pageLayoutComponent(
    activePath: '/tasks',
    title: 'Tasks',
    subtitle: 'Individual Celery task executions',
    headerActions: _liveRefreshControls(live),
    body: div(
      children: [
        if (notice != null)
          div(
            className: 'mb-3 rounded-md bg-primary/10 p-3 text-sm text-primary',
            children: [Text(notice)],
          ),
        _filterBar(
          search: table.search,
          onSearch: table.setSearch,
          searchPlaceholder: 'Search tasks by ID, name, or worker...',
          selected: statusFilter,
          onSelect: setStatusFilter.call,
          options: const [
            UiSelectOption('all', 'All Status'),
            UiSelectOption('pending', 'Pending'),
            UiSelectOption('received', 'Received'),
            UiSelectOption('started', 'Started'),
            UiSelectOption('success', 'Success'),
            UiSelectOption('failure', 'Failure'),
            UiSelectOption('retry', 'Retry'),
            UiSelectOption('revoked', 'Revoked'),
          ],
          secondSelected: queueFilter,
          secondOptions: [
            const UiSelectOption('all', 'All Queues'),
            for (final queue in queueNames) UiSelectOption(queue, queue),
          ],
          onSecondSelect: setQueueFilter.call,
          onClear: () {
            setStatusFilter('all');
            setQueueFilter('all');
            table.clearFilters();
          },
        ),
        div(
          className: 'overflow-hidden rounded-xl border border-border bg-card',
          children: [
            uiTable(
              children: [
                uiTableHeader(
                  children: [
                    uiTableRow(
                      children: [
                        uiTableHead('Task ID'),
                        dataTableHeader(
                          label: 'Name',
                          sortKey: 'name',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        uiTableHead('Status'),
                        uiTableHead('Queue'),
                        uiTableHead('Worker'),
                        uiTableHead('Runtime'),
                        dataTableHeader(
                          label: 'Retries',
                          sortKey: 'retries',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        uiTableHead('Actions'),
                      ],
                    ),
                  ],
                ),
                uiTableBody(
                  children: [
                    if (table.paginatedData.isEmpty)
                      uiTableRow(
                        children: [
                          uiTableCell(
                            children: [
                              Text('No tasks found matching your filters'),
                            ],
                          ),
                        ],
                      )
                    else
                      for (final task in table.paginatedData)
                        uiTableRow(
                          key: task.id,
                          children: [
                            uiTableCell(
                              children: [
                                uiTooltip(
                                  label: 'Click to copy ${task.id}',
                                  child: button(
                                    type: 'button',
                                    className:
                                        'font-mono text-xs hover:text-primary',
                                    onClick: (_) =>
                                        setNotice('Copied ${task.id}'),
                                    children: [
                                      Text(
                                        '${task.id.substring(0, task.id.length < 12 ? task.id.length : 12)}...',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            uiTableCell(children: [Text(task.name)]),
                            uiTableCell(
                              children: [taskStatusBadgeComponent(task.status)],
                            ),
                            uiTableCell(
                              children: [
                                span(
                                  className: 'rounded bg-secondary px-2 py-1 text-xs font-medium',
                                  children: [Text(task.queue)],
                                ),
                              ],
                            ),
                            uiTableCell(children: [Text(task.worker ?? '—')]),
                            uiTableCell(children: [Text(task.runtime ?? '—')]),
                            uiTableCell(children: [Text('${task.retries}')]),
                            uiTableCell(
                              children: [
                                uiDropdownMenu(
                                  trigger: uiButton(
                                    label: '•••',
                                    variant: UiButtonVariant.ghost,
                                    size: UiButtonSize.icon,
                                  ),
                                  children: [
                                    uiDropdownItem(
                                      label: 'Retry',
                                      onSelected: () =>
                                          setNotice('Retrying ${task.name}'),
                                    ),
                                    uiDropdownItem(
                                      label: 'Revoke',
                                      onSelected: () =>
                                          setNotice('Revoked ${task.name}'),
                                    ),
                                    uiDropdownItem(
                                      label: 'Delete',
                                      destructive: true,
                                      onSelected: () =>
                                          setNotice('Deleted ${task.name}'),
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
            dataTablePagination(
              currentPage: table.currentPage,
              totalPages: table.totalPages,
              totalItems: table.totalItems,
              onPageChange: table.setCurrentPage,
            ),
          ],
        ),
      ],
    ),
  );
}

/// Queue overview with live counters, sparklines, and lifecycle actions.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode QueuesPage(({String? scope}) props) {
  final tenant = useTenant();
  final (statusFilter, setStatusFilter) = useState('all');
  final (notice, setNotice) = useState<String?>(null);
  final live = useRealTimeData<Queue>(
    RealTimeDataOptions(
      data: queues,
      interval: const Duration(seconds: 3),
      mutator: (queue) => queue.status == QueueStatus.active
          ? Queue(
              id: queue.id,
              name: queue.name,
              status: queue.status,
              pendingTasks: (queue.pendingTasks + (queue.id.hashCode % 3) - 1)
                  .clamp(0, 100000),
              consumers: queue.consumers,
              messageRate: (queue.messageRate + 0.1)
                  .clamp(0, 100000)
                  .toDouble(),
              avgProcessingTime: queue.avgProcessingTime,
              maxLength: queue.maxLength,
            )
          : queue,
    ),
  );
  final filtered = statusFilter == 'all'
      ? live.data
      : live.data.where((queue) => queue.status.name == statusFilter).toList();
  final table = useDataTable<Queue>(
    DataTableOptions(
      data: filtered,
      pageSize: 10,
      searchKeys: const ['name'],
      valueOf: (queue, key) => switch (key) {
        'name' => queue.name,
        'pendingTasks' => queue.pendingTasks,
        'consumers' => queue.consumers,
        'messageRate' => queue.messageRate,
        _ => null,
      },
    ),
  );

  if (!tenant.isGatewayConnected) {
    return pageLayoutComponent(
      activePath: '/queues',
      title: 'Queues',
      subtitle: 'Message queues and their current state',
      headerActions: _liveRefreshControls(live),
      body: gatewayConnectionEmptyState(
        onConnect: () => tenant.setIsGatewayConnected(true),
      ),
    );
  }

  return pageLayoutComponent(
    activePath: '/queues',
    title: 'Queues',
    subtitle: 'Message queues and their current state',
    headerActions: _liveRefreshControls(live),
    body: div(
      children: [
        if (notice != null)
          div(
            className: 'mb-3 rounded-md bg-primary/10 p-3 text-sm text-primary',
            children: [Text(notice)],
          ),
        div(
          className:
              'mb-6 grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3',
          children: [
            for (final queue
                in live.data
                    .where((queue) => queue.status == QueueStatus.active)
                    .take(3))
              div(
                className: 'group rounded-xl border border-border bg-card p-4 transition-all hover:border-primary/50',
                children: [
                  div(
                    className: 'mb-3 flex items-center justify-between',
                    children: [
                      h3(
                        className: 'font-semibold',
                        children: [Text(queue.name)],
                      ),
                      queueStatusBadgeComponent(queue.status),
                    ],
                  ),
                  div(
                    className: 'space-y-3',
                    children: [
                      div(
                        className: 'flex items-center justify-between text-sm',
                        children: [
                          Text('Pending'),
                          Text('${queue.pendingTasks}'),
                        ],
                      ),
                      div(
                        className: 'flex items-center justify-between text-sm',
                        children: [
                          Text('Consumers'),
                          Text('${queue.consumers}'),
                        ],
                      ),
                      div(
                        className: 'flex items-center justify-between text-sm',
                        children: [
                          Text('Rate'),
                          div(
                            className: 'flex items-center gap-2',
                            children: [
                              miniSparklineComponent(
                                generateSparklineData(
                                  base: queue.messageRate * 5 + 10,
                                ),
                                className: 'w-12',
                              ),
                              Text('${queue.messageRate.toStringAsFixed(1)}/s'),
                            ],
                          ),
                        ],
                      ),
                      if (queue.maxLength case final maxLength?)
                        div(
                          className: 'pt-2',
                          children: [
                            div(
                              className: 'mb-1 flex items-center justify-between text-xs text-muted-foreground',
                              children: [
                                const Text('Queue usage'),
                                Text(
                                  '${(queue.pendingTasks / maxLength * 100).clamp(0, 100).round()}%',
                                ),
                              ],
                            ),
                            uiProgress(
                              value: queue.pendingTasks / maxLength * 100,
                            ),
                          ],
                        ),
                    ],
                  ),
                  div(
                    className: 'mt-4 flex gap-2',
                    children: [
                      uiButton(
                        label: queue.status == QueueStatus.paused
                            ? 'Resume'
                            : 'Pause',
                        variant: UiButtonVariant.outline,
                        size: UiButtonSize.sm,
                        onPressed: (_) => setNotice(
                          queue.status == QueueStatus.paused
                              ? 'Resumed ${queue.name}'
                              : 'Paused ${queue.name}',
                        ),
                      ),
                      uiButton(
                        label: 'Purge',
                        variant: UiButtonVariant.ghost,
                        size: UiButtonSize.sm,
                        onPressed: (_) => setNotice('Purged ${queue.name}'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
        _filterBar(
          search: table.search,
          onSearch: table.setSearch,
          searchPlaceholder: 'Search queues...',
          selected: statusFilter,
          onSelect: setStatusFilter.call,
          options: const [
            UiSelectOption('all', 'All Status'),
            UiSelectOption('active', 'Active'),
            UiSelectOption('paused', 'Paused'),
            UiSelectOption('draining', 'Draining'),
          ],
          onClear: () {
            setStatusFilter('all');
            table.clearFilters();
          },
        ),
        div(
          className: 'overflow-hidden rounded-xl border border-border bg-card',
          children: [
            uiTable(
              children: [
                uiTableHeader(
                  children: [
                    uiTableRow(
                      children: [
                        dataTableHeader(
                          label: 'Queue Name',
                          sortKey: 'name',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        uiTableHead('Status'),
                        dataTableHeader(
                          label: 'Pending Tasks',
                          sortKey: 'pendingTasks',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        dataTableHeader(
                          label: 'Consumers',
                          sortKey: 'consumers',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        dataTableHeader(
                          label: 'Message Rate',
                          sortKey: 'messageRate',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        uiTableHead('Avg Processing'),
                        uiTableHead('Max Length'),
                        uiTableHead('Actions'),
                      ],
                    ),
                  ],
                ),
                uiTableBody(
                  children: [
                    for (final queue in table.paginatedData)
                      uiTableRow(
                        key: queue.id,
                        children: [
                          uiTableCell(children: [Text(queue.name)]),
                          uiTableCell(
                            children: [queueStatusBadgeComponent(queue.status)],
                          ),
                          uiTableCell(
                            children: [Text('${queue.pendingTasks}')],
                          ),
                          uiTableCell(children: [Text('${queue.consumers}')]),
                          uiTableCell(
                            children: [
                              Text('${queue.messageRate.toStringAsFixed(1)}/s'),
                            ],
                          ),
                          uiTableCell(
                            children: [Text(queue.avgProcessingTime)],
                          ),
                          uiTableCell(
                            children: [
                              Text(queue.maxLength?.toString() ?? '∞'),
                            ],
                          ),
                          uiTableCell(
                            children: [
                              div(
                                className: 'flex gap-1',
                                children: [
                                  uiButton(
                                    label: queue.status == QueueStatus.paused
                                        ? 'Resume'
                                        : 'Pause',
                                    variant: UiButtonVariant.ghost,
                                    size: UiButtonSize.sm,
                                    onPressed: (_) => setNotice(
                                      queue.status == QueueStatus.paused
                                          ? 'Resumed ${queue.name}'
                                          : 'Paused ${queue.name}',
                                    ),
                                  ),
                                  uiButton(
                                    label: 'Purge',
                                    variant: UiButtonVariant.ghost,
                                    size: UiButtonSize.sm,
                                    onPressed: (_) =>
                                        setNotice('Purged ${queue.name}'),
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
            dataTablePagination(
              currentPage: table.currentPage,
              totalPages: table.totalPages,
              totalItems: table.totalItems,
              onPageChange: table.setCurrentPage,
            ),
          ],
        ),
      ],
    ),
  );
}

/// Worker health page with heartbeat, capacity, and load information.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode WorkersPage(({String? scope}) props) {
  final tenant = useTenant();
  final (statusFilter, setStatusFilter) = useState('all');
  final (query, setQuery) = useState('');
  final (notice, setNotice) = useState<String?>(null);
  final live = useRealTimeData<Worker>(
    RealTimeDataOptions(data: workers, interval: const Duration(seconds: 5)),
  );
  final filtered = live.data.where((worker) {
    final queryMatch =
        query.isEmpty ||
        worker.hostname.toLowerCase().contains(query.toLowerCase());
    final statusMatch =
        statusFilter == 'all' || worker.status.name == statusFilter;
    return queryMatch && statusMatch;
  }).toList();
  if (!tenant.isGatewayConnected) {
    return pageLayoutComponent(
      activePath: '/workers',
      title: 'Workers',
      subtitle: 'Worker health, capacity, and task throughput',
      headerActions: _liveRefreshControls(live),
      body: gatewayConnectionEmptyState(
        onConnect: () => tenant.setIsGatewayConnected(true),
      ),
    );
  }
  return pageLayoutComponent(
    activePath: '/workers',
    title: 'Workers',
    subtitle: 'Worker health, capacity, and task throughput',
    headerActions: _liveRefreshControls(live),
    body: div(
      children: [
        if (notice != null)
          div(
            className: 'mb-3 rounded-md bg-primary/10 p-3 text-sm text-primary',
            children: [Text(notice)],
          ),
        _filterBar(
          search: query,
          onSearch: setQuery.call,
          searchPlaceholder: 'Search workers...',
          selected: statusFilter,
          onSelect: setStatusFilter.call,
          options: const [
            UiSelectOption('all', 'All Status'),
            UiSelectOption('online', 'Online'),
            UiSelectOption('offline', 'Offline'),
            UiSelectOption('heartbeatLost', 'Heartbeat Lost'),
          ],
        ),
        div(
          className: 'grid gap-4 md:grid-cols-2 xl:grid-cols-3',
          children: [
            for (final worker in filtered)
              div(
                className: 'rounded-xl border border-border bg-card p-5',
                children: [
                  div(
                    className: 'mb-4 flex items-start justify-between gap-3',
                    children: [
                      div(
                        children: [
                          p(
                            className: 'font-medium',
                            children: [Text(worker.hostname)],
                          ),
                          p(
                            className:
                                'font-mono text-xs text-muted-foreground',
                            children: [Text(worker.id)],
                          ),
                        ],
                      ),
                      workerStatusBadgeComponent(worker.status),
                    ],
                  ),
                  div(
                    className: 'grid grid-cols-2 gap-4 text-sm',
                    children: [
                      _workerMetric('Queues', worker.queues.join(', ')),
                      _workerMetric('Uptime', worker.uptime),
                      _workerMetric(
                        'Active',
                        '${worker.activeTasks}/${worker.concurrency}',
                      ),
                      _workerMetric('Completed', '${worker.completedTasks}'),
                      _workerMetric('Failed', '${worker.failedTasks}'),
                      _workerMetric('Memory', '${worker.memoryUsage.round()}%'),
                    ],
                  ),
                  div(
                    className: 'mt-4 border-t border-border pt-3 text-xs text-muted-foreground',
                    children: [
                      Text(
                        'Last heartbeat ${formatTimeSince(DateTime.tryParse(worker.lastHeartbeat) ?? DateTime.now())} · PID ${worker.pid}',
                      ),
                    ],
                  ),
                  div(
                    className: 'mt-3 flex justify-end',
                    children: [
                      uiButton(
                        label: 'Inspect worker',
                        variant: UiButtonVariant.outline,
                        size: UiButtonSize.sm,
                        onPressed: (_) =>
                            setNotice('Inspecting ${worker.hostname}'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ],
    ),
  );
}

ReactNode _workerMetric(String label, String value) => div(
  children: [
    p(className: 'text-xs text-muted-foreground', children: [Text(label)]),
    p(className: 'mt-1 font-medium', children: [Text(value)]),
  ],
);

/// Dead-letter queue page with requeue and delete actions.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode DeadLettersPage(({String? scope}) props) {
  final tenant = useTenant();
  final (query, setQuery) = useState('');
  final (reasonFilter, setReasonFilter) = useState('all');
  final (items, setItems) = useState<List<DeadLetter>>(List.of(deadLetters));
  final filtered = items
      .where(
        (letter) =>
            query.isEmpty ||
            letter.taskName.toLowerCase().contains(query.toLowerCase()) ||
            letter.id.toLowerCase().contains(query.toLowerCase()),
      )
      .where(
        (letter) => reasonFilter == 'all' || letter.reason.name == reasonFilter,
      )
      .toList();
  if (!tenant.isGatewayConnected) {
    return pageLayoutComponent(
      activePath: '/dead-letters',
      title: 'Dead Letters',
      subtitle: 'Tasks that exhausted retries or could not be delivered',
      body: gatewayConnectionEmptyState(
        onConnect: () => tenant.setIsGatewayConnected(true),
      ),
    );
  }
  return pageLayoutComponent(
    activePath: '/dead-letters',
    title: 'Dead Letters',
    subtitle: 'Tasks that exhausted retries or could not be delivered',
    body: div(
      children: [
        _filterBar(
          search: query,
          onSearch: setQuery.call,
          searchPlaceholder: 'Search dead letters...',
          selected: reasonFilter,
          onSelect: setReasonFilter.call,
          options: const [
            UiSelectOption('all', 'All Reasons'),
            UiSelectOption('maxRetries', 'Max retries'),
            UiSelectOption('expired', 'Expired'),
            UiSelectOption('rejected', 'Rejected'),
            UiSelectOption('unroutable', 'Unroutable'),
            UiSelectOption('processingError', 'Processing error'),
          ],
          onClear: () {
            setQuery('');
            setReasonFilter('all');
          },
        ),
        div(
          className: 'overflow-hidden rounded-xl border border-border bg-card',
          children: [
            uiTable(
              children: [
                uiTableHeader(
                  children: [
                    uiTableRow(
                      children: [
                        uiTableHead('Task'),
                        uiTableHead('Queue'),
                        uiTableHead('Reason'),
                        uiTableHead('Retries'),
                        uiTableHead('Dead-lettered'),
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
                          uiTableCell(
                            children: [Text('No dead letters found')],
                          ),
                        ],
                      ),
                    for (final letter in filtered)
                      uiTableRow(
                        key: letter.id,
                        children: [
                          uiTableCell(
                            children: [
                              div(
                                children: [
                                  p(
                                    className: 'font-medium',
                                    children: [Text(letter.taskName)],
                                  ),
                                  p(
                                    className: 'font-mono text-xs text-muted-foreground',
                                    children: [Text(letter.originalTaskId)],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          uiTableCell(children: [Text(letter.queue)]),
                          uiTableCell(children: [Text(letter.reason.label)]),
                          uiTableCell(children: [Text('${letter.retries}')]),
                          uiTableCell(
                            children: [Text(formatDate(letter.deadLetteredAt))],
                          ),
                          uiTableCell(
                            children: [
                              div(
                                className: 'flex gap-1',
                                children: [
                                  uiButton(
                                    label: 'Requeue',
                                    variant: UiButtonVariant.outline,
                                    size: UiButtonSize.sm,
                                    onPressed: (_) => setItems.update(
                                      (items) => items
                                          .map(
                                            (item) => item.id == letter.id
                                                ? DeadLetter(
                                                    id: item.id,
                                                    taskName: item.taskName,
                                                    queue: item.queue,
                                                    reason: item.reason,
                                                    retries: item.retries,
                                                    requeued: true,
                                                    originalTaskId:
                                                        item.originalTaskId,
                                                    args: item.args,
                                                    kwargs: item.kwargs,
                                                    exception: item.exception,
                                                    traceback: item.traceback,
                                                    originalReceivedAt:
                                                        item.originalReceivedAt,
                                                    deadLetteredAt:
                                                        item.deadLetteredAt,
                                                  )
                                                : item,
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  uiButton(
                                    label: 'Delete',
                                    variant: UiButtonVariant.ghost,
                                    size: UiButtonSize.sm,
                                    onPressed: (_) => setItems.update(
                                      (items) => items
                                          .where((item) => item.id != letter.id)
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
      ],
    ),
  );
}

/// Execution history timeline with status filtering.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode ExecutionsPage(({String? scope}) props) {
  final tenant = useTenant();
  final (status, setStatus) = useState('all');
  final records = [...recentExecutions, ...recentExecutions];
  final filtered = status == 'all'
      ? records
      : records.where((item) => item.status.name == status).toList();
  if (!tenant.isGatewayConnected) {
    return pageLayoutComponent(
      activePath: '/executions',
      title: 'Executions',
      subtitle: 'A timeline of workflow runs',
      body: gatewayConnectionEmptyState(
        onConnect: () => tenant.setIsGatewayConnected(true),
      ),
    );
  }
  return pageLayoutComponent(
    activePath: '/executions',
    title: 'Executions',
    subtitle: 'A timeline of workflow runs',
    body: div(
      children: [
        div(
          className: 'mb-4 flex justify-end',
          children: [
            uiSelect(
              value: status,
              options: const [
                UiSelectOption('all', 'All Statuses'),
                UiSelectOption('completed', 'Completed'),
                UiSelectOption('running', 'Running'),
                UiSelectOption('failed', 'Failed'),
                UiSelectOption('retrying', 'Retrying'),
              ],
              onChanged: (event) =>
                  setStatus((event.target as HTMLSelectElement).value),
              className: 'w-44',
            ),
          ],
        ),
        div(
          className: 'rounded-xl border border-border bg-card p-2',
          children: [
            for (final (index, execution) in filtered.indexed)
              div(
                key: '${execution.id}-$index',
                className: 'border-b border-border p-4 last:border-0',
                children: [
                  div(
                    className: 'flex items-center justify-between',
                    children: [
                      div(
                        children: [
                          p(
                            className: 'font-medium',
                            children: [Text(execution.workflowName)],
                          ),
                          p(
                            className:
                                'font-mono text-xs text-muted-foreground',
                            children: [Text(execution.id)],
                          ),
                        ],
                      ),
                      span(
                        className: 'text-sm text-muted-foreground',
                        children: [Text(execution.duration)],
                      ),
                    ],
                  ),
                  div(
                    className: 'mt-2 flex items-center gap-3 text-xs text-muted-foreground',
                    children: [
                      span(className: 'h-2 w-2 rounded-full bg-primary'),
                      Text(execution.timestamp),
                      Text(execution.status.label),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ],
    ),
  );
}
