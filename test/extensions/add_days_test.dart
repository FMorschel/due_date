// ignore_for_file: prefer_const_constructors
import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('AddDays on DateTime:', () {
    // Monday, July 18, 2022 is used as a reference workweek start.
    final monday = DateTime.utc(2022, DateTime.july, 18);

    group('Throws when all days are ignored:', () {
      // All weekdays are ignored, so the operation cannot proceed.
      const allWeek = Weekday.values;
      test('Add ignoring all weekdays throws', () {
        expect(
          () => monday.addDays(1, ignoring: allWeek),
          throwsArgumentError,
        );
      });
      test('Subtract ignoring all weekdays throws', () {
        expect(
          () => monday.subtractDays(1, ignoring: allWeek),
          throwsArgumentError,
        );
      });
    });

    group('Add Days:', () {
      // Adding 6 workdays from Monday, ignoring Tuesdays, lands on next Monday.
      final nextMonday = DateTime.utc(2022, DateTime.july, 25);
      test('Ignoring Tuesdays', () {
        final result = monday.addDays(6, ignoring: [Weekday.tuesday]);
        expect(result, equals(nextMonday));
      });
      test('Ignoring weekend', () {
        final result = monday.addWorkDays(5);
        expect(result, equals(nextMonday));
      });
    });

    group('Subtract Days:', () {
      // Subtracting 6 workdays from Monday, ignoring Tuesdays, lands on
      // previous Monday.
      final prevMonday = DateTime.utc(2022, DateTime.july, 11);
      test('Ignoring Tuesdays', () {
        final result = monday.subtractDays(6, ignoring: [Weekday.tuesday]);
        expect(result, equals(prevMonday));
      });
      test('Ignoring weekend', () {
        final result = monday.subtractWorkDays(5);
        expect(result, equals(prevMonday));
      });
    });

    group('Edge cases:', () {
      // Adding 0 days should return the same date if not ignored.
      test('Add 0 days returns same date', () {
        expect(monday.addDays(0), equals(monday));
      });
      // Subtracting 0 days should return the same date if not ignored.
      test('Subtract 0 days returns same date', () {
        expect(monday.subtractDays(0), equals(monday));
      });
      // Adding 0 days but ignored day should still move forward.
      test('Add 0 days but ignored day moves forward', () {
        final tuesday = DateTime.utc(2022, DateTime.july, 19);
        expect(
          tuesday.addDays(0, ignoring: [Weekday.tuesday]),
          isNot(equals(tuesday)),
        );
      });
    });
  });
}
