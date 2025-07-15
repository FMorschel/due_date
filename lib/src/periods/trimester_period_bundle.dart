import 'month_period.dart';
import 'month_period_bundle.dart';
import 'trimester_period.dart';

/// {@template trimesterPeriodBundle}
/// A base class that represents a bundle of trimesters.
/// {@endtemplate}
abstract class TrimesterPeriodBundle extends MonthPeriodBundle {
  /// {@macro trimesterPeriodBundle}
  TrimesterPeriodBundle({required super.start, required super.end});

  /// Returns the list of trimesters in this bundle.
  List<TrimesterPeriod> get trimesters;

  @override
  List<MonthPeriod> get months => trimesters.expand((t) => t.months).toList();
}
