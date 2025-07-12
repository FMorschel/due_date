import '../period_generators/period_generators.dart';
import '../period_generators/semester_generator.dart';
import '../period_generators/year_generator.dart';
import '../periods/periods.dart';

/// An enumeration of the different period generators implemented in this
/// package.
enum PeriodGenerator<T extends Period> with PeriodGeneratorMixin<T> {
  /// Creates periods of a second.
  second(SecondGenerator()),

  /// Creates periods of a minute.
  minute(MinuteGenerator()),

  /// Creates periods of an hour.
  hour(HourGenerator()),

  /// Creates periods of a day.
  day(DayGenerator()),

  /// Creates periods of a week.
  week(WeekGenerator()),

  /// Creates periods of a fortnight.
  fortnight(FortnightGenerator()),

  /// Creates periods of a month.
  month(MonthGenerator()),

  /// Creates periods of a trimester.
  trimester(TrimesterGenerator()),

  /// Creates periods of a semester.
  semester(SemesterGenerator()),

  /// Creates periods of a year.
  year(YearGenerator());

  /// An enumeration of the different period generators implemented in this
  /// package.
  const PeriodGenerator(PeriodGeneratorMixin<T> handler) : _handler = handler;

  final PeriodGeneratorMixin<T> _handler;

  @override
  T of(DateTime date) => _handler.of(date);

  @override
  bool fitsGenerator(Period period) => _handler.fitsGenerator(period);
}
