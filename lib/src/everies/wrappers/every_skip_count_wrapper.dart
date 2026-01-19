import 'package:equatable/equatable.dart';

import '../date_direction.dart';
import '../every.dart';
import 'every_wrapper.dart';
import 'every_wrapper_mixin.dart';

/// {@template everySkipCountWrapper}
/// Class that wraps an [Every] generator and skips [count] times from the
/// [Every] base process.
/// {@endtemplate}
class EverySkipCountWrapper<T extends Every> extends EveryWrapper<T>
    with EquatableMixin, EveryWrapperMixin<T> {
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
  DateTime next(DateTime date, {int? currentCount}) {
    assert(
      currentCount == null || currentCount >= 0,
      'currentCount must be greater than or equal to 0',
    );
    return processDate(
      every.next(date),
      DateDirection.next,
      currentCount: currentCount ?? count,
    );
  }

  /// Generates the previous of the [every] base process.
  /// It will skip [currentCount] times from the [date] using the
  /// [EverySkipCountWrapper.previous] process.
  ///
  /// {@macro currentCount}
  @override
  DateTime previous(DateTime date, {int? currentCount}) {
    assert(
      currentCount == null || currentCount >= 0,
      'currentCount must be greater than or equal to 0',
    );
    return processDate(
      every.previous(date),
      DateDirection.previous,
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
    int? currentCount,
  }) {
    assert(
      (currentCount == null) || (currentCount >= 0),
      'currentCount must be greater than or equal to 0',
    );
    currentCount ??= count;
    if (currentCount <= 0) return date;
    if (direction.isForward) {
      return next(date, currentCount: currentCount - 1);
    }
    return previous(date, currentCount: currentCount - 1);
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
