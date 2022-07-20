import 'package:time/time.dart';
import 'package:intl/intl.dart';

import 'enums.dart';

extension AddDays on DateTime {
  bool get isWeekend => Weekday.fromDateTime(weekday).weekend;

  bool get isWorkDay => !isWeekend;

  DateTime addDays(int days, {required Iterable<Weekday> ignoring}) {
    final ignoreSet = ignoring.toSet();
    assert(
      ignoreSet.length < Weekday.values.length,
      'Too many ignore days, will skip forever',
    );
    final day = Weekday.fromDateTime(weekday);
    if (!ignoreSet.contains(day) && (days == 0)) return this;
    final dayToAdd = (days.isNegative ? -1 : 1).days;
    final set = days.isNegative ? ignoreSet.daysAfter : ignoreSet.daysBefore;
    if (!set.contains(day)) {
      return add(dayToAdd).addDays(
        days.isNegative ? days + 1 : days - 1,
        ignoring: ignoreSet,
      );
    } else {
      return add(dayToAdd).addDays(days, ignoring: ignoreSet);
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
