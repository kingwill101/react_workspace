import 'dart:convert';

import 'package:react_tool/src/debug_import_map.dart';
import 'package:react_tool/src/project_config.dart';
import 'package:test/test.dart';

void main() {
  test(
    'authored aliases, scopes, and metadata survive repeated debug setup',
    () {
      const source = '''<head><script type='importmap' nonce="app">
{"imports":{"app/":"/lib/","react":"/old.js"},
"scopes":{"/lib/":{"util":"/utils.js"}},"integrity":{"/utils.js":"sha384-test"}}
</script></head><body>app</body>''';
      final result = updateDebugImportMap(source, {'react': '/debug/react.js'});
      final document = jsonDecode(
        RegExp(
          r'<script[^>]*>([\s\S]*?)</script>',
        ).firstMatch(result)!.group(1)!,
      );
      expect(document['imports'], {
        'app/': '/lib/',
        'react': '/debug/react.js',
      });
      expect(document['scopes']['/lib/']['util'], '/utils.js');
      expect(document['integrity']['/utils.js'], 'sha384-test');
      expect(result, contains('nonce="app"'));
      expect(
        updateDebugImportMap(result, {'react': '/debug/react.js'}),
        result,
      );
      expect(result, endsWith('</head><body>app</body>'));
    },
  );

  test('inserts before head end and rejects invalid authored maps', () {
    expect(
      updateDebugImportMap('<head></head>', {'react': '/react.js'}),
      contains('</script>\n<!-- react_tool:debug-importmap:end -->\n</head>'),
    );
    expect(
      () => updateDebugImportMap('<script type="importmap">{bad}</script>', {}),
      throwsA(isA<ReactToolException>()),
    );
  });

  test(
    'matches an uppercase closing head tag without moving before doctype',
    () {
      const source = '<!doctype html>\n<HEAD></HEAD><body></body>';
      final result = updateDebugImportMap(source, {'react': '/react.js'});

      expect(result, startsWith('<!doctype html>\n<HEAD>'));
      expect(
        result,
        contains('</script>\n<!-- react_tool:debug-importmap:end -->\n</HEAD>'),
      );
    },
  );
}
