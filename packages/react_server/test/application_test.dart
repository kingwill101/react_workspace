import 'package:react_server/react_server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ReactServerApp delegates non-SSR pages to the static handler',
    () async {
      final app = ReactServerApp(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (request) => Response.ok('static'),
        indexTemplate: '<div>{{SSR}}</div>',
      );

      final response = await app.handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(response.statusCode, 200);
      expect(await response.readAsString(), 'static');
    },
  );
}
