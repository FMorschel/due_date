import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

/// Test implementation of [LimitedEvery] that can be made constant.
class _TestLimitedEvery extends LimitedEvery {
  /// Creates a test implementation of [LimitedEvery].
  const _TestLimitedEvery();

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) => date;

  @override
  DateTime next(DateTime date, {DateTime? limit}) => date;

  @override
  DateTime previous(DateTime date, {DateTime? limit}) => date;
}

void main() {
  group('LimitedEvery:', () {
    group('Constructor', () {
      test('Can be created as constant', () {
        const every = _TestLimitedEvery();
        expect(every, isNotNull);
        expect(every.runtimeType, equals(_TestLimitedEvery));
      });
    });
  });
}
