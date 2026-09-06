import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement, HTMLSelectElement;

import '../components/dialogs.dart';
import '../components/empty_state.dart';
import '../components/page_layout.dart';
import '../components/workflow_card.dart';
import '../components/ui/button.dart';
import '../components/ui/input.dart';
import '../components/ui/select.dart';
import '../components/ui/table.dart';
import '../contexts/tenant_context.dart';
import '../data/mock_data.dart';
import '../models/workflow.dart';
import '../router.dart' as router;
import '../utils.dart';

/// The two views available on the workflows page.
enum WorkflowViewMode { grid, list }

/// A complete stateful translation of the reference workflow index page.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode WorkflowsPage(({String? scope}) props) {
  final tenant = useTenant();
  final (query, setQuery) = useState('');
  final (status, setStatus) = useState('all');
  final (mode, setMode) = useState(WorkflowViewMode.grid);
  final (newWorkflowOpen, setNewWorkflowOpen) = useState(false);
  final (localWorkflows, setLocalWorkflows) = useState<List<Workflow>>(
    List.of(workflows),
  );

  final display = tenant.isGatewayConnected
      ? localWorkflows
      : const <Workflow>[];
  final filtered = display.where((workflow) {
    final normalized = query.toLowerCase();
    final matchesQuery =
        normalized.isEmpty ||
        workflow.name.toLowerCase().contains(normalized) ||
        workflow.id.toLowerCase().contains(normalized);
    final matchesStatus = status == 'all' || workflow.status.name == status;
    return matchesQuery && matchesStatus;
  }).toList();
  final stats = (
    total: display.length,
    running: display.where((item) => item.status == JobStatus.running).length,
    completed: display
        .where((item) => item.status == JobStatus.completed)
        .length,
    failed: display.where((item) => item.status == JobStatus.failed).length,
  );

  ReactNode content;
  if (!tenant.isGatewayConnected) {
    content = gatewayConnectionEmptyState(
      onConnect: () => tenant.setIsGatewayConnected(true),
      learnMoreHref: '/settings',
    );
  } else if (filtered.isEmpty) {
    content = emptyStateComponent(
      glyph: query.isNotEmpty || status != 'all' ? '⌕' : '⑂',
      title: query.isNotEmpty || status != 'all'
          ? 'No workflows found'
          : 'No workflows yet',
      description: query.isNotEmpty || status != 'all'
          ? 'Try adjusting your search or filter criteria'
          : 'Create your first workflow to get started',
      action: query.isEmpty && status == 'all' ? 'Create Workflow' : null,
      onAction: (_) => setNewWorkflowOpen(true),
    );
  } else if (mode == WorkflowViewMode.grid) {
    content = div(
      className: 'grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3',
      children: [
        for (final workflow in filtered)
          workflowCardComponent(workflow, key: workflow.id),
      ],
    );
  } else {
    content = div(
      className: 'overflow-hidden rounded-xl border border-border bg-card',
      children: [
        uiTable(
          children: [
            uiTableHeader(
              children: [
                uiTableRow(
                  children: [
                    uiTableHead('Workflow'),
                    uiTableHead('Status'),
                    uiTableHead('Steps'),
                    uiTableHead('Duration'),
                    uiTableHead('Last Run'),
                    uiTableHead('Retries'),
                  ],
                ),
              ],
            ),
            uiTableBody(
              children: [
                for (final workflow in filtered)
                  uiTableRow(
                    key: workflow.id,
                    children: [
                      uiTableCell(
                        children: [
                          router.navLink(
                            to: '/workflows/${workflow.id}',
                            className: 'block hover:text-primary',
                            children: [
                              p(
                                className: 'font-medium',
                                children: [Text(workflow.name)],
                              ),
                              p(
                                className:
                                    'font-mono text-xs text-muted-foreground',
                                children: [Text(workflow.id)],
                              ),
                            ],
                          ),
                        ],
                      ),
                      uiTableCell(children: [Text(workflow.status.label)]),
                      uiTableCell(
                        children: [
                          Text(
                            '${workflow.steps.where((step) => step.status == JobStatus.completed).length}/${workflow.steps.length}',
                          ),
                        ],
                      ),
                      uiTableCell(children: [Text(workflow.duration)]),
                      uiTableCell(
                        children: [Text(formatDate(workflow.lastRun))],
                      ),
                      uiTableCell(children: [Text('${workflow.retries}')]),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  return pageLayoutComponent(
    activePath: '/workflows',
    title: 'Workflows',
    subtitle: 'Manage and monitor your workflow definitions',
    body: div(
      children: [
        div(
          className: 'mb-8 flex items-center justify-between',
          children: [
            p(
              className: 'text-sm text-muted-foreground',
              children: [
                Text(
                  '${stats.total} total · ${stats.running} running · ${stats.completed} completed · ${stats.failed} failed',
                ),
              ],
            ),
            uiButton(
              label: '+  New Workflow',
              onPressed: (_) => setNewWorkflowOpen(true),
            ),
          ],
        ),
        div(
          className: 'mb-6 flex flex-wrap items-center gap-3',
          children: [
            uiInput(
              value: query,
              placeholder: 'Search workflows...',
              onChanged: (event) =>
                  setQuery((event.target as HTMLInputElement).value),
              className: 'max-w-md flex-1',
            ),
            uiSelect(
              value: status,
              options: const [
                UiSelectOption('all', 'All Statuses'),
                UiSelectOption('completed', 'Completed'),
                UiSelectOption('running', 'Running'),
                UiSelectOption('failed', 'Failed'),
                UiSelectOption('pending', 'Pending'),
                UiSelectOption('retrying', 'Retrying'),
              ],
              onChanged: (event) =>
                  setStatus((event.target as HTMLSelectElement).value),
              className: 'w-40',
            ),
            uiButton(
              label: mode == WorkflowViewMode.grid ? '▦ Grid' : '☷ List',
              variant: UiButtonVariant.outline,
              onPressed: (_) => setMode(
                mode == WorkflowViewMode.grid
                    ? WorkflowViewMode.list
                    : WorkflowViewMode.grid,
              ),
            ),
          ],
        ),
        content,
        newWorkflowDialog(
          open: newWorkflowOpen,
          onOpenChange: setNewWorkflowOpen.call,
          onCreated: (workflow) =>
              setLocalWorkflows.update((items) => [workflow, ...items]),
        ),
      ],
    ),
  );
}
