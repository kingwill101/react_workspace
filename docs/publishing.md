# Publishing React Dart packages

This repository is a workspace containing the React Dart runtime, server,
tooling, testing, and integration packages. Firehose is the source of truth
for package publication validation and GitHub Actions publishing.

## Initial publish wave

The first publish wave contains the portable runtime foundation:

| Package | Role |
| --- | --- |
| `react_core` | Platform-agnostic React nodes, components, hooks, refs, and callbacks |
| `react_actions` | Browser-safe server-function protocol and invocation types |
| `react_js` | JavaScript React runtime and renderer bindings |
| `react_web` | Web API types, DOM factories, and browser adapters |
| `react_dom` | React DOM mounting and hydration APIs |
| `react_server` | Transport-neutral SSR and server-function primitives |
| `react_server_shelf` | Shelf transport integration for React Dart servers |

These packages are the smallest useful foundation. `react_server_routed` remains
a separate integration and is intentionally not part of this wave.
`react_server_shelf` is included because its dependencies are already available
from pub.dev.

The following packages are currently deferred because they are tooling,
testing, framework integrations, or still experimental:

`react_analyzer`, `react_codegen`, `react_router`, `react_server_routed`,
`react_testing`, `react_web_generator`, and `react_zustand`.

`react_bloc` and `react_riverpod` are the first state-management integration
wave. They are pure-Dart wrappers over the portable React context and external
store APIs, so they do not add browser or server transport dependencies.

`react_analysis` and `react_tool` are the next tooling wave. Publish
`react_analysis` before `react_tool`, because the CLI depends on its analyzer
engine. The CLI's Rust/Oxc native asset is released separately through the
`react_tool native prebuilts` workflow.

Other deferred packages currently declare `publish_to: none`. To prepare one for a
future release, remove that marker, add it to the approved publish set, and
complete a separate readiness review.

## Firehose workflows

`.github/workflows/health.yaml` runs Firehose PR health checks. It checks only
the initial publish wave and ignores deferred packages.

`.github/workflows/publish.yaml` runs Firehose’s package dry-run on pull
requests and publishes a package when a matching package tag is pushed. In a
monorepo, tags use this form:

```text
<package_name>-v<version>
```

For example:

```text
react_core-v0.1.0
```

Firehose detects the package from the tag and publishes that package only.
Each package’s `CHANGELOG.md` version must match its `pubspec.yaml` version.

## Before enabling publication

From each package’s pub.dev admin page, enable publishing from GitHub Actions.
The workflow requests the `id-token: write` permission required for pub.dev’s
trusted-publishing flow. Configure the GitHub repository and workflow as a
trusted publisher for every package in the initial wave.

Run the same checks locally before opening a release PR:

```bash
dart pub global activate --source git \
  https://github.com/dart-lang/ecosystem --git-path pkgs/firehose
dart pub global run firehose:health
```

For a package archive check, run `dart pub publish --dry-run` from the package
directory. Workspace resolution is useful during development, but the final
package archive must resolve its dependencies from pub.dev.

## Release procedure

1. Add the release entry to the package changelog and make sure its version is
   stable and matches the changelog heading.
2. Merge the release PR after Firehose health and publish validation pass.
3. Create a GitHub release or push a tag such as `react_core-v0.1.0` at the
   merged commit.
4. Confirm the Firehose publish workflow and the package page on pub.dev.
5. Publish dependent packages in dependency order when releasing several
   packages: core primitives first, then adapters and higher-level packages.

Do not tag deferred packages until they are removed from `publish_to: none`
and have their own release readiness review.
