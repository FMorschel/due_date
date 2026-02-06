import 'package:due_date/src/date_validators/built_in/date_validator_day_in_year.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_due_day_month.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_weekday.dart';
import 'package:due_date/src/date_validators/date_validator.dart';
import 'package:due_date/src/date_validators/group/date_validator_intersection.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';

void main() {
  group('DateValidatorIntersection', () {
    group('Constructor', () {
      test('Valid basic case', () {
        expect(
          DateValidatorIntersection([
            DateValidatorDueDayMonth(1),
            DateValidatorWeekday(Weekday.sunday),
          ]),
          isNotNull,
        );
      });
      test('Empty list doesnt throw', () {
        expect(
          DateValidatorIntersection<DateValidator>([]),
          isNotNull,
        );
      });
      test('Single validator is allowed', () {
        expect(
          DateValidatorIntersection([DateValidatorDueDayMonth(1)]),
          isNotNull,
        );
      });
      test('Properties are set correctly', () {
        final validators = [
          DateValidatorDueDayMonth(2),
          DateValidatorWeekday(Weekday.friday),
        ];
        final intersection = DateValidatorIntersection(validators);
        expect(intersection.validators, equals(validators));
      });
    });

    group('valid:', () {
      final validator = DateValidatorIntersection([
        DateValidatorDueDayMonth(24),
        DateValidatorWeekday(Weekday.saturday),
      ]);
      test('All validators match', () {
        // September 24, 2022 is Saturday and 24th.
        final date = DateTime(2022, DateTime.september, 24);
        expect(validator, isValid(date));
      });
      test('Invalid when only day matches', () {
        // August 24, 2022 is Wednesday, not Saturday.
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator, isInvalid(date));
      });
      test('Invalid when only weekday matches', () {
        // September 17, 2022 is Saturday but not 24th.
        final date = DateTime(2022, DateTime.september, 17);
        expect(validator, isInvalid(date));
      });
      test('Invalid when no validators match', () {
        // September 23, 2022 is Friday and 23rd.
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator, isInvalid(date));
      });
    });

    group('Edge Cases', () {
      test('Empty list always valid', () {
        final validator = DateValidatorIntersection<DateValidator>([]);
        final date = DateTime(2022);
        expect(validator, isValid(date));
      });
      test('Single validator behaves normally', () {
        final validator = DateValidatorIntersection([
          DateValidatorDueDayMonth(1),
        ]);
        final validDate = DateTime(2022);
        final invalidDate = DateTime(2022, 1, 2);
        expect(validator, isValid(validDate));
        expect(validator, isInvalid(invalidDate));
      });
      test('Duplicate validators', () {
        final validator = DateValidatorIntersection([
          DateValidatorDueDayMonth(1),
          DateValidatorDueDayMonth(1),
        ]);
        // Date matches both identical validators.
        final date = DateTime(2022);
        expect(validator, isValid(date));
      });
      test('Three validators all matching', () {
        final validator = DateValidatorIntersection([
          DateValidatorDueDayMonth(3),
          DateValidatorWeekday(Weekday.monday),
          DateValidatorDayInYear(3),
        ]);
        // January 3, 2022 is Monday, 3rd, and 3rd day of year.
        final date = DateTime(2022, 1, 3);
        expect(validator, isValid(date));
      });
      test('Three validators with one not matching', () {
        final validator = DateValidatorIntersection([
          DateValidatorDueDayMonth(3),
          // Should be Monday.
          DateValidatorWeekday(Weekday.tuesday),
          DateValidatorDayInYear(3),
        ]);
        // January 3, 2022 is Monday, not Tuesday.
        final date = DateTime(2022, 1, 3);
        expect(validator, isInvalid(date));
      });
      test('Validators with no possible overlap', () {
        final validator = DateValidatorIntersection([
          DateValidatorDueDayMonth(31, exact: true),
          DateValidatorWeekday(Weekday.monday),
        ]);
        // February 28th, 2022 is Monday, but exact day 31 doesn't exist in
        // February.
        final date = DateTime(2022, 2, 28);
        expect(validator, isInvalid(date));
      });
    });

    group('Equality', () {
      final validator1 = DateValidatorIntersection([
        DateValidatorDueDayMonth(1),
        DateValidatorWeekday(Weekday.sunday),
      ]);
      final validator2 = DateValidatorIntersection([
        DateValidatorDueDayMonth(1),
        DateValidatorWeekday(Weekday.sunday),
      ]);
      final validator3 = DateValidatorIntersection([
        DateValidatorDueDayMonth(2),
        DateValidatorWeekday(Weekday.sunday),
      ]);
      final validator4 = DateValidatorIntersection([
        DateValidatorWeekday(Weekday.sunday),
        DateValidatorDueDayMonth(1),
      ]);

      test('Same instance', () {
        expect(validator1, equals(validator1));
      });
      test('Same validators, same order', () {
        expect(validator1, equals(validator2));
      });
      test('Different validators', () {
        expect(validator1, isNot(equals(validator3)));
      });
      test('Same validators, different order', () {
        expect(validator1, isNot(equals(validator4)));
      });
      test('Hash code consistency', () {
        expect(validator1.hashCode, equals(validator2.hashCode));
      });
    });
  });
}
