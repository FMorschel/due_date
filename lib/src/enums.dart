import 'package:time/time.dart';

/// Weekday constants that are returned by [DateTime.weekday] method.
enum Weekday {
  monday(DateTime.monday),
  tuesday(DateTime.tuesday),
  wednesday(DateTime.wednesday),
  thursday(DateTime.thursday),
  friday(DateTime.friday),
  saturday(DateTime.saturday, weekend: true),
  sunday(DateTime.sunday, weekend: true);

  const Weekday(this.dateTimeValue, {this.weekend = false});

  factory Weekday.fromDateTime(int weekday) {
    if (weekday == DateTime.monday) {
      return monday;
    } else if (weekday == DateTime.tuesday) {
      return tuesday;
    } else if (weekday == DateTime.wednesday) {
      return wednesday;
    } else if (weekday == DateTime.thursday) {
      return thursday;
    } else if (weekday == DateTime.friday) {
      return friday;
    } else if (weekday == DateTime.saturday) {
      return saturday;
    } else if (weekday == DateTime.sunday) {
      return sunday;
    } else {
      throw RangeError.range(weekday, DateTime.monday, DateTime.sunday);
    }
  }

  final int dateTimeValue;
  final bool weekend;
  bool get workDay => !weekend;

  Weekday get previous {
    if (dateTimeValue != monday.dateTimeValue) {
      return Weekday.fromDateTime(dateTimeValue - 1);
    } else {
      return sunday;
    }
  }

  Weekday get next {
    if (dateTimeValue != sunday.dateTimeValue) {
      return Weekday.fromDateTime(dateTimeValue + 1);
    } else {
      return monday;
    }
  }

  static Set<Weekday> get weekendDays {
    return values.where((weekday) => weekday.weekend).toSet();
  }
}

/// Month constants that are returned by [DateTime.month] method.
enum Month {
  january(DateTime.january),
  february(DateTime.february),
  march(DateTime.march),
  april(DateTime.april),
  may(DateTime.may),
  june(DateTime.june),
  july(DateTime.july),
  august(DateTime.august),
  september(DateTime.september),
  october(DateTime.october),
  november(DateTime.november),
  december(DateTime.december);

  const Month(this.dateTimeValue);

  factory Month.fromDateTime(int month) {
    if (month == DateTime.january) {
      return january;
    } else if (month == DateTime.february) {
      return february;
    } else if (month == DateTime.march) {
      return march;
    } else if (month == DateTime.april) {
      return april;
    } else if (month == DateTime.may) {
      return may;
    } else if (month == DateTime.june) {
      return june;
    } else if (month == DateTime.july) {
      return july;
    } else if (month == DateTime.august) {
      return august;
    } else if (month == DateTime.september) {
      return september;
    } else if (month == DateTime.october) {
      return october;
    } else if (month == DateTime.november) {
      return november;
    } else if (month == DateTime.december) {
      return december;
    } else {
      throw RangeError.range(month, DateTime.monday, DateTime.december);
    }
  }

  final int dateTimeValue;

  DateTime of(int year) => DateTime.utc(year, dateTimeValue);
  DateTime lastDayOfAt(int year) =>
      DateTime.utc(year, dateTimeValue).lastDayOfMonth;

  Month get previous {
    if (dateTimeValue != january.dateTimeValue) {
      return Month.fromDateTime(dateTimeValue - 1);
    } else {
      return december;
    }
  }

  Month get next {
    if (dateTimeValue != december.dateTimeValue) {
      return Month.fromDateTime(dateTimeValue + 1);
    } else {
      return january;
    }
  }
}

enum Week {
  first,
  second,
  third,
  fourth,
  last;

  /// Returns the first day (just as [DateTime], is Monday) of the week of the
  /// selected week for the given [year] and [month].
  DateTime weekOf(int year, int month) {
    final firstDayOfMonth = DateTime.utc(year, month);
    switch (this) {
      case first:
        return firstDayOfMonth.firstDayOfWeek;
      case second:
        return DateTime.utc(year, month, 8).firstDayOfWeek;
      case third:
        return DateTime.utc(year, month, 15).firstDayOfWeek;
      case fourth:
        return DateTime.utc(year, month, 22).firstDayOfWeek;
      case last:
        final fourthWeek = fourth.weekOf(year, month);
        if (fourthWeek.lastDayOfWeek.isBefore(firstDayOfMonth.lastDayOfMonth)) {
          return DateTime.utc(year, month).lastDayOfMonth.firstDayOfWeek;
        } else {
          return fourthWeek;
        }
    }
  }
}
