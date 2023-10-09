import 'package:due_date/due_date.dart';
import 'package:due_date/period.dart';

void main(List<String> arguments) {
  /// DueDateTime.

  final date = DateTime(2022, DateTime.january, 31);
  DueDateTime dueDate = date.dueDateTime;
  print(dueDate.toString()); // 2022-01-31
  dueDate = dueDate.next();
  print(dueDate.toString()); // 2022-02-28
  dueDate = dueDate.next();
  print(dueDate.toString()); // 2022-03-31

  DueDateTime dueDate2 = DueDateTime.fromDate(
    date,
    every: EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.last,
    ), // WeekdayOccurrence.lastFriday
  );
  print(dueDate2.toString()); // 2022-02-25
  dueDate2 = dueDate2.next();
  print(dueDate2.toString()); // 2022-03-25
  dueDate2 = dueDate2.next();
  print(dueDate2.toString()); // 2022-04-29

  /// Period.

  final period1 = Period(
    start: DateTime(2022, DateTime.january, 1),
    end: DateTime(2022, DateTime.january, 5),
  );
  final period2 = Period(
    start: DateTime(2022, DateTime.january, 3),
    end: DateTime(2022, DateTime.january, 7),
  );

  if (period1.overlapsWith(period2)) {
    print('The two periods overlap.');
  } else {
    print('The two periods do not overlap.');
  }

  /// PeriodGenerators.

  final hourGenerator = HourGenerator();
  final secondGenerator = SecondGenerator();

  final now = DateTime.now();
  final currentHour = hourGenerator.of(now);
  final currentSecond = secondGenerator.of(now);

  print('The current hour is $currentHour.');
  print('The current second is $currentSecond.');

  final nextHour = currentHour.getNext(hourGenerator);
  final nextSecond = currentSecond.getNext(secondGenerator);

  print('The next hour is $nextHour.');
  print('The next second is $nextSecond.');

  final previousHour = currentHour.getPrevious(hourGenerator);
  final previousSecond = currentSecond.getPrevious(secondGenerator);

  print('The previous hour is $previousHour.');
  print('The previous second is $previousSecond.');
}
