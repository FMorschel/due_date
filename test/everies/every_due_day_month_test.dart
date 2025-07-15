import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';
import '../src/every_match.dart';

void main() {
  group('EveryDueDayMonth:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(const EveryDueDayMonth(15), isNotNull);
        });
        test('Default property values', () {
          expect(const EveryDueDayMonth(15).dueDay, equals(15));
          expect(const EveryDueDayMonth(15).exact, isFalse);
        });
        group('asserts limits', () {
          test('dueDay cannot be 0', () {
            expect(
              () => EveryDueDayMonth(0),
              throwsA(isA<AssertionError>()),
            );
          });
          test('dueDay cannot be greater than 31', () {
            expect(
              () => EveryDueDayMonth(32),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
    });

    group('Methods', () {
      group('startDate', () {
        const every = EveryDueDayMonth(15);

        test('Returns same date when input is valid', () {
          // August 15, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.august, 15);
          expect(every, startsAtSameDate.withInput(validDate));
        });
        test('Returns next valid date when input is invalid', () {
          // August 14, 2022 is Sunday.
          final invalidDate = DateTime(2022, DateTime.august, 14);
          // August 15, 2022 is Monday.
          final expected = DateTime(2022, DateTime.august, 15);
          expect(every, startsAt(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          // August 15, 2022 is Monday (UTC).
          final validDateUtc = DateTime.utc(2022, DateTime.august, 15);
          expect(every, startsAtSameDate.withInput(validDateUtc));
        });
      });

      group('next', () {
        const every = EveryDueDayMonth(15);

        test('Always generates date after input', () {
          // August 15, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.august, 15);
          expect(every, nextIsAfter.withInput(validDate));
        });
        test('Generates next occurrence from valid date', () {
          // August 15, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.august, 15);
          // September 15, 2022 is Thursday.
          final expected = DateTime(2022, DateTime.september, 15);
          expect(every, hasNext(expected).withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          // August 14, 2022 is Sunday.
          final invalidDate = DateTime(2022, DateTime.august, 14);
          // August 15, 2022 is Monday.
          final expected = DateTime(2022, DateTime.august, 15);
          expect(every, hasNext(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          // August 15, 2022 is Monday (UTC).
          final validDateUtc = DateTime.utc(2022, DateTime.august, 15);
          // September 15, 2022 is Thursday (UTC).
          final expectedUtc = DateTime.utc(2022, DateTime.september, 15);
          expect(every, hasNext(expectedUtc).withInput(validDateUtc));
        });
      });

      group('previous', () {
        const every = EveryDueDayMonth(15);

        test('Always generates date before input', () {
          // August 15, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.august, 15);
          expect(every, previousIsBefore.withInput(validDate));
        });
        test('Generates previous occurrence from valid date', () {
          // August 15, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.august, 15);
          // July 15, 2022 is Friday.
          final expected = DateTime(2022, DateTime.july, 15);
          expect(every, hasPrevious(expected).withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          // August 16, 2022 is Tuesday.
          final invalidDate = DateTime(2022, DateTime.august, 16);
          // August 15, 2022 is Monday.
          final expected = DateTime(2022, DateTime.august, 15);
          expect(every, hasPrevious(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          // August 15, 2022 is Monday (UTC).
          final validDateUtc = DateTime.utc(2022, DateTime.august, 15);
          // July 15, 2022 is Friday (UTC).
          final expectedUtc = DateTime.utc(2022, DateTime.july, 15);
          expect(every, hasPrevious(expectedUtc).withInput(validDateUtc));
        });
      });

      group('addMonths', () {
        const every = EveryDueDayMonth(31);

        test('Zero months returns same date when valid', () {
          // August 31, 2022 is Wednesday.
          final validDate = DateTime(2022, DateTime.august, 31);
          expect(every.addMonths(validDate, 0), isSameDateTime(validDate));
        });
        test('Positive months adds correctly', () {
          // August 31, 2022 is Wednesday.
          final validDate = DateTime(2022, DateTime.august, 31);
          // September 30, 2022 is Friday (clamped to month end).
          final expected = DateTime(2022, DateTime.september, 30);
          expect(every.addMonths(validDate, 1), isSameDateTime(expected));
        });
        test('Negative months subtracts correctly', () {
          // March 31, 2022 is Thursday.
          final validDate = DateTime(2022, DateTime.march, 31);
          // February 28, 2022 is Monday (clamped to month end).
          final expected = DateTime(2022, DateTime.february, 28);
          expect(every.addMonths(validDate, -1), isSameDateTime(expected));
        });
        test('Works with UTC dates', () {
          // August 31, 2022 is Wednesday (UTC).
          final validDateUtc = DateTime.utc(2022, DateTime.august, 31);
          // September 30, 2022 is Friday (UTC, clamped to month end).
          final expectedUtc = DateTime.utc(2022, DateTime.september, 30);
          expect(every.addMonths(validDateUtc, 1), isSameDateTime(expectedUtc));
        });
      });
    });

    // REQUIRED: Explicit datetime-to-datetime tests.
    group('Explicit datetime tests:', () {
      test('15th of month calculation', () {
        const everyFifteenth = EveryDueDayMonth(15);
        // August 12, 2022 is Friday.
        final inputDate = DateTime(2022, 8, 12);
        // August 15, 2022 is Monday.
        final expected = DateTime(2022, 8, 15);

        expect(everyFifteenth, hasNext(expected).withInput(inputDate));
      });

      test('31st of month calculation (month with 31 days)', () {
        const everyThirtyFirst = EveryDueDayMonth(31);
        // August 12, 2022 is Friday.
        final inputDate = DateTime(2022, 8, 12);
        // August 31, 2022 is Wednesday.
        final expected = DateTime(2022, 8, 31);

        expect(everyThirtyFirst, hasNext(expected).withInput(inputDate));
      });

      test('31st of month calculation (month with 30 days)', () {
        const everyThirtyFirst = EveryDueDayMonth(31);
        // September 15, 2022 is Thursday.
        final inputDate = DateTime(2022, 9, 15);
        // September 30, 2022 is Friday (clamped to month end).
        final expected = DateTime(2022, 9, 30);

        expect(everyThirtyFirst, hasNext(expected).withInput(inputDate));
      });

      test('29th of February in leap year', () {
        const everyTwentyNinth = EveryDueDayMonth(29);
        // February 15, 2024 is Thursday.
        final inputDate = DateTime(2024, 2, 15);
        // February 29, 2024 is Thursday (leap year).
        final expected = DateTime(2024, 2, 29);

        expect(everyTwentyNinth, hasNext(expected).withInput(inputDate));
      });

      test('29th of February in non-leap year', () {
        const everyTwentyNinth = EveryDueDayMonth(29);
        // February 15, 2022 is Tuesday.
        final inputDate = DateTime(2022, 2, 15);
        // February 28, 2022 is Monday (clamped to month end).
        final expected = DateTime(2022, 2, 28);

        expect(everyTwentyNinth, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: year boundary crossing', () {
        const everyFifteenth = EveryDueDayMonth(15);
        // December 20, 2022 is Tuesday.
        final inputDate = DateTime(2022, 12, 20);
        // January 15, 2023 is Sunday.
        final expected = DateTime(2023, 1, 15);

        expect(everyFifteenth, hasNext(expected).withInput(inputDate));
      });

      test('Previous calculation across months', () {
        const everyFifteenth = EveryDueDayMonth(15);
        // August 10, 2022 is Wednesday.
        final inputDate = DateTime(2022, 8, 10);
        // July 15, 2022 is Friday.
        final expected = DateTime(2022, 7, 15);

        expect(everyFifteenth, hasPrevious(expected).withInput(inputDate));
      });
    });

    // REQUIRED: Time component preservation tests.
    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        const everyFifteenth = EveryDueDayMonth(15);
        final inputWithTime = DateTime(2022, 8, 12, 14, 30, 45, 123, 456);
        final result = everyFifteenth.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });

      test('Maintains time components in local DateTime when clamped', () {
        const everyFifteenth = EveryDueDayMonth(31);
        final inputWithTime = DateTime(2022, 9, 12, 14, 30, 45, 123, 456);
        final result = everyFifteenth.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });

      test('Maintains time components in UTC DateTime', () {
        const everyFifteenth = EveryDueDayMonth(15);
        final inputWithTime = DateTime.utc(2022, 8, 12, 14, 30, 45, 123, 456);
        final result = everyFifteenth.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isUtcDateTime);
      });

      test('Previous maintains time components in local DateTime', () {
        const everyFifteenth = EveryDueDayMonth(15);
        final inputWithTime = DateTime(2022, 8, 20, 9, 15, 30, 500, 250);
        final result = everyFifteenth.previous(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isLocalDateTime);
      });

      test('Previous maintains time components in UTC DateTime', () {
        const everyFifteenth = EveryDueDayMonth(15);
        final inputWithTime = DateTime.utc(2022, 8, 20, 9, 15, 30, 500, 250);
        final result = everyFifteenth.previous(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isUtcDateTime);
      });

      test('Normal generation with date-only input (local)', () {
        const everyFifteenth = EveryDueDayMonth(15);
        final inputDate = DateTime(2022, 8, 12);
        final result = everyFifteenth.next(inputDate);

        // Should maintain date-only format.
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result, isLocalDateTime);
      });

      test('Normal generation with date-only input (UTC)', () {
        const everyFifteenth = EveryDueDayMonth(15);
        final inputDate = DateTime.utc(2022, 8, 12);
        final result = everyFifteenth.next(inputDate);

        // Should maintain date-only format and UTC flag.
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result, isUtcDateTime);
      });
    });

    group('Edge Cases', () {
      group('Day 31 handling', () {
        const everyThirtyFirst = EveryDueDayMonth(31);

        test('Handles month with 31 days', () {
          // August 12, 2022 is Friday.
          final inputDate = DateTime(2022, DateTime.august, 12);
          // August 31, 2022 is Wednesday.
          final expected = DateTime(2022, DateTime.august, 31);
          expect(everyThirtyFirst, startsAt(expected).withInput(inputDate));
        });

        test('Handles month with 30 days', () {
          // September 15, 2022 is Thursday.
          final inputDate = DateTime(2022, DateTime.september, 15);
          // September 30, 2022 is Friday (clamped to month end).
          final expected = DateTime(2022, DateTime.september, 30);
          expect(everyThirtyFirst, startsAt(expected).withInput(inputDate));
        });

        test('Handles February in leap year', () {
          // February 15, 2024 is Thursday.
          final inputDate = DateTime(2024, DateTime.february, 15);
          // February 29, 2024 is Thursday (leap year, clamped to month end).
          final expected = DateTime(2024, DateTime.february, 29);
          expect(everyThirtyFirst, startsAt(expected).withInput(inputDate));
        });

        test('Handles February in non-leap year', () {
          // February 15, 2022 is Tuesday.
          final inputDate = DateTime(2022, DateTime.february, 15);
          // February 28, 2022 is Monday (non-leap year, clamped to month end).
          final expected = DateTime(2022, DateTime.february, 28);
          expect(everyThirtyFirst, startsAt(expected).withInput(inputDate));
        });
      });

      group('Year boundary transitions', () {
        test('December to January transition', () {
          const everyFifteenth = EveryDueDayMonth(15);
          // December 20, 2022 is Tuesday.
          final december20 = DateTime(2022, 12, 20);
          // January 15, 2023 is Sunday.
          final expected = DateTime(2023, 1, 15);
          expect(everyFifteenth, hasNext(expected).withInput(december20));
        });

        test('January to December transition (previous)', () {
          const everyFifteenth = EveryDueDayMonth(15);
          // January 10, 2023 is Tuesday.
          final january10 = DateTime(2023, 1, 10);
          // December 15, 2022 is Thursday.
          final expected = DateTime(2022, 12, 15);
          expect(everyFifteenth, hasPrevious(expected).withInput(january10));
        });
      });
    });

    group('toString', () {
      test('Returns meaningful string representation', () {
        const everyFifteenth = EveryDueDayMonth(15);
        expect(everyFifteenth.toString(), equals('EveryDueDayMonth<15>'));
      });

      test('Returns meaningful string representation for day 31', () {
        const everyThirtyFirst = EveryDueDayMonth(31);
        expect(everyThirtyFirst.toString(), equals('EveryDueDayMonth<31>'));
      });
    });

    group('Equality', () {
      final everyFifteenth1 = EveryDueDayMonth(15);
      final everyFifteenth2 = EveryDueDayMonth(15);
      final everyThirtyFirst = EveryDueDayMonth(31);

      test('Same instance', () {
        expect(everyFifteenth1, equals(everyFifteenth1));
      });
      test('Different dueDay', () {
        expect(everyFifteenth1, isNot(equals(everyThirtyFirst)));
      });
      test('Same dueDay', () {
        expect(everyFifteenth1, equals(everyFifteenth2));
      });
      test('Hash code consistency', () {
        expect(everyFifteenth1.hashCode, equals(everyFifteenth2.hashCode));
      });
    });

    // Test named constructors separately.
    group('from', () {
      test('Creates instance with day from given date', () {
        // August 15, 2022 is Monday.
        final date = DateTime(2022, 8, 15);
        final every = EveryDueDayMonth.from(date);

        expect(every.dueDay, equals(15));
        expect(every, isNotNull);
      });

      test('Creates instance with day 1', () {
        // August 1, 2022 is Monday.
        final date = DateTime(2022, 8);
        final every = EveryDueDayMonth.from(date);

        expect(every.dueDay, equals(1));
      });

      test('Creates instance with day 31', () {
        // August 31, 2022 is Wednesday.
        final date = DateTime(2022, 8, 31);
        final every = EveryDueDayMonth.from(date);

        expect(every.dueDay, equals(31));
      });

      test('Works with UTC dates', () {
        // August 15, 2022 is Monday (UTC).
        final dateUtc = DateTime.utc(2022, 8, 15);
        final every = EveryDueDayMonth.from(dateUtc);

        expect(every.dueDay, equals(15));
      });

      test('Ignores time components, only uses day', () {
        // August 15, 2022 14:30:45.
        final dateWithTime = DateTime(2022, 8, 15, 14, 30, 45, 123, 456);
        final every = EveryDueDayMonth.from(dateWithTime);

        expect(every.dueDay, equals(15));
      });
    });
  });
}
