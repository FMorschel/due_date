import 'package:test/test.dart';

/// Matcher for asserting that a DateTime is UTC.
Matcher get isUtcDateTime => const _IsUtcDateTimeMatcher();

class _IsUtcDateTimeMatcher extends Matcher {
  const _IsUtcDateTimeMatcher();

  @override
  Description describe(Description description) =>
      description.add('is a UTC DateTime');

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is! DateTime) return false;
    return item.isUtc;
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
    mismatchDescription.add('$item was not UTC');
    return mismatchDescription;
  }
}

/// Matcher for asserting that a DateTime is local (not UTC).
Matcher get isLocalDateTime => const _IsLocalDateTimeMatcher();

class _IsLocalDateTimeMatcher extends Matcher {
  const _IsLocalDateTimeMatcher();

  @override
  Description describe(Description description) =>
      description.add('is a local DateTime');

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is! DateTime) return false;
    return !item.isUtc;
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
    mismatchDescription.add('$item was not local');
    return mismatchDescription;
  }
}
