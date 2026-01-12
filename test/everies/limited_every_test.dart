import 'package:due_date/src/everies/limited_every.dart';
import 'package:due_date/src/everies/limited_every_mixin.dart';
import 'package:test/test.dart';

/// Test implementation of [LimitedEvery] that can be made constant.
class _TestLimitedEvery extends LimitedEvery with LimitedEveryMixin {
  /// Creates a test implementation of [LimitedEvery].
  const _TestLimitedEvery();

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
