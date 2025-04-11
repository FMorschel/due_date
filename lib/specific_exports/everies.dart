/// Support for creating your own custom DateTime generators.
///
/// There are already some [Every] classes implemented in this package.
///
/// Here are some examples:
/// - [EveryDateValidator];
/// - [EveryDayInYear];
/// - [EveryDueDayMonth];
/// - [EveryDueWorkdayMonth];
/// - [EveryDueTimeOfDay];
/// - [EveryDueWorkdayMonth];
/// - [EveryWeekdayCountInMonth];
/// - [EveryWeekday].
///
/// For base classes that represent an [Every] there are:
/// - [Every];
/// - [EveryDateValidator];
/// - [EveryMonth];
/// - [EveryWeek];
/// - [EveryYear].
///
/// You would probaly use [Every] or [EveryDateValidator] the most with any of
/// the other as a mixin.
///
/// Different validators can be combined using [EveryDateValidatorUnion],
/// [EveryDateValidatorDifference] and [EveryDateValidatorIntersection].
///
/// If you want to make your own combinator you can use
/// [EveryDateValidatorListMixin].
///
/// ---
///
/// There are also modifiers that can be used to modify the base behaviour of an
/// [Every] class. These are:
/// - [EveryModifierInvalidator];
/// - [EveryOverrideWrapper];
/// - [EverySkipCountWrapper];
/// - [EverySkipInvalidModifier].
///
/// And if you want to make your own modifier/wrapper you can use:
/// - [EveryModifierMixin];
/// - [EveryModifier];
/// - [LimitedEveryModifierMixin].
library date_validator;

import '../src/everies/everies.dart';

export '../src/enums/enums.dart' show Month, Week, Weekday, WeekdayOccurrence;
export '../src/everies/everies.dart';
export '../src/extensions/extensions.dart'
    show
        AddDays,
        ClampInMonth,
        DayInYear,
        EveryDateValidatorListExt,
        ExactTimeOfDay,
        PreviousNext,
        WeekCalc,
        WorkdayInMonth;
