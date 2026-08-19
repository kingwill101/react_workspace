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
  });
}
