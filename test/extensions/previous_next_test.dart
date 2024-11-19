import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('PreviousNext on Iterable of Weekday:', () {
    final entireWeek = <Weekday>[...Weekday.values];
    group('daysBefore:', () {
      group('single:', () {
        for (final weekday in Weekday.values) {
          final matcher = [weekday.previous];
          final result = [weekday].previousWeekdays;
          test(
            weekday.name,
            () => expect(result, containsAll(matcher)),
          );
        }
      });
      group('multiple:', () {
        for (final weekday in Weekday.values) {
          final matcher = {...entireWeek}..remove(weekday.previous);
          final iterable = [...entireWeek]..remove(weekday);
          test(
            'all but ${weekday.name}',
            () => expect(iterable.previousWeekdays, containsAll(matcher)),
          );
        }
      });
    });
    group('daysAfter:', () {
      group('single:', () {
        for (final weekday in Weekday.values) {
          final matcher = {weekday.next};
          test(
            weekday.next,
            () => expect([weekday].nextWeekdays, equals(matcher)),
          );
        }
      });
      group('multiple:', () {
        for (final weekday in Weekday.values) {
          final matcher = {...entireWeek}..remove(weekday.next);
          final iterable = [...entireWeek]..remove(weekday);
          test(
            'all but ${weekday.name}',
            () => expect(iterable.nextWeekdays, containsAll(matcher)),
          );
        }
      });
    });
  });
}
