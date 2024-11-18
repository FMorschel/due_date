import 'day_period.dart';
import 'period.dart';

/// {@template dayPeriodBundle}
/// A base class that represents a bundle of days.
/// {@endtemplate}
abstract class DayPeriodBundle extends Period {
  /// {@macro dayPeriodBundle}
  DayPeriodBundle({required super.start, required super.end});

  /// Returns the list of days in this bundle.
  List<DayPeriod> get days;
}
