import 'package:due_date/due_date.dart';

void main(List<String> arguments) {
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
}
