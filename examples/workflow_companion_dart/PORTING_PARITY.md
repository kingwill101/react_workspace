# Workflow Companion port parity

This example is a Dart/React port of the reference application at
`/home/kingwill101/code/dart_packages/stem/stem_cloud/workflow-companion`.
The reference was observed at commit `626bbbb2eed0642f428ae2200b753e2322b3b404`
on 2026-08-31. The reference checkout has an unrelated `package-lock.json`
change; it is not modified by this port.

## Success criteria

The port is complete when every reference route and primary interaction works
from Dart, the release build and the native React test harness pass, and at
least 80% of the reference authored executable source is represented by Dart
source. The parity percentage is based on source lines, not generated output:

```text
translated Dart source lines / 13,268 reference TypeScript/TSX lines
```

Foreign wrappers are allowed for external runtime islands (Lucide, Radix,
charts, date picker), but the application state, route map, page composition,
forms, and interaction logic must be Dart-owned.

## Reference inventory

| Area | Reference files | Reference lines | Dart status |
| --- | ---: | ---: | --- |
| Pages | 19 | 5,221 | Dart page modules cover every reference route |
| App components | 19 | 2,234 | Dart-owned shell, tables, dialogs, indicators, and cards |
| UI primitives | 49 | 3,954 | portable Dart equivalents with native browser semantics |
| Models, data, contexts, hooks, entrypoints, CSS | 17 | 1,859 | split into typed Dart models, data, hooks, and entrypoints |
| **Total** | **104** | **13,268** | **10,704 Dart lines / 80.7%** |

## Route parity

| Reference path | Dart target | Primary interaction |
| --- | --- | --- |
| `/` | `pages/landing.dart` | sign-up/demo navigation |
| `/dashboard` | `pages/dashboard.dart` | refresh, filter, new workflow |
| `/signin` | `pages/auth.dart` | sign-in form |
| `/signup` | `pages/auth.dart` | sign-up form |
| `/onboarding` | `pages/onboarding.dart` | finish onboarding |
| `/workflows` | `pages/workflows.dart` | open workflow, create workflow |
| `/workflows/:id` | `pages/details.dart` | run workflow, inspect executions |
| `/jobs` | `pages/jobs.dart` | search and sort jobs |
| `/jobs/:id` | `pages/details.dart` | retry/revoke job |
| `/tasks` | `pages/operations.dart` | task status filtering |
| `/queues` | `pages/operations.dart` | pause/drain queue |
| `/workers` | `pages/operations.dart` | worker inspection |
| `/dead-letters` | `pages/operations.dart` | requeue/delete dead letter |
| `/executions` | `pages/operations.dart` | execution filtering |
| `/schedules` | `pages/schedules.dart` | enable/disable schedule, create schedule |
| `/alerts` | `pages/alerts.dart` | acknowledge alert |
| `/settings` | `pages/settings.dart` | tenant, members, API keys, settings |
| `/billing` | `pages/billing.dart` | plan/upgrade action |
| `*` | `pages/not_found.dart` | return to dashboard |

## Incremental work order

1. Scaffold and preserve the reference style/assets (complete).
2. Port models, mock data, tenant/theme state, and reusable table/filter
   behavior (complete).
3. Port the dashboard shell and all route pages (complete).
4. Port forms, dialogs, and operation actions one file at a time, keeping
   state in Dart hooks (complete for this reference snapshot).
5. Add foreign wrappers only for external components that cannot be expressed
   by `react_dom`; record each wrapper and its bundle entry.
6. Add native component and route/integration tests, then verify debug and
   release assets with `react_tool` (component tests complete; build gate is
   rerun with each parity change).
7. Recount source lines, close every route/interaction row, and document any
   remaining intentional foreign island before claiming 80% (line threshold
   met; final browser smoke coverage remains).

## File translation ledger

- `src/App.tsx` and `src/main.tsx` are `lib/react/app.dart`,
  `lib/react/app_shell.dart`, and `web/client.dart`. Generated wrappers are
  not counted as authored parity source.
- `src/pages/` is split into one Dart module per page family. The five Celery
  operation pages share `lib/pages/operations.dart` because their data-table
  and live-refresh behavior is the same reusable Dart implementation.
- `src/types/` and the three mock-data files are translated to typed files in
  `lib/models/` and `lib/data/`. `schedule_catalog.dart` holds the reference
  cron, timezone, and solar selector catalog.
- The reference Radix wrappers are represented by portable controlled
  primitives in `lib/components/ui/`. Calendar, carousel, command palette,
  form, layout, selection, pagination, and toast surfaces are Dart-owned;
  pages control their state through Dart callbacks.
- `lucide-react` icons are represented by stable text glyphs in this example.
  This keeps SSR, VM tests, and browser builds independent of a foreign icon
  runtime while preserving the information and interaction affordance.
- `vite-env.d.ts` has no runtime behavior and therefore has no Dart file.

Generated files under `lib/.generated/` and `build/react/` are implementation
artifacts and are not parity credit.
