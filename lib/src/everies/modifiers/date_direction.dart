import 'modifiers.dart';

/// An enum that represents the direction of the process inside [EveryModifier].
/// Used on [EveryModifier.processDate].
enum DateDirection {
  /// Represents the start direction of the process inside [EveryModifier].
  start,

  /// Represents the next direction of the process inside [EveryModifier].
  next,

  /// Represents the previous direction of the process inside [EveryModifier].
  previous,

  /// Represents the end direction of the process inside [EveryModifier].
  end;

  /// Returns true if the [DateDirection] is [DateDirection.start].
  bool get isStart => this == DateDirection.start;

  /// Returns true if the [DateDirection] is [DateDirection.next].
  bool get isNext => this == DateDirection.next;

  /// Returns true if the [DateDirection] is [DateDirection.previous].
  bool get isPrevious => this == DateDirection.previous;

  /// Returns true if the [DateDirection] is [DateDirection.end].
  bool get isEnd => this == DateDirection.end;
}
