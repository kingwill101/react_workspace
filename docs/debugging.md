# Debugging React Dart

Start one development session from the application directory:

```sh
dart run react_tool:react serve --debug
```

For full-stack Node SSR applications, this starts the SSR worker, a VM-debuggable
Dart application, webdev/DDC with DWDS, and a loopback gateway. Pages and actions
go to the application; DDC modules, source maps, and debugger connections go to
webdev. The application keeps rendering SSR and injecting its own initial props.
Internal ports are allocated automatically; `--port` selects the public gateway.

For filesystems where native change notifications are unreliable, add `--poll`:

```sh
dart run react_tool:react serve --debug --poll
```

Polling is opt-in and increases filesystem activity, including for local path
dependencies. It requires a matching `react_codegen` with the polling capability;
the CLI checks the resolved generator before starting. Until that generator is
published, use matching local `--packages` dependencies. Native watching remains
the default. Add `--poll` to the generated VS Code task if your filesystem needs it.

New scaffolds include a VS Code **React: debug session** task. Run that task,
wait for the application to load, and press **Alt+D** (**Option+D** on macOS)
inside the page. Webdev starts its browser debug service on that command and
prints the DWDS VM service URI; it is not printed merely by starting the server.
See the [Dart web debugging guide](https://dart.dev/web/debugging).
Then choose **React: attach full stack** (or **React: attach browser** for a
client-only app) and paste that URI when prompted. The server
attachment reads `.dart_tool/react/server_vm_service.json` automatically. This
uses the Dart extension's standard attach configuration; see
[Dart Code launch configuration](https://dartcode.org/docs/launch-configuration/).

Use `--no-launch-browser --chrome-debug-port <port>` when an IDE or remote
environment manages an existing Chrome instance with remote debugging enabled.
Stop the CLI session with Ctrl-C to stop its children and restore the normal
HTML templates. Debug sessions temporarily stage DDC templates in `web/index.html`
and the build output; do not edit these templates during a session.

DDC rebuilds browser changes and refreshes the page automatically; the complete
end-to-end gate passes using `--poll`. Server and SSR source changes require
restarting the session; `--watch` is not combined with `--debug`. A full page
reload reruns SSR and resets browser-local state. Do not assume React state
preservation from DDC reload support alone.

The gateway has native HTTP/WebSocket coverage. The real-browser gate has
verified hydration, actions, server and browser Dart breakpoints, manual and
automatic refresh, template restoration, and closed service ports. Webdev's SDK
discovery uses the same SDK as the running CLI instead of a PATH wrapper. The
FVM SDK-outline warning is resolved, but some `.ddc.dill` connection resets
remain in webdev output. Expression evaluation is not covered by the breakpoint
evidence. A heavily loaded-host run timed out installing a breakpoint; the
unchanged gate passed on retry.

Maintainers run the opt-in browser gate from `packages/react_tool`:

```sh
REACT_BROWSER_TESTS=1 dart test test/debug_session_integration_test.dart
```

It uses an isolated headless Chromium profile and allocated ports.
The gate selects polling explicitly to cover filesystems with unreliable native
notifications; it does not certify native watching on every filesystem. Set
`CHROME_EXECUTABLE` if the executable is not named `chromium`. Ordinary test
runs skip this browser-only gate; they retain native proxy routing and cleanup tests.

For repeated local diagnosis, set `REACT_KEEP_DEBUG_FIXTURE=1` to retain the
generated fixture and print its location. A later run may set
`REACT_DEBUG_FIXTURE=/absolute/path/from/that/output` to reuse its build cache.
Only fixtures marked by this test are accepted. Reused fixtures are preserved;
process shutdown and template-restoration assertions still run. Default runs
always generate a fresh fixture and clean it up.
