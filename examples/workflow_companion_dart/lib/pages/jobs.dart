import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

import '../components/data_table.dart';
import '../components/empty_state.dart';
import '../components/page_layout.dart';
import '../components/status_badge.dart';
import '../components/ui/button.dart';
import '../components/ui/input.dart';
import '../components/ui/table.dart';
import '../contexts/tenant_context.dart';
import '../data/mock_data.dart';
import '../hooks/use_data_table.dart';
import '../models/workflow.dart';
import '../utils.dart';

/// Jobs index with search, status sorting, and workflow links.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode JobsPage(({String? scope}) props) {
  final tenant = useTenant();
  final (notice, setNotice) = useState<String?>(null);
  final table = useDataTable<Job>(
    DataTableOptions(
      data: jobs,
      pageSize: 10,
      searchKeys: const ['id', 'name', 'workflowId'],
      valueOf: (job, key) => switch (key) {
        'id' => job.id,
        'name' => job.name,
        'workflowId' => job.workflowId,
        'retries' => job.retries,
        _ => null,
      },
    ),
  );
  if (!tenant.isGatewayConnected) {
    return pageLayoutComponent(
      activePath: '/jobs',
      title: 'Jobs',
      subtitle: 'Individual task executions across all workflows',
      body: gatewayConnectionEmptyState(
        onConnect: () => tenant.setIsGatewayConnected(true),
      ),
    );
  }
  return pageLayoutComponent(
    activePath: '/jobs',
    title: 'Jobs',
    subtitle: 'Individual task executions across all workflows',
    body: div(
      children: [
        if (notice != null)
          div(
            key: 'notice',
            className: 'mb-3 rounded-md bg-primary/10 p-3 text-sm text-primary',
            children: [Text(notice)],
          ),
        div(
          key: 'search-controls',
          className: 'mb-4 flex items-center justify-between gap-3',
          children: [
            uiInput(
              value: table.search,
              placeholder: 'Search jobs...',
              onChanged: (event) =>
                  table.setSearch((event.target as HTMLInputElement).value),
              className: 'max-w-md flex-1',
            ),
            uiButton(
              label: '↻ Refresh',
              variant: UiButtonVariant.ghost,
              onPressed: (_) => setNotice('Jobs refreshed.'),
            ),
          ],
        ),
        div(
          key: 'jobs-table',
          className: 'overflow-hidden rounded-xl border border-border bg-card',
          children: [
            uiTable(
              key: 'table',
              children: [
                uiTableHeader(
                  key: 'header',
                  children: [
                    uiTableRow(
                      children: [
                        dataTableHeader(
                          label: 'Job ID',
                          sortKey: 'id',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        dataTableHeader(
                          label: 'Name',
                          sortKey: 'name',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        uiTableHead('Status'),
                        uiTableHead('Duration'),
                        dataTableHeader(
                          label: 'Retries',
                          sortKey: 'retries',
                          sortConfig: table.sortConfig,
                          onSort: table.toggleSort,
                        ),
                        uiTableHead('Started'),
                        uiTableHead('Workflow'),
                      ],
                    ),
                  ],
                ),
                uiTableBody(
                  key: 'body',
                  children: [
                    for (final job in table.paginatedData)
                      uiTableRow(
                        key: job.id,
                        children: [
                          uiTableCell(children: [Text(job.id)]),
                          uiTableCell(children: [Text(job.name)]),
                          uiTableCell(
                            children: [statusBadgeComponent(job.status)],
                          ),
                          uiTableCell(children: [Text(job.duration)]),
                          uiTableCell(children: [Text('${job.retries}')]),
                          uiTableCell(
                            children: [
                              Text(formatDate(job.startedAt.toIso8601String())),
                            ],
                          ),
                          uiTableCell(
                            children: [Text(job.workflowId ?? 'Standalone')],
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            dataTablePagination(
              key: 'pagination',
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
