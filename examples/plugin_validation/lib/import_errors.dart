// Demonstrates server/client import boundary validation.
// This file simulates `bin/server.dart` or `lib/ssr.dart` — server context.
// Any of these imports should trigger the new import rules.

import 'dart:js_interop'; // expect: js_interop_in_server — must not be in server
import 'dart:js_interop_unsafe'; // expect: js_interop_in_server
import 'package:react_web/react_web.dart'; // expect: browser_import_in_server
import 'package:react_js/react_js.dart'; // expect: browser_import_in_server
import 'package:web/web.dart'; // expect: browser_import_in_server

import '.generated/valid_component.react.g.dart'; // expect: generated_bridge_import — use *.react.dart
import '.generated/valid_component.react.dart'; // ok — public API

// ignore_for_file: unused_import, directives_ordering
