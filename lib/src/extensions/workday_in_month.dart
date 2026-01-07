import '../helpers/workday_helper.dart';

/// Extension methods to get the workday number in the month of a [DateTime].
extension WorkdayInMonth on DateTime {
  // ignore: format-comment, false positive
  /// Returns the workday number in the month of this [DateTime].
  ///
  /// If the [DateTime] is not a workday (weekend: saturday or sunday), returns
  /// 0.
  int get workdayInMonth => WorkdayHelper.getWorkdayNumberInMonth(this);

  // ignore: format-comment, false positive
  /// Returns `true` if the [DateTime] is a workday (weekdays: monday to
  /// friday).
  bool get isWorkday => WorkdayHelper.every.valid(this);
}
