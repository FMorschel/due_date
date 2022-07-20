import 'package:time/time.dart';

class DueDateTime extends DateTime {
  factory DueDateTime(int dueDay, [DateTime? startReference]) {
    final reference = (startReference ?? DateTime.now()).date;
    late final DateTime dueDate;
    if (reference.day == dueDay) {
      return DueDateTime._toConstructor(dueDay, reference);
    } else if (reference.day < dueDay) {
      if (reference.lastDayOfMonth.day > dueDay) {
        dueDate = reference
            .to(reference.lastDayOfMonth)
            .firstWhere((date) => date.day == dueDay);
        return DueDateTime._toConstructor(dueDay, dueDate);
      } else {
        dueDate = reference
            .copyWith(day: dueDay)
            .clamp(max: reference.lastDayOfMonth);
        return DueDateTime._toConstructor(dueDay, dueDate);
      }
    } else {
      final dueNextMonth =
          reference.copyWith(month: reference.month + 1, day: dueDay);
      final endNextMonth =
          reference.copyWith(month: reference.month + 1, day: 1).lastDayOfMonth;
      dueDate = dueNextMonth.clamp(max: endNextMonth);
      return DueDateTime._toConstructor(dueDay, dueDate);
    }
  }

  DueDateTime._(this.dueDay, DateTime date)
      : super(
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
          date.second,
          date.millisecond,
          date.microsecond,
        );

  DueDateTime._utc(this.dueDay, DateTime date)
      : super.utc(
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
          date.second,
          date.millisecond,
          date.microsecond,
        );

  factory DueDateTime._toConstructor(int dueDay, DateTime date) {
    return date.isUtc
        ? DueDateTime._utc(dueDay, date)
        : DueDateTime._(dueDay, date);
  }

  int dueDay;

  DueDateTime addMonths([int months = 1]) {
    final firstDay = copyWith(month: month + months, day: 1);
    return DueDateTime._toConstructor(
      dueDay,
      firstDay.copyWith(day: dueDay).clamp(
            min: firstDay,
            max: firstDay.lastDayOfMonth,
          ),
    );
  }
}
