import 'package:equatable/equatable.dart';

import '../everies/every.dart';
import '../everies/every_date_validator.dart';
import '../everies/limited_every.dart';
import '../helpers/limited_or_every_handler.dart';
import '../periods/period.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of periods delimited by [Every]
/// occurrences.
///
/// Each period starts at an occurrence of [start] and ends one microsecond
/// before the next occurrence of [end] after that start.
///
/// When [end] is omitted, [start] is used for both, so the generated periods
/// are contiguous (e.g. `Every.dueDayMonth(15)` generates periods from the
/// 15th to the end of the 14th of the next month).
///
/// When [end] differs from [start], there may be gaps between periods (e.g.
/// starting on Mondays and ending on Saturdays leaves the weekends out). In
/// that case, [of] returns the period of the latest [start] occurrence, which
/// may not contain the given date.
///
/// The given dates are passed to the [Every]s as-is, so their time of day is
/// kept.
class EveryGenerator with PeriodGeneratorMixin<Period>, Equatable {
  /// A class that implements a generator of periods delimited by [Every]
  /// occurrences.
  ///
  /// If [end] is omitted, [start] is used for both.
  const EveryGenerator(this.start, {Every? end}) : end = end ?? start;

  /// The [Every] whose occurrences start each period.
  final Every start;

  EveryDateValidator? get _start =>
      start is EveryDateValidator ? start as EveryDateValidator : null;

  /// The [Every] whose next occurrence (after the period start) ends each
  /// period, exclusively.
  final Every end;

  /// Returns the period starting at the latest occurrence of [start] that is
  /// not after [date].
  ///
  /// The [limit] is passed to [start] and [end] when they are [LimitedEvery]s.
  @override
  Period of(DateTime date, {DateTime? limit}) {
    final validator = _start;
    final DateTime periodStart;
    if (validator != null) {
      periodStart = LimitedOrEveryHandler.endDate(
        validator,
        date,
        limit: limit,
      );
    } else {
      // A plain Every can't validate [date], and its previous occurrence is
      // always before it, so check whether [date] is an occurrence itself.
      final previous = LimitedOrEveryHandler.previous(
        start,
        date,
        limit: limit,
      );
      periodStart = LimitedOrEveryHandler.next(start, previous, limit: limit)
              .isAtSameMomentAs(date)
          ? date
          : previous;
    }
    final periodEnd = LimitedOrEveryHandler.next(end, periodStart, limit: limit)
        .subtract(const Duration(microseconds: 1));
    return Period(start: periodStart, end: periodEnd);
  }

  /// Returns the period starting at the occurrence of [start] that follows
  /// the one [period] starts in.
  ///
  /// The [duration] is ignored, since the time of day is kept by [of].
  @override
  Period after(
    Period period, {
    Duration duration = const Duration(microseconds: 1),
  }) {
    assert(
      duration == const Duration(microseconds: 1),
      'EveryGenerator ignores the duration',
    );
    return of(start.next(of(period.start).start));
  }

  /// Returns the period starting at the occurrence of [start] that precedes
  /// the one [period] starts in.
  ///
  /// The [duration] is ignored, since the time of day is kept by [of].
  @override
  Period before(
    Period period, {
    Duration duration = const Duration(microseconds: 1),
  }) {
    assert(
      duration == const Duration(microseconds: 1),
      'EveryGenerator ignores the duration',
    );
    return of(start.previous(of(period.start).start));
  }

  @override
  // ignore: hash_and_equals, overridden in Equatable
  bool operator ==(Object other) {
    return (super == other) ||
        (other is EveryGenerator) && props == other.props;
  }

  @override
  List<Object?> get props => [start, end];
}
