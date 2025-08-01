import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

/// Test implementation of [Every] that can be made constant.
class _TestEvery extends Every {
  /// Creates a test implementation of [Every].
  const _TestEvery();

  @override
  DateTime next(DateTime date) => date;

  @override
  DateTime previous(DateTime date) => date;
}

void main() {
  group('Every:', () {
    group('Constructor', () {
      test('Can be created as constant', () {
        const every = _TestEvery();
        expect(every, isNotNull);
        expect(every.runtimeType, equals(_TestEvery));
      });
    });
  });
}
