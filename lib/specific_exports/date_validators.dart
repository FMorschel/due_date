/// Support for creating your own custom validators for dates.
///
/// These validators can be used inside [Iterable.where] or similar.
///
/// These validators are used by [Every] classes to validate dates.
///
/// For the [Every] classes, look at the `every` or `due_date` import.
///
/// There are already some [DateValidator] classes implemented in this package.
///
/// Here are some examples:
/// - [DateValidatorDayInYear];
/// - [DateValidatorDueDayMonth];
/// - [DateValidatorDueWorkdayMonth];
/// - [DateValidatorTimeOfDay];
/// - [DateValidatorWeekdayCountInMonth];
/// - [DateValidatorWeekday];
/// - [DateValidator];
/// - [ExactDateValidator].
///
/// Different validators can be combined using [DateValidatorUnion],
/// [DateValidatorDifference] and [DateValidatorIntersection].
///
/// If you want to make your own combinator you can use
/// [DateValidatorListMixin].
library date_validator;

import '../src/date_validators/date_validators.dart';
import '../src/everies/every.dart' show Every;

export '../src/date_validators/date_validators.dart';
export '../src/enums/enums.dart' show Month, Week, Weekday, WeekdayOccurrence;
export '../src/extensions/extensions.dart'
    show
        AddDays,
        ClampInMonth,
        DateValidatorListExt,
        DayInYear,
        ExactTimeOfDay,
        PreviousNext,
        WeekCalc,
        WorkdayInMonth;
