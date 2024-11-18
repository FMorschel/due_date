import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorWeekday:', () {
    group('Monday', () {
      const validator = DateValidatorWeekday(Weekday.monday);
      test('Monday is valid', () {
        expect(validator.valid(DateTime(2022, DateTime.september, 26)), isTrue);
      });

      test('Tuesday is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
  });
}
