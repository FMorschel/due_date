import '../period_generators/month_generator.dart';
import '../period_generators/period_generators.dart';
import '../periods/periods.dart';

/// Month constants that are returned by [DateTime.month] method.
enum Month implements Comparable<Month> {
  /// January month constant.
  january(DateTime.january),

  /// February month constant.
  february(DateTime.february),

  /// March month constant.
  march(DateTime.march),

  /// April month constant.
  april(DateTime.april),

  /// May month constant.
  may(DateTime.may),

  /// June month constant.
  june(DateTime.june),

  /// July month constant.
  july(DateTime.july),

  /// August month constant.
  august(DateTime.august),

  /// September month constant.
  september(DateTime.september),

  /// October month constant.
  october(DateTime.october),

  /// November month constant.
  november(DateTime.november),

  /// December month constant.
  december(DateTime.december);

  /// Month constants that are returned by [DateTime.month] method.
  const Month(this.dateTimeValue);

  /// Returns the [Month] constant that corresponds to the given [date].
  factory Month.of(DateTime date) => Month.fromDateTimeValue(date.month);

  /// Returns the [Month] constant that corresponds to the given [month] on
  /// [dateTimeValue].
  factory Month.fromDateTimeValue(int month) {
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
    }
    throw RangeError.range(month, DateTime.monday, DateTime.december);
  }

  /// Returns a constant [MonthGenerator].
  static const generator = MonthGenerator();

  /// The value of the month in [DateTime] class.
  final int dateTimeValue;

  /// Returns the period of the month on the given [year].
  MonthPeriod of(int year, {bool utc = true}) => generator.of(
        utc ? DateTime.utc(year, dateTimeValue) : DateTime(year, dateTimeValue),
      );

  @override
  int compareTo(Month other) => dateTimeValue.compareTo(other.dateTimeValue);

  /// Returns true if this month is after other.
  bool operator >(Month other) => index > other.index;

  /// Returns true if this month is after or equal to other.
  bool operator >=(Month other) => index >= other.index;

  /// Returns true if this month is before than other.
  bool operator <(Month other) => index < other.index;

  /// Returns true if this month is before or equal to other.
  bool operator <=(Month other) => index <= other.index;

  /// Returns the [Month] that corresponds to this added [months].
  /// Eg.:
  ///  - [january] + `1` returns [february].
  ///  - [december] + `3` returns [march].
  Month operator +(int months) => Month.fromDateTimeValue(
        ((dateTimeValue + months - 1) % values.length + 1).abs(),
      );

  /// Returns the [Month] that corresponds to this subtracted [months].
  /// Eg.:
  ///  - [february] - `1` returns [january].
  ///  - [march] - `3` returns [december].
  Month operator -(int months) => Month.fromDateTimeValue(
        ((dateTimeValue - months - 1) % values.length + 1).abs(),
      );

  /// Returns the [Month] previous to this.
  Month get previous {
    if (dateTimeValue != january.dateTimeValue) {
      return Month.fromDateTimeValue(dateTimeValue - 1);
    } else {
      return december;
    }
  }

  /// Returns the [Month] next to this.
  Month get next {
    if (dateTimeValue != december.dateTimeValue) {
      return Month.fromDateTimeValue(dateTimeValue + 1);
    } else {
      return january;
    }
  }
}
