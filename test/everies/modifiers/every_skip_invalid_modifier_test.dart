import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../../src/date_time_match.dart';
import '../../src/every_match.dart';

void main() {
  group('EverySkipInvalidModifier:', () {
    final every = Weekday.monday.every;
    const invalidator = DateValidatorWeekdayCountInMonth(
      week: Week.first,
      day: Weekday.monday,
    );
    final modifier = EverySkipInvalidModifier(
      every: every,
      invalidator: invalidator,
    );

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EverySkipInvalidModifier(every: every, invalidator: invalidator),
            isNotNull,
          );
        });
        test('Creates with correct every', () {
          expect(modifier.every, equals(every));
        });
        test('Creates with correct invalidator', () {
          expect(modifier.invalidator, equals(invalidator));
        });
      });
    });

    group('Methods', () {
      group('startDate', () {
        test('Returns same date when input is valid', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(modifier, startsAtSameDate.withInput(validDate));
        });
        test('Returns next valid date when input is invalid', () {
          // October 7, 2022 is Friday.
          final invalidDate = DateTime(2022, DateTime.october, 7);
          // October 10, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.october, 10);
          expect(modifier, startsAt(expected).withInput(invalidDate));
        });
      });

      group('next', () {
        test('Always generates date after input', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(modifier, nextIsAfter.withInput(validDate));
        });
        test('Generates next occurrence from valid date', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          // October 17, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.october, 17);
          expect(modifier, hasNext(expected).withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          // October 7, 2022 is Friday.
          final invalidDate = DateTime(2022, DateTime.october, 7);
          // October 10, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.october, 10);
          expect(modifier, hasNext(expected).withInput(invalidDate));
        });
      });

      group('previous', () {
        test('Always generates date before input', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(modifier, previousIsBefore.withInput(validDate));
        });
        test('Generates previous occurrence from valid date', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          // September 26, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.september, 26);
          expect(modifier, hasPrevious(expected).withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          // October 7, 2022 is Friday.
          final invalidDate = DateTime(2022, DateTime.october, 7);
          // September 26, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.september, 26);
          expect(modifier, hasPrevious(expected).withInput(invalidDate));
        });
      });

      group('valid', () {
        test('Returns true when date is valid', () {
          // December 11, 2023 is Monday (not first Monday).
          final validDate = DateTime(2023, 12, 11);
          final result = modifier.valid(validDate);
          expect(result, isTrue);
        });
        test('Returns false when date is invalid because of invalidator', () {
          // December 4, 2023 is first Monday (invalidated).
          final invalidDate = DateTime(2023, 12, 4);
          final result = modifier.valid(invalidDate);
          expect(result, isFalse);
        });
        test('Returns false when date is invalid because of every', () {
          // December 3, 2023 is Sunday (not Monday).
          final invalidDate = DateTime(2023, 12, 3);
          final result = modifier.valid(invalidDate);
          expect(result, isFalse);
        });
      });

      group('invalid', () {
        test('Returns false when date is valid', () {
          // December 11, 2023 is Monday (not first Monday).
          final validDate = DateTime(2023, 12, 11);
          final result = modifier.invalid(validDate);
          expect(result, isFalse);
        });
        test('Returns true when date is invalid because of invalidator', () {
          // December 4, 2023 is first Monday (invalidated).
          final invalidDate = DateTime(2023, 12, 4);
          final result = modifier.invalid(invalidDate);
          expect(result, isTrue);
        });
        test('Returns true when date is invalid because of every', () {
          // December 3, 2023 is Sunday (not Monday).
          final invalidDate = DateTime(2023, 12, 3);
          final result = modifier.invalid(invalidDate);
          expect(result, isTrue);
        });
      });
    });

    group('Skip invalid behavior:', () {
      test('Skips first Monday of month', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 11, 2023 is Monday (skips December 4, first Monday).
        final expected = DateTime(2023, 12, 11);
        expect(modifier, hasNext(expected).withInput(inputDate));
      });

      test('Normal Monday generation when not first Monday', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // December 11, 2023 is Monday (not first Monday).
        final expected = DateTime(2023, 12, 11);
        expect(modifier, hasNext(expected).withInput(inputDate));
      });

      test('Previous skips first Monday of month', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 27, 2023 is Monday (skips December 4, first Monday).
        final expected = DateTime(2023, 11, 27);
        expect(modifier, hasPrevious(expected).withInput(inputDate));
      });
    });

    group('Explicit datetime tests:', () {
      test('Skip first Monday calculation', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 11, 2023 is Monday (skips December 4, first Monday).
        final expectedDate = DateTime(2023, 12, 11);
        expect(modifier, hasNext(expectedDate).withInput(inputDate));
      });

      test('Previous calculation with skip', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 27, 2023 is Monday (skips December 4, first Monday).
        final expectedDate = DateTime(2023, 11, 27);
        expect(modifier, hasPrevious(expectedDate).withInput(inputDate));
      });

      test('Edge case: limit reached in next', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 1, 2023 is before input date.
        final limitDate = DateTime(2023, 12);
        expect(
          () => modifier.next(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Edge case: limit reached in previous', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 28, 2023 is after expected previous date.
        final limitDate = DateTime(2023, 11, 28);
        expect(
          () => modifier.previous(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Limit is exactly the expected date', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 11, 2023 is Monday.
        final expectedDate = DateTime(2023, 12, 11);
        expect(
          modifier,
          hasNext(expectedDate).withInput(inputDate, limit: expectedDate),
        );
      });
    });

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        final inputWithTime = DateTime(2023, 12, 3, 14, 30, 45, 123, 456);
        final result = modifier.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });

      test('Maintains time components in UTC DateTime', () {
        final inputWithTime = DateTime.utc(2023, 12, 3, 14, 30, 45, 123, 456);
        final result = modifier.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isUtcDateTime);
      });

      test('Previous maintains time components in local DateTime', () {
        final inputWithTime = DateTime(2023, 12, 10, 9, 15, 30, 500, 250);
        final result = modifier.previous(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isLocalDateTime);
      });

      test('Previous maintains time components in UTC DateTime', () {
        final inputWithTime = DateTime.utc(2023, 12, 10, 9, 15, 30, 500, 250);
        final result = modifier.previous(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isUtcDateTime);
      });

      test('Normal generation with date-only input (local)', () {
        final inputDate = DateTime(2023, 12, 3);
        final expected = DateTime(2023, 12, 11);
        expect(modifier, hasNext(expected).withInput(inputDate));
      });

      test('Normal generation with date-only input (UTC)', () {
        final inputDate = DateTime.utc(2023, 12, 3);
        final expected = DateTime.utc(2023, 12, 11);
        expect(modifier, hasNext(expected).withInput(inputDate));
      });
    });

    group('Edge Cases', () {
      test('Limit validation in startDate', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 1, 2023 is before input date.
        final limitDate = DateTime(2023, 12);
        expect(
          () => modifier.startDate(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Limit validation in next', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 12, 2023 is after expected date.
        final limitDate = DateTime(2023, 12, 12);
        final expectedDate = DateTime(2023, 12, 11);
        expect(
          modifier,
          hasNext(expectedDate).withInput(inputDate, limit: limitDate),
        );
      });

      test('Limit validation in previous', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 26, 2023 is before expected date.
        final limitDate = DateTime(2023, 11, 26);
        final expectedDate = DateTime(2023, 11, 27);
        expect(
          modifier,
          hasPrevious(expectedDate).withInput(inputDate, limit: limitDate),
        );
      });

      test('First Monday of different months', () {
        // Test that first Monday is consistently skipped across months.
        // January 1, 2024 is Monday (first Monday).
        final jan1st = DateTime(2024);
        expect(modifier.valid(jan1st), isFalse);

        // February 5, 2024 is Monday (first Monday).
        final feb5th = DateTime(2024, 2, 5);
        expect(modifier.valid(feb5th), isFalse);

        // March 4, 2024 is Monday (first Monday).
        final mar4th = DateTime(2024, 3, 4);
        expect(modifier.valid(mar4th), isFalse);
      });
    });

    group('Equality', () {
      final modifier1 = EverySkipInvalidModifier(
        every: Weekday.monday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        ),
      );
      final modifier2 = EverySkipInvalidModifier(
        every: Weekday.monday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.second,
          day: Weekday.monday,
        ),
      );
      final modifier3 = EverySkipInvalidModifier(
        every: Weekday.tuesday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        ),
      );
      final modifier4 = EverySkipInvalidModifier(
        every: Weekday.monday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        ),
      );

      test('Same instance', () {
        expect(modifier1, equals(modifier1));
      });
      test('Same every, different invalidator', () {
        expect(modifier1, isNot(equals(modifier2)));
      });
      test('Different every, same invalidator', () {
        expect(modifier1, isNot(equals(modifier3)));
      });
      test('Same every, same invalidator', () {
        expect(modifier1, equals(modifier4));
      });
    });
  });
}
