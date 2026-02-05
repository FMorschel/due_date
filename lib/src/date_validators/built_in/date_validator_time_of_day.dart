import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../date_validator_mixin.dart';

/// {@template dateValidatorDay}
/// Class that validates a [DateTime] if its [DateTimeTimeExtension.timeOfDay]
/// matches the given [timeOfDay].
///
/// The [timeOfDay] must be between 0 and 24 hours (exclusive).
/// {@endtemplate}
class DateValidatorTimeOfDay
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorTimeOfDay> {
  /// {@macro dateValidatorDay}
  const DateValidatorTimeOfDay(this.timeOfDay);

  /// Constructor that takes the time of day from [date].
  ///
  /// {@macro dateValidatorDay}
  factory DateValidatorTimeOfDay.from(DateTime date) {
    return DateValidatorTimeOfDay(date.timeOfDay);
  }

  /// This is the time of day that will be used to calculate the next date.
  ///
  /// The [timeOfDay] must be between 0 and 24 hours (exclusive).
  final Duration timeOfDay;

  @override
  List<Object?> get props => [timeOfDay];

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorTimeOfDay) && (timeOfDay == other.timeOfDay));
  }

  @override
  int compareTo(DateValidatorTimeOfDay other) =>
      timeOfDay.compareTo(other.timeOfDay);

  @override
  bool valid(DateTime date) => date.timeOfDay == timeOfDay;
}
