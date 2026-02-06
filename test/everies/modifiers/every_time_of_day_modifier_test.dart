import 'package:due_date/src/date_validators/built_in/date_validator_weekday_count_in_month.dart';
import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/every_adapter_invalidator.dart';
import 'package:due_date/src/everies/adapters/every_adapter_invalidator_mixin.dart';
import 'package:due_date/src/everies/built_in/every_due_time_of_day.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/modifiers/every_time_of_day_modifier.dart';
import 'package:test/test.dart';

import '../../src/every_incompatible_validator_and_generator.dart';
import '../../src/every_match.dart';

void main() {
  group('EveryTimeOfDayModifier:', () {
    const every = EveryWeekday(Weekday.monday);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EveryTimeOfDayModifier(every: every),
            isNotNull,
          );
        });
        test('Can be created as constant', () {
          const modifier = EveryTimeOfDayModifier(
            every: EveryWeekday(Weekday.monday),
          );
          expect(modifier, isNotNull);
        });
        test('Creates with correct every', () {
          final modifier = EveryTimeOfDayModifier(every: every);
          expect(modifier.every, equals(every));
        });
        test('Default everyTimeOfDay is midnight', () {
          final modifier = EveryTimeOfDayModifier(every: every);
          expect(modifier.everyTimeOfDay, equals(EveryDueTimeOfDay.midnight));
        });
        test('Creates with custom everyTimeOfDay', () {
          const customTime =
              EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
          final modifier = EveryTimeOfDayModifier(
            every: every,
            everyTimeOfDay: customTime,
          );
          expect(modifier.everyTimeOfDay, equals(customTime));
        });
      });
    });

    group('Methods', () {
      group('Selective validator (first Monday)', () {
        final modifierIncompatibleValidatorAndGenerator =
            EveryTimeOfDayModifier(
          every: EveryIncompatibleValidatorAndGeneratorTest(),
          everyTimeOfDay: const EveryDueTimeOfDay(Duration(hours: 10)),
        );

        group('startDate', () {
          test('Recursively finds next valid date when given second Monday',
              () {
            // July 8, 2024 is the second Monday of July.
            final secondMonday = DateTime(2024, 7, 8);
            // August 5, 2024 is the first Monday of August at 10:00.
            final expected = DateTime(2024, 8, 5, 10);
            expect(
              modifierIncompatibleValidatorAndGenerator,
              startsAt(expected).withInput(secondMonday),
            );
          });
          test('Recursively finds next valid date when given third Monday', () {
            // July 15, 2024 is the third Monday of July.
            final thirdMonday = DateTime(2024, 7, 15);
            // August 5, 2024 is the first Monday of August at 10:00.
            final expected = DateTime(2024, 8, 5, 10);
            expect(
              modifierIncompatibleValidatorAndGenerator,
              startsAt(expected).withInput(thirdMonday),
            );
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
            expect(
              modifierIncompatibleValidatorAndGenerator,
              endsAt(expected).withInput(secondMonday),
            );
          });
          test('Recursively finds previous valid date when given third Monday',
              () {
            // July 22, 2024 is the fourth Monday of July.
            final thirdMonday = DateTime(2024, 7, 22);
            // July 1, 2024 is the first Monday of July at 10:00.
            final expected = DateTime(2024, 7, 1, 10);
            expect(
              modifierIncompatibleValidatorAndGenerator,
              endsAt(expected).withInput(thirdMonday),
            );
          });
        });
      });
      group('Default midnight', () {

        final modifier = EveryTimeOfDayModifier(every: every);
        group('startDate', () {
          test('Returns same date at midnight when input is valid', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(modifier, startsAtSameDate.withInput(validDate));
          });
          test('Returns next valid date at midnight when input is invalid', () {
            // July 2, 2024 is Tuesday.
            final invalidDate = DateTime(2024, 7, 2);
            // July 8, 2024 is Monday.
            final expected = DateTime(2024, 7, 8);
            expect(modifier, startsAt(expected).withInput(invalidDate));
          });
          test('Sets time to midnight from non-midnight input', () {
            // July 1, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 1, 15, 30);
            // July 1, 2024 at 00:00.
            final expected = DateTime(2024, 7);
            expect(modifier, startsAt(expected).withInput(validDate));
          });
        });

        group('next', () {
          test('Always generates date after input', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(modifier, nextIsAfter.withInput(validDate));
          });
          test('Generates next occurrence at midnight', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 8, 2024 is Monday at 00:00.
            final expected = DateTime(2024, 7, 8);
            expect(modifier, hasNext(expected).withInput(validDate));
          });
          test('Generates next occurrence at midnight from non-midnight input',
              () {
            // July 1, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 1, 15, 30);
            // July 8, 2024 at 00:00.
            final expected = DateTime(2024, 7, 8);
            expect(modifier, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Always generates date before input', () {
            // July 8, 2024 is Monday.
            final validDate = DateTime(2024, 7, 8);
            expect(modifier, previousIsBefore.withInput(validDate));
          });
          test('Generates previous occurrence at midnight', () {
            // July 8, 2024 is Monday.
            final validDate = DateTime(2024, 7, 8);
            // July 1, 2024 is Monday at 00:00.
            final expected = DateTime(2024, 7);
            expect(modifier, hasPrevious(expected).withInput(validDate));
          });
          test(
              'Generates previous occurrence at midnight from non-midnight '
              'input', () {
            // July 8, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 8, 15, 30);
            // July 1, 2024 at 00:00.
            final expected = DateTime(2024, 7);
            expect(modifier, hasPrevious(expected).withInput(validDate));
          });
        });

        group('endDate', () {
          test('Returns same date at midnight when input is valid', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(modifier, endsAtSameDate.withInput(validDate));
          });
          test('Returns previous valid date at midnight when input is invalid',
              () {
            // July 2, 2024 is Tuesday.
            final invalidDate = DateTime(2024, 7, 2);
            // July 1, 2024 is Monday.
            final expected = DateTime(2024, 7);
            expect(modifier, endsAt(expected).withInput(invalidDate));
          });
          test('Sets time to midnight from non-midnight input', () {
            // July 1, 2024 at 15:30.
            final validDate = DateTime(2024, 7, 1, 15, 30);
            // July 1, 2024 at 00:00.
            final expected = DateTime(2024, 7);
            expect(modifier, endsAt(expected).withInput(validDate));
          });
        });
      });

      group('Custom time of day', () {
        const customTime = EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
        final modifier = EveryTimeOfDayModifier(
          every: every,
          everyTimeOfDay: customTime,
        );

        group('startDate', () {
          test('Returns same date at custom time when input is valid', () {
            // July 1, 2024 is Monday at 14:30.
            final validDate = DateTime(2024, 7, 1, 14, 30);
            expect(modifier, startsAtSameDate.withInput(validDate));
          });
          test('Sets time to custom time from different input time', () {
            // July 1, 2024 at 09:00.
            final validDate = DateTime(2024, 7, 1, 9);
            // July 1, 2024 at 14:30.
            final expected = DateTime(2024, 7, 1, 14, 30);
            expect(modifier, startsAt(expected).withInput(validDate));
          });
          test('Returns next valid date at custom time when input is invalid',
              () {
            // July 2, 2024 is Tuesday.
            final invalidDate = DateTime(2024, 7, 2);
            // July 8, 2024 is Monday at 14:30.
            final expected = DateTime(2024, 7, 8, 14, 30);
            expect(modifier, startsAt(expected).withInput(invalidDate));
          });
        });

        group('next', () {
          test('Generates next occurrence at custom time', () {
            // July 1, 2024 at 14:30.
            final validDate = DateTime(2024, 7, 1, 14, 30);
            // July 8, 2024 at 14:30.
            final expected = DateTime(2024, 7, 8, 14, 30);
            expect(modifier, hasNext(expected).withInput(validDate));
          });
          test('Generates next occurrence at custom time from midnight input',
              () {
            // July 1, 2024 at 00:00.
            final validDate = DateTime(2024, 7);
            // July 8, 2024 at 14:30.
            final expected = DateTime(2024, 7, 8, 14, 30);
            expect(modifier, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Generates previous occurrence at custom time', () {
            // July 8, 2024 at 14:30.
            final validDate = DateTime(2024, 7, 8, 14, 30);
            // July 1, 2024 at 14:30.
            final expected = DateTime(2024, 7, 1, 14, 30);
            expect(modifier, hasPrevious(expected).withInput(validDate));
          });
        });

        group('endDate', () {
          test('Returns same date at custom time when input is valid', () {
            // July 1, 2024 at 14:30.
            final validDate = DateTime(2024, 7, 1, 14, 30);
            expect(modifier, endsAtSameDate.withInput(validDate));
          });
          test('Sets time to custom time from different input time', () {
            // July 1, 2024 at 09:00.
            final validDate = DateTime(2024, 7, 1, 9);
            // July 1, 2024 at 14:30.
            final expected = DateTime(2024, 7, 1, 14, 30);
            expect(modifier, endsAt(expected).withInput(validDate));
          });
          test(
              'Returns previous valid date at custom time when input is '
              'invalid', () {
            // July 2, 2024 is Tuesday.
            final invalidDate = DateTime(2024, 7, 2);
            // July 1, 2024 is Monday at 14:30.
            final expected = DateTime(2024, 7, 1, 14, 30);
            expect(modifier, endsAt(expected).withInput(invalidDate));
          });
        });
      });

      group('valid', () {
        final modifier = EveryTimeOfDayModifier(every: every);

        test('Returns true when date is valid', () {
          // July 1, 2024 is Monday at midnight.
          final validDate = DateTime(2024, 7);
          final result = modifier.valid(validDate);
          expect(result, isTrue);
        });
        test('Returns false when date is invalid', () {
          // July 2, 2024 is Tuesday.
          final invalidDate = DateTime(2024, 7, 2);
          final result = modifier.valid(invalidDate);
          expect(result, isFalse);
        });
        test('Returns false when time is invalid', () {
          // July 1, 2024 is Monday at 15:30 (not midnight).
          final invalidTime = DateTime(2024, 7, 1, 15, 30);
          final result = modifier.valid(invalidTime);
          expect(result, isFalse);
        });
      });
    });

    group('Equality', () {
      final modifier1 = EveryTimeOfDayModifier(every: every);
      final modifier2 = EveryTimeOfDayModifier(every: every);
      const customTime = EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
      final modifier3 = EveryTimeOfDayModifier(
        every: every,
        everyTimeOfDay: customTime,
      );
      const differentEvery = EveryWeekday(Weekday.tuesday);
      final modifier4 = EveryTimeOfDayModifier(every: differentEvery);

      test('Same instance', () {
        expect(modifier1, equals(modifier1));
      });
      test('Same properties are equal', () {
        expect(modifier1, equals(modifier2));
      });
      test('Different everyTimeOfDay are not equal', () {
        expect(modifier1, isNot(equals(modifier3)));
      });
      test('Different every are not equal', () {
        expect(modifier1, isNot(equals(modifier4)));
      });
      test('hashCode is consistent', () {
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });
    });
  });
}
