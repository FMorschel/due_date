import 'package:meta/meta.dart';

import '../enums/enums.dart';
import 'every_day_in_year.dart';
import 'every_due_day_month.dart';
import 'every_month.dart';
import 'every_week.dart';
import 'every_weekday.dart';
import 'every_weekday_count_in_month.dart';
import 'every_year.dart';

/// Abstract class that, when extended, processes [DateTime] with custom logic.
///
/// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
/// [WeekdayOccurrence]) and [EveryDayInYear] for complete base implementations.
///
/// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
@immutable
abstract class Every {
  /// Abstract class that, when extended, processes [DateTime] with custom
  /// logic.
  ///
  /// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
  /// [WeekdayOccurrence]) and [EveryDayInYear] for complete base
  /// implementations.
  ///
  /// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
  const Every();

  /// {@template next}
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, a new
  /// [DateTime] will be generated.
  /// {@endtemplate}
  DateTime next(DateTime date);

  /// {@template previous}
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, a new
  /// [DateTime] will be generated.
  /// {@endtemplate}
  DateTime previous(DateTime date);
}
