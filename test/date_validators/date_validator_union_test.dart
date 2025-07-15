import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';

void main() {
  group('DateValidatorUnion', () {
    group('Constructor', () {
      test('Valid basic case', () {
        expect(
          DateValidatorUnion([
            DateValidatorDueDayMonth(1),
            DateValidatorWeekday(Weekday.sunday),
          ]),
          isNotNull,
        );
      });
      test('Empty list doesnt throw', () {
        expect(
          DateValidatorUnion<DateValidator>([]),
          isNotNull,
        );
      });
      test('Single validator is allowed', () {
        expect(DateValidatorUnion([DateValidatorDueDayMonth(1)]), isNotNull);
      });
      test('Properties are set correctly', () {
        final validators = [
          DateValidatorDueDayMonth(2),
          DateValidatorWeekday(Weekday.friday),
        ];
        final union = DateValidatorUnion(validators);
        expect(union.validators, equals(validators));
      });
    });

    group('valid:', () {
      final validator = DateValidatorUnion([
        DateValidatorDueDayMonth(24),
        DateValidatorWeekday(Weekday.saturday),
      ]);
      test('All valid', () {
        // 24th is Saturday.
        final date = DateTime(2022, DateTime.september, 24);
        expect(validator, isValid(date));
      });
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
      test('Invalid', () {
        // 23rd is Friday.
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator, isInvalid(date));
      });
    });

    group('Edge Cases', () {
      test('Duplicate validators', () {
        final validator = DateValidatorUnion([
          DateValidatorDueDayMonth(1),
          DateValidatorDueDayMonth(1),
        ]);
        final date = DateTime(2022);
        expect(validator, isValid(date));
      });
      test('Validators with no overlap', () {
        final validator = DateValidatorUnion([
          DateValidatorDueDayMonth(1),
          DateValidatorDueDayMonth(2),
        ]);
        final date = DateTime(2022, 1, 3);
        expect(validator, isInvalid(date));
      });
    });

    group('Methods', () {
      test('Equality', () {
        final v1 = DateValidatorUnion([
          DateValidatorDueDayMonth(1),
          DateValidatorWeekday(Weekday.sunday),
        ]);
        final v2 = DateValidatorUnion([
          DateValidatorDueDayMonth(1),
          DateValidatorWeekday(Weekday.sunday),
        ]);
        final v3 = DateValidatorUnion([
          DateValidatorDueDayMonth(2),
          DateValidatorWeekday(Weekday.sunday),
        ]);
        expect(v1, equals(v2));
        expect(v1, isNot(equals(v3)));
        expect(v1.hashCode, equals(v2.hashCode));
      });
    });
  });
}
