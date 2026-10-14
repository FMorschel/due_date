import '../due_date.dart';
import '../everies/every_month.dart';
import '../everies/every_week.dart';
import '../everies/every_year.dart';

/// Extension methods for a [DueDateTime] whose `every` is an [EveryWeek].
extension DueDateTimeEveryWeek on DueDateTime<EveryWeek> {
  /// Returns a new [DueDateTime] instance with [weeks] weeks added to this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the `every`
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime addWeeks(int weeks, {bool sameEvery = true}) {
    return DueDateTime.fromDate(
      every.addWeeks(this, weeks),
      every: sameEvery ? every : null,
    );
  }

  /// Returns a new [DueDateTime] instance with [weeks] weeks subtracted from
  /// this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the `every`
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime subtractWeeks(int weeks, {bool sameEvery = true}) =>
      addWeeks(-weeks, sameEvery: sameEvery);
}

/// Extension methods for a [DueDateTime] whose `every` is an [EveryMonth].
extension DueDateTimeEveryMonth on DueDateTime<EveryMonth> {
  /// Returns a new [DueDateTime] instance with [months] months added to this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the `every`
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime addMonths(int months, {bool sameEvery = true}) {
    return DueDateTime.fromDate(
      every.addMonths(this, months),
      every: sameEvery ? every : null,
    );
  }

  /// Returns a new [DueDateTime] instance with [months] months subtracted from
  /// this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the `every`
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime subtractMonths(int months, {bool sameEvery = true}) =>
      addMonths(-months, sameEvery: sameEvery);
}

/// Extension methods for a [DueDateTime] whose `every` is an [EveryYear].
extension DueDateTimeEveryYear on DueDateTime<EveryYear> {
  /// Returns a new [DueDateTime] instance with [years] years added to this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the `every`
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime addYears(int years, {bool sameEvery = true}) {
    return DueDateTime.fromDate(
      every.addYears(this, years),
      every: sameEvery ? every : null,
    );
  }

  /// Returns a new [DueDateTime] instance with [years] years subtracted from
  /// this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the `every`
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime subtractYears(int years, {bool sameEvery = true}) =>
      addYears(-years, sameEvery: sameEvery);
}
