import 'modifiers.dart';

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
