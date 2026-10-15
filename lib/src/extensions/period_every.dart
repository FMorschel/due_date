import '../everies/date_time_limit_reached_exception.dart';
import '../everies/every.dart';
import '../everies/every_date_validator.dart';
import '../everies/limited_every.dart';
import '../helpers/limited_or_every_handler.dart';
import '../periods/period.dart';

/// Extension methods for generating [DateTime] values in a [Period] with an
/// [Every].
extension PeriodEvery on Period {
  /// Returns the occurrences of [every] contained in this [Period], in order.
  ///
  /// If [every] is an [EveryDateValidator], the first occurrence is its
  /// [EveryDateValidator.startDate] of [Period.start], so [Period.start] is
  /// included when it is valid. Otherwise, the first occurrence is the
  /// [Every.next] of [Period.start], which is never included.
  ///
  /// [Every.next] is then called until an occurrence falls after [Period.end].
  /// An occurrence at [Period.end] is included.
  ///
  /// If [every] is a [LimitedEvery], [Period.end] is passed as the limit.
  List<DateTime> getEveryDateTimeValues(Every every) {
    final dates = <DateTime>[];
    DateTime date;
    try {
      if (every is EveryDateValidator) {
        date = LimitedOrEveryHandler.startDate(every, start, limit: end);
      } else {
        date = LimitedOrEveryHandler.next(every, start, limit: end);
      }
    } on DateTimeLimitReachedException {
      return dates;
    }
    while (date.isBefore(end) || date.isAtSameMomentAs(end)) {
      dates.add(date);
      try {
        date = LimitedOrEveryHandler.next(every, date, limit: end);
      } on DateTimeLimitReachedException {
        break;
      }
    }
    return dates;
  }
}
