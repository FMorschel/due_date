import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

/// Test implementation of [EveryDateValidator] that can be made constant.
class _TestEveryDateValidator extends EveryDateValidator {
  /// Creates a test implementation of [EveryDateValidator].
  const _TestEveryDateValidator();

  @override
  DateTime startDate(DateTime date) => date;

  @override
  DateTime next(DateTime date) => date;

  @override
  DateTime previous(DateTime date) => date;

  @override
  bool valid(DateTime date) => true;
}

void main() {
  group('EveryDateValidator:', () {
    group('Constructor', () {
      test('Can be created as constant', () {
        const every = _TestEveryDateValidator();
        expect(every, isNotNull);
        expect(every.runtimeType, equals(_TestEveryDateValidator));
      });
    });
  });
}
