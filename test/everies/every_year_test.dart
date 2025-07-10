// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/every_match.dart';

/// Test implementation of [EveryYear] that can be made constant.
class _TestEveryYear extends Every with EveryYear {
  /// Creates a test implementation of [EveryYear].
  const _TestEveryYear();

  @override
  DateTime startDate(DateTime date) => date;

  @override
  DateTime addYears(DateTime date, int years) {
    final newYear = date.year + years;
    return DateTime(
      newYear,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }
}

/// Test implementation of [EveryYear] with UTC support that can be made
/// constant.
class _TestEveryYearUtc extends Every with EveryYear {
  /// Creates a test implementation of [EveryYear] with UTC support.
  const _TestEveryYearUtc();

  @override
  DateTime startDate(DateTime date) => date;

  @override
  DateTime addYears(DateTime date, int years) {
    final newYear = date.year + years;
    if (date.isUtc) {
      return DateTime.utc(
        newYear,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
    } else {
      return DateTime(
        newYear,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
    }
  }
}

void main() {
  group('EveryYear:', () {
    group('Constructor', () {
      test('Can be mixed in and created as constant', () {
        const every = _TestEveryYear();
        expect(every, isNotNull);
        expect(every.runtimeType, equals(_TestEveryYear));
      });
    });

    group('Methods', () {
      group('next', () {
        test('Returns next year', () {
          const every = _TestEveryYear();
          // July 15, 2024.
          final date = DateTime(2024, 7, 15);
          // July 15, 2025.
          final expected = DateTime(2025, 7, 15);

          expect(every, hasNext(expected).withInput(date));
        });

        test('Handles regular February 28th', () {
          const every = _TestEveryYear();
          // February 28, 2024.
          final date = DateTime(2024, 2, 28);
          // February 28, 2025.
          final expected = DateTime(2025, 2, 28);

          expect(every, hasNext(expected).withInput(date));
        });

        test('Handles leap year February 29th to leap year', () {
          const every = _TestEveryYear();
          // February 29, 2024 (leap year).
          final date = DateTime(2024, 2, 29);
          // February 29, 2028 (leap year).
          final expected = DateTime(2028, 2, 29);

          final result = every.addYears(date, 4);
          expect(result, equals(expected));
        });
      });

      group('previous', () {
        test('Returns previous year', () {
          const every = _TestEveryYear();
          // July 15, 2024.
          final date = DateTime(2024, 7, 15);
          // July 15, 2023.
          final expected = DateTime(2023, 7, 15);

          expect(every, hasPrevious(expected).withInput(date));
        });

        test('Handles century boundary', () {
          const every = _TestEveryYear();
          // March 1, 2000.
          final date = DateTime(2000, 3);
          // March 1, 1999.
          final expected = DateTime(1999, 3);

          expect(every, hasPrevious(expected).withInput(date));
        });
      });

      group('addYears', () {
        test('Adds positive years correctly', () {
          const every = _TestEveryYear();
          // July 15, 2020.
          final date = DateTime(2020, 7, 15);

          // Add 5 years.
          final result = every.addYears(date, 5);
          // July 15, 2025.
          final expected = DateTime(2025, 7, 15);

          expect(result, equals(expected));
        });

        test('Handles negative years', () {
          const every = _TestEveryYear();
          // July 15, 2025.
          final date = DateTime(2025, 7, 15);

          // Subtract 3 years.
          final result = every.addYears(date, -3);
          // July 15, 2022.
          final expected = DateTime(2022, 7, 15);

          expect(result, equals(expected));
        });

        test('Zero years returns same date', () {
          const every = _TestEveryYear();
          // July 15, 2024.
          final date = DateTime(2024, 7, 15);

          final result = every.addYears(date, 0);

          expect(result, equals(date));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('Specific year calculations with normal dates', () {
        const every = _TestEveryYear();
        // September 15, 2020.
        final inputDate = DateTime(2020, 9, 15);
        // September 15, 2021.
        final expectedNext = DateTime(2021, 9, 15);
        // September 15, 2019.
        final expectedPrevious = DateTime(2019, 9, 15);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });

      test('Century boundary calculations', () {
        const every = _TestEveryYear();
        // December 31, 1999.
        final inputDate = DateTime(1999, 12, 31);
        // December 31, 2000.
        final expectedNext = DateTime(2000, 12, 31);
        // December 31, 1998.
        final expectedPrevious = DateTime(1998, 12, 31);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });

      test('Multiple years addition across leap years', () {
        const every = _TestEveryYear();
        // February 29, 2020 (leap year).
        final inputDate = DateTime(2020, 2, 29);

        // Add 8 years (next leap year).
        final result = every.addYears(inputDate, 8);
        // February 29, 2028 (leap year).
        final expected = DateTime(2028, 2, 29);

        expect(result, equals(expected));
      });
    });

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        const every = _TestEveryYearUtc();
        final inputWithTime = DateTime(2024, 7, 15, 14, 30, 45, 123, 456);
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
        const every = _TestEveryYearUtc();
        final inputWithTime = DateTime.utc(2024, 7, 15, 14, 30, 45, 123, 456);
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
        const every = _TestEveryYearUtc();
        final inputDate = DateTime(2024, 7, 15);
        final expected = DateTime(2025, 7, 15);

        expect(every, hasNext(expected).withInput(inputDate));
      });

      test('Normal generation with date-only input (UTC)', () {
        const every = _TestEveryYearUtc();
        final inputDate = DateTime.utc(2024, 7, 15);
        final expected = DateTime.utc(2025, 7, 15);

        expect(every, hasNext(expected).withInput(inputDate));
      });
    });
  });
}
