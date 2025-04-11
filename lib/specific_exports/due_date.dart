/// This is a library that only exports the [DueDateTime] class.
///
/// It is used together with an [Every] class to configure the rule for the next
/// date to be generated. By default it will use a [EveryDueDayMonth] internally
/// if nothing is specified.
library due_date;

import '../src/due_date.dart';
import '../src/everies/everies.dart';

export '../src/due_date.dart';
