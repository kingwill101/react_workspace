import 'package:watcher/watcher.dart';

bool _pollingRegistered = false;

/// Configures the build process only when the React CLI requests polling.
///
/// Factory construction precedes build_runner's watcher startup. Registering
/// here uses watcher's public extension point without patching build_runner or
/// changing ordinary `build_runner watch` behavior. It also covers local path
/// dependencies, not just the application's own source directory.
void configureReactBuildWatcher({required bool polling}) {
  if (!polling || _pollingRegistered) {
    return;
  }
  registerCustomWatcher(
    'react_codegen.polling',
    (path, {pollingDelay}) =>
        PollingDirectoryWatcher(path, pollingDelay: pollingDelay),
    null,
  );
  _pollingRegistered = true;
}
