import 'wrappers/every_wrapper.dart';

/// An enum that represents the direction of the process inside [EveryWrapper].
/// Used on [EveryWrapper.processDate].
enum DateDirection {
  /// Represents the start direction of the process inside [EveryWrapper].
  start,

  /// Represents the next direction of the process inside [EveryWrapper].
  next,

  /// Represents the previous direction of the process inside [EveryWrapper].
  previous,

  /// Represents the end direction of the process inside [EveryWrapper].
  end;

  /// Returns true if the [DateDirection] is [DateDirection.start].
  bool get isStart => this == DateDirection.start;

  /// Returns true if the [DateDirection] is [DateDirection.next].
  bool get isNext => this == DateDirection.next;

  /// Returns true if the [DateDirection] is [DateDirection.previous].
  bool get isPrevious => this == DateDirection.previous;

  /// Returns true if the [DateDirection] is [DateDirection.end].
  bool get isEnd => this == DateDirection.end;

  /// Returns true if the [DateDirection] is [DateDirection.start] or
  /// [DateDirection.next].
  bool get isForward => isNext || isStart;

  /// Returns true if the [DateDirection] is [DateDirection.previous] or
  /// [DateDirection.end].
  bool get isBackward => isPrevious || isEnd;

  /// Returns true if the [DateDirection] could stay equal to the input date.
  bool get couldStayEqual => isStart || isEnd;
}
