import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

/// Custom matcher for DueDateTime equality.
///
/// Compares all fields of [DueDateTime], including [DueDateTime.every],
/// [DueDateTime.isUtc], and all date/time components.
Matcher isSameDueDateTime(DateTime expected) => _DueDateTimeMatcher(expected);

class _DueDateTimeMatcher extends Matcher {
  const _DueDateTimeMatcher(this._expected);

  final DateTime _expected;

  @override
  Description describe(Description description) =>
      description.add('is same DueDateTime as $_expected');

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is! DateTime) return false;
    // Compare all fields relevant for DueDateTime.
    return item.year == _expected.year &&
        item.month == _expected.month &&
        item.day == _expected.day &&
        item.hour == _expected.hour &&
        item.minute == _expected.minute &&
        item.second == _expected.second &&
        item.millisecond == _expected.millisecond &&
        item.microsecond == _expected.microsecond &&
        item.isUtc == _expected.isUtc &&
        _compareEvery(item, _expected);
  }

  bool _compareEvery(DateTime a, DateTime b) {
    // If both are DueDateTime, compare .every, else ignore.
    if (a is DueDateTime && b is DueDateTime) {
      return a.every == b.every;
    }
    return true;
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is! DateTime) {
      mismatchDescription.add('$item was not a DateTime');
      return mismatchDescription;
    }
    mismatchDescription.add('was $item');
    return mismatchDescription;
  }
}
