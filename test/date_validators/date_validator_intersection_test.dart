import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorIntersection', () {
    const validator = DateValidatorIntersection([
      DateValidatorDueDayMonth(24),
      DateValidatorWeekday(Weekday.saturday),
    ]);
    test('Valid', () {
      final date = DateTime(2022, DateTime.september, 24);
      expect(validator.valid(date), isTrue);
    });
    group('Invalid', () {
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator.valid(date), isFalse);
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator.valid(date), isFalse);
      });
    });
  });
}
