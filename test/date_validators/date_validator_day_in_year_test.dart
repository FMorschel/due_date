import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';
import '../src/extensions.dart';

void main() {
  group('DateValidatorDayInYear', () {
    for (var day = 1; day <= 366; day++) {
      group('Day $day', () {
        final validator = DateValidatorDayInYear(day);
        final date = day.dayIn(2020);
        test('Is valid for day ${date.dateStr} ($day)', () {
          expect(validator, isValid(date));
        });
        final add = day == 1 ? 1 : -1;
        final invalidDate = date.copyWith(day: date.day + add);
        test('Is invalid for day ${invalidDate.dateStr} ($day)', () {
          expect(validator, isInvalid(invalidDate));
        });
        if (day == 366) {
          final nonLeapYearEnd = 365.dayIn(2021);
          test('Is valid for day ${nonLeapYearEnd.dateStr} ($day)', () {
            expect(validator, isValid(nonLeapYearEnd));
          });
        }
      });
    }
    group('Day 366 not exact', () {
      const validator = DateValidatorDayInYear(366);
      group('Is valid', () {
        test('Leap year', () {
          expect(validator, isValid(366.dayIn(2020)));
        });
        test('Non-leap year', () {
          expect(validator, isValid(365.dayIn(2021)));
        });
      });
      test('Is not valid', () {
        expect(validator, isInvalid(364.dayIn(2021)));
      });
    });
    group('Day 366 exact', () {
      const validator = DateValidatorDayInYear(366, exact: true);
      test('Is valid', () {
        expect(validator, isValid(366.dayIn(2020)));
      });
      group('Is not valid', () {
        test('Non-leap year', () {
          expect(validator, isInvalid(365.dayIn(2021)));
        });
        test('Invalid day', () {
          expect(validator, isInvalid(364.dayIn(2021)));
        });
      });
    });
  });
}
