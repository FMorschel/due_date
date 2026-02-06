import 'package:due_date/src/everies/every.dart';
import 'package:due_date/src/everies/every_month.dart';
import 'package:test/test.dart';

import '../src/every_match.dart';

/// Test implementation of [EveryMonth] that can be made constant.
class _TestEveryMonth extends Every with EveryMonth {
  /// Creates a test implementation of [EveryMonth].
  const _TestEveryMonth();

  @override
  DateTime addMonths(DateTime date, int months) {
    return DateTime(
      date.year,
      date.month + months,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

  @override
  DateTime next(DateTime date) => addMonths(date, 1);

  @override
  DateTime previous(DateTime date) => addMonths(date, -1);
}

/// Test implementation of [EveryMonth] with UTC support that can be made
/// constant.
class _TestEveryMonthUtc extends Every with EveryMonth {
  /// Creates a test implementation of [EveryMonth] with UTC support.
  const _TestEveryMonthUtc();

  @override
  DateTime addMonths(DateTime date, int months) {
    if (date.isUtc) {
      return DateTime.utc(
        date.year,
        date.month + months,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
    }
    return DateTime(
      date.year,
      date.month + months,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

  @override
  DateTime next(DateTime date) => addMonths(date, 1);

  @override
  DateTime previous(DateTime date) => addMonths(date, -1);
}

void main() {
  group('EveryMonth:', () {
    group('Constructor', () {
      test('Can be mixed in and created as constant', () {
        const every = _TestEveryMonth();
        expect(every, isNotNull);
        expect(every.runtimeType, equals(_TestEveryMonth));
      });
    });

    group('Methods', () {
      group('addYears', () {
        test('Converts years to months correctly', () {
          const every = _TestEveryMonth();
          // January 15, 2024.
          final date = DateTime(2024, 1, 15);

          // Add 2 years (24 months).
          final result = every.addYears(date, 2);
          // January 15, 2026.
          final expected = DateTime(2026, 1, 15);

          expect(result, equals(expected));
        });

        test('Handles negative years', () {
          const every = _TestEveryMonth();
          // January 15, 2024.
          final date = DateTime(2024, 1, 15);

          // Subtract 1 year (12 months).
          final result = every.addYears(date, -1);
          // January 15, 2023.
          final expected = DateTime(2023, 1, 15);

          expect(result, equals(expected));
        });
      });

      group('next', () {
        test('Returns next month', () {
          const every = _TestEveryMonth();
          // January 15, 2024.
          final date = DateTime(2024, 1, 15);
          // February 15, 2024.
          final expected = DateTime(2024, 2, 15);

          expect(every, hasNext(expected).withInput(date));
        });

        test('Handles year boundary', () {
          const every = _TestEveryMonth();
          // December 15, 2023.
          final date = DateTime(2023, 12, 15);
          // January 15, 2024.
          final expected = DateTime(2024, 1, 15);

          expect(every, hasNext(expected).withInput(date));
        });

        test('Handles February 29th to February 28th', () {
          const every = _TestEveryMonth();
          // February 29, 2024 (leap year).
          final date = DateTime(2024, 2, 29);
          // March 29, 2024.
          final expected = DateTime(2024, 3, 29);

          expect(every, hasNext(expected).withInput(date));
        });
      });

      group('previous', () {
        test('Returns previous month', () {
          const every = _TestEveryMonth();
          // February 15, 2024.
          final date = DateTime(2024, 2, 15);
          // January 15, 2024.
          final expected = DateTime(2024, 1, 15);

          expect(every, hasPrevious(expected).withInput(date));
        });

        test('Handles year boundary backwards', () {
          const every = _TestEveryMonth();
          // January 15, 2024.
          final date = DateTime(2024, 1, 15);
          // December 15, 2023.
          final expected = DateTime(2023, 12, 15);

          expect(every, hasPrevious(expected).withInput(date));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('Specific month calculations with normal days', () {
        const every = _TestEveryMonth();
        // June 15, 2024.
        final inputDate = DateTime(2024, 6, 15);
        // July 15, 2024.
        final expectedNext = DateTime(2024, 7, 15);
        // May 15, 2024.
        final expectedPrevious = DateTime(2024, 5, 15);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });

      test('Leap year February 29th handling', () {
        const every = _TestEveryMonth();
        // February 29, 2024 (leap year).
        final inputDate = DateTime(2024, 2, 29);
        // March 29, 2024.
        final expectedNext = DateTime(2024, 3, 29);
        // January 29, 2024.
        final expectedPrevious = DateTime(2024, 1, 29);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });

      test('Month with 30 days to month with 31 days', () {
        const every = _TestEveryMonth();
        // April 30, 2024.
        final inputDate = DateTime(2024, 4, 30);
        // May 30, 2024.
        final expectedNext = DateTime(2024, 5, 30);

        expect(every, hasNext(expectedNext).withInput(inputDate));
      });

      test('December to January year boundary', () {
        const every = _TestEveryMonth();
        // December 25, 2023.
        final inputDate = DateTime(2023, 12, 25);
        // January 25, 2024.
        final expectedNext = DateTime(2024, 1, 25);
        // November 25, 2023.
        final expectedPrevious = DateTime(2023, 11, 25);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });
    });

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        const every = _TestEveryMonthUtc();
        final inputWithTime = DateTime(2024, 1, 15, 14, 30, 45, 123, 456);
        final result = every.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        const every = _TestEveryMonthUtc();
        final inputWithTime = DateTime.utc(2024, 1, 15, 14, 30, 45, 123, 456);
        final result = every.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result.isUtc, isTrue);
      });

      test('Normal generation with date-only input (local)', () {
        const every = _TestEveryMonthUtc();
        final inputDate = DateTime(2024, 1, 15);
        final expected = DateTime(2024, 2, 15);

        expect(every, hasNext(expected).withInput(inputDate));
      });

      test('Normal generation with date-only input (UTC)', () {
        const every = _TestEveryMonthUtc();
        final inputDate = DateTime.utc(2024, 1, 15);
        final expected = DateTime.utc(2024, 2, 15);

        expect(every, hasNext(expected).withInput(inputDate));
      });
    });
  });
}
