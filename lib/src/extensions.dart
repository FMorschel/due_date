import 'package:time/time.dart';

import 'enums.dart';

extension AddWorkDays on DateTime {
  bool get isWeekend => Weekday.fromDateTime(weekday).weekend;

  bool get isWorkDay => !isWeekend;

  DateTime addDays(int days, {required Iterable<Weekday> ignoring}) {
    final day = Weekday.fromDateTime(weekday);
    if (!ignoring.contains(day) && (days == 0)) return this;
    final dayToAdd = (days.isNegative ? -1 : 1).days;
    final set = days.isNegative ? ignoring.daysAfter : ignoring.daysBefore;
    if (!set.contains(day)) {
      return add(dayToAdd).addWorkDays(days.isNegative ? days + 1 : days - 1);
    } else {
      return add(dayToAdd).addWorkDays(days);
    }
  }

  DateTime subtractDays(int days, {required Iterable<Weekday> ignoring}) {
    return addDays(-days, ignoring: ignoring);
  }

  DateTime addWorkDays(int days) {
    return addDays(days, ignoring: Weekday.weekendDays);
  }

  DateTime subtractWorkDays(int days) {
    return subtractDays(days, ignoring: Weekday.weekendDays);
  }
}

extension PreviousNext on Iterable<Weekday> {
  Set<Weekday> get daysBefore {
    final set = <Weekday>{};
    for (final weekday in this) {
      set.add(weekday.previous);
    }
    return set;
  }

  Set<Weekday> get daysAfter {
    final set = <Weekday>{};
    for (final weekday in this) {
      set.add(weekday.next);
    }
    return set;
  }
}
