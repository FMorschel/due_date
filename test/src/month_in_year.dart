import 'package:equatable/equatable.dart';

class MonthInYear with EquatableMixin {
  const MonthInYear(
    this.year,
    this.month,
  );

  final int month;
  final int year;

  // ignore: essential_lints/optional_positional_parameters valid use
  DateTime date([int day = 1]) => DateTime(year, month, day);

  @override
  String toString() {
    return 'MonthInYear{year: $year, month: $month}';
  }

  @override
  List<Object?> get props => [year, month];
}
