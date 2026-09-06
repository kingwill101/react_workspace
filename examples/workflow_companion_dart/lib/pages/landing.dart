import 'package:react_dom/react_dom.dart';

import '../router.dart' as router;
import '../utils.dart';

/// Public landing page for the Workflow Companion demo.
///
/// The page deliberately keeps navigation as ordinary links. That makes the
/// same component usable in the browser, in SSR output, and in the native
/// component harness without requiring a browser-only navigation hook.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode LandingPage(({String? scope}) props) => div(
  className: 'min-h-screen bg-background',
  children: [
    nav(
      className: 'sticky top-0 z-50 border-b border-border bg-background/80 backdrop-blur-sm',
      children: [
        div(
          className:
              'container mx-auto flex h-16 items-center justify-between px-6',
          children: [
            div(
              className: 'flex items-center gap-2',
              children: [
                div(
                  className: 'flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary',
                  children: const [Text('✦')],
                ),
                span(
                  className: 'text-xl font-bold',
                  children: const [Text('StemCloud')],
                ),
              ],
            ),
            div(
              className: 'hidden items-center gap-8 md:flex',
              children: [
                _landingAnchor('#features', 'Features'),
                _landingAnchor('#code', 'Quick Start'),
                a(
                  target: '_blank',
                  additionalProps: {'href': 'https://pub.dev'},
                  className:
                      'text-sm text-muted-foreground hover:text-foreground',
                  children: const [Text('Docs')],
                ),
                a(
                  target: '_blank',
                  additionalProps: {'href': 'https://github.com'},
                  className:
                      'text-sm text-muted-foreground hover:text-foreground',
                  children: const [Text('GitHub')],
                ),
              ],
            ),
            div(
              className: 'flex items-center gap-3',
              children: [
                _landingNavButton('/signin', 'Sign In', ghost: true),
                _landingNavButton('/signup', 'Get Started'),
              ],
            ),
          ],
        ),
      ],
    ),
    section(
      className: 'relative overflow-hidden',
      children: [
        div(
          className: 'pointer-events-none absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-transparent',
          children: const [],
        ),
        div(
          className: 'container relative mx-auto px-6 pb-32 pt-20',
          children: [
            div(
              className: 'mx-auto max-w-4xl text-center',
              children: [
                span(
                  className: 'mb-6 inline-flex rounded-full bg-secondary px-4 py-1.5 text-sm text-secondary-foreground',
                  children: const [Text('◈  Dart-Native Background Jobs')],
                ),
                h1(
                  className: 'mb-6 text-4xl font-bold tracking-tight md:text-6xl lg:text-7xl',
                  children: [
                    const Text('Background jobs for '),
                    span(
                      className: 'text-primary',
                      children: const [Text('Dart')],
                    ),
                    const Text(' developers'),
                  ],
                ),
                p(
                  className: 'mx-auto mb-10 max-w-2xl text-lg text-muted-foreground md:text-xl',
                  children: const [
                    Text(
                      'Stem is a Dart-native background job platform. Celery-style task execution, Redis Streams, retries, scheduling, and observability—all without leaving the Dart ecosystem.',
                    ),
                  ],
                ),
                div(
                  className: 'flex flex-col items-center justify-center gap-4 sm:flex-row',
                  children: [
                    _landingNavButton(
                      '/signup',
                      'Start for Free  →',
                      large: true,
                    ),
                    _landingNavButton(
                      '/dashboard',
                      '▶  View Demo Dashboard',
                      ghost: true,
                      large: true,
                    ),
                  ],
                ),
                div(
                  className: 'mt-12 flex flex-wrap items-center justify-center gap-8 text-sm text-muted-foreground',
                  children: const [
                    Text('✓  No credit card required'),
                    Text('✓  10K free tasks/month'),
                    Text('✓  Open source SDK'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    section(
      id: 'features',
      className: 'bg-muted/30 py-24',
      children: [
        div(
          className: 'container mx-auto px-6',
          children: [
            _landingSectionIntro(
              title: 'Everything you need for background processing',
              description: 'Production-ready infrastructure for Dart applications, with the features you would expect from enterprise job systems.',
            ),
            div(
              className: 'grid gap-6 md:grid-cols-2 lg:grid-cols-3',
              children: [
                for (final feature in _features)
                  div(
                    key: feature.title,
                    className: 'rounded-xl border border-border bg-card p-6 transition-colors hover:border-primary/50',
                    children: [
                      div(
                        className: 'mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10 text-2xl text-primary',
                        children: [Text(feature.glyph)],
                      ),
                      h3(
                        className: 'mb-2 text-lg font-semibold',
                        children: [Text(feature.title)],
                      ),
                      p(
                        className:
                            'text-sm leading-relaxed text-muted-foreground',
                        children: [Text(feature.description)],
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ],
    ),
    section(
      id: 'code',
      className: 'py-24',
      children: [
        div(
          className: 'container mx-auto px-6',
          children: [
            _landingSectionIntro(
              title: 'A beautiful Dart-first API',
              description: 'Define tasks as classes, dispatch with type safety, and run workers with a few lines of code.',
            ),
            div(
              className: 'mx-auto grid max-w-6xl gap-6 lg:grid-cols-2',
              children: [
                _codePanel(title: 'Define and dispatch', source: _taskExample),
                _codePanel(title: 'Run a worker', source: _workerExample),
              ],
            ),
          ],
        ),
      ],
    ),
    section(
      className: 'border-t border-border bg-muted/30 py-20',
      children: [
        div(
          className: 'container mx-auto px-6 text-center',
          children: [
            h2(
              className: 'mb-4 text-3xl font-bold',
              children: const [Text('Ready to ship reliable background work?')],
            ),
            p(
              className: 'mx-auto mb-8 max-w-2xl text-muted-foreground',
              children: const [
                Text('Start with the demo, then connect your own gateway.'),
              ],
            ),
            _landingNavButton('/signup', 'Create an account', large: true),
          ],
        ),
      ],
    ),
  ],
);

ReactNode _landingAnchor(String href, String label) => a(
  additionalProps: {'href': href},
  className: 'text-sm text-muted-foreground hover:text-foreground',
  children: [Text(label)],
);

ReactNode _landingNavButton(
  String to,
  String label, {
  bool ghost = false,
  bool large = false,
}) => router.navLink(
  to: to,
  className: cn([
    'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors',
    'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
    ghost
        ? 'border border-input bg-background px-4 hover:bg-accent hover:text-accent-foreground'
        : 'bg-primary px-4 text-primary-foreground shadow hover:bg-primary/90',
    large ? 'h-11 px-8 text-base' : 'h-10',
  ]),
  children: [Text(label)],
);

ReactNode _landingSectionIntro({
  required String title,
  required String description,
}) => div(
  className: 'mb-16 text-center',
  children: [
    h2(
      className: 'mb-4 text-3xl font-bold md:text-4xl',
      children: [Text(title)],
    ),
    p(
      className: 'mx-auto max-w-2xl text-lg text-muted-foreground',
      children: [Text(description)],
    ),
  ],
);

ReactNode _codePanel({required String title, required String source}) => div(
  className: 'overflow-hidden rounded-xl border border-border bg-card',
  children: [
    div(
      className: 'border-b border-border px-4 py-3 text-sm font-medium',
      children: [Text(title)],
    ),
    pre(
      className: 'overflow-auto bg-slate-950 p-5 text-left text-xs leading-6 text-slate-100',
      children: [
        code(children: [Text(source)]),
      ],
    ),
  ],
);

final _features = <({String glyph, String title, String description})>[
  (
    glyph: '◈',
    title: 'Celery-style Task Execution',
    description: "Familiar patterns for defining and dispatching background tasks, optimized for Dart's async/await model.",
  ),
  (
    glyph: '▱',
    title: 'Redis Streams Integration',
    description: 'Reliable message delivery, automatic consumer groups, and at-least-once semantics.',
  ),
  (
    glyph: '↻',
    title: 'Automatic Retries',
    description: 'Configurable retry policies with exponential backoff, dead letter queues, and failure callbacks.',
  ),
  (
    glyph: '◷',
    title: 'Flexible Scheduling',
    description: 'Cron expressions, solar events, and webhook triggers for any time or event.',
  ),
  (
    glyph: '◉',
    title: 'Full Observability',
    description: 'Real-time dashboards, execution traces, worker health metrics, and alerting built-in.',
  ),
  (
    glyph: '⌁',
    title: 'Security Tooling',
    description: 'API key management, namespace isolation, and encrypted transport for production workloads.',
  ),
];

const _taskExample = '''import 'package:stem/stem.dart';

@StemTask()
class SendEmailTask extends Task<void> {
  @override
  Future<void> run(Map<String, dynamic> args) async {
    await emailService.send(
      to: args['email'] as String,
      template: args['template'] as String,
    );
  }
}

await stem.dispatch(
  SendEmailTask(),
  args: {'email': 'user@example.com', 'template': 'welcome'},
  queue: 'emails',
  retries: 3,
);''';

const _workerExample = '''import 'package:stem/stem.dart';

final worker = Worker(
  broker: StemCloudBroker(
    transport: WebSocketWorkerTransport(
      uri: config.wsUri,
      headers: {'Authorization': 'Bearer <api-key>'},
    ),
  ),
  registry: registry..register(SendEmailTask()),
);

await worker.start();''';
