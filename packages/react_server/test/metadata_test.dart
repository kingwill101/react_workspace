import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  test('renders escaped page metadata', () {
    const metadata = ReactPageMetadata(
      title: 'Ada & Sons',
      description: 'A <strong>typed</strong> app',
      canonical: 'https://example.test/products?a=1&b=2',
      openGraph: {'og:title': 'Ada'},
      meta: [ReactMetaTag(name: 'robots', content: 'index,follow')],
      links: [ReactLinkTag(rel: 'preload', href: '/app.js')],
      jsonLd: {'@type': 'WebSite', 'name': 'Ada'},
    );

    final html = metadata.toHtml();
    expect(html, contains('<title>Ada &amp; Sons</title>'));
    expect(
      html,
      contains('content="A &lt;strong&gt;typed&lt;/strong&gt; app"'),
    );
    expect(html, contains('property="og:title"'));
    expect(html, contains('name="robots"'));
    expect(html, contains('rel="preload"'));
    expect(html, contains('application/ld+json'));
    expect(html, isNot(contains('<strong>')));
  });

  test('injects metadata into a head marker or head element', () {
    const metadata = ReactPageMetadata(title: 'Home');
    expect(
      injectReactPageMetadata('<head>{{HEAD}}</head>', metadata),
      '<head><title>Home</title></head>',
    );
    expect(
      injectReactPageMetadata(
        '<html><head></head><body></body></html>',
        metadata,
      ),
      '<html><head><title>Home</title></head><body></body></html>',
    );
  });
}
