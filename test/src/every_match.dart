import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:due_date/src/everies/every.dart';
import 'package:due_date/src/everies/every_date_validator.dart';
import 'package:due_date/src/everies/limited_every.dart';
import 'package:due_date/src/everies/limited_every_date_validator.dart';
import 'package:test/test.dart';

/// Creates a matcher that verifies [EveryDateValidator.startDate] returns the
/// expected date.
EveryDateValidatorMatcher startsAt(DateTime expectedDate) =>
    _StartsAtMatcher(expectedDate);

/// Creates a matcher that verifies [EveryDateValidator.endDate] returns the
/// expected date.
EveryDateValidatorMatcher endsAt(DateTime expectedDate) =>
    _EndsAtMatcher(expectedDate);

/// Creates a matcher that verifies [Every.next] returns the expected date.
EveryMatcher hasNext(DateTime expectedDate) => _HasNextMatcher(expectedDate);

/// Creates a matcher that verifies [Every.previous] returns the expected date.
EveryMatcher hasPrevious(DateTime expectedDate) =>
    _HasPreviousMatcher(expectedDate);

/// Creates a matcher that verifies [EveryDateValidator.startDate] returns the
/// input date when valid.
EveryDateValidatorMatcher startsAtSameDate = const _StartsAtSameDateMatcher();

/// Creates a matcher that verifies [EveryDateValidator.endDate] returns the
/// input date when valid.
EveryDateValidatorMatcher endsAtSameDate = const _EndsAtSameDateMatcher();

/// Creates a matcher that verifies [LimitedEvery.next] is limited by the given
/// limit.
LimitedEveryMatcher limitedNext = const _LimitedNextMatcher();

/// Creates a matcher that verifies [LimitedEvery.previous] is limited by the
/// given limit.
LimitedEveryMatcher limitedPrevious = const _LimitedPreviousMatcher();

/// Creates a matcher that verifies [LimitedEveryDateValidator.startDate] is
/// limited by the given limit.
LimitedEveryDateValidatorMatcher startLimited = const _StartLimitedMatcher();

/// Creates a matcher that verifies [LimitedEveryDateValidator.endDate] is
/// limited by the given limit.
LimitedEveryDateValidatorMatcher endLimited = const _EndLimitedMatcher();

/// Creates a matcher that verifies [Every.next] generates a date after the
/// input.
EveryMatcher nextIsAfter = const _NextIsAfterMatcher();

/// Creates a matcher that verifies [Every.previous] generates a date before the
/// input.
EveryMatcher previousIsBefore = const _PreviousIsBeforeMatcher();

final Matcher throwsADateTimeLimitReachedException =
    throwsA(isA<DateTimeLimitReachedException>());

abstract class EveryDateValidatorMatcher<T extends EveryDateValidator>
    extends EveryMatcher<T> {
  const EveryDateValidatorMatcher();
}

abstract class LimitedEveryDateValidatorMatcher<
    T extends LimitedEveryDateValidator> extends LimitedEveryMatcher<T> {
  const LimitedEveryDateValidatorMatcher();
}

abstract class EveryMatcher<T extends Every> extends Matcher {
  const EveryMatcher();

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is! T) return false;
    return _matchesEvery(item, matchState);
  }

  bool _matchesEvery(T every, Map<dynamic, dynamic> matchState);

  /// {@template withInputMethod}
  /// Adds input context for method testing.
  /// {@endtemplate}
  Matcher withInput(DateTime input, {DateTime? limit}) =>
      _WithInputMatcher<DateTime?>(
        _WithInputMatcher<DateTime>(this, input),
        limit,
        key: 'limit',
      );

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is! T) {
      return mismatchDescription.add('$item is not a(n) $T instance');
    }
    return _describeEveryMismatch(item, mismatchDescription, matchState);
  }

  Description _describeEveryMismatch(
    T every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  );
}

abstract class LimitedEveryMatcher<T extends LimitedEvery>
    extends EveryMatcher<T> {
  const LimitedEveryMatcher();
}

class _StartsAtMatcher extends EveryDateValidatorMatcher<EveryDateValidator> {
  const _StartsAtMatcher(this._expectedDate);

  final DateTime _expectedDate;

  @override
  Description describe(Description description) =>
      description.add('starts at $_expectedDate');

  @override
  bool _matchesEvery(
    EveryDateValidator every,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    final actualDate = every is LimitedEveryDateValidator && limit != null
        ? every.startDate(input, limit: limit)
        : every.startDate(input);
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
    return mismatchDescription.add('started at [$actualDate]');
  }
}

class _EndsAtMatcher extends EveryDateValidatorMatcher<EveryDateValidator> {
  const _EndsAtMatcher(this._expectedDate);

  final DateTime _expectedDate;

  @override
  Description describe(Description description) =>
      description.add('ends at $_expectedDate');

  @override
  bool _matchesEvery(
    EveryDateValidator every,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    final actualDate = every is LimitedEveryDateValidator && limit != null
        ? every.endDate(input, limit: limit)
        : every.endDate(input);
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
    return mismatchDescription.add('ended at [$actualDate]');
  }
}

class _HasNextMatcher extends EveryMatcher<Every> {
  const _HasNextMatcher(this._expectedDate);

  final DateTime _expectedDate;

  @override
  Description describe(Description description) =>
      description.add('has next $_expectedDate');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    final actualDate = every is LimitedEvery && limit != null
        ? every.next(input, limit: limit)
        : every.next(input);
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
    return mismatchDescription.add('next was [$actualDate]');
  }
}

class _HasPreviousMatcher extends EveryMatcher<Every> {
  const _HasPreviousMatcher(this._expectedDate);

  final DateTime _expectedDate;

  @override
  Description describe(Description description) =>
      description.add('has previous $_expectedDate');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    final actualDate = every is LimitedEvery && limit != null
        ? every.previous(input, limit: limit)
        : every.previous(input);
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
    return mismatchDescription.add('previous was [$actualDate]');
  }
}

class _LimitedPreviousMatcher extends LimitedEveryMatcher {
  const _LimitedPreviousMatcher();

  @override
  Description describe(Description description) =>
      description.add('limited for this previous date');

  @override
  bool _matchesEvery(LimitedEvery every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    if (limit == null) return false;

    return throwsADateTimeLimitReachedException.matches(
      () => every.previous(input, limit: limit),
      matchState,
    );
  }

  @override
  Description _describeEveryMismatch(
    LimitedEvery every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final limit = matchState['limit'];
    final input = matchState['input'];
    return mismatchDescription
        .add('was not limited for [$limit] with input [$input]');
  }
}

class _LimitedNextMatcher extends LimitedEveryMatcher {
  const _LimitedNextMatcher();

  @override
  Description describe(Description description) =>
      description.add('limited for this next date');

  @override
  bool _matchesEvery(LimitedEvery every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    if (limit == null) return false;

    return throwsADateTimeLimitReachedException.matches(
      () => every.next(input, limit: limit),
      matchState,
    );
  }

  @override
  Description _describeEveryMismatch(
    LimitedEvery every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final limit = matchState['limit'];
    final input = matchState['input'];
    return mismatchDescription
        .add('was not limited for [$limit] with input [$input]');
  }
}

class _StartsAtSameDateMatcher
    extends EveryDateValidatorMatcher<EveryDateValidator> {
  const _StartsAtSameDateMatcher();

  @override
  Description describe(Description description) =>
      description.add('starts at the same date when input is valid');

  @override
  bool _matchesEvery(
    EveryDateValidator every,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    final actualDate = every is LimitedEveryDateValidator && limit != null
        ? every.startDate(input, limit: limit)
        : every.startDate(input);
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
      'started at [$actualDate] instead of [$input]',
    );
  }
}

class _EndsAtSameDateMatcher
    extends EveryDateValidatorMatcher<EveryDateValidator> {
  const _EndsAtSameDateMatcher();

  @override
  Description describe(Description description) =>
      description.add('ends at the same date when input is valid');

  @override
  bool _matchesEvery(
    EveryDateValidator every,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    final actualDate = every is LimitedEveryDateValidator && limit != null
        ? every.endDate(input, limit: limit)
        : every.endDate(input);
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
      'ended at [$actualDate] instead of [$input]',
    );
  }
}

class _StartLimitedMatcher
    extends LimitedEveryDateValidatorMatcher<LimitedEveryDateValidator> {
  const _StartLimitedMatcher();

  @override
  Description describe(Description description) =>
      description.add('start is limited for this date');

  @override
  bool _matchesEvery(
    LimitedEveryDateValidator every,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    if (limit == null) return false;

    return throwsADateTimeLimitReachedException.matches(
      () => every.startDate(input, limit: limit),
      matchState,
    );
  }

  @override
  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'];
    return mismatchDescription.add('was limited for [$input]');
  }
}

class _EndLimitedMatcher
    extends LimitedEveryDateValidatorMatcher<LimitedEveryDateValidator> {
  const _EndLimitedMatcher();

  @override
  Description describe(Description description) =>
      description.add('end is limited for this date');

  @override
  bool _matchesEvery(
    LimitedEveryDateValidator every,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    if (limit == null) return false;

    return throwsADateTimeLimitReachedException.matches(
      () => every.endDate(input, limit: limit),
      matchState,
    );
  }

  @override
  Description _describeEveryMismatch(
    Every every,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
  ) {
    final input = matchState['input'];
    return mismatchDescription.add('was not limited for [$input]');
  }
}

class _NextIsAfterMatcher extends EveryMatcher<Every> {
  const _NextIsAfterMatcher();

  @override
  Description describe(Description description) =>
      description.add('generates next date after input');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    final actualDate = every is LimitedEvery && limit != null
        ? every.next(input, limit: limit)
        : every.next(input);
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
      'next [$actualDate] is not after [$input]',
    );
  }
}

class _PreviousIsBeforeMatcher extends EveryMatcher<Every> {
  const _PreviousIsBeforeMatcher();

  @override
  Description describe(Description description) =>
      description.add('generates previous date before input');

  @override
  bool _matchesEvery(Every every, Map<dynamic, dynamic> matchState) {
    final input = matchState['input'] as DateTime?;
    if (input == null) return false;

    final limit = matchState['limit'] as DateTime?;
    final actualDate = every is LimitedEvery && limit != null
        ? every.previous(input, limit: limit)
        : every.previous(input);
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
      'previous [$actualDate] is not before [$input]',
    );
  }
}

class _WithInputMatcher<T> extends Matcher {
  const _WithInputMatcher(this._baseMatcher, this._input, {String? key})
      : _key = key;

  final Matcher _baseMatcher;
  final T _input;
  final String? _key;

  @override
  Description describe(Description description) =>
      _baseMatcher.describe(description);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    matchState[_key ?? 'input'] = _input;
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
