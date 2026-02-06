import 'package:due_date/src/everies/every.dart';
import 'package:due_date/src/everies/every_week.dart';
import 'package:test/test.dart';

import '../src/every_match.dart';

/// Test implementation of [EveryWeek] that can be made constant.
class _TestEveryWeek extends Every with EveryWeek {
  /// Creates a test implementation of [EveryWeek].
  const _TestEveryWeek();

  @override
  DateTime addWeeks(DateTime date, int weeks) {
    return date.add(Duration(days: weeks * 7));
  }

  @override
  DateTime next(DateTime date) => addWeeks(date, 1);

  @override
  DateTime previous(DateTime date) => addWeeks(date, -1);
}

/// Test implementation of [EveryWeek] with UTC support that can be made
/// constant.
class _TestEveryWeekUtc extends Every with EveryWeek {
  /// Creates a test implementation of [EveryWeek] with UTC support.
  const _TestEveryWeekUtc();

  @override
  DateTime addWeeks(DateTime date, int weeks) {
    if (date.isUtc) {
      return DateTime.utc(
        date.year,
        date.month,
        date.day + (weeks * 7),
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
    }
    return DateTime(
      date.year,
      date.month,
      date.day + (weeks * 7),
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  @override
  DateTime next(DateTime date) => addWeeks(date, 1);

  @override
  DateTime previous(DateTime date) => addWeeks(date, -1);
}

void main() {
  group('EveryWeek:', () {
    group('Constructor', () {
      test('Can be mixed in and created as constant', () {
        const every = _TestEveryWeek();
        expect(every, isNotNull);
        expect(every.runtimeType, equals(_TestEveryWeek));
      });
    });

    group('Methods', () {
      group('next', () {
        test('Returns next week', () {
          const every = _TestEveryWeek();
          // Monday, July 1, 2024.
          final date = DateTime(2024, 7);
          // Monday, July 8, 2024.
          final expected = DateTime(2024, 7, 8);

          expect(every, hasNext(expected).withInput(date));
        });

        test('Handles month boundary', () {
          const every = _TestEveryWeek();
          // Monday, July 29, 2024.
          final date = DateTime(2024, 7, 29);
          // Monday, August 5, 2024.
          final expected = DateTime(2024, 8, 5);

          expect(every, hasNext(expected).withInput(date));
        });

        test('Handles year boundary', () {
          const every = _TestEveryWeek();
          // Monday, December 30, 2024.
          final date = DateTime(2024, 12, 30);
          // Monday, January 6, 2025.
          final expected = DateTime(2025, 1, 6);

          expect(every, hasNext(expected).withInput(date));
        });

        test('Handles leap year February', () {
          const every = _TestEveryWeek();
          // Thursday, February 22, 2024 (leap year).
          final date = DateTime(2024, 2, 22);
          // Thursday, February 29, 2024.
          final expected = DateTime(2024, 2, 29);

          expect(every, hasNext(expected).withInput(date));
        });
      });

      group('previous', () {
        test('Returns previous week', () {
          const every = _TestEveryWeek();
          // Monday, July 8, 2024.
          final date = DateTime(2024, 7, 8);
          // Monday, July 1, 2024.
          final expected = DateTime(2024, 7);

          expect(every, hasPrevious(expected).withInput(date));
        });

        test('Handles month boundary backwards', () {
          const every = _TestEveryWeek();
          // Tuesday, August 6, 2024.
          final date = DateTime(2024, 8, 6);
          // Tuesday, July 30, 2024.
          final expected = DateTime(2024, 7, 30);

          expect(every, hasPrevious(expected).withInput(date));
        });

        test('Handles year boundary backwards', () {
          const every = _TestEveryWeek();
          // Wednesday, January 3, 2024.
          final date = DateTime(2024, 1, 3);
          // Wednesday, December 27, 2023.
          final expected = DateTime(2023, 12, 27);

          expect(every, hasPrevious(expected).withInput(date));
        });
      });

      group('addWeeks', () {
        test('Adds positive weeks correctly', () {
          const every = _TestEveryWeek();
          // Monday, July 1, 2024.
          final date = DateTime(2024, 7);

          // Add 3 weeks.
          final result = every.addWeeks(date, 3);
          // Monday, July 22, 2024.
          final expected = DateTime(2024, 7, 22);

          expect(result, equals(expected));
        });

        test('Handles negative weeks', () {
          const every = _TestEveryWeek();
          // Monday, July 22, 2024.
          final date = DateTime(2024, 7, 22);

          // Subtract 2 weeks.
          final result = every.addWeeks(date, -2);
          // Monday, July 8, 2024.
          final expected = DateTime(2024, 7, 8);

          expect(result, equals(expected));
        });

        test('Zero weeks returns same date', () {
          const every = _TestEveryWeek();
          // Monday, July 1, 2024.
          final date = DateTime(2024, 7);

          final result = every.addWeeks(date, 0);

          expect(result, equals(date));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('Specific week calculations across normal days', () {
        const every = _TestEveryWeek();
        // Wednesday, June 12, 2024.
        final inputDate = DateTime(2024, 6, 12);
        // Wednesday, June 19, 2024.
        final expectedNext = DateTime(2024, 6, 19);
        // Wednesday, June 5, 2024.
        final expectedPrevious = DateTime(2024, 6, 5);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });

      test('Week calculation across month boundary', () {
        const every = _TestEveryWeek();
        // Saturday, June 29, 2024.
        final inputDate = DateTime(2024, 6, 29);
        // Saturday, July 6, 2024.
        final expectedNext = DateTime(2024, 7, 6);
        // Saturday, June 22, 2024.
        final expectedPrevious = DateTime(2024, 6, 22);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });

      test('Week calculation across year boundary', () {
        const every = _TestEveryWeek();
        // Sunday, December 29, 2024.
        final inputDate = DateTime(2024, 12, 29);
        // Sunday, January 5, 2025.
        final expectedNext = DateTime(2025, 1, 5);
        // Sunday, December 22, 2024.
        final expectedPrevious = DateTime(2024, 12, 22);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });

      test('Leap year February boundary', () {
        const every = _TestEveryWeek();
        // Friday, February 23, 2024 (leap year).
        final inputDate = DateTime(2024, 2, 23);
        // Friday, March 1, 2024.
        final expectedNext = DateTime(2024, 3);
        // Friday, February 16, 2024.
        final expectedPrevious = DateTime(2024, 2, 16);

        expect(every, hasNext(expectedNext).withInput(inputDate));
        expect(every, hasPrevious(expectedPrevious).withInput(inputDate));
      });

      test('Multiple weeks addition', () {
        const every = _TestEveryWeek();
        // Tuesday, July 2, 2024.
        final inputDate = DateTime(2024, 7, 2);

        // Add 4 weeks.
        final result = every.addWeeks(inputDate, 4);
        // Tuesday, July 30, 2024.
        final expected = DateTime(2024, 7, 30);

        expect(result, equals(expected));
      });
    });

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        const every = _TestEveryWeekUtc();
        final inputWithTime = DateTime(2024, 7, 1, 14, 30, 45, 123, 456);
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
        const every = _TestEveryWeekUtc();
        final inputWithTime = DateTime.utc(2024, 7, 1, 14, 30, 45, 123, 456);
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
        const every = _TestEveryWeekUtc();
        final inputDate = DateTime(2024, 7);
        final expected = DateTime(2024, 7, 8);

        expect(every, hasNext(expected).withInput(inputDate));
      });

      test('Normal generation with date-only input (UTC)', () {
        const every = _TestEveryWeekUtc();
        final inputDate = DateTime.utc(2024, 7);
        final expected = DateTime.utc(2024, 7, 8);

        expect(every, hasNext(expected).withInput(inputDate));
      });
    });
  });
}
