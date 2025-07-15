import 'package:intl/intl.dart';

extension DayInExt on int {
  static const _daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  DateTime dayIn(int year) {
    if (this < 1 || this > 366) {
      throw ArgumentError('Day must be between 1 and 366');
    }
    final monthDay = _month(isLeap: year._isLeapYear);
    if (monthDay == _MonthDay.invalid) {
      throw ArgumentError('Invalid day in year $this for year $year');
    }
    return DateTime(year, monthDay.month, monthDay.day);
  }

  bool get _isLeapYear {
    if (this < 1) {
      throw ArgumentError('Year must be greater than 0');
    }
    return (this % 4 == 0 && this % 100 != 0) || (this % 400 == 0);
  }

  _MonthDay _month({bool isLeap = false}) {
    var self = this;
    if (self == 366 && isLeap) {
      return _MonthDay.yearEnd;
    }
    for (var i = 0; i < _daysInMonth.length; i++) {
      final dayInMonth = _daysInMonth[i];
      if (self <= dayInMonth) {
        return _MonthDay(i + 1, self);
      }
      self -= dayInMonth;
      if (isLeap && i == 1) {
        if (self == 1) {
          return _MonthDay.leapDay;
        }
        self -= 1;
      }
    }
    return _MonthDay.invalid;
  }
}

class _MonthDay {
  const _MonthDay(this.month, this.day);

  static const leapDay = _MonthDay(2, 29);
  static const yearEnd = _MonthDay(12, 31);
  static const invalid = _MonthDay(-1, -1);

  final int month;
  final int day;
}

extension DateStrExt on DateTime {
  String get dateStr => DateFormat('yyyy-MM-dd').format(this);
}
