import '../everies/everies.dart';

/// Simple class to delegate the work to a given [Every] base process.
/// For every one one of the everies that is a [LimitedEvery], the limit
/// will be passed.
abstract class LimitedOrEveryHandler {
  /// Returns the start date considering the given [every] base process.
  /// If [every] is a [LimitedEvery], the [limit] will be passed on.
  static DateTime startDate<T extends Every>(
    T every,
    DateTime date, {
    required DateTime? limit,
  }) {
    if (every is! LimitedEvery) return every.startDate(date);
    return every.startDate(date, limit: limit);
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
}
