import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('WeekdayOccurrence', () {
    group('Equals', () {
      test('FirstMonday', () {
        const weekdayOccurrence = WeekdayOccurrence.firstMonday;
        const everyWeekdayCountInMonth = EveryWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        );
        expect(
          weekdayOccurrence,
          equals(everyWeekdayCountInMonth),
        );
      });
    });
  });
}
