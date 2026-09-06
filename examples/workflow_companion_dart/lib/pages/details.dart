import 'package:react_dom/react_dom.dart';

import '../components/page_layout.dart';
import '../components/status_badge.dart';
import '../components/ui/button.dart';
import '../components/ui/card.dart';
import '../data/mock_data.dart';
import '../models/workflow.dart';
import '../router.dart' as router;
import '../utils.dart';

/// Resolves the workflow id captured by `/workflows/:id`.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode WorkflowDetailRoute(({String? scope}) props) {
  final params = router.useParams();
  return WorkflowDetailPage((id: params['id'] ?? workflows.first.id));
}

ReactNode _detailValue(String label, String value) => div(
  className: 'rounded-lg bg-secondary/50 p-3',
  children: [
    p(className: 'mb-1 text-xs text-muted-foreground', children: [Text(label)]),
    p(className: 'font-semibold', children: [Text(value)]),
  ],
);

/// Workflow detail route with step and execution history.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode WorkflowDetailPage(({String id}) props) {
  final (notice, setNotice) = useState<String?>(null);
  final workflow = getWorkflowById(props.id);
  if (workflow == null) {
    return pageLayoutComponent(
      activePath: '/workflows',
      title: 'Workflow Not Found',
      subtitle: 'The requested workflow does not exist',
      body: _notFoundBody('workflow'),
    );
  }
  final completedSteps = workflow.steps
      .where((step) => step.status == JobStatus.completed)
      .length;
  return pageLayoutComponent(
    activePath: '/workflows',
    title: workflow.name,
    subtitle: 'Workflow definition and execution history',
    body: div(
      children: [
        if (notice != null)
          div(
            className: 'mb-3 rounded-md bg-primary/10 p-3 text-sm text-primary',
            children: [Text(notice)],
          ),
        div(
          className: 'mb-4 flex flex-wrap items-start justify-between gap-3',
          children: [
            div(
              children: [
                statusBadgeComponent(workflow.status),
                p(
                  className: 'mt-2 font-mono text-xs text-muted-foreground',
                  children: [Text(workflow.id)],
                ),
              ],
            ),
            div(
              className: 'flex gap-2',
              children: [
                uiButton(
                  label: 'Pause',
                  variant: UiButtonVariant.ghost,
                  onPressed: (_) => setNotice('Workflow paused.'),
                ),
                uiButton(
                  label: '↻ Retry',
                  variant: UiButtonVariant.outline,
                  onPressed: (_) => setNotice('Workflow retry requested.'),
                ),
                uiButton(
                  label: '▶ Run Now',
                  onPressed: (_) => setNotice('Workflow run queued.'),
                ),
              ],
            ),
          ],
        ),
        uiCard(
          children: [
            uiCardHeader(
              children: [
                h2(
                  className: 'text-lg font-semibold',
                  children: const [Text('Overview')],
                ),
              ],
            ),
            uiCardContent(
              children: [
                if (workflow.description != null)
                  p(
                    className: 'mb-4 text-muted-foreground',
                    children: [Text(workflow.description ?? '')],
                  ),
                div(
                  className: 'grid grid-cols-2 gap-4 md:grid-cols-4',
                  children: [
                    _detailValue('Duration', workflow.duration),
                    _detailValue('Retries', '${workflow.retries}'),
                    _detailValue('Last Run', workflow.lastRun),
                    _detailValue(
                      'Progress',
                      '$completedSteps/${workflow.steps.length} steps',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        uiCard(
          children: [
            uiCardHeader(
              children: [
                h2(
                  className: 'text-lg font-semibold',
                  children: const [Text('Steps')],
                ),
              ],
            ),
            uiCardContent(
              children: [
                div(
                  className: 'space-y-2',
                  children: [
                    for (final step in workflow.steps)
                      _workflowStep(
                        step,
                        onSelect: () => setNotice('Selected ${step.jobId}'),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
        uiCard(
          children: [
            uiCardHeader(
              children: [
                h2(
                  className: 'text-lg font-semibold',
                  children: const [Text('Execution History')],
                ),
              ],
            ),
            uiCardContent(
              children: [
                if (workflow.history.isEmpty)
                  p(
                    className: 'text-sm text-muted-foreground',
                    children: const [Text('No execution history available.')],
                  )
                else
                  div(
                    className: 'space-y-2',
                    children: [
                      for (final execution in workflow.history)
                        div(
                          key: execution.id,
                          className: 'flex items-center gap-4 rounded-lg border border-border p-4',
                          children: [
                            statusBadgeComponent(execution.status),
                            div(
                              className: 'flex-1',
                              children: [
                                p(
                                  className: 'font-mono text-sm',
                                  children: [Text(execution.id)],
                                ),
                                p(
                                  className: 'text-xs text-muted-foreground',
                                  children: [Text(execution.timestamp)],
                                ),
                              ],
                            ),
                            Text(execution.duration),
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

ReactNode _workflowStep(
  WorkflowStep step, {
  required void Function() onSelect,
}) => div(
  className: 'flex cursor-pointer items-center gap-4 rounded-lg border border-border p-4 transition-colors hover:bg-secondary/30',
  onClick: (_) => onSelect(),
  children: [
    div(
      className: 'flex h-8 w-8 items-center justify-center rounded-full bg-muted text-sm font-medium',
      children: [Text('${step.order}')],
    ),
    div(
      className: 'flex-1',
      children: [
        p(className: 'font-medium', children: [Text(step.name)]),
        p(
          className: 'font-mono text-xs text-muted-foreground',
          children: [Text(step.jobId)],
        ),
      ],
    ),
    Text(step.duration),
    statusBadgeComponent(step.status),
  ],
);

/// Job detail route showing timing, workflow relation, and serialized data.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode JobDetailPage(({String id}) props) {
  final (notice, setNotice) = useState<String?>(null);
  final job = getJobById(props.id);
  if (job == null) {
    return pageLayoutComponent(
      activePath: '/jobs',
      title: 'Job Not Found',
      subtitle: 'The requested job does not exist',
      body: _notFoundBody('job'),
    );
  }
  return pageLayoutComponent(
    activePath: '/jobs',
    title: job.name,
    subtitle: 'Individual task execution details',
    body: div(
      children: [
        if (notice != null)
          div(
            className: 'mb-3 rounded-md bg-primary/10 p-3 text-sm text-primary',
            children: [Text(notice)],
          ),
        div(
          className: 'mb-4 flex flex-wrap items-center justify-between gap-3',
          children: [
            div(
              children: [
                statusBadgeComponent(job.status),
                p(
                  className: 'mt-2 font-mono text-xs text-muted-foreground',
                  children: [Text(job.id)],
                ),
              ],
            ),
            div(
              className: 'flex gap-2',
              children: [
                uiButton(
                  label: '↻ Retry',
                  variant: UiButtonVariant.outline,
                  onPressed: (_) => setNotice('Retry requested.'),
                ),
                uiButton(
                  label: '▶ Run Again',
                  onPressed: (_) => setNotice('Job queued to run again.'),
                ),
              ],
            ),
          ],
        ),
        uiCard(
          children: [
            uiCardHeader(
              children: [
                h2(
                  className: 'text-lg font-semibold',
                  children: const [Text('Overview')],
                ),
              ],
            ),
            uiCardContent(
              children: [
                div(
                  className: 'grid grid-cols-2 gap-4 md:grid-cols-4',
                  children: [
                    _detailValue('Duration', job.duration),
                    _detailValue('Retries', '${job.retries}'),
                    _detailValue(
                      'Started',
                      formatDate(job.startedAt.toIso8601String()),
                    ),
                    _detailValue(
                      'Completed',
                      job.completedAt == null
                          ? '—'
                          : formatDate(job.completedAt!.toIso8601String()),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        if (job.workflowId != null)
          uiCard(
            children: [
              uiCardHeader(
                children: [
                  h2(
                    className: 'text-lg font-semibold',
                    children: const [Text('Part of Workflow')],
                  ),
                ],
              ),
              uiCardContent(
                children: [
                  p(
                    className: 'font-mono text-sm text-primary',
                    children: [Text(job.workflowId ?? '')],
                  ),
                ],
              ),
            ],
          ),
        if (job.error != null)
          uiCard(
            className: 'border-destructive/30 bg-destructive/10',
            children: [
              uiCardHeader(
                children: [
                  h2(
                    className: 'text-lg font-semibold text-destructive',
                    children: const [Text('Error')],
                  ),
                ],
              ),
              uiCardContent(
                children: [
                  pre(
                    className: 'whitespace-pre-wrap font-mono text-sm text-destructive/90',
                    children: [Text(job.error ?? '')],
                  ),
                ],
              ),
            ],
          ),
        _jsonCard('Input', job.input),
        _jsonCard('Output', job.output),
      ],
    ),
  );
}

/// Resolves the job id captured by `/jobs/:id`.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode JobDetailRoute(({String? scope}) props) {
  final params = router.useParams();
  return JobDetailPage((id: params['id'] ?? jobs.first.id));
}

ReactNode _jsonCard(String title, Map<String, Object?>? value) => uiCard(
  children: [
    uiCardHeader(
      children: [
        h2(className: 'text-lg font-semibold', children: [Text(title)]),
      ],
    ),
    uiCardContent(
      children: [
        pre(
          className: 'overflow-auto rounded-lg bg-secondary/50 p-4 font-mono text-sm text-muted-foreground',
          children: [
            Text(
              value == null
                  ? '{\n  "message": "No $title data"\n}'
                  : value.entries
                        .map((entry) => '"${entry.key}": "${entry.value}"')
                        .join('\n'),
            ),
          ],
        ),
      ],
    ),
  ],
);

ReactNode _notFoundBody(String kind) => div(
  className: 'flex min-h-[40vh] items-center justify-center',
  children: [
    div(
      className: 'text-center',
      children: [
        h2(
          className: 'mb-2 text-2xl font-semibold',
          children: [
            Text('${kind[0].toUpperCase()}${kind.substring(1)} Not Found'),
          ],
        ),
        p(
          className: 'text-muted-foreground',
          children: [Text('The $kind you are looking for does not exist.')],
        ),
      ],
    ),
  ],
);
