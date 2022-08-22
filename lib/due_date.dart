/// Support for creating your own custom due dates.
///
/// This package is used to create custom due dates.
///
/// Implementing your own DueDateTime is easy. You implement an [Every]
/// class and pass it to the [DueDateTime] constructor.
///
/// There are already some [Every] classes implemented in this package. Look for
/// [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (or
/// [WeekdayOccurrence]s constants) and [EveryDayInYear].
///
/// The [Every] class is a base class that processes all the base operations for
/// [DueDateTime]. You can mix in one of the folowing mixins:
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
library due_date;

export 'src/due_date.dart';
export 'src/enums.dart';
export 'src/every.dart';
export 'src/extensions.dart';
