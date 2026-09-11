import 'package:react_core/react.dart' as legacy;
import 'package:react_core/react_core.dart' as canonical;
import 'package:test/test.dart';

void main() {
  test('both entrypoints expose identical portable types', () {
    expect(canonical.ReactNode, legacy.ReactNode);
    expect(canonical.ReactRef, legacy.ReactRef);
    const canonical.ReactNode node = legacy.Text('compatible');
    expect(node, isA<canonical.Text>());
  });
}
