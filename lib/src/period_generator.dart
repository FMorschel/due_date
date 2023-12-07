import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../period.dart';

/// A mixin for period types.
///
/// If you are looking for implementations, see [PeriodGenerator] and its
/// values:
/// [SecondGenerator], [MinuteGenerator], [HourGenerator], [DayGenerator],
/// [WeekGenerator], [FortnightGenerator], [MonthGenerator],
/// [TrimesterGenerator], [SemesterGenerator] and [YearGenerator].
mixin PeriodGeneratorMixin<T extends Period> {
  /// Returns the period of the given [date] considering the generator type.
  T of(DateTime date);

  /// Returns the period after the given [period] by the rule:
  /// The [Period.end] is given to this [of]. The given [duration] is added to
  /// the end of the resulting period and this is given to [of].
  T after(
    Period period, {
    Duration duration = const Duration(microseconds: 1),
  }) =>
      of(of(period.end).end.add(duration));

  /// Returns the period before the given [period] by the rule:
  /// The [Period.start] is given to this [of]. The given [duration] is
  /// subtracted from the start of the resulting period and this is given to
  /// [of].
  T before(
    Period period, {
    Duration duration = const Duration(microseconds: 1),
  }) =>
      of(of(period.start).start.subtract(duration));

  /// Returns true if the given [period] fits the generator.
  bool fitsGenerator(Period period) {
    final newPeriod = of(period.start);
    return newPeriod == period;
  }
}

/// A class that implements a generator of a period type of a second.
class SecondGenerator with PeriodGeneratorMixin<SecondPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a second.
  const SecondGenerator();

  @override
  SecondPeriod of(DateTime date) {
    return SecondPeriod(
      start: date.copyWith(
        millisecond: 0,
        microsecond: 0,
      ),
      end: date.copyWith(
        millisecond: 999,
        microsecond: 999,
      ),
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is SecondGenerator);
  }

  @override
  List<Object?> get props => [];
}

/// A class that implements a generator of a period type of a minute.
class MinuteGenerator with PeriodGeneratorMixin<MinutePeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a minute.
  const MinuteGenerator();

  @override
  MinutePeriod of(DateTime date) {
    return MinutePeriod(
      start: date.copyWith(
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      end: date.copyWith(
        second: 59,
        millisecond: 999,
        microsecond: 999,
      ),
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is MinuteGenerator);
  }

  @override
  List<Object?> get props => [];
}

/// A class that implements a generator of a period type of an hour.
class HourGenerator with PeriodGeneratorMixin<HourPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of an hour.
  const HourGenerator();

  @override
  HourPeriod of(DateTime date) {
    return HourPeriod(
      start: date.copyWith(
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      end: date.copyWith(
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
      ),
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is HourGenerator);
  }

  @override
  List<Object?> get props => [];
}

/// A class that implements a generator of a period type of a day.
class DayGenerator with PeriodGeneratorMixin<DayPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a day.
  const DayGenerator();

  @override
  DayPeriod of(DateTime date) {
    final start = date.date;
    final end = date.endOfDay;
    return DayPeriod(start: start, end: end);
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is DayGenerator);
  }

  @override
  List<Object?> get props => [];
}

/// A class that implements a generator of a period type of a week.
class WeekGenerator with PeriodGeneratorMixin<WeekPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a week.
  const WeekGenerator({this.weekStart = DateTime.monday});

  /// The first day of the week.
  final int weekStart;

  @override
  WeekPeriod of(DateTime date) {
    int difference = weekStart - date.weekday;
    if (difference > 0) difference -= DateTime.daysPerWeek;
    final day = date.day + difference;
    final start = date.copyWith(day: day).date;
    final end =
        start.add(const Duration(days: DateTime.daysPerWeek - 1)).endOfDay;
    return WeekPeriod(start: start, end: end);
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is WeekGenerator);
  }

  @override
  List<Object?> get props => [weekStart];
}

/// A class that implements a generator of a period type of a fortnight.
class FortnightGenerator
    with PeriodGeneratorMixin<FortnightPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a fortnight.
  const FortnightGenerator();

  @override
  FortnightPeriod of(DateTime date) {
    final sixteenth = date.copyWith(day: 16).date;
    if (date.isBefore(sixteenth)) {
      return FortnightPeriod(
        start: date.firstDayOfMonth.date,
        end: sixteenth.subtract(const Duration(microseconds: 1)),
      );
    }
    return FortnightPeriod(
      start: sixteenth,
      end: date.lastDayOfMonth.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is FortnightGenerator);
  }

  @override
  List<Object?> get props => [];
}

/// A class that implements a generator of a period type of a month.
class MonthGenerator with PeriodGeneratorMixin<MonthPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a month.
  const MonthGenerator();

  @override
  MonthPeriod of(DateTime date) {
    return MonthPeriod(
      start: date.firstDayOfMonth.date,
      end: date.lastDayOfMonth.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is MonthGenerator);
  }

  @override
  List<Object?> get props => [];
}

/// A class that implements a generator of a period type of a trimester.
class TrimesterGenerator
    with PeriodGeneratorMixin<TrimesterPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a trimester.
  const TrimesterGenerator();

  @override
  TrimesterPeriod of(DateTime date) {
    final octoberFirst = date.copyWith(month: DateTime.october, day: 1).date;
    if (date.isBefore(octoberFirst)) {
      final julyFirst = date.copyWith(month: DateTime.july, day: 1).date;
      if (date.isBefore(julyFirst)) {
        final aprilFirst = date.copyWith(month: DateTime.april, day: 1).date;
        if (date.isBefore(aprilFirst)) {
          return TrimesterPeriod(
            start: date.firstDayOfYear.date,
            end: aprilFirst.subtract(const Duration(microseconds: 1)),
          );
        }
        return TrimesterPeriod(
          start: aprilFirst,
          end: julyFirst.subtract(const Duration(microseconds: 1)),
        );
      }
      return TrimesterPeriod(
        start: julyFirst,
        end: octoberFirst.subtract(const Duration(microseconds: 1)),
      );
    }
    return TrimesterPeriod(
      start: octoberFirst,
      end: date.lastDayOfYear.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is TrimesterGenerator);
  }

  @override
  List<Object?> get props => [];
}

/// A class that implements a generator of a period type of a semester.
class SemesterGenerator
    with PeriodGeneratorMixin<SemesterPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a semester.
  const SemesterGenerator();

  @override
  SemesterPeriod of(DateTime date) {
    final julyFirst = date.copyWith(month: DateTime.july, day: 1).date;
    if (date.isBefore(julyFirst)) {
      return SemesterPeriod(
        start: date.firstDayOfYear.date,
        end: julyFirst.subtract(const Duration(microseconds: 1)),
      );
    }
    return SemesterPeriod(
      start: julyFirst,
      end: date.lastDayOfYear.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is SemesterGenerator);
  }

  @override
  List<Object?> get props => [];
}

/// A class that implements a generator of a period type of a year.
class YearGenerator with PeriodGeneratorMixin<YearPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a year.
  const YearGenerator();

  @override
  YearPeriod of(DateTime date) {
    return YearPeriod(
      start: date.firstDayOfYear.date,
      end: date.lastDayOfYear.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is YearGenerator);
  }

  @override
  List<Object?> get props => [];
}
