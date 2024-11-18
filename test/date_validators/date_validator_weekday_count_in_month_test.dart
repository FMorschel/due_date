import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorWeekdayCountInMonth', () {
    group('First Monday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.monday,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 5)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 6)),
          isFalse,
        );
      });
    });
    group('Second Tuesday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.tuesday,
        week: Week.second,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 13)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 5)),
          isFalse,
        );
      });
    });
    group('Third Wednesday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.wednesday,
        week: Week.third,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 21)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 12)),
          isFalse,
        );
      });
    });
    group('Fourth Thursday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.thursday,
        week: Week.fourth,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 22)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 19)),
          isFalse,
        );
      });
    });
    group('Last Friday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.friday,
        week: Week.last,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 30)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 19)),
          isFalse,
        );
      });
    });
  });
}
