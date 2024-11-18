import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorDayInYear', () {
    group('Day 1', () {
      const validator = DateValidatorDayInYear(1);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 2)),
          isFalse,
        );
      });
    });
    group('Day 365', () {
      const validator = DateValidatorDayInYear(365);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.december, 31)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 2)),
          isFalse,
        );
      });
    });
    group('Day 366 not exact', () {
      const validator = DateValidatorDayInYear(366);
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 31)),
          isFalse,
        );
      });
      group('Is valid', () {
        test('2022', () {
          expect(
            validator.valid(DateTime(2022, DateTime.december, 31)),
            isTrue,
          );
        });
        test('2020', () {
          expect(
            validator.valid(DateTime(2020, DateTime.december, 31)),
            isTrue,
          );
        });
      });
    });
    group('Day 366 exact', () {
      const validator = DateValidatorDayInYear(366, exact: true);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2020, DateTime.december, 31)),
          isTrue,
        );
      });
      group('Is not valid', () {
        test('January 2nd', () {
          expect(
            validator.valid(DateTime(2022, DateTime.january, 2)),
            isFalse,
          );
        });
        test('December 31st 2022', () {
          expect(
            validator.valid(DateTime(2022, DateTime.december, 31)),
            isFalse,
          );
        });
      });
    });
  });
}
