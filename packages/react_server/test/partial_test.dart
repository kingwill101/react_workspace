import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  test('renders shell and independently cached regions', () async {
    var shells = 0;
    var regions = 0;
    final document = ReactPartialDocument(
      shellKey: 'shell',
      shell: () {
        shells++;
        return '<main><!--react-partial:feed--></main>';
      },
      regions: [
        ReactPartialRegion(
          key: 'feed',
          ttl: Duration.zero,
          render: () {
            regions++;
            return '<ul>feed $regions</ul>';
          },
        ),
      ],
    );
    final cache = ReactDataCache();

    expect(await document.render(cache), '<main><ul>feed 1</ul></main>');
    expect(await document.render(cache), '<main><ul>feed 2</ul></main>');
    expect(shells, 1);
    expect(regions, 2);
  });

  test('rejects a shell without a region marker', () async {
    final document = ReactPartialDocument(
      shellKey: 'shell',
      shell: () => '<main>missing</main>',
      regions: [ReactPartialRegion(key: 'feed', render: () => '<ul>feed</ul>')],
    );

    expect(() => document.render(ReactDataCache()), throwsA(isA<StateError>()));
  });
}
