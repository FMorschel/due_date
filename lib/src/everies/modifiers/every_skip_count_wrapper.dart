import 'package:equatable/equatable.dart';

import '../../helpers/helpers.dart';
import '../date_time_limit_reached_exception.dart';
import '../every.dart';
import 'date_direction.dart';
import 'limited_every_modifier.dart';
import 'limited_every_modifier_mixin.dart';

/// {@template everySkipCountWrapper}
/// Class that wraps an [Every] generator and skips [count] times from the
/// [Every] base process.
/// {@endtemplate}
class EverySkipCountWrapper<T extends Every> extends LimitedEveryModifier<T>
    with EquatableMixin, LimitedEveryModifierMixin<T> {
  /// {@macro everySkipCountWrapper}
  const EverySkipCountWrapper({
    required super.every,
    required this.count,
  }) : assert(count >= 0, 'Count must be greater than or equal to 0');

  /// The number of times to skip.
  final int count;

  /// Generates the next of the [every] base process.
  /// It will skip [currentCount] times from the [date] using the
  /// [EverySkipCountWrapper.next] process.
  ///
  /// {@macro currentCount}
  @override
  DateTime next(DateTime date, {DateTime? limit, int? currentCount}) {
    assert(
      currentCount == null || currentCount >= 0,
      'currentCount must be greater than or equal to 0',
    );
    return processDate(
      LimitedOrEveryHandler.next(every, date, limit: limit),
      DateDirection.next,
      limit: limit,
      currentCount: currentCount ?? count,
    );
  }

  /// Generates the previous of the [every] base process.
  /// It will skip [currentCount] times from the [date] using the
  /// [EverySkipCountWrapper.previous] process.
  ///
  /// {@macro currentCount}
  @override
  DateTime previous(DateTime date, {DateTime? limit, int? currentCount}) {
    assert(
      currentCount == null || currentCount >= 0,
      'currentCount must be greater than or equal to 0',
    );
    return processDate(
      LimitedOrEveryHandler.previous(every, date, limit: limit),
      DateDirection.previous,
      limit: limit,
      currentCount: currentCount ?? count,
    );
  }

  /// Continues iterating the [every] base process.
  /// It will skip [currentCount] times from the [date].
  ///
  /// {@macro currentCount}
  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
    int? currentCount,
  }) {
    assert(
      (currentCount == null) || (currentCount >= 0),
      'currentCount must be greater than or equal to 0',
    );
    if ((limit != null) &&
        (direction.isPrevious ? date.isBefore(limit) : date.isAfter(limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    currentCount ??= count;
    if (currentCount <= 0) return date;
    if (!direction.isPrevious) {
      return next(date, limit: limit, currentCount: currentCount - 1);
    }
    return previous(date, limit: limit, currentCount: currentCount - 1);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EverySkipCountWrapper) &&
            (other.every == every) &&
            (other.count == count));
  }

  @override
  List<Object?> get props => [every, count];
}
