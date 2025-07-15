import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';

void main() {
  group('DateValidatorDifference', () {
    group('Constructor', () {
      test('Valid basic case', () {
        expect(
          DateValidatorDifference([
            DateValidatorDueDayMonth(1),
            DateValidatorWeekday(Weekday.sunday),
          ]),
          isNotNull,
        );
      });
      test('Empty list doesnt throw', () {
        expect(
          DateValidatorDifference<DateValidator>([]),
          isNotNull,
        );
      });
      test('Single validator is allowed', () {
        expect(
          DateValidatorDifference([DateValidatorDueDayMonth(1)]),
          isNotNull,
        );
      });
      test('Properties are set correctly', () {
        final validators = [
          DateValidatorDueDayMonth(2),
          DateValidatorWeekday(Weekday.friday),
        ];
        final difference = DateValidatorDifference(validators);
        expect(difference.validators, equals(validators));
      });
    });

    group('valid:', () {
      final validator = DateValidatorDifference([
        DateValidatorDueDayMonth(24),
        DateValidatorWeekday(Weekday.saturday),
      ]);
      test('Valid for day only', () {
        // 24th is Wednesday.
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator, isValid(date));
      });
      test('Valid for weekday only', () {
        // 17th is Saturday.
        final date = DateTime(2022, DateTime.september, 17);
        expect(validator, isValid(date));
      });
      test('Invalid when all validators match', () {
        // 24th is Saturday.
        final date = DateTime(2022, DateTime.september, 24);
        expect(validator, isInvalid(date));
      });
      test('Invalid when no validators match', () {
        // 23rd is Friday.
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator, isInvalid(date));
      });
    });

    group('Edge Cases', () {
      test('Empty list always invalid', () {
        final validator = DateValidatorDifference<DateValidator>([]);
        final date = DateTime(2022);
        expect(validator, isInvalid(date));
      });
      test('Single validator behaves normally', () {
        final validator = DateValidatorDifference([
          DateValidatorDueDayMonth(1),
        ]);
        final validDate = DateTime(2022);
        final invalidDate = DateTime(2022, 1, 2);
        expect(validator, isValid(validDate));
        expect(validator, isInvalid(invalidDate));
      });
      test('Duplicate validators', () {
        final validator = DateValidatorDifference([
          DateValidatorDueDayMonth(1),
          DateValidatorDueDayMonth(1),
        ]);
        // Date matches both validators, so it should be invalid.
        final date = DateTime(2022);
        expect(validator, isInvalid(date));
      });
      test('Three validators with one match', () {
        final validator = DateValidatorDifference([
          DateValidatorDueDayMonth(1),
          DateValidatorDueDayMonth(2),
          DateValidatorWeekday(Weekday.monday),
        ]);
        // January 3, 2022 is Monday, so only weekday validator matches.
        final date = DateTime(2022, 1, 3);
        expect(validator, isValid(date));
      });
      test('Three validators with two matches', () {
        final validator = DateValidatorDifference([
          DateValidatorDueDayMonth(3),
          DateValidatorDueDayMonth(2),
          DateValidatorWeekday(Weekday.monday),
        ]);
        // January 3, 2022 is Monday and 3rd, so two validators match.
        final date = DateTime(2022, 1, 3);
        expect(validator, isInvalid(date));
      });
      test('Three validators with all matches', () {
        final validator = DateValidatorDifference([
          DateValidatorDueDayMonth(3),
          DateValidatorWeekday(Weekday.monday),
          DateValidatorDayInYear(3),
        ]);
        // January 3, 2022 is Monday, 3rd, and 3rd day of year.
        final date = DateTime(2022, 1, 3);
        expect(validator, isInvalid(date));
      });
    });

    group('Equality', () {
      final validator1 = DateValidatorDifference([
        DateValidatorDueDayMonth(1),
        DateValidatorWeekday(Weekday.sunday),
      ]);
      final validator2 = DateValidatorDifference([
        DateValidatorDueDayMonth(1),
        DateValidatorWeekday(Weekday.sunday),
      ]);
      final validator3 = DateValidatorDifference([
        DateValidatorDueDayMonth(2),
        DateValidatorWeekday(Weekday.sunday),
      ]);
      final validator4 = DateValidatorDifference([
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
