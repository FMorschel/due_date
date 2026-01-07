import '../date_validators/date_validator.dart';
import '../everies/every.dart';
import '../everies/every_date_validator.dart';
import '../everies/limited_every.dart';
import '../everies/limited_every_date_validator.dart';

/// Simple class to delegate the work to a given [Every] base process.
/// For every one one of the everies that is a [LimitedEvery], the limit
/// will be passed.
abstract class LimitedOrEveryHandler {
  /// {@template startDate}
  /// Returns the start date considering the given [every] base process.
  /// If [every] is a [LimitedEveryDateValidator], the [limit] will be passed
  /// on.
  /// {@endtemplate}
  static DateTime startDate<T extends EveryDateValidator>(
    T every,
    DateTime date, {
    required DateTime? limit,
  }) {
    if (every is! LimitedEveryDateValidator) return every.startDate(date);
    return every.startDate(date, limit: limit);
  }

  /// Returns the start date considering the given [every] and [validator] base
  /// process.
  ///
  /// If the [validator] is valid for the [date], it will be returned.
  /// If not, the next date will be returned considering the [every] base
  /// process.
  static DateTime startDate2<T extends Every, V extends DateValidator>(
    T every,
    V validator,
    DateTime date, {
    required DateTime? limit,
  }) {
    if (validator.valid(date)) return date;
    return next(every, date, limit: limit);
  }

  /// Returns the next date considering the given [every] base process.
  /// If [every] is a [LimitedEvery], the [limit] will be passed on.
  static DateTime next<T extends Every>(
    T every,
    DateTime date, {
    required DateTime? limit,
  }) {
    if (every is! LimitedEvery) return every.next(date);
    return every.next(date, limit: limit);
  }

  /// Returns the previous date considering the given [every] base process.
  /// If [every] is a [LimitedEvery], the [limit] will be passed on.
  static DateTime previous<T extends Every>(
    T every,
    DateTime date, {
    required DateTime? limit,
  }) {
    if (every is! LimitedEvery) return every.previous(date);
    return every.previous(date, limit: limit);
  }

  /// Returns the start date considering the given [every] base process.
  /// If [every] is a [LimitedEveryDateValidator], the [limit] will be passed
  /// on.
  static DateTime endDate<T extends EveryDateValidator>(
    T every,
    DateTime date, {
    required DateTime? limit,
  }) {
    if (every is! LimitedEveryDateValidator) return every.endDate(date);
    return every.endDate(date, limit: limit);
  }

  /// Returns the end date considering the given [every] and [validator] base
  /// process.
  ///
  /// If the [validator] is valid for the [date], it will be returned.
  /// If not, the previous date will be returned considering the [every] base
  /// process.
  static DateTime endDate2<T extends Every, V extends DateValidator>(
    T every,
    V validator,
    DateTime date, {
    required DateTime? limit,
  }) {
    if (validator.valid(date)) return date;
    return previous(every, date, limit: limit);
  }
}
