---
applyTo: '**/*_test.dart'
---

# General Dart Testing Standards for due_date Library

When writing tests for this Dart library, follow these comprehensive guidelines to maintain consistency and quality.

## File Structure and Naming

1. **File naming**: Test files must end with `_test.dart`
2. **Directory structure**: Mirror the `lib/src/` structure in `test/`
3. **Test utilities**: Place shared test utilities in `test/src/`

## Import Standards

General imports for the package tests:
```dart
import 'package:due_date/due_date.dart';
import 'package:due_date/period.dart';
```

Internal helpers (if needed):
```dart
import 'package:due_date/src/helpers/helpers.dart';
```

Packages:
```dart
import 'package:test/test.dart';
import 'package:time/time.dart';
```

Relative imports for test utilities:
```dart
import '../src/date_validator_match.dart';
import '../src/every_match.dart';
import '../src/month_in_year.dart';
```

## Test Structure

### Main Test Organization

```dart
void main() {
  group('ClassName:', () {
    // Group tests by major functionality.
    group('Constructor', () { /* ... */ });
    group('Methods', () { /* ... */ });
    group('Edge Cases', () { /* ... */ });
    group('Equality', () { /* ... */ });
  });
}
```

### Constructor Testing Pattern

Always test constructors with these categories:

```dart
group('Constructor', () {
  group('Unnamed', () {
    test('Valid basic case', () {
      expect(const ClassName(validParam), isNotNull);
    });
    test('Default property values', () {
      expect(const ClassName(param).propertyName, expectedValue);
    });
    group('asserts limits', () {
      test('Description of invalid input', () {
        expect(
          () => ClassName(invalidParam),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
  
  // Test named constructors separately.
  group('namedConstructor', () {
    test('Valid case description', () {
      expect(ClassName.namedConstructor(params), isNotNull);
    });
    test('Error case description', () {
      expect(
        () => ClassName.namedConstructor(invalidParams),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
});
```

### Equality Testing Pattern

Always include equality tests for value objects. **Important: Do not use `const` in equality tests** as it can interfere with proper equality testing:

```dart
group('Equality', () {
  final instance1 = ClassName(param1);
  final instance2 = ClassName(param1, namedParam: differentValue);
  final instance3 = ClassName(param2);
  final instance4 = ClassName(param1);

  test('Same instance', () {
    expect(instance1, equals(instance1));
  });
  test('Same param, different named param', () {
    expect(instance1, isNot(equals(instance2)));
  });
  test('Different param, same named param', () {
    expect(instance1, isNot(equals(instance3)));
  });
  test('Same param, same named param', () {
    expect(instance1, equals(instance4));
  });
});
```

## Custom Matchers

Use custom matchers for domain-specific assertions:

```dart
// For date validators, use custom matchers.
expect(validator, isValid(date));
expect(validator, isInvalid(date));

// For Every implementations, use custom matchers.
expect(every, startsAt(expectedDate).withInput(inputDate, /*some tests may use this, its optional*/ limit: limit));
expect(every, hasNext(expectedDate).withInput(inputDate));
expect(every, hasPrevious(expectedDate).withInput(inputDate));
expect(every, startsAtSameDate.withInput(validDate));
expect(every, nextIsAfter.withInput(inputDate));
expect(every, previousIsBefore.withInput(inputDate));

// For collections.
expect(collection, containsAllInOrder(expectedItems));
```
