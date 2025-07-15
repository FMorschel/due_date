import 'semester_period.dart';
import 'trimester_period.dart';
import 'trimester_period_bundle.dart';

/// {@template semesterPeriodBundle}
/// A base class that represents a bundle of semesters.
/// {@endtemplate}
abstract class SemesterPeriodBundle extends TrimesterPeriodBundle {
  /// {@macro semesterPeriodBundle}
  SemesterPeriodBundle({required super.start, required super.end});

  /// Returns the list of semesters in this bundle.
  List<SemesterPeriod> get semesters;

  @override
  List<TrimesterPeriod> get trimesters =>
      semesters.expand((s) => s.trimesters).toList();
}
