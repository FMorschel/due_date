import 'package:equatable/equatable.dart';

import '../due_date.dart';
import 'constants.dart';

/// An enum that represents the direction of the process inside [EveryModifier].
/// Used on [EveryModifier.processDate].
enum DateDirection {
  /// An enum that represents the start direction of the process inside
  /// [EveryModifier].
  start,

  /// An enum that represents the next direction of the process inside
  /// [EveryModifier].
  next,

  /// An enum that represents the previous direction of the process inside
  /// [EveryModifier].
  previous;

  /// Returns true if the [DateDirection] is [DateDirection.start].
  bool get isStart => this == DateDirection.start;

  /// Returns true if the [DateDirection] is [DateDirection.next].
  bool get isNext => this == DateDirection.next;

  /// Returns true if the [DateDirection] is [DateDirection.previous].
  bool get isPrevious => this == DateDirection.previous;
}

/// {@template everyModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class EveryModifier<T extends Every> implements Every {
  /// {@macro everyModifier}
  const EveryModifier({
    required this.every,
  });

  /// The base generator for this [EveryModifier].
  final T every;

  /// A method that processes [date] with custom logic.
  DateTime processDate(DateTime date, DateDirection direction);
}

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls the specific method on the
/// underlying [every].
///
/// If the [every] is a [LimitedEvery], the [LimitedEveryModifierMixin] should
/// be used instead.
/// {@endtemplate}
mixin EveryModifierMixin<T extends Every> on EveryModifier<T> {
  @override
  DateTime startDate(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.startDate(every, date, limit: null),
      DateDirection.start,
    );
  }

  @override
  DateTime next(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.next(every, date, limit: null),
      DateDirection.next,
    );
  }

  @override
  DateTime previous(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.previous(every, date, limit: null),
      DateDirection.previous,
    );
  }
}

/// {@macro everyModifierMixin}
///
/// Also makes the using class a [LimitedEvery].
///
/// Should **always** be used when the [every] is a [LimitedEvery].
mixin LimitedEveryModifierMixin<T extends Every> on EveryModifier<T>
    implements LimitedEvery {
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.startDate(every, date, limit: limit),
      DateDirection.start,
      limit: limit,
    );
  }

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.next(every, date, limit: limit),
      DateDirection.next,
      limit: limit,
    );
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.previous(every, date, limit: limit),
      DateDirection.previous,
      limit: limit,
    );
  }

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  });
}

/// {@template everyModifierInvalidator}
/// Class that wraps an [every] generator and adds an [invalidator] that will
/// be used to invalidate the generated dates.
/// {@endtemplate}
abstract class EveryModifierInvalidator<T extends Every>
    extends EveryModifier<T> with EveryModifierMixin<T> {
  /// {@macro everyModifierInvalidator}
  const EveryModifierInvalidator({
    required super.every,
    required this.invalidator,
  });

  /// The [DateValidator] that will be used to invalidate the generated dates.
  final DateValidator invalidator;
}

/// {@template everySkipInvalidModifier}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates.
///
/// It will return the next [DateTime] that matches the [every] pattern and is
/// not valid for the [invalidator].
/// {@endtemplate}
class EverySkipInvalidModifier<T extends Every, V extends DateValidator>
    extends EveryModifierInvalidator<T>
    with EquatableMixin, DateValidatorMixin, LimitedEveryModifierMixin<T>
    implements EveryDateValidator {
  /// {@macro everySkipInvalidModifier}
  const EverySkipInvalidModifier({
    required super.every,
    required super.invalidator,
  });

  /// Returns the next [DateTime] that matches the [every] pattern and is not
  /// valid for the [invalidator].
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) =>
      super.startDate(date, limit: limit);

  /// Returns the next instance of the given [date] considering the [every]
  /// base process. If the [date] is valid for the [invalidator], a new
  /// [DateTime] will be returned.
  @override
  DateTime next(DateTime date, {DateTime? limit}) =>
      super.next(date, limit: limit);

  /// Returns the previous instance of the given [date] considering the [every]
  /// base process. If the [date] is valid for the [invalidator], a new
  /// [DateTime] will be returned.
  @override
  DateTime previous(DateTime date, {DateTime? limit}) =>
      super.previous(date, limit: limit);

  /// Returns `true` if the [date] is valid for the [every] (if it is a
  /// [DateValidator], like an [EveryDateValidator], for example) and not valid
  /// for the [invalidator].
  @override
  bool valid(DateTime date) {
    if (every is DateValidator) {
      final invalid = (every as DateValidator).invalid(date);
      if (invalid) return false;
    }
    return invalidator.invalid(date);
  }

  /// Returns `true` if the [date] is invalid for the [every] (if it is a
  /// [DateValidator], like an [EveryDateValidator], for example) and valid for
  /// the [invalidator].
  ///
  /// This is the opposite of [valid].
  /// Implementations that return true for invalid should also return false for
  /// valid.
  ///
  /// Usually, this will be implemented as `!valid(date)` by the [Every] classes
  /// that implement [DateValidatorMixin]. However, if there is a simpler way to
  /// check for invalid dates, it can be implemented here.
  @override
  bool invalid(DateTime date) {
    if (every is DateValidator) {
      final invalid = (every as DateValidator).invalid(date);
      if (invalid) return true;
    }
    return invalidator.valid(date);
  }

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) {
    if ((limit != null) &&
        (direction.isPrevious ? date.isBefore(limit) : date.isAfter(limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    if (invalidator.invalid(date)) return date;
    if (!direction.isPrevious) return next(date, limit: limit);
    return previous(date, limit: limit);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EverySkipInvalidModifier) &&
            (other.every == every) &&
            (other.invalidator == invalidator));
  }

  @override
  List<Object?> get props => [every, invalidator];
}

/// {@template everyOverrideWrapper}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates and an [overrider] that will be
/// used instead.
///
/// When the [invalidator] invalidates the generated dates, the [overrider]
/// will be used instead.
/// {@endtemplate}
class EveryOverrideWrapper<T extends Every> extends EveryModifierInvalidator<T>
    with EquatableMixin, LimitedEveryModifierMixin<T> {
  /// {@macro everyOverrideWrapper}
  const EveryOverrideWrapper({
    required super.every,
    required super.invalidator,
    required this.overrider,
  });

  /// The every used instead of the original when the generated date is valid
  /// for the [invalidator].
  final T overrider;

  /// Generates the start date of the [every] base process.
  /// If the [date] is valid for the [invalidator], the [overrider] startDate
  /// will be used instead of the [every].
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    final validForEveryValidator =
        (every is DateValidator) && ((every as DateValidator).valid(date));
    if (!validForEveryValidator && (every.startDate(date) != date)) {
      DateTime previous = LimitedOrEveryHandler.previous(
        overrider,
        date,
        limit: limit,
      );

      /// - Iterate over the next possible dates after [previous] with the
      /// [every] generator using startDate on the first iteration and next on
      /// every following.
      /// If the date generated for the  iteration is already bigger than the
      /// given [date], super.startDate will be used.
      /// If the date is valid for the [invalidator], the [overrider] startDate
      /// will be used.
      /// If that date is then the exact given [date], it will be returned.
      /// If that date is before the given [date], a new iteration will be
      /// started.
      previous = every.startDate(previous);
      if (previous.isAfter(date)) {
        return super.startDate(date, limit: limit);
      } else if (previous.isAtSameMomentAs(date)) {
        if (invalidator.invalid(previous)) return date;
      }
      while (previous.isBefore(date)) {
        if (invalidator.valid(previous)) {
          previous = overrider.startDate(previous);
        }
        if (previous.isAfter(date)) {
          return super.startDate(date, limit: limit);
        } else if (previous.isAtSameMomentAs(date)) {
          if (invalidator.invalid(previous)) return date;
        }
        previous = every.next(previous);
      }
      if (previous.isAfter(date)) {
        return super.startDate(date, limit: limit);
      } else if (previous.isAtSameMomentAs(date)) {
        if (invalidator.invalid(previous)) return date;
      }
    }
    return super.startDate(date, limit: limit);
  }

  /// Generates the next instance of the given [date] considering the [every]
  /// base process.
  /// If the [date] is valid for the [invalidator], the [overrider] next will
  /// be used instead of the [every].
  @override
  DateTime next(DateTime date, {DateTime? limit}) =>
      super.next(date, limit: limit);

  /// Generates the previous instance of the given [date] considering the
  /// [every] base process.
  /// If the [date] is valid for the [invalidator], the [overrider] previous
  /// will be used instead of the [every].
  @override
  DateTime previous(DateTime date, {DateTime? limit}) =>
      super.previous(date, limit: limit);

  /// When the [date] is valid for the [invalidator], the [overrider] will be
  /// used instead of [every].
  ///
  /// If the [date] is invalid for the [invalidator], [date] will be returned.
  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) {
    if ((limit != null) &&
        (direction.isPrevious ? date.isBefore(limit) : date.isAfter(limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    if (invalidator.invalid(date)) return date;
    if (!direction.isPrevious) {
      return processDate(
        LimitedOrEveryHandler.next(overrider, date, limit: limit),
        direction,
        limit: limit,
      );
    }
    return processDate(
      LimitedOrEveryHandler.previous(overrider, date, limit: limit),
      direction,
      limit: limit,
    );
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryOverrideWrapper) &&
            (other.every == every) &&
            (other.invalidator == invalidator) &&
            (other.overrider == overrider));
  }

  @override
  List<Object?> get props => [every, invalidator, overrider];
}

/// {@template everySkipCountWrapper}
/// Class that wraps an [Every] generator and skips [count] times from the
/// [Every] base process.
/// {@endtemplate}
class EverySkipCountWrapper<T extends Every> extends EveryModifier<T>
    with EquatableMixin, LimitedEveryModifierMixin<T> {
  /// {@macro everySkipCountWrapper}
  const EverySkipCountWrapper({
    required super.every,
    required this.count,
  }) : assert(count >= 0, 'Count must be greater than or equal to 0');

  /// The number of times to skip.
  final int count;

  /// Generates the start date of the [every] base process.
  /// It will skip [currentCount] times from the [date] using the
  /// [EverySkipCountWrapper.next] process.
  ///
  /// {@template currentCount}
  /// If [currentCount] is `null`, it will be set to [count].
  /// {@endtemplate}
  @override
  DateTime startDate(DateTime date, {DateTime? limit, int? currentCount}) {
    assert(
      currentCount == null || currentCount >= 0,
      'currentCount must be greater than or equal to 0',
    );
    final validForEveryValidator =
        (every is DateValidator) && ((every as DateValidator).valid(date));
    if (validForEveryValidator ||
        LimitedOrEveryHandler.startDate(every, date, limit: limit) == date) {
      return date;
    }
    return processDate(
      LimitedOrEveryHandler.next(every, date, limit: limit),
      DateDirection.next,
      limit: limit,
      currentCount: currentCount ?? count,
    );
  }

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
