import 'package:due_date/src/date_validators/date_validator_weekday.dart';
import 'package:due_date/src/date_validators/date_validator_weekday_count_in_month.dart';
import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/every_time_of_day_adapter.dart';
import 'package:due_date/src/everies/built_in/every_due_time_of_day.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

void main() {
  group('EveryTimeOfDayAdapter:', () {
    final every = Weekday.monday.every;
    final validator = DateValidatorWeekday(Weekday.monday);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EveryTimeOfDayAdapter(
              every: every,
              validator: validator,
            ),
            isNotNull,
          );
        });
        test('Can be created as constant', () {
          const adapter = EveryTimeOfDayAdapter(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
          );
          expect(adapter, isNotNull);
        });
        test('Creates with correct every', () {
          final adapter = EveryTimeOfDayAdapter(
            every: every,
            validator: validator,
          );
          expect(adapter.every, equals(every));
        });
        test('Creates with correct validator', () {
          final adapter = EveryTimeOfDayAdapter(
            every: every,
            validator: validator,
          );
          expect(adapter.validator, equals(validator));
        });
        test('Default everyTimeOfDay is midnight', () {
          final adapter = EveryTimeOfDayAdapter(
            every: every,
            validator: validator,
          );
          expect(adapter.everyTimeOfDay, equals(EveryDueTimeOfDay.midnight));
        });
        test('Creates with custom everyTimeOfDay', () {
          const customTime =
              EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
          final adapter = EveryTimeOfDayAdapter(
            every: every,
            validator: validator,
            everyTimeOfDay: customTime,
          );
          expect(adapter.everyTimeOfDay, equals(customTime));
        });
      });
    });

    group('Methods', () {
      group('Default midnight', () {
        final adapter = EveryTimeOfDayAdapter(
          every: every,
          validator: validator,
        );

        group('startDate', () {
          test('Returns same date at midnight when input is valid', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(adapter, startsAtSameDate.withInput(validDate));
          });
          test('Returns next valid date at midnight when input is invalid', () {
            // July 2, 2024 is Tuesday.
            final invalidDate = DateTime(2024, 7, 2);
            // July 8, 2024 is Monday.
            final expected = DateTime(2024, 7, 8);
            expect(adapter, startsAt(expected).withInput(invalidDate));
          });
          test('Sets time to midnight from non-midnight input', () {
            // July 1, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 1, 15, 30);
            // July 1, 2024 at 00:00.
            final expected = DateTime(2024, 7);
            expect(adapter, startsAt(expected).withInput(validDate));
          });
        });

        group('next', () {
          test('Always generates date after input', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(adapter, nextIsAfter.withInput(validDate));
          });
          test('Generates next occurrence at midnight', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 8, 2024 is Monday at 00:00.
            final expected = DateTime(2024, 7, 8);
            expect(adapter, hasNext(expected).withInput(validDate));
          });
          test('Generates next occurrence at midnight from non-midnight input',
              () {
            // July 1, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 1, 15, 30);
            // July 8, 2024 at 00:00.
            final expected = DateTime(2024, 7, 8);
            expect(adapter, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Always generates date before input', () {
            // July 8, 2024 is Monday.
            final validDate = DateTime(2024, 7, 8);
            expect(adapter, previousIsBefore.withInput(validDate));
          });
          test('Generates previous occurrence at midnight', () {
            // July 8, 2024 is Monday.
            final validDate = DateTime(2024, 7, 8);
            // July 1, 2024 is Monday at 00:00.
            final expected = DateTime(2024, 7);
            expect(adapter, hasPrevious(expected).withInput(validDate));
          });
          test(
              'Generates previous occurrence at midnight from non-midnight '
              'input', () {
            // July 8, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 8, 15, 30);
            // July 1, 2024 at 00:00.
            final expected = DateTime(2024, 7);
            expect(adapter, hasPrevious(expected).withInput(validDate));
          });
        });

        group('endDate', () {
          test('Returns same date at midnight when input is valid', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(adapter, endsAtSameDate.withInput(validDate));
          });
          test('Returns previous valid date at midnight when input is invalid',
              () {
            // July 2, 2024 is Tuesday.
            final invalidDate = DateTime(2024, 7, 2);
            // July 1, 2024 is Monday.
            final expected = DateTime(2024, 7);
            expect(adapter, endsAt(expected).withInput(invalidDate));
          });
          test('Sets time to midnight from non-midnight input', () {
            // July 1, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 1, 15, 30);
            // July 1, 2024 at 00:00.
            final expected = DateTime(2024, 7);
            expect(adapter, endsAt(expected).withInput(validDate));
          });
        });
      });

      group('Custom time of day', () {
        const customTime = EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
        final adapter = EveryTimeOfDayAdapter(
          every: every,
          validator: validator,
          everyTimeOfDay: customTime,
        );

        group('startDate', () {
          test('Returns same date at custom time when input is valid', () {
            // July 1, 2024 is Monday at 14:30.
            final validDate = DateTime(2024, 7, 1, 14, 30);
            expect(adapter, startsAtSameDate.withInput(validDate));
          });
          test('Sets time to custom time from different input time', () {
            // July 1, 2024 at 09:00.
            final validDate = DateTime(2024, 7, 1, 9);
            // July 1, 2024 at 14:30.
            final expected = DateTime(2024, 7, 1, 14, 30);
            expect(adapter, startsAt(expected).withInput(validDate));
          });
        });

        group('next', () {
          test('Generates next occurrence at custom time', () {
            // July 1, 2024 at 14:30.
            final validDate = DateTime(2024, 7, 1, 14, 30);
            // July 8, 2024 at 14:30.
            final expected = DateTime(2024, 7, 8, 14, 30);
            expect(adapter, hasNext(expected).withInput(validDate));
          });
          test('Generates next occurrence at custom time from midnight input',
              () {
            // July 1, 2024 at 00:00.
            final validDate = DateTime(2024, 7);
            // July 8, 2024 at 14:30.
            final expected = DateTime(2024, 7, 8, 14, 30);
            expect(adapter, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Generates previous occurrence at custom time', () {
            // July 8, 2024 at 14:30.
            final validDate = DateTime(2024, 7, 8, 14, 30);
            // July 1, 2024 at 14:30.
            final expected = DateTime(2024, 7, 1, 14, 30);
            expect(adapter, hasPrevious(expected).withInput(validDate));
          });
        });

        group('endDate', () {
          test('Returns same date at custom time when input is valid', () {
            // July 1, 2024 at 14:30.
            final validDate = DateTime(2024, 7, 1, 14, 30);
            expect(adapter, endsAtSameDate.withInput(validDate));
          });
          test('Sets time to custom time from different input time', () {
            // July 1, 2024 at 09:00.
            final validDate = DateTime(2024, 7, 1, 9);
            // July 1, 2024 at 14:30.
            final expected = DateTime(2024, 7, 1, 14, 30);
            expect(adapter, endsAt(expected).withInput(validDate));
          });
        });
      });

      group('valid', () {
        final adapter = EveryTimeOfDayAdapter(
          every: every,
          validator: validator,
        );

        test('Returns true when date is valid', () {
          // July 1, 2024 is Monday.
          final validDate = DateTime(2024, 7);
          final result = adapter.valid(validDate);
          expect(result, isTrue);
        });
        test('Returns false when date is invalid', () {
          // July 2, 2024 is Tuesday.
          final invalidDate = DateTime(2024, 7, 2);
          final result = adapter.valid(invalidDate);
          expect(result, isFalse);
        });
      });

      group('Selective validator (first Monday)', () {
        // Every Monday, but validator only accepts first Monday of month.
        final selectiveEvery = Weekday.monday.every;
        const selectiveValidator = DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        );
        const customTime = EveryDueTimeOfDay(Duration(hours: 10));

        final adapter = EveryTimeOfDayAdapter(
          every: selectiveEvery,
          validator: selectiveValidator,
          everyTimeOfDay: customTime,
        );

        group('startDate', () {
          test('Recursively finds next valid date when given second Monday',
              () {
            // July 8, 2024 is the second Monday of July.
            final secondMonday = DateTime(2024, 7, 8);
            // August 5, 2024 is the first Monday of August at 10:00.
            final expected = DateTime(2024, 8, 5, 10);
            expect(adapter, startsAt(expected).withInput(secondMonday));
          });
          test('Recursively finds next valid date when given third Monday', () {
            // July 15, 2024 is the third Monday of July.
            final thirdMonday = DateTime(2024, 7, 15);
            // August 5, 2024 is the first Monday of August at 10:00.
            final expected = DateTime(2024, 8, 5, 10);
            expect(adapter, startsAt(expected).withInput(thirdMonday));
          });
        });

        group('endDate', () {
          test(
              'Recursively finds previous valid date when given second '
              'Monday', () {
            // July 8, 2024 is the second Monday of July.
            final secondMonday = DateTime(2024, 7, 8);
            // July 1, 2024 is the first Monday of July at 10:00.
            final expected = DateTime(2024, 7, 1, 10);
            expect(adapter, endsAt(expected).withInput(secondMonday));
          });
          test('Recursively finds previous valid date when given third Monday',
              () {
            // July 15, 2024 is the third Monday of July.
            final thirdMonday = DateTime(2024, 7, 15);
            // July 1, 2024 is the first Monday of July at 10:00.
            final expected = DateTime(2024, 7, 1, 10);
            expect(adapter, endsAt(expected).withInput(thirdMonday));
          });
        });
      });
    });

    group('Equality', () {
      final adapter1 = EveryTimeOfDayAdapter(
        every: every,
        validator: validator,
      );
      final adapter2 = EveryTimeOfDayAdapter(
        every: every,
        validator: validator,
      );
      const customTime = EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
      final adapter3 = EveryTimeOfDayAdapter(
        every: every,
        validator: validator,
        everyTimeOfDay: customTime,
      );

      test('Same properties are equal', () {
        expect(adapter1, equals(adapter2));
      });
      test('Different everyTimeOfDay are not equal', () {
        expect(adapter1, isNot(equals(adapter3)));
      });
      test('hashCode is consistent', () {
        expect(adapter1.hashCode, equals(adapter2.hashCode));
      });
    });
  });
}
