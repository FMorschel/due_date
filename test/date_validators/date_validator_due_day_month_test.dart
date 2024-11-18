import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorDueDayMonth:', () {
    group('Day 2', () {
      const validator = DateValidatorDueDayMonth(2);
      test('Is valid', () {
        expect(validator.valid(DateTime(2022, DateTime.september, 2)), isTrue);
      });

      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
    group('Day 31 not exact', () {
      const validator = DateValidatorDueDayMonth(31);
      group('Is valid', () {
        test('February', () {
          expect(
            validator.valid(DateTime(2022, DateTime.february, 28)),
            isTrue,
          );
        });
        test('September', () {
          expect(
            validator.valid(DateTime(2022, DateTime.september, 30)),
            isTrue,
          );
        });
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
    group('Day 31 exact', () {
      const validator = DateValidatorDueDayMonth(31, exact: true);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.october, 31)),
          isTrue,
        );
      });
      group('Is not valid', () {
        test('February', () {
          expect(
            validator.valid(DateTime(2022, DateTime.february, 28)),
            isFalse,
          );
        });
        test('September', () {
          expect(
            validator.valid(DateTime(2022, DateTime.september, 27)),
            isFalse,
          );
        });
      });
    });
  });
}
