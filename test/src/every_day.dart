import 'package:due_date/src/everies/every.dart';

/// A plain [Every] (not a date validator) that occurs every day at the time
/// of day of the given date.
class EveryDay extends Every {
  /// A plain [Every] that occurs every day.
  const EveryDay();

  @override
  DateTime next(DateTime date) => date.add(const Duration(days: 1));

  @override
  DateTime previous(DateTime date) => date.subtract(const Duration(days: 1));
}
