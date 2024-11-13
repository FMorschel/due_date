import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:time/time.dart';

import '../period.dart';

/// A period of time between two [DateTime]s.
@immutable
class Period with EquatableMixin implements Comparable<Period> {
  /// Creates a period of time between two [DateTime]s.
  Period({
    required this.start,
    required this.end,
  }) {
    if (start.isAfter(end)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be after or equals to start.',
      );
    }
    if (start.isUtc ^ end.isUtc) {
      throw ArgumentError.value(
        end,
        'end',
        'Start and end must be both UTC or both local.',
      );
    }
  }

  /// The start of the period. It is included in the period.
  final DateTime start;

  /// The end of the period. It is included in the period.
  final DateTime end;

  /// Returns a list of periods that are the union of the given periods.
  ///
  /// The periods will be sorted if [sort] is `true`.
  ///
  /// It will iterate over the periods and merge the periods that overlap.
  /// If the periods do not overlap, they are added to the list as is. If the
  /// periods overlap, the union of the periods will be added to the list.
  static List<Period> mergeOverlappingPeriods(
    List<Period> periods, {
    bool sort = true,
  }) {
    final localPeriods = [...periods];
    if (sort) localPeriods.sort();
    return localPeriods.fold<List<Period>>([], (merged, current) {
      if (merged.isEmpty) {
        merged.add(current);
      } else {
        final last = merged.last;
        if (last.overlapsWith(current)) {
          merged
            ..removeLast()
            ..add(last.mergeWith(current)!);
        } else {
          merged.add(current);
        }
      }
      return merged;
    });
  }

  /// Returns a list of periods that are the intersection of the given periods.
  ///
  /// The periods will be sorted if [sort] is `true`.
  /// It will iterate over the periods and get the intersections of the periods.
  ///
  /// If the periods do not overlap, they are added to the list as is. If the
  /// periods overlap, the intersection of the periods will be added to the
  /// list.
  static List<Period> intersections(List<Period> periods, {bool sort = true}) {
    final localPeriods = [...periods];
    if (sort) localPeriods.sort();
    if (localPeriods.isEmpty) return [];
    final merged = <Period>[localPeriods.first];
    for (var i = 1; i < localPeriods.length; i++) {
      final current = localPeriods[i];
      final previous = localPeriods[i - 1];
      final lastMerged = merged.last;
      if (lastMerged.overlapsWith(current)) {
        merged
          ..removeLast()
          ..add(lastMerged.getIntersection(current)!);
      } else if (previous.overlapsWith(current)) {
        merged.add(previous.getIntersection(current)!);
      } else {
        merged.add(current);
      }
    }
    return merged;
  }

  /// Returns the period between [first] and [second].
  ///
  /// If [first] and [second] overlap, `null` will be returned.
  ///
  /// If [first] and [second] do not overlap, the period between them will be
  /// returned.
  /// If [first] occurs before [second], the period will be from the end of the
  /// [first] period to the start of the [second] period.
  /// If [first] occurs after [second], the period will be from the end of the
  /// [second] period to the start of the [first] period.
  static Period? inBetween(Period first, Period second) {
    if (first.overlapsWith(second)) return null;
    if (first.occursBefore(second)) {
      return Period(start: first.end, end: second.start);
    }
    return Period(start: second.end, end: first.start);
  }

  /// Returns the period between the start of the [first] period and the start
  /// of the [second] period.
  ///
  /// If [first] and [second] do not overlap, the period that occurs before will
  /// be returned.
  ///
  /// If the [first] period starts before the [second] period, the period will
  /// be from the start of the [first] period to the start of the [second]
  /// period.
  ///
  /// If the [first] period starts after the [second] period, the period will be
  /// from the start of the [second] period to the start of the [first] period.
  ///
  /// If both periods start at the same time, `null` will be returned.
  static Period? calculateStartDifference(Period first, Period second) {
    if (first.overlapsWith(second)) {
      if (first.startsBefore(second.start)) {
        return Period(start: first.start, end: second.start);
      } else if (first.startsAfter(second.start)) {
        return Period(start: second.start, end: first.start);
      }
    } else {
      if (first.occursBefore(second)) return first;
      return second;
    }
    return null;
  }

  /// Returns the period between the end of the [first] period and the end
  /// of the [second] period.
  ///
  /// If [first] and [second] do not overlap, the period that occurs after will
  /// be returned.
  ///
  /// If the [first] period ends after the [second] period, the period will be
  /// from the end of the [second] period to the end of the [first] period.
  ///
  /// If the [first] period ends before the [second] period, the period will be
  /// from the end of the [first] period to the end of the [second] period.
  ///
  /// If both periods end at the same time, `null` will be returned.
  static Period? calculateEndDifference(Period first, Period second) {
    if (first.overlapsWith(second)) {
      if (first.endsAfter(second.end)) {
        return Period(start: second.end, end: first.end);
      } else if (first.endsBefore(second.end)) {
        return Period(start: first.end, end: second.end);
      }
    } else {
      if (first.occursAfter(second)) return first;
      return second;
    }
    return null;
  }

  /// Split the period in multiple periods. The [times] is the number of periods
  /// to split the period in.
  ///
  /// The [periodBetween] is the duration between each period.
  /// The [periodBetween] must be greater than or equals to zero and less than
  /// the duration of the period.
  /// The sum of the period between the periods must be less than the duration
  /// of the period.
  /// If the [periodBetween] is zero, the periods will be contiguous.
  /// If the [periodBetween] is greater than zero, the periods will be
  /// separated by the given duration.
  ///
  /// The [times] must be greater than zero.
  /// If the [times] is one, the period will be returned.
  /// If the [times] is greater than one, the period will be split in multiple
  /// periods.
  ///
  /// Example:
  ///
  /// ```dart
  /// final period = Period(
  ///   start: DateTime(2020, 1, 1),
  ///   end: DateTime(2020, 1, 31),
  /// );
  /// final periods = period.splitIn(
  ///   3,
  ///   periodBetween: Duration(days: 1),
  /// );
  /// // periods = [
  /// //   Period(
  /// //     start: DateTime(2020, 1, 1),
  /// //     end: DateTime(2020, 1, 10, 8),
  /// //   ),
  /// //   Period(
  /// //     start: DateTime(2020, 1, 11, 8),
  /// //     end: DateTime(2020, 1, 20, 16),
  /// //   ),
  /// //   Period(
  /// //     start: DateTime(2020, 1, 21, 16),
  /// //     end: DateTime(2020, 1, 31),
  /// //   ),
  /// // ]
  /// ```
  List<Period> splitIn(
    int times, {
    Duration periodBetween = Duration.zero,
  }) {
    if (times <= 0) {
      throw ArgumentError.value(
        times,
        'times',
        'Times must be greater than zero.',
      );
    }
    if ((periodBetween < Duration.zero) || (duration <= periodBetween)) {
      throw ArgumentError.value(
        periodBetween,
        'periodBetween',
        'Period between must be greater than or equals to zero and less than '
            'the duration of the period.',
      );
    }
    if ((periodBetween * times) > duration) {
      throw ArgumentError.value(
        times,
        'times',
        'The sum of the period between dates is greater than the duration of '
            'the period.',
      );
    }
    final periods = <Period>[];
    final finalBetween = periodBetween * (times - 1);
    var fullPeriodDuration = duration - finalBetween;
    var rest = fullPeriodDuration.inMicroseconds % times;
    while (rest != 0) {
      fullPeriodDuration -= const Duration(microseconds: 1);
      rest = fullPeriodDuration.inMicroseconds % times;
    }
    final periodDuration = fullPeriodDuration ~/ times;
    for (var i = 0; i < times; i++) {
      final start = this.start.add(
            (periodDuration * i) + periodBetween * i,
          );
      var end = this.start.add(
            periodDuration * (i + 1) + periodBetween * i,
          );
      if (i == (times - 1)) end = this.end;
      periods.add(Period(start: start, end: end));
    }
    return periods;
  }

  /// Splits the period in multiple periods at the given [dates].
  /// The [periodBetween] is the duration between each period.
  /// The [dates] not included in the period are ignored.
  /// The [dates] will be sorted before splitting.
  ///
  /// The [periodBetween] must be greater than or equals to zero and less than
  /// the duration of the period.
  /// The sum of the period between dates must be less than the duration of the
  /// period.
  ///
  /// If the [periodBetween] is zero, the periods will be contiguous.
  /// If the [periodBetween] is greater than zero, the periods will be
  /// separated by the given duration.
  ///
  /// If the [dates] are empty, the period is returned.
  /// If the [dates] are not empty, the period is split at the given dates.
  ///
  /// Example:
  /// ```dart
  /// final period = Period(
  ///   start: DateTime(2020, 1, 1),
  ///   end: DateTime(2020, 1, 31),
  /// );
  ///
  /// final periods = period.splitAt(
  ///   {
  ///     DateTime(2020, 1, 10),
  ///     DateTime(2020, 1, 20),
  ///   },
  ///   periodBetween: const Duration(days: 1),
  /// );
  ///
  /// // periods = [
  /// //   Period(
  /// //     start: DateTime(2020, 1, 1),
  /// //     end: DateTime(2020, 1, 10),
  /// //   ),
  /// //   Period(
  /// //     start: DateTime(2020, 1, 11),
  /// //     end: DateTime(2020, 1, 20),
  /// //   ),
  /// //   Period(
  /// //     start: DateTime(2020, 1, 21),
  /// //     end: DateTime(2020, 1, 31),
  /// //   ),
  /// // ]
  /// ```
  List<Period> splitAt(
    Set<DateTime> dates, {
    Duration periodBetween = Duration.zero,
  }) {
    if ((periodBetween < Duration.zero) || (duration <= periodBetween)) {
      throw ArgumentError.value(
        periodBetween,
        'periodBetween',
        'The period between dates must be greater than or equals to zero and '
            'less than the duration of the period.',
      );
    }
    final periods = <Period>[];
    final sortedValidDates = [...dates.where(contains)]..sort();
    final resultDuration = periodBetween * sortedValidDates.length;
    if (resultDuration > duration) {
      throw ArgumentError.value(
        dates,
        'dates',
        'The sum of the period between dates is greater than the duration of '
            'the period.',
      );
    }
    for (final date in sortedValidDates.sublist(sortedValidDates.length - 1)) {
      if (periods.isEmpty) {
        periods.add(Period(start: start, end: date));
      } else {
        final last = periods.last;
        if (last.end.add(periodBetween).isBefore(date)) {
          periods.add(Period(start: last.end.add(periodBetween), end: date));
        } else {
          final start = last.end.add(periodBetween);
          periods.add(Period(start: start, end: start));
        }
      }
    }
    if (periods.isNotEmpty) {
      final last = periods.last;
      if (last.end.add(periodBetween).isBefore(end)) {
        periods.add(Period(start: last.end.add(periodBetween), end: end));
      } else {
        final start = last.end.add(periodBetween);
        periods.add(Period(start: start, end: start));
      }
    } else {
      periods.add(this);
    }
    return periods;
  }

  /// Returns a list of [Period]s that are the difference between this [Period]
  /// and the [periods] passed as argument.
  ///
  /// The [periods] are sorted, merged, trimmed and if not overlapping with
  /// this [Period] they are removed.
  /// After that, the result will be the periods between the merged periods and
  /// the period between the [start] of this [Period] and the first merged
  /// period, and the period between the [end] of this [Period] and the last
  /// merged period.
  ///
  /// If the [periods] are overlapping with this [Period] the result will be
  /// a list with only this [Period].
  ///
  /// Example:
  ///
  /// ```dart
  /// final period = Period(
  ///   start: DateTime(2020, 1, 1),
  ///   end: DateTime(2020, 1, 31),
  /// );
  /// final periods = [
  ///   Period(
  ///     start: DateTime(2020, 1, 1),
  ///     end: DateTime(2020, 1, 10),
  ///   ),
  ///   Period(
  ///     start: DateTime(2020, 1, 15),
  ///     end: DateTime(2020, 1, 20),
  ///   ),
  ///   Period(
  ///     start: DateTime(2020, 1, 25),
  ///     end: DateTime(2020, 1, 29),
  ///   ),
  /// ];
  ///
  /// final result = period.subtract(periods);
  ///
  /// // result = [
  /// //   Period(
  /// //     start: DateTime(2020, 1, 10),
  /// //     end: DateTime(2020, 1, 15),
  /// //   ),
  /// //   Period(
  /// //     start: DateTime(2020, 1, 20),
  /// //     end: DateTime(2020, 1, 25),
  /// //   ),
  /// //   Period(
  /// //     start: DateTime(2020, 1, 29),
  /// //     end: DateTime(2020, 1, 31),
  /// //   ),
  /// // ]
  /// ```
  ///
  List<Period> subtract(List<Period> periods) {
    if (periods.isEmpty) return [this];
    final localPeriods = trim(periods);
    if (localPeriods.isEmpty) return [this];
    final merged = mergeOverlappingPeriods(localPeriods);
    final result = <Period>[];
    final difference = calculateStartDifference(merged.first, this);
    if (difference != null) result.add(difference);
    for (var i = 0, j = 1; j < merged.length; i++, j++) {
      result.add(Period.inBetween(merged[i], merged[j])!);
    }
    if (merged.length > 1) {
      final differenceLast = calculateEndDifference(merged.last, this);
      if (differenceLast != null) result.add(differenceLast);
    }
    return result;
  }

  /// {@template getIntersection}
  /// Returns a [Period] that is the intersection of this and [other].
  ///
  /// If [other] does not overlap with this, the returned [Period] will be
  /// `null`.
  ///
  /// If [other] overlaps with this, the returned [Period] will be the
  /// intersection of the two [Period]s. Starting at the latest [Period.start]
  /// and ending at the earliest [Period.end].
  /// {@endtemplate}
  Period? getIntersection(Period other) {
    if (doesNotOverlapWith(other)) return null;
    return Period(
      start: start.isAfter(other.start) ? start : other.start,
      end: end.isBefore(other.end) ? end : other.end,
    );
  }

  /// {@macro getIntersection}
  Period? operator &(Period other) => getIntersection(other);

  /// Returns a [Period] that is the union of this and [other].
  ///
  /// If [other] overlaps with this, the returned [Period] will be the union of
  /// the two [Period]s. Starting at the earliest [Period.start] and ending at
  /// the latest [Period.end].
  ///
  /// If [other] does not overlap with this, the returned [Period] will be
  /// `null`.
  Period? mergeWith(Period other) {
    if (doesNotOverlapWith(other)) return null;
    return Period(
      start: start.isBefore(other.start) ? start : other.start,
      end: end.isAfter(other.end) ? end : other.end,
    );
  }

  /// Returns a list of [Period]s.
  ///
  /// If [other] overlaps with this, the returned list will contain the union of
  /// the two [Period]s. Starting at the earliest [Period.start] and ending at
  /// the latest [Period.end].
  ///
  /// If [other] does not overlap with this, the returned list will contain both
  /// this and [other].
  List<Period> operator |(Period other) {
    return [
      ...mergeWith(other)?.apply((self) => [self]) ?? [this, other],
    ];
  }

  /// Returns a list of [Period]s that are the difference between this and
  /// [other].
  ///
  /// If [other] does not overlap with this, the returned list will contain
  /// both this and [other].
  ///
  /// If [other] overlaps with this, the returned list will contain the
  /// difference between the two.
  /// If both start at the same time, the returned list will contain the period
  /// between the two [Period.end] values.
  /// If both end at the same time, the returned list will contain the period
  /// between the two [Period.start] values.
  ///
  /// If they are equal, the returned list will be empty.
  List<Period> differenceBetween(Period other) {
    if (doesNotOverlapWith(other)) return [this, other];
    final periods = <Period>[];
    final before = calculateStartDifference(other, this);
    if (before != null) periods.add(before);
    final after = calculateEndDifference(other, this);
    if (after != null) periods.add(after);
    return periods;
  }

  /// Returns `true` if this starts after the given [date].
  bool startsAfter(DateTime date) => start.isAfter(date);

  /// Returns `true` if this starts before the given [date].
  bool startsBefore(DateTime date) => start.isBefore(date);

  /// Returns `true` if this ends after the given [date].
  bool endsAfter(DateTime date) => end.isAfter(date);

  /// Returns `true` if this ends before the given [date].
  bool endsBefore(DateTime date) => end.isBefore(date);

  /// Returns `true` if this contains the given [date]. If the [date] is equal
  /// to the [start] or [end] or is between the two dates, it will return
  /// `true`.
  bool contains(DateTime date) {
    return (startsBefore(date) || date.isAtSameMomentAs(start)) &&
        (endsAfter(date) || date.isAtSameMomentAs(end));
  }

  /// Returns `true` if this overlaps with [other].
  bool overlapsWith(Period other) {
    return (contains(other.start) || contains(other.end)) ||
        (other.contains(start) || other.contains(end));
  }

  /// Returns `true` if this does not overlap with [other].
  bool doesNotOverlapWith(Period other) {
    return (!contains(other.start) && !contains(other.end)) &&
        (!other.contains(start) && !other.contains(end));
  }

  /// Returns `true` if this fully contains [other].
  bool containsFully(Period other) {
    return contains(other.start) && contains(other.end);
  }

  /// Returns `true` if this contains partially [other].
  bool containsPartially(Period other) {
    return overlapsWith(other) && !containsFully(other);
  }

  /// Returns `true` if this occurs before [other].
  bool occursBefore(Period other) => end.isBefore(other.start);

  /// Returns `true` if this occurs after [other].
  bool occursAfter(Period other) => start.isAfter(other.end);

  /// Returns `true` if this is contained fully by [other].
  bool containedFullyBy(Period other) => other.containsFully(this);

  /// Returns `true` if this is contained partially by [other].
  bool containedPartiallyBy(Period other) => other.containsPartially(this);

  /// Returns a new [Period] that starts after this using [generator].
  T getNext<T extends Period>(PeriodGeneratorMixin<T> generator) =>
      generator.after(this);

  /// Returns a new [Period] that starts before this using [generator].
  T getPrevious<T extends Period>(PeriodGeneratorMixin<T> generator) =>
      generator.before(this);

  /// {@template shift}
  /// Returns a new [Period] that is shifted by the given [duration]
  /// {@endtemplate}
  /// .
  Period shift(Duration duration) {
    return Period(start: start.add(duration), end: end.add(duration));
  }

  // ignore: format-comment, using macro
  /// {@macro shift}
  /// forwards.
  Period operator >>(Duration duration) => shift(duration);

  // ignore: format-comment, using macro
  /// {@macro shift}
  /// backwards.
  Period operator <<(Duration duration) => shift(-duration);

  /// Returns a list of [DateTime] values that are contained in this [Period].
  /// The [next] function is used to calculate the [DateTime] values for the
  /// returned list.
  /// The [next] function is called with the last [DateTime] value, or [start].
  /// The [next] function must return a [DateTime] value that is contained in
  /// this [Period].
  /// The [next] function must return a [DateTime] value that is not after the
  /// [end] value of this [Period].
  /// When the [next] function returns `null`, the iteration stops.
  List<DateTime> getDateTimeValues(DateTime? Function(DateTime last) next) {
    final dates = <DateTime>[];
    var last = start;
    while (endsAfter(last)) {
      final nextDate = next(last);
      if (nextDate == null) break;
      if (contains(nextDate)) {
        dates.add(nextDate);
        last = dates.last;
      } else {
        throw ArgumentError.value(
          nextDate,
          'next',
          'The next date must be contained in the period',
        );
      }
    }
    return dates;
  }

  /// Returns a new [Period] with the given [start] and [end] values.
  /// If [start] or [end] are not provided, the corresponding value of this
  /// is used.
  Period copyWith({
    DateTime? start,
    DateTime? end,
  }) {
    return Period(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  int compareTo(Period other) {
    final result = start.compareTo(other.start);
    if (result != 0) return result;
    return end.compareTo(other.end);
  }

  @override
  String toString({String Function(DateTime date)? dateFormat}) {
    // ignore: no_runtimetype_tostring, simply to print the class
    return '$runtimeType(${dateFormat?.call(start) ?? start}, '
        '${dateFormat?.call(end) ?? end})';
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is Period) && (other.start == start) && (other.end == end));
  }

  /// Removes periods that do not overlap with this period and trims the ones
  /// that do overlap and are not fully contained by this period.
  List<Period> trim(List<Period> periods) {
    final localPeriods = [...periods];
    for (final period in [...periods]) {
      if (period.doesNotOverlapWith(this)) {
        localPeriods.remove(period);
      } else if (containsPartially(period)) {
        localPeriods
          ..remove(period)
          ..add(getIntersection(period)!);
      }
    }
    return localPeriods;
  }

  /// The difference between the [start] and [end] plus one microsecond.
  /// If [start] and [end] are equal, returns `Duration(microseconds: 1)`.
  Duration get duration =>
      end.difference(start) + const Duration(microseconds: 1);

  /// If [start] and [end] are equal.
  ///
  /// If the [duration] is `Duration(microseconds: 1)`.
  bool get isEmpty => start == end;

  /// If [start] and [end] are different.
  ///
  /// If the [duration] is not `Duration(microseconds: 1)`.
  bool get isNotEmpty => start != end;

  @override
  List<Object?> get props => [start, end];
}

/// A class that implements a period type of a second.
class SecondPeriod extends Period {
  /// A class that implements a period type of a second.
  SecondPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) ==
              const Duration(
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 999 milliseconds and '
          '999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if ((duration != const Duration(seconds: 1)) ||
        !start.isAtSameSecondAs(end) ||
        end.add(microsecond).isAtSameSecondAs(start)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same second as start and must be the last '
            'microsecond of the second',
      );
    }
  }
}

/// A class that implements a period type of a minute.
class MinutePeriod extends Period {
  /// A class that implements a period type of a minute.
  MinutePeriod({required super.start, required super.end})
      : assert(
          end.difference(start) ==
              const Duration(
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 59 seconds, 999 '
          'milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (duration != const Duration(minutes: 1) ||
        !start.isAtSameMinuteAs(end) ||
        end.add(microsecond).isAtSameMinuteAs(start)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same minute as start and must be the last '
            'microsecond of the minute',
      );
    }
  }

  /// Returns the list of seconds that are contained in this minute.
  List<SecondPeriod> get seconds {
    const generator = SecondGenerator();
    final seconds = <SecondPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      seconds.add(last);
      last = generator.after(last);
    }
    return seconds;
  }
}

/// A class that implements a period type of an hour.
class HourPeriod extends Period {
  /// A class that implements a period type of an hour.
  HourPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) ==
              const Duration(
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 59 minutes, 59 '
          'seconds, 999 milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (duration != const Duration(hours: 1) ||
        !start.isAtSameHourAs(end) ||
        end.add(microsecond).isAtSameHourAs(start)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same hour as start and must be the last '
            'microsecond of the hour',
      );
    }
  }

  /// Returns the list of minutes that are contained in this hour.
  List<MinutePeriod> get minutes {
    const generator = MinuteGenerator();
    final minutes = <MinutePeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      minutes.add(last);
      last = generator.after(last);
    }
    return minutes;
  }
}

/// A class that implements a period type of a day.
class DayPeriod extends Period {
  /// A class that implements a period type of a day.
  DayPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) < const Duration(days: 1),
          'The difference between start and end must be 23 hours, 59 minutes, '
          '59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (!start.isAtSameDayAs(end) ||
        end.add(microsecond).isAtSameDayAs(start)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same day as start and must be the last microsecond '
            'of the day',
      );
    }
  }

  /// Returns the list of hours in this day.
  List<HourPeriod> get hours {
    const generator = HourGenerator();
    final hours = <HourPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      hours.add(last);
      last = generator.after(last);
    }
    return hours;
  }
}

/// {@template dayPeriodBundle}
/// A base class that represents a bundle of days.
/// {@endtemplate}
abstract class DayPeriodBundle extends Period {
  /// {@macro dayPeriodBundle}
  DayPeriodBundle({required super.start, required super.end});

  /// Returns the list of days in this bundle.
  List<DayPeriod> get days;
}

/// A class that implements a period type of a week.
class WeekPeriod extends Period implements DayPeriodBundle {
  /// A class that implements a period type of a week.
  WeekPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 7,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 7 days, 0 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    if ((duration > const Duration(days: 7, hours: 1)) ||
        (duration <
            const Duration(
              days: 6,
              hours: 22,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
              microseconds: 999,
            )) ||
        (start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        (end.weekday != Weekday.from(start).previous.dateTimeValue)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same week as start and must be the last '
            'microsecond of the week',
      );
    }
  }

  @override
  List<DayPeriod> get days {
    const generator = DayGenerator();
    final days = <DayPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      days.add(last);
      last = generator.after(last);
    }
    return days;
  }
}

/// A class that implements a period type of a fortnight.
class FortnightPeriod extends Period implements DayPeriodBundle {
  /// A class that implements a period type of a fortnight.
  FortnightPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 15,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 15 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    if ((duration > const Duration(days: 16, hours: 1)) ||
        (duration <
            const Duration(
              days: 12,
              hours: 22,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
              microseconds: 999,
            )) ||
        (start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        !start.isAtSameMonthAs(end) ||
        ((start.firstDayOfMonth != start) &&
            (start != start.copyWith(day: 16))) ||
        ((end.lastDayOfMonth.endOfDay != end) &&
            (end != end.copyWith(day: 15).endOfDay))) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same fortnight as start and must be the last '
            'microsecond of the fortnight',
      );
    }
  }

  @override
  List<DayPeriod> get days {
    const generator = DayGenerator();
    final days = <DayPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      days.add(last);
      last = generator.after(last);
    }
    return days;
  }
}

/// A class that implements a period type of a month.
class MonthPeriod extends Period implements DayPeriodBundle {
  /// A class that implements a period type of a month.
  MonthPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 30,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 30 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (!start.isAtSameMonthAs(end) ||
        end.add(microsecond).isAtSameMonthAs(start) ||
        (start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        (start.day != 1) ||
        (end.day != end.lastDayOfMonth.day)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same month as start and must be the last '
            'microsecond of the month',
      );
    }
  }

  @override
  List<DayPeriod> get days {
    const generator = DayGenerator();
    final days = <DayPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      days.add(last);
      last = generator.after(last);
    }
    return days;
  }
}

/// {@template monthPeriodBundle}
/// A base class that represents a bundle of months.
/// {@endtemplate}
abstract class MonthPeriodBundle extends Period {
  /// {@macro monthPeriodBundle}
  MonthPeriodBundle({required super.start, required super.end});

  /// Returns the list of months in this bundle.
  List<MonthPeriod> get months;
}

/// A class that implements a period type of a trimester.
class TrimesterPeriod extends Period implements MonthPeriodBundle {
  /// A class that implements a period type of a trimester.
  TrimesterPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 91,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 91 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    if ((start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        start.isAtSameMonthAs(end) ||
        (start.firstDayOfMonth != start) ||
        (end.lastDayOfMonth.endOfDay != end) ||
        ((end.month - start.month) != 2)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same trimester as start and must be the last '
            'microsecond of the trimester',
      );
    }
  }

  @override
  List<MonthPeriod> get months {
    const generator = MonthGenerator();
    final months = <MonthPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      months.add(last);
      last = generator.after(last);
    }
    return months;
  }
}

/// A class that implements a period type of a semester.
class SemesterPeriod extends Period implements MonthPeriodBundle {
  /// A class that implements a period type of a semester.
  SemesterPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 183,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 183 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    if ((start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        start.isAtSameMonthAs(end) ||
        (start.firstDayOfMonth != start) ||
        (end.lastDayOfMonth.endOfDay != end) ||
        ((end.month - start.month) != 5)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same semester as start and must be the last '
            'microsecond of the semester',
      );
    }
  }

  @override
  List<MonthPeriod> get months {
    const generator = MonthGenerator();
    final months = <MonthPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      months.add(last);
      last = generator.after(last);
    }
    return months;
  }
}

/// A class that implements a period type of a year.
class YearPeriod extends Period implements MonthPeriodBundle {
  /// A class that implements a period type of a year.
  YearPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 365,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 365 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (!start.isAtSameYearAs(end) ||
        end.add(microsecond).isAtSameYearAs(start) ||
        (start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        start.isAtSameMonthAs(end) ||
        (start.firstDayOfMonth != start) ||
        (end.lastDayOfMonth.endOfDay != end) ||
        ((end.month - start.month) != 11)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same year as start and must be the last '
            'microsecond of the year',
      );
    }
  }

  @override
  List<MonthPeriod> get months {
    const generator = MonthGenerator();
    final months = <MonthPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      months.add(last);
      last = generator.after(last);
    }
    return months;
  }
}

extension _Apply<T extends Object> on T {
  R apply<R>(R Function(T self) f) => f(this);
}
