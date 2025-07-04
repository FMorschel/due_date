import 'package:due_date/src/everies/every.dart';
import 'package:test/test.dart';

/// Creates a matcher that verifies [Every.startDate] returns the expected date.
Matcher startsAt(DateTime expectedDate) => _StartsAtMatcher(expectedDate);

/// Creates a matcher that verifies [Every.next] returns the expected date.
Matcher hasNext(DateTime expectedDate) => _HasNextMatcher(expectedDate);

/// Creates a matcher that verifies [Every.previous] returns the expected date.
Matcher hasPrevious(DateTime expectedDate) => _HasPreviousMatcher(expectedDate);

/// Creates a matcher that verifies [Every.startDate] returns the input date
/// when valid.
Matcher startsAtSameDate = const _StartsAtSameDateMatcher();

/// Creates a matcher that verifies [Every.next] generates a date after the
/// input.
Matcher nextIsAfter = const _NextIsAfterMatcher();

/// Creates a matcher that verifies [Every.previous] generates a date before the
/// input.
Matcher previousIsBefore = const _PreviousIsBeforeMatcher();

abstract class _EveryMatcher extends Matcher {
  const _EveryMatcher();

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is! Every) return false;
    return _matchesEvery(item, matchState);
  }

  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState);

  /// {@macro withInputMethod}
  Matcher withInput(DateTime input) => _WithInputMatcher<DateTime>(this, input);

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is! Every) {
      return mismatchDescription.add('$item is not an Every instance');
    }
    return _describeEveryMismatch(item, mismatchDescription, matchState);
  }

  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  );
}

class _StartsAtMatcher extends _EveryMatcher {
  const _StartsAtMatcher(this._expectedDate);

  final DateTime _expectedDate;

  @override
  Description describe(Description description) =>
      description.add('starts at $_expectedDate');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final actualDate = every.startDate(input);
    matchState['actualDate'] = actualDate;
    return actualDate.isAtSameMomentAs(_expectedDate);
  }

  @override
  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final actualDate = matchState['actualDate'];
    return mismatchDescription.add('started at $actualDate');
  }
}

class _HasNextMatcher extends _EveryMatcher {
  const _HasNextMatcher(this._expectedDate);

  final DateTime _expectedDate;

  @override
  Description describe(Description description) =>
      description.add('has next $_expectedDate');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final actualDate = every.next(input);
    matchState['actualDate'] = actualDate;
    return actualDate.isAtSameMomentAs(_expectedDate);
  }

  @override
  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final actualDate = matchState['actualDate'];
    return mismatchDescription.add('next was $actualDate');
  }
}

class _HasPreviousMatcher extends _EveryMatcher {
  const _HasPreviousMatcher(this._expectedDate);

  final DateTime _expectedDate;

  @override
  Description describe(Description description) =>
      description.add('has previous $_expectedDate');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final actualDate = every.previous(input);
    matchState['actualDate'] = actualDate;
    return actualDate.isAtSameMomentAs(_expectedDate);
  }

  @override
  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final actualDate = matchState['actualDate'];
    return mismatchDescription.add('previous was $actualDate');
  }
}

class _StartsAtSameDateMatcher extends _EveryMatcher {
  const _StartsAtSameDateMatcher();

  @override
  Description describe(Description description) =>
      description.add('starts at the same date when input is valid');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final actualDate = every.startDate(input);
    matchState['actualDate'] = actualDate;
    return actualDate.isAtSameMomentAs(input);
  }

  @override
  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'];
    final actualDate = matchState['actualDate'];
    return mismatchDescription.add(
      'started at $actualDate instead of $input',
    );
  }
}

class _NextIsAfterMatcher extends _EveryMatcher {
  const _NextIsAfterMatcher();

  @override
  Description describe(Description description) =>
      description.add('generates next date after input');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final actualDate = every.next(input);
    matchState['actualDate'] = actualDate;
    return actualDate.isAfter(input);
  }

  @override
  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'];
    final actualDate = matchState['actualDate'];
    return mismatchDescription.add(
      'next $actualDate is not after $input',
    );
  }
}

class _PreviousIsBeforeMatcher extends _EveryMatcher {
  const _PreviousIsBeforeMatcher();

  @override
  Description describe(Description description) =>
      description.add('generates previous date before input');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final actualDate = every.previous(input);
    matchState['actualDate'] = actualDate;
    return actualDate.isBefore(input);
  }

  @override
  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'];
    final actualDate = matchState['actualDate'];
    return mismatchDescription.add(
      'previous $actualDate is not before $input',
    );
  }
}

/// Extension to add input date context to matchers for better testing.
extension MatcherExtension<T> on Matcher {
  /// {@template withInputMethod}
  /// Adds input context for method testing.
  /// {@endtemplate}
  Matcher withInput(T input) => _WithInputMatcher<T>(this, input);
}

class _WithInputMatcher<T> extends Matcher {
  const _WithInputMatcher(this._baseMatcher, this._input);

  final Matcher _baseMatcher;
  final T _input;

  @override
  Description describe(Description description) =>
      _baseMatcher.describe(description);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    matchState['input'] = _input;
    return _baseMatcher.matches(item, matchState);
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    return _baseMatcher.describeMismatch(
      item,
      mismatchDescription,
      matchState,
      verbose,
    );
  }
}
