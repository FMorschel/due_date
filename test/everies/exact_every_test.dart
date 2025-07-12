import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

/// Test implementation of [ExactEvery] that can be made constant.
class _TestExactEvery extends ExactEvery {
  /// Creates a test implementation of [ExactEvery].
  const _TestExactEvery({super.exact});

  @override
  DateTime startDate(DateTime date) => date;

  @override
  DateTime next(DateTime date) => date;

  @override
  DateTime previous(DateTime date) => date;

  @override
  bool valid(DateTime date) => true;

  @override
  bool invalid(DateTime date) => !valid(date);

  @override
  @Deprecated("Use 'DateValidator.filterValidDates' instead.")
  Iterable<DateTime> validsIn(Iterable<DateTime> dates) =>
      filterValidDates(dates);

  @override
  Iterable<DateTime> filterValidDates(Iterable<DateTime> dates) sync* {
    for (final date in dates) {
      if (valid(date)) yield date;
    }
  }
}

void main() {
  group('ExactEvery:', () {
    group('Constructor', () {
      test('Can be created as constant with default exact value', () {
        const every = _TestExactEvery();
        expect(every, isNotNull);
        expect(every.runtimeType, equals(_TestExactEvery));
        expect(every.exact, isFalse);
        expect(every.inexact, isTrue);
      });

      test('Can be created as constant with explicit exact value', () {
        const every = _TestExactEvery(exact: true);
        expect(every, isNotNull);
        expect(every.runtimeType, equals(_TestExactEvery));
        expect(every.exact, isTrue);
        expect(every.inexact, isFalse);
      });
    });
  });
}
