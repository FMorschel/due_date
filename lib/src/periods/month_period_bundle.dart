import 'month_period.dart';
import 'period.dart';

/// {@template monthPeriodBundle}
/// A base class that represents a bundle of months.
/// {@endtemplate}
abstract class MonthPeriodBundle extends Period {
  /// {@macro monthPeriodBundle}
  MonthPeriodBundle({required super.start, required super.end});

  /// Returns the list of months in this bundle.
  List<MonthPeriod> get months;
}
