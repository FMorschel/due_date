/// Support for creating your own custom due dates.
///
/// This package is used to create custom due dates.
///
/// Implementing your own [DueDateTime] is easy. You implement an [Every]
/// class and pass it to the [DueDateTime] constructor.
///
/// There are already some [Every] classes implemented in this package. Look for
/// [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (or
/// [WeekdayOccurrence]s constants) and [EveryDayInYear].
///
/// The [Every] class is a base class that processes all the base operations for
/// [DueDateTime]. You can mix in one of the following mixins:
/// - [EveryWeek];
/// - [EveryMonth];
/// - [EveryYear];
///
/// And if you want to be more specific, implement the others.
///
/// WARNING: If you mix in two of the above mixins, the order in which you mix
/// them in is important. The last mixin you mix in will be the one that is
/// used for [DueDateTime.next] and [DueDateTime.previous] on the [DueDateTime]
/// class.
library;

import 'src/due_date.dart';
import 'src/enums/weekday_occurrence.dart';
import 'src/everies/built_in/every_day_in_year.dart';
import 'src/everies/built_in/every_due_day_month.dart';
import 'src/everies/built_in/every_weekday.dart';
import 'src/everies/built_in/every_weekday_count_in_month.dart';
import 'src/everies/every.dart';
import 'src/everies/every_month.dart';
import 'src/everies/every_week.dart';
import 'src/everies/every_year.dart';

export 'src/date_validators/date_validator.dart';
export 'src/date_validators/built_in/date_validator_day_in_year.dart';
export 'src/date_validators/group/date_validator_difference.dart';
export 'src/date_validators/built_in/date_validator_due_day_month.dart';
export 'src/date_validators/built_in/date_validator_due_workday_month.dart';
export 'src/date_validators/group/date_validator_intersection.dart';
export 'src/date_validators/group/date_validator_list_mixin.dart';
export 'src/date_validators/date_validator_mixin.dart';
export 'src/date_validators/built_in/date_validator_opposite.dart';
export 'src/date_validators/built_in/date_validator_time_of_day.dart';
export 'src/date_validators/group/date_validator_union.dart';
export 'src/date_validators/built_in/date_validator_weekday.dart';
export 'src/date_validators/built_in/date_validator_weekday_count_in_month.dart';
export 'src/date_validators/exact_date_validator.dart';
export 'src/due_date.dart';
export 'src/enums/month.dart';
export 'src/enums/week.dart';
export 'src/enums/weekday.dart';
export 'src/enums/weekday_occurrence.dart';
export 'src/everies/everies.dart';
export 'src/extensions/add_days.dart';
export 'src/extensions/clamp_in_month.dart';
export 'src/extensions/date_validator_list_ext.dart';
export 'src/extensions/day_in_year.dart';
export 'src/extensions/every_date_validator_list_ext.dart';
export 'src/extensions/previous_next.dart';
export 'src/extensions/week_calc.dart';
export 'src/extensions/workday_in_month.dart';
