// Simulates `web/client.dart` — browser context.
// These imports are allowed here; the same imports would be flagged in `bin/server.dart`.

import 'dart:js_interop'; // ok in client
import 'package:react_web/react_web.dart'; // ok in client
import '.generated/valid_component.react.dart'; // ok — public API

// This is still flagged even in client context — generated bridge should not be
// imported from hand-written code; the bundler handles it.
import '.generated/valid_component.react.g.dart'; // expect: generated_bridge_import

// ignore_for_file: unused_import, directives_ordering
