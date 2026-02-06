import 'built_in/every_due_workday_month.dart';

/// An enum that represents the direction of the [EveryDueWorkdayMonth.from]
/// constructor.
enum WorkdayDirection {
  /// An enum that represents the direction of the [EveryDueWorkdayMonth.from]
  /// constructor.
  ///
  /// Represents no direction.
  /// If this is passed to the [EveryDueWorkdayMonth.from] constructor, and the
  /// given date is not a workday, it will throw an [ArgumentError].
  none,

  /// An enum that represents the direction of the [EveryDueWorkdayMonth.from]
  /// constructor.
  ///
  /// Represents a forward direction.
  /// If this is passed to the [EveryDueWorkdayMonth.from] constructor, and the
  /// given date is not a workday, it will return the next workday.
  forward,

  /// An enum that represents the direction of the [EveryDueWorkdayMonth.from]
  /// constructor.
  ///
  /// Represents a backward direction.
  /// If this is passed to the [EveryDueWorkdayMonth.from] constructor, and the
  /// given date is not a workday, it will return the previous workday.
  backward;

  /// Returns true if `this` is [WorkdayDirection.none].
  bool get isNone => this == WorkdayDirection.none;

  /// Returns true if `this` is [WorkdayDirection.forward].
  bool get isForward => this == WorkdayDirection.forward;

  /// Returns true if `this` is [WorkdayDirection.backward].
  bool get isBackward => this == WorkdayDirection.backward;
}
