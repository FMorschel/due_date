import 'package:equatable/equatable.dart';

import '../../helpers/limited_or_every_handler.dart';
import '../date_direction.dart';
import '../every.dart';
import '../every_date_validator.dart';
import '../wrappers/limited_every_skip_count_wrapper.dart';
import 'every_skip_count_modifier.dart';
import 'limited_every_modifier.dart';
import 'limited_every_modifier_mixin.dart';

/// {@template limitedEverySkipCountModifier}
/// Class that wraps an [Every] generator and skips [count] times from the
/// [Every] base process.
/// {@endtemplate}
class LimitedEverySkipCountModifier<T extends EveryDateValidator>
    extends LimitedEveryModifier<T>
    with EquatableMixin, LimitedEveryModifierMixin<T>
    implements LimitedEverySkipCountWrapper<T>, EverySkipCountModifier<T> {
  /// {@macro limitedEverySkipCountModifier}
  const LimitedEverySkipCountModifier({
    required super.every,
    required this.count,
  }) : assert(count >= 0, 'Count must be greater than or equal to 0');

  /// The number of times to skip.
  @override
  final int count;

  @override
  bool valid(DateTime date, {int? currentCount}) {
    assert(
      currentCount == null || currentCount >= 0,
      'currentCount must be greater than or equal to 0',
    );
    if (currentCount != null && currentCount > 0) return false;
    return every.valid(date);
  }

  /// Generates the next of the [every] base process.
  /// It will skip [currentCount] times from the [date] using the
  /// [LimitedEverySkipCountModifier.next] process.
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
  /// [LimitedEverySkipCountModifier.previous] process.
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
    throwIfLimitReached(date, direction, limit: limit);
    currentCount ??= count;
    if (currentCount <= 0) return date;
    if (direction.isForward) {
      return next(date, limit: limit, currentCount: currentCount - 1);
    }
    return previous(date, limit: limit, currentCount: currentCount - 1);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is LimitedEverySkipCountModifier<T>) &&
            (other.every == every) &&
            (other.count == count));
  }

  @override
  List<Object?> get props => [every, count];
}
