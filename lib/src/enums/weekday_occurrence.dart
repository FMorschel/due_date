import '../date_validators/date_validator_mixin.dart';
import '../date_validators/date_validator_weekday_count_in_month.dart';
import '../everies/every_weekday_count_in_month.dart';
import 'week.dart';
import 'weekday.dart';

/// An enum wrapper in EveryWeekdayCountInMonth class.
///
/// Shows all possible values for the [EveryWeekdayCountInMonth] with better
/// naming.
enum WeekdayOccurrence
    with DateValidatorMixin
    implements EveryWeekdayCountInMonth {
  /// The first Monday of the month.
  firstMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.first,
    ),
  ),

  /// The first Tuesday of the month.
  firstTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.first,
    ),
  ),

  /// The first Wednesday of the month.
  firstWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.first,
    ),
  ),

  /// The first Thursday of the month.
  firstThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.first,
    ),
  ),

  /// The first Friday of the month.
  firstFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.first,
    ),
  ),

  /// The first Saturday of the month.
  firstSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.first,
    ),
  ),

  /// The first Sunday of the month.
  firstSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.first,
    ),
  ),

  /// The second Monday of the month.
  secondMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.second,
    ),
  ),

  /// The second Tuesday of the month.
  secondTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.second,
    ),
  ),

  /// The second Wednesday of the month.
  secondWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.second,
    ),
  ),

  /// The second Thursday of the month.
  secondThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.second,
    ),
  ),

  /// The second Friday of the month.
  secondFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.second,
    ),
  ),

  /// The second Saturday of the month.
  secondSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.second,
    ),
  ),

  /// The second Sunday of the month.
  secondSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.second,
    ),
  ),

  /// The third Monday of the month.
  thirdMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.third,
    ),
  ),

  /// The third Tuesday of the month.
  thirdTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.third,
    ),
  ),

  /// The third Wednesday of the month.
  thirdWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.third,
    ),
  ),

  /// The third Thursday of the month.
  thirdThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.third,
    ),
  ),

  /// The third Friday of the month.
  thirdFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.third,
    ),
  ),

  /// The third Saturday of the month.
  thirdSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.third,
    ),
  ),

  /// The third Sunday of the month.
  thirdSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.third,
    ),
  ),

  /// The fourth Monday of the month.
  fourthMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.fourth,
    ),
  ),

  /// The fourth Tuesday of the month.
  fourthTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.fourth,
    ),
  ),

  /// The fourth Wednesday of the month.
  fourthWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.fourth,
    ),
  ),

  /// The fourth Thursday of the month.
  fourthThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.fourth,
    ),
  ),

  /// The fourth Friday of the month.
  fourthFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.fourth,
    ),
  ),

  /// The fourth Saturday of the month.
  fourthSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.fourth,
    ),
  ),

  /// The fourth Sunday of the month.
  fourthSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.fourth,
    ),
  ),

  /// The last Monday of the month.
  lastMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.last,
    ),
  ),

  /// The last Tuesday of the month.
  lastTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.last,
    ),
  ),

  /// The last Wednesday of the month.
  lastWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.last,
    ),
  ),

  /// The last Thursday of the month.
  lastThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.last,
    ),
  ),

  /// The last Friday of the month.
  lastFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.last,
    ),
  ),

  /// The last Saturday of the month.
  lastSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.last,
    ),
  ),

  /// The last Sunday of the month.
  lastSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.last,
    ),
  );

  /// An enum wrapper in EveryWeekdayCountInMonth class.
  ///
  /// Shows all possible values for the [EveryWeekdayCountInMonth] with better
  /// naming.
  const WeekdayOccurrence(this._handler);

  /// Returns the [WeekdayOccurrence] for the given [date].
  factory WeekdayOccurrence.from(DateTime date) {
    final every = EveryWeekdayCountInMonth.from(date);
    return WeekdayOccurrence.fromEvery(every);
  }

  /// Returns the [WeekdayOccurrence] for the given [every].
  factory WeekdayOccurrence.fromEvery(EveryWeekdayCountInMonth every) {
    return WeekdayOccurrence.values.singleWhere(
      (element) => (element.day == every.day) && (element.week == every.week),
    );
  }

  final EveryWeekdayCountInMonth _handler;

  @override
  Weekday get day => _handler.day;

  @override
  Week get week => _handler.week;

  @override
  DateTime startDate(DateTime date) => _handler.startDate(date);

  @override
  DateTime addMonths(DateTime date, int months) =>
      _handler.addMonths(date, months);

  @override
  DateTime next(DateTime date) => _handler.next(date);

  @override
  DateTime previous(DateTime date) => _handler.previous(date);

  @override
  DateTime endDate(DateTime date) => _handler.endDate(date);

  @override
  DateTime addYears(DateTime date, int years) => _handler.addYears(date, years);

  @override
  bool valid(DateTime date) => _handler.valid(date);

  @override
  int compareTo(DateValidatorWeekdayCountInMonth other) =>
      _handler.compareTo(other);

  /// Returns true if this [week] is after [other]s [WeekdayOccurrence.week], or
  /// if they are the same and this [day] is after [other]s
  /// [WeekdayOccurrence.day].
  bool operator >(WeekdayOccurrence other) => index > other.index;

  /// Returns true if this [week] is after or equal to [other]s
  /// [WeekdayOccurrence.week], or if they are the same and this [day] is
  /// after or equal to [other]s [WeekdayOccurrence.day].
  bool operator >=(WeekdayOccurrence other) => index >= other.index;

  /// Returns true if this [week] is before [other]s [WeekdayOccurrence.week],
  /// or if they are the same and this [day] is before [other]s
  /// [WeekdayOccurrence.day].
  bool operator <(WeekdayOccurrence other) => index < other.index;

  /// Returns true if this [week] is before or equal to [other]s
  /// [WeekdayOccurrence.week], or if they are the same and this [day] is
  /// before or equal to [other]s [WeekdayOccurrence.day].
  bool operator <=(WeekdayOccurrence other) => index <= other.index;

  @override
  bool? get stringify => _handler.stringify;

  @override
  List<Object> get props => _handler.props;
}
