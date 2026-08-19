import 'package:react_web/react_web.dart';
import 'package:test/test.dart';

void main() {
  test('classNames flattens conditions and removes duplicates', () {
    expect(
      classNames(
        'button primary',
        ['large', null],
        {'primary': true, 'disabled': false},
      ),
      'button primary large',
    );
  });

  test('css emits a React style map and supports custom properties', () {
    final style = css(display: 'flex', padding: 16)
      ..custom('--accent', 'tomato');

    expect(style, {'display': 'flex', 'padding': 16, '--accent': 'tomato'});
  });

  test('aria and data prefix attributes', () {
    expect(aria(label: 'Save', expanded: true), {
      'aria-label': 'Save',
      'aria-expanded': true,
    });
    expect(dataAttributes({'test-id': 'save', 'data-state': 'ready'}), {
      'data-test-id': 'save',
      'data-state': 'ready',
    });
  });
}
