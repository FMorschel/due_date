import 'package:equatable/equatable.dart';

import '../../enums/weekday.dart';
import '../../everies/built_in/every_weekday.dart';
import '../date_validator.dart';
import '../date_validator_mixin.dart';
import '../group/date_validator_union.dart';

/// A [DateValidator] that validates a [DateTime] if it is on the given
/// [weekday].
class DateValidatorWeekday
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorWeekday> {
  /// A [DateValidator] that validates a [DateTime] if it is on the given
  /// [weekday].
  const DateValidatorWeekday(this.weekday);

  /// A [DateValidator] that validates a [DateTime] if it is on the given
  /// [weekday].
  factory DateValidatorWeekday.from(DateTime date) {
    return DateValidatorWeekday(Weekday.from(date));
  }

  /// A [DateValidator] that validates a [DateTime] if it is a workday.
  static const DateValidatorUnion<EveryWeekday> workdays = DateValidatorUnion([
    EveryWeekday(Weekday.monday),
    EveryWeekday(Weekday.tuesday),
    EveryWeekday(Weekday.wednesday),
    EveryWeekday(Weekday.thursday),
    EveryWeekday(Weekday.friday),
  ]);

  /// A [DateValidator] that validates a [DateTime] if it is a weekend.
  static const DateValidatorUnion<EveryWeekday> weekend = DateValidatorUnion([
    EveryWeekday(Weekday.saturday),
    EveryWeekday(Weekday.sunday),
  ]);

  /// The expected weekday.
  final Weekday weekday;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorWeekday) && (weekday == other.weekday));
  }

  @override
  bool valid(DateTime date) => date.weekday == weekday.dateTimeValue;

  @override
  int compareTo(DateValidatorWeekday other) => weekday.compareTo(other.weekday);

  @override
  List<Object> get props => [weekday];
}
