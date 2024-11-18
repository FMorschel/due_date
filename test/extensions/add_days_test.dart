import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main () {
  group('AddDays on DateTime:', () {
    group('Add/Subtract Days:', () {
      final monday = DateTime.utc(2022, DateTime.july, 18);
      group("Throws won't skip all days", () {
        const allWeek = Weekday.values;
        test('Add ignoring all weekdays', () {
          expect(
            () => monday.addDays(1, ignoring: allWeek),
            throwsArgumentError,
          );
        });
        test('Subtract ignoring all weekdays', () {
          expect(
            () => monday.subtractDays(1, ignoring: allWeek),
            throwsArgumentError,
          );
        });
      });
      group('Add Days:', () {
        final matcher = DateTime.utc(2022, DateTime.july, 25);
        test('Ignoring Tuesdays', () {
          final result = monday.addDays(6, ignoring: [Weekday.tuesday]);
          expect(result, equals(matcher));
        });
        test('Ignoring weekend', () {
          final result = monday.addWorkDays(5);
          expect(result, equals(matcher));
        });
      });
      group('Subtract Days:', () {
        final matcher = DateTime.utc(2022, DateTime.july, 11);
        test('Ignoring Tuesdays', () {
          final result = monday.subtractDays(6, ignoring: [Weekday.tuesday]);
          expect(result, equals(matcher));
        });
        test('Ignoring weekend', () {
          final result = monday.subtractWorkDays(5);
          expect(result, equals(matcher));
        });
      });
    });
  });
}
