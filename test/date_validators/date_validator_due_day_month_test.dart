import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';

void main() {
  group('DateValidatorDueDayMonth:', () {
    for (var day = 1; day <= 31; day++) {
      group('Day $day', () {
        final validator = DateValidatorDueDayMonth(day);
        test('Is valid for day $day', () {
          final date = DateTime(2022, DateTime.january, day);
          expect(validator, isValid(date));
        });

        final add = day == 1 ? 1 : -1;
        test('Is not valid for day $day', () {
          final invalidDate = DateTime(2022, DateTime.january, day + add);
          expect(validator, isInvalid(invalidDate));
        });
      });
    }
    group('Day 31 not exact', () {
      const validator = DateValidatorDueDayMonth(31);
      group('Is valid', () {
        test('February', () {
          expect(
            validator,
            isValid(DateTime(2022, DateTime.february, 28)),
          );
        });
        test('September', () {
          expect(
            validator,
            isValid(DateTime(2022, DateTime.september, 30)),
          );
        });
      });
      test('Is not valid', () {
        expect(
          validator,
          isInvalid(DateTime(2022, DateTime.september, 27)),
        );
      });
    });

    group('Day 31 exact', () {
      const validator = DateValidatorDueDayMonth(31, exact: true);
      test('Is valid', () {
        expect(
          validator,
          isValid(DateTime(2022, DateTime.october, 31)),
        );
      });
      group('Is not valid', () {
        test('February', () {
          expect(
            validator,
            isInvalid(DateTime(2022, DateTime.february, 28)),
          );
        });
        test('September', () {
          expect(
            validator,
            isInvalid(DateTime(2022, DateTime.september, 27)),
          );
        });
      });
    });
  });
}
