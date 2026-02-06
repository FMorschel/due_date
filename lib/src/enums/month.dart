import '../period_generators/month_generator.dart';
import '../periods/month_period.dart';

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
    const dateTimeValues = {
      DateTime.january: january,
      DateTime.february: february,
      DateTime.march: march,
      DateTime.april: april,
      DateTime.may: may,
      DateTime.june: june,
      DateTime.july: july,
      DateTime.august: august,
      DateTime.september: september,
      DateTime.october: october,
      DateTime.november: november,
      DateTime.december: december,
    };
    if (dateTimeValues.containsKey(month)) {
      return dateTimeValues[month]!;
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
    if (dateTimeValue == january.dateTimeValue) {
      return december;
    }
    return Month.fromDateTimeValue(dateTimeValue - 1);
  }

  /// Returns the [Month] next to this.
  Month get next {
    if (dateTimeValue == december.dateTimeValue) {
      return january;
    }
    return Month.fromDateTimeValue(dateTimeValue + 1);
  }
}
