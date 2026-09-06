import 'package:react_dom/react_dom.dart';

import '../components/page_layout.dart';
import '../components/ui/button.dart';
import '../components/ui/card.dart';
import '../components/ui/controls.dart';
import '../contexts/tenant_context.dart';

final class _UsageRow {
  const _UsageRow(this.name, this.used, this.limit, this.unit);

  final String name;
  final double used;
  final double limit;
  final String unit;
}

const _usage = <_UsageRow>[
  _UsageRow('Workflow Executions', 8420, 10000, 'runs'),
  _UsageRow('Compute Time', 156, 200, 'hours'),
  _UsageRow('API Calls', 45230, 100000, 'calls'),
  _UsageRow('Storage', 2.4, 10, 'GB'),
];

/// Billing and usage page. Payment operations remain intentionally mocked.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode BillingPage(({String? scope}) props) {
  final tenant = useTenant();
  final (notice, setNotice) = useState<String?>(null);
  return pageLayoutComponent(
    activePath: '/billing',
    title: 'Billing & Usage',
    subtitle: 'Manage your subscription, credits, and usage',
    body: div(
      className: 'mx-auto max-w-4xl space-y-8',
      children: [
        if (notice != null)
          div(
            className: 'rounded-md bg-primary/10 p-3 text-sm text-primary',
            children: [Text(notice)],
          ),
        uiCard(
          children: [
            uiCardHeader(
              children: [
                div(
                  className: 'flex items-center justify-between',
                  children: [
                    div(
                      children: [
                        h2(
                          className: 'text-lg font-semibold',
                          children: const [Text('Current Plan')],
                        ),
                        p(
                          className: 'text-sm text-muted-foreground',
                          children: const [Text('Your subscription details')],
                        ),
                      ],
                    ),
                    uiButton(
                      label: 'Change Plan',
                      variant: UiButtonVariant.outline,
                      onPressed: (_) => setNotice('Plan selection opened.'),
                    ),
                  ],
                ),
              ],
            ),
            uiCardContent(
              children: [
                div(
                  className: 'grid grid-cols-1 gap-4 md:grid-cols-3',
                  children: [
                    _planValue('Plan', 'Pro', '\$99/month'),
                    _planValue(
                      'Billing Cycle',
                      'Monthly',
                      'Renews Feb 1, 2025',
                    ),
                    _planValue('Status', 'Active', 'Since Jan 2024'),
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
                div(
                  className: 'flex items-center justify-between',
                  children: [
                    div(
                      children: [
                        h2(
                          className: 'text-lg font-semibold',
                          children: const [Text('Credits')],
                        ),
                        p(
                          className: 'text-sm text-muted-foreground',
                          children: const [Text('Available workflow credits')],
                        ),
                      ],
                    ),
                    uiButton(
                      label: 'Buy Credits',
                      onPressed: (_) => setNotice('Credit purchase opened.'),
                    ),
                  ],
                ),
              ],
            ),
            uiCardContent(
              children: [
                div(
                  className: 'flex items-end gap-2',
                  children: [
                    span(
                      className: 'text-4xl font-bold',
                      children: const [Text('1,580')],
                    ),
                    span(
                      className: 'mb-1 text-muted-foreground',
                      children: const [Text('credits remaining')],
                    ),
                  ],
                ),
                uiProgress(value: 80, className: 'mt-3', showLabel: true),
                p(
                  className: 'mt-2 text-sm text-muted-foreground',
                  children: const [
                    Text('420 credits used this billing period'),
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
                  children: const [Text('Usage This Month')],
                ),
                p(
                  className: 'text-sm text-muted-foreground',
                  children: const [Text('Current billing period usage')],
                ),
              ],
            ),
            uiCardContent(
              children: [
                div(
                  className: 'space-y-4',
                  children: [
                    for (final item in _usage)
                      div(
                        key: item.name,
                        children: [
                          div(
                            className: 'mb-2 flex items-center justify-between text-sm',
                            children: [
                              span(
                                className: 'font-medium',
                                children: [Text(item.name)],
                              ),
                              span(
                                className: 'text-muted-foreground',
                                children: [
                                  Text(
                                    '${item.used}/${item.limit} ${item.unit}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          uiProgress(value: item.used / item.limit * 100),
                        ],
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
                div(
                  className: 'flex items-center justify-between',
                  children: [
                    div(
                      children: [
                        h2(
                          className: 'text-lg font-semibold',
                          children: const [Text('Payment Method')],
                        ),
                        p(
                          className: 'text-sm text-muted-foreground',
                          children: const [Text('Manage your payment details')],
                        ),
                      ],
                    ),
                    uiButton(
                      label: 'Update',
                      variant: UiButtonVariant.outline,
                      onPressed: (_) =>
                          setNotice('Payment method editor opened.'),
                    ),
                  ],
                ),
              ],
            ),
            uiCardContent(
              children: [
                div(
                  className: 'flex items-center justify-between rounded-lg bg-muted/50 p-4',
                  children: [
                    div(
                      children: [
                        p(
                          className: 'font-medium',
                          children: const [Text('•••• •••• •••• 4242')],
                        ),
                        p(
                          className: 'text-sm text-muted-foreground',
                          children: const [Text('Expires 12/2026')],
                        ),
                      ],
                    ),
                    span(
                      className: 'rounded bg-success/10 px-2 py-1 text-xs text-success',
                      children: const [Text('Default')],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        if (!tenant.isGatewayConnected)
          p(
            className: 'text-xs text-muted-foreground',
            children: const [
              Text('Billing data is shown from the local demo tenant.'),
            ],
          ),
      ],
    ),
  );
}

ReactNode _planValue(String label, String value, String detail) => div(
  className: 'rounded-lg bg-muted/50 p-4',
  children: [
    p(className: 'mb-1 text-sm text-muted-foreground', children: [Text(label)]),
    p(className: 'text-xl font-bold', children: [Text(value)]),
    p(className: 'mt-1 text-xs text-primary', children: [Text(detail)]),
  ],
);
