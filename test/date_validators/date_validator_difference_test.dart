import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorDifference', () {
    const validator = DateValidatorDifference([
      DateValidatorDueDayMonth(24),
      DateValidatorWeekday(Weekday.saturday),
    ]);
    group('Valid', () {
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 17);
        expect(validator.valid(date), isTrue);
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator.valid(date), isTrue);
      });
    });
    group('Invalid', () {
      test('All valid', () {
        final date = DateTime(2022, DateTime.september, 24);
        expect(validator.valid(date), isFalse);
      });
      test('All Wrong', () {
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator.valid(date), isFalse);
      });
    });
  });
}
