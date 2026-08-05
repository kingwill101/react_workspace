@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:react_js/react_js.dart';
import 'package:react_web/src/generated/browser_adapter.dart';
import 'package:react_web/src/generated/web/web.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' as web;

void main() {
  test('decodes a DOM ref as the generated host interface', () {
    registerBrowserAdapters();
    final element = web.document.createElement('div');

    final decoded = ReactCodecRegistry.decodeHostValue(
      'web',
      'HTMLDivElement',
      element as JSAny,
    );

    expect(decoded, isA<HTMLDivElement>());
  });
}
