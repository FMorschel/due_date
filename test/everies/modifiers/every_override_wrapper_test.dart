import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../../src/date_time_match.dart';
import '../../src/every_match.dart';

/// Basic Every implementation for testing that returns predefined dates.
class BasicEvery extends Every {
  const BasicEvery();

  @override
  DateTime next(DateTime date) => date;

  @override
  DateTime previous(DateTime date) => date;
}

void main() {
  group('EveryOverrideWrapper:', () {
    final every = Weekday.monday.every;
    const invalidator = DateValidatorWeekdayCountInMonth(
      week: Week.first,
      day: Weekday.monday,
    );
    final wrapper = EveryOverrideWrapper(
      every: every,
      invalidator: invalidator,
      overrider: Weekday.tuesday.every,
    );

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(wrapper, isNotNull);
        });
        test('Creates with correct every', () {
          expect(wrapper.every, equals(every));
        });
      });
    });

    group('Methods', () {
      group('next', () {
        test('Always generates date after input', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          expect(wrapper, nextIsAfter.withInput(validDate));
        });
        test('Generates next occurrence from valid date', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          // October 10, 2022 is Monday.
          final expected = DateTime(2022, DateTime.october, 10);
          expect(wrapper, hasNext(expected).withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          // September 27, 2022 is Tuesday.
          final invalidDate = DateTime(2022, DateTime.september, 27);
          // October 4, 2022 is Tuesday.
          final expected = DateTime(2022, DateTime.october, 4);
          expect(wrapper, hasNext(expected).withInput(invalidDate));
        });
      });

      group('previous', () {
        test('Always generates date before input', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          expect(wrapper, previousIsBefore.withInput(validDate));
        });
        test('Generates previous occurrence from valid date', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          // September 27, 2022 is Tuesday.
          final expected = DateTime(2022, DateTime.september, 27);
          expect(wrapper, hasPrevious(expected).withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          // September 27, 2022 is Tuesday.
          final invalidDate = DateTime(2022, DateTime.september, 27);
          // September 26, 2022 is Monday.
          final expected = DateTime(2022, DateTime.september, 26);
          expect(wrapper, hasPrevious(expected).withInput(invalidDate));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('Override first Monday with Tuesday calculation', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 5, 2023 is Tuesday (overriding first Monday).
        final expectedDate = DateTime(2023, 12, 5);
        expect(wrapper, hasNext(expectedDate).withInput(inputDate));
      });

      test('Previous calculation with override', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 28, 2023 is Tuesday.
        final expectedDate = DateTime(2023, 11, 28);
        expect(wrapper, hasPrevious(expectedDate).withInput(inputDate));
      });

      test('Edge case: limit reached in next', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 1, 2023 is before input date.
        final limitDate = DateTime(2023, 12);
        expect(
          () => wrapper.next(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Edge case: limit reached in previous', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 29, 2023 is after expected previous date.
        final limitDate = DateTime(2023, 11, 29);
        expect(
          () => wrapper.previous(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Limit is exactly the expected date', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 5, 2023 is Tuesday.
        final expectedDate = DateTime(2023, 12, 5);
        expect(
          wrapper,
          hasNext(expectedDate).withInput(inputDate, limit: expectedDate),
        );
      });
    });

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        final input = DateTime(2024, 1, 10, 14, 30, 45, 123, 456);
        final result = wrapper.next(input);
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });
      test('Maintains time components in UTC DateTime', () {
        final input = DateTime.utc(2024, 1, 10, 14, 30, 45, 123, 456);
        final result = wrapper.next(input);
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isUtcDateTime);
      });

      test('Previous maintains time components in local DateTime', () {
        final inputWithTime = DateTime(2023, 12, 10, 9, 15, 30, 500, 250);
        final result = wrapper.previous(inputWithTime);

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
        final result = wrapper.previous(inputWithTime);

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
        final expected = DateTime(2023, 12, 5);
        expect(wrapper, hasNext(expected).withInput(inputDate));
      });

      test('Normal generation with date-only input (UTC)', () {
        final inputDate = DateTime.utc(2023, 12, 3);
        final expected = DateTime.utc(2023, 12, 5);
        expect(wrapper, hasNext(expected).withInput(inputDate));
      });
    });

    group('Edge Cases', () {
      test('Limit validation in next', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 12, 2023 is after expected date.
        final limitDate = DateTime(2023, 12, 12);
        final expectedDate = DateTime(2023, 12, 5);
        expect(
          wrapper,
          hasNext(expectedDate).withInput(inputDate, limit: limitDate),
        );
      });

      test('Limit validation in previous', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 26, 2023 is before expected date.
        final limitDate = DateTime(2023, 11, 26);
        final expectedDate = DateTime(2023, 11, 28);
        expect(
          wrapper,
          hasPrevious(expectedDate).withInput(inputDate, limit: limitDate),
        );
      });
    });

    group('Equality', () {
      final wrapper1 = EveryOverrideWrapper(
        every: Weekday.monday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        ),
        overrider: Weekday.tuesday.every,
      );
      final wrapper2 = EveryOverrideWrapper(
        every: Weekday.monday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.second,
          day: Weekday.monday,
        ),
        overrider: Weekday.tuesday.every,
      );
      final wrapper3 = EveryOverrideWrapper(
        every: Weekday.tuesday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        ),
        overrider: Weekday.tuesday.every,
      );
      final wrapper4 = EveryOverrideWrapper(
        every: Weekday.monday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        ),
        overrider: Weekday.tuesday.every,
      );
      final wrapper5 = EveryOverrideWrapper(
        every: Weekday.monday.every,
        invalidator: DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        ),
        overrider: Weekday.wednesday.every,
      );

      test('Same instance', () {
        expect(wrapper1, equals(wrapper1));
      });
      test('Same every, different invalidator', () {
        expect(wrapper1, isNot(equals(wrapper2)));
      });
      test('Different every, same invalidator', () {
        expect(wrapper1, isNot(equals(wrapper3)));
      });
      test('Same every, same invalidator, same overrider', () {
        expect(wrapper1, equals(wrapper4));
      });
      test('Same every, same invalidator, different overrider', () {
        expect(wrapper1, isNot(equals(wrapper5)));
      });
    });
  });
}
