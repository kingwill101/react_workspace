import 'dart:convert';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  group('ReactSsrClient', () {
    test('render returns document on success', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        final response = request.response;
        response.headers.contentType = ContentType.json;
        response.write(
          jsonEncode({
            'html': '<div>hi</div>',
            'props': {'x': 1},
          }),
        );
        await response.close();
      });

      final client = ReactSsrClient(
        endpoint: Uri.parse('http://127.0.0.1:${server.port}/'),
      );
      final document = await client.render(
        component: 'app#Root',
        props: {'a': 1},
      );
      expect(document.html, '<div>hi</div>');
      expect(document.props['x'], 1);

      client.close();
      await server.close(force: true);
    });

    test('render rejects non-2xx responses', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        request.response.statusCode = 500;
        request.response.write('error');
        await request.response.close();
      });

      final client = ReactSsrClient(
        endpoint: Uri.parse('http://127.0.0.1:${server.port}/'),
      );
      await expectLater(
        client.render(component: 'app#Root', props: const {}),
        throwsA(isA<HttpException>()),
      );
      client.close();
      await server.close(force: true);
    });

    test('render rejects an invalid response envelope', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode({'bad': 'envelope'}));
        await request.response.close();
      });

      final client = ReactSsrClient(
        endpoint: Uri.parse('http://127.0.0.1:${server.port}/'),
      );
      await expectLater(
        client.render(component: 'app#Root', props: const {}),
        throwsA(isA<FormatException>()),
      );
      client.close();
      await server.close(force: true);
    });

    test('requires an absolute base for a relative endpoint', () async {
      final client = ReactSsrClient(endpoint: Uri.parse('/__react/ssr'));
      await expectLater(
        client.render(component: 'app#Root', props: const {}),
        throwsA(isA<ArgumentError>()),
      );
      client.close();
    });

    test('renderStream decodes progressive HTML chunks', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        final response = request.response;
        response.headers.contentType = ContentType('application', 'x-ndjson');
        response.write('{"type":"start"}\n');
        await response.flush();
        response.write('{"type":"chunk","html":"<main>"}\n');
        response.write('{"type":"chunk","html":"Hello</main>"}\n');
        response.write('{"type":"end","props":{"title":"Hi"}}\n');
        await response.close();
      });

      final client = ReactSsrClient(
        endpoint: Uri.parse('http://127.0.0.1:${server.port}/'),
      );
      final chunks = await client
          .renderStream(component: 'app#Root', props: const {})
          .toList();

      expect(chunks.map((chunk) => chunk.html).join(), '<main>Hello</main>');
      expect(chunks.last.done, isTrue);
      expect(chunks.last.props['title'], 'Hi');

      client.close();
      await server.close(force: true);
    });
  });
}
