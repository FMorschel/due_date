import 'every.dart';
import 'every_year.dart';

/// {@template everyMonth}
/// A representation of an [Every] that occurs every month.
/// {@endtemplate}
mixin EveryMonth implements EveryYear {
  /// This mixin's implementation of [Every.next] and [Every.previous].
  DateTime addMonths(DateTime date, int months);

  @override
  DateTime addYears(DateTime date, int years);
}
