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
import 'src/enums/enums.dart' show WeekdayOccurrence;
import 'src/everies/everies.dart';

export 'src/date_validators/date_validators.dart';
export 'src/due_date.dart';
export 'src/enums/enums.dart' show Month, Week, Weekday, WeekdayOccurrence;
export 'src/everies/everies.dart';
export 'src/extensions/extensions.dart' show ExactTimeOfDay, WorkdayInMonth;
export 'src/extensions/extensions.dart'
    show
        AddDays,
        ClampInMonth,
        DateValidatorListExt,
        DayInYear,
        EveryDateValidatorListExt,
        PreviousNext,
        WeekCalc;
