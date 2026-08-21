# react_analyzer

The IDE and `dart analyze` plugin for React Dart. It exposes the shared
`react_analysis` rules through `analysis_server_plugin` and adds React-specific
quick fixes and assists.

## Enable the plugin

After `react_analyzer` and `react_analysis` are available from your configured
package source, add this top-level section to `analysis_options.yaml`:

```yaml
plugins:
  react_analyzer: ^0.1.0
```

For local development, `analysis_server_plugin` also accepts an absolute path:

```yaml
plugins:
  react_analyzer:
    path: /absolute/path/to/react_workspace/packages/react_analyzer
```

The plugin host resolves the plugin as its own package. A relative workspace
path is therefore not portable. Restart the Dart analysis server after changing
plugin configuration.

This workspace currently validates the plugin engine directly until the
interdependent packages are published. The version-based configuration above
is the consumer setup, not a claim that the packages are being published now.

## Diagnostics

| Rule | Detects |
| --- | --- |
| `invalid_react_component` | unsupported component signatures and props |
| `invalid_hook_call` | hooks outside components, in branches or loops, or after an early return |
| `browser_api_during_ssr` | browser-only APIs used while rendering on the server |
| `js_interop_in_server` | direct JS interop in server code |
| `browser_import_in_server` | browser package imports crossing into server code |
| `generated_bridge_import` | handwritten imports of generated implementation files |

Available edits include adding `@ClientOnly`, replacing a generated bridge
import with its public API, and converting a function to a React component.

## Workspace validation

From the repository root:

```bash
dart analyze packages/react_analyzer --fatal-infos
dart test packages/react_analyzer
dart test packages/react_analysis
dart test examples/plugin_validation
```

The direct engine and fixture tests remain authoritative when local plugin
activation cannot resolve an unpublished workspace dependency.
