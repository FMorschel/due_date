import 'package:due_date/src/date_validators/built_in/date_validator_weekday.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/limited_every_time_of_day_adapter.dart';
import 'package:due_date/src/everies/built_in/every_due_time_of_day.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

void main() {
  group('LimitedEveryTimeOfDayAdapter:', () {
    final every = Weekday.monday.every;
    final validator = DateValidatorWeekday(Weekday.monday);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            LimitedEveryTimeOfDayAdapter(
              every: every,
              validator: validator,
            ),
            isNotNull,
          );
        });
        test('Can be created as constant', () {
          const adapter = LimitedEveryTimeOfDayAdapter(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
          );
          expect(adapter, isNotNull);
        });
        test('Creates with correct every', () {
          final adapter = LimitedEveryTimeOfDayAdapter(
            every: every,
            validator: validator,
          );
          expect(adapter.every, equals(every));
        });
        test('Creates with correct validator', () {
          final adapter = LimitedEveryTimeOfDayAdapter(
            every: every,
            validator: validator,
          );
          expect(adapter.validator, equals(validator));
        });
        test('Default everyTimeOfDay is midnight', () {
          final adapter = LimitedEveryTimeOfDayAdapter(
            every: every,
            validator: validator,
          );
          expect(adapter.everyTimeOfDay, equals(EveryDueTimeOfDay.midnight));
        });
        test('Creates with custom everyTimeOfDay', () {
          const customTime =
              EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
          final adapter = LimitedEveryTimeOfDayAdapter(
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
        final adapter = LimitedEveryTimeOfDayAdapter(
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
          test('Accepts limit parameter', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 31, 2024 is Wednesday.
            final limit = DateTime(2024, 7, 31);
            final result = adapter.startDate(validDate, limit: limit);
            expect(result, isNotNull);
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
          test('Accepts limit parameter', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 31, 2024 is Wednesday.
            final limit = DateTime(2024, 7, 31);
            final result = adapter.next(validDate, limit: limit);
            expect(result, isNotNull);
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
              'Generates previous occurrence at midnight from non-midnight'
              ' input', () {
            // July 8, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 8, 15, 30);
            // July 1, 2024 at 00:00.
            final expected = DateTime(2024, 7);
            expect(adapter, hasPrevious(expected).withInput(validDate));
          });
          test('Accepts limit parameter', () {
            // July 8, 2024 is Monday.
            final validDate = DateTime(2024, 7, 8);
            // June 1, 2024 is Saturday.
            final limit = DateTime(2024, 6);
            final result = adapter.previous(validDate, limit: limit);
            expect(result, isNotNull);
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
          test('Accepts limit parameter', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // June 1, 2024 is Saturday.
            final limit = DateTime(2024, 6);
            final result = adapter.endDate(validDate, limit: limit);
            expect(result, isNotNull);
          });
        });
      });

      group('Custom time of day', () {
        const customTime = EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
        final adapter = LimitedEveryTimeOfDayAdapter(
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
        final adapter = LimitedEveryTimeOfDayAdapter(
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
    });

    group('Limit handling:', () {
      final adapter = LimitedEveryTimeOfDayAdapter(
        every: every,
        validator: validator,
      );

      test('Throws when limit is reached in next', () {
        // July 1, 2024 is Monday.
        final inputDate = DateTime(2024, 7);
        // July 2, 2024 is Tuesday (before expected result).
        final limitDate = DateTime(2024, 7, 2);
        expect(
          () => adapter.next(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Throws when limit is reached in previous', () {
        // July 8, 2024 is Monday.
        final inputDate = DateTime(2024, 7, 8);
        // July 2, 2024 is Tuesday (after expected result).
        final limitDate = DateTime(2024, 7, 2);
        expect(
          () => adapter.previous(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });
    });

    group('Equality', () {
      final adapter1 = LimitedEveryTimeOfDayAdapter(
        every: every,
        validator: validator,
      );
      final adapter2 = LimitedEveryTimeOfDayAdapter(
        every: every,
        validator: validator,
      );
      const customTime = EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
      final adapter3 = LimitedEveryTimeOfDayAdapter(
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
