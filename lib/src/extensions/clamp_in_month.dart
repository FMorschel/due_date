import 'package:time/time.dart';

import '../due_date.dart';
import '../everies/everies.dart';

/// Extension methods related to clamping months on [DateTime].
extension ClampInMonth on DateTime {
  /// Returns a new [DueDateTime] with a [EveryDueDayMonth] based on [day].
  DueDateTime get dueDateTime => DueDateTime.fromDate(this);

  /// Returns a new [DateTime] clamped to the given [month].
  DateTime clampInMonth(DateTime month) {
    final monthStart = month.firstDayOfMonth;
    final monthEnd = monthStart.lastDayOfMonth;
    return clamp(min: monthStart, max: monthEnd);
  }
}
