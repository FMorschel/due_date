---
applyTo: '**/*_test.dart'
---

# Dart Testing Standards for due_date Library

When writing tests for this Dart library, follow these comprehensive guidelines to maintain consistency and quality.

## File Structure and Naming

1. **File naming**: Test files must end with `_test.dart`
2. **Directory structure**: Mirror the `lib/src/` structure in `test/`
3. **Test utilities**: Place shared test utilities in `test/src/`

## Import Standards

Always include this comment at the top for equality tests:
```dart
// ignore_for_file: prefer_const_constructors
```

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
import '../src/every_validator_match.dart';
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

### Validation Testing Pattern

For validators, use comprehensive loops to test all scenarios:

```dart
group('valid:', () {
  // Define test data sets with descriptive comments.
  const testCases = [
    // Description of what this tests.
    TestCase(params),
    // Another scenario.
    TestCase(params),
  ];
  
  for (final testCase in testCases) {
    group('${testCase.description}', () {
      for (final exact in {true, false}) {
        for (var i = 1; i <= maxValue; i++) {
          final validator = ValidatorClass(i, exact: exact);
          group('$validator', () {
            for (var day = 1; day <= daysInPeriod; day++) {
              final date = testCase.date(day);
              if (shouldBeValid(date, validator)) {
                test('Day $day is valid', () {
                  expect(validator, isValid(date));
                });
              } else {
                test('Day $day is not valid', () {
                  expect(validator, isInvalid(date));
                });
              }
            }
          });
        }
      }
    });
  }
});
```

### Equality Testing Pattern

Always include equality tests for value objects:

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
expect(every, startsAt(expectedDate).withInput(inputDate));
expect(every, hasNext(expectedDate).withInput(inputDate));
expect(every, hasPrevious(expectedDate).withInput(inputDate));
expect(every, startsAtSameDate().withInput(validDate));
expect(every, nextIsAfter().withInput(inputDate));
expect(every, previousIsBefore().withInput(inputDate));

// For collections.
expect(collection, containsAllInOrder(expectedItems));
```

## Custom Matchers (REQUIRED for Validators and Every Implementations)

**All validator assertions MUST use the custom matchers provided in `date_validator_match.dart` or other relevant matcher utility files.**

- Do NOT use `expect(validator.valid(date), isTrue)` or `isFalse` directly.
- Instead, always use:
  - `expect(validator, isValid(date));`
  - `expect(validator, isInvalid(date));`

**All Every implementation assertions MUST use the custom matchers provided in `every_validator_match.dart`.**

- Do NOT use direct method calls like `expect(every.next(date), equals(expectedDate))`.
- Instead, always use:
  - `expect(every, startsAt(expectedDate).withInput(inputDate));`
  - `expect(every, hasNext(expectedDate).withInput(inputDate));`
  - `expect(every, hasPrevious(expectedDate).withInput(inputDate));`
  - `expect(every, startsAtSameDate().withInput(validDate));`
  - `expect(every, nextIsAfter().withInput(inputDate));`
  - `expect(every, previousIsBefore().withInput(inputDate));`

This applies to all validator types, including but not limited to:
- `DateValidatorDueDayMonth`
- `DateValidatorWeekday`
- `DateValidatorUnion`
- `DateValidatorTimeOfDay`
- `DateValidatorDayInYear`
- `DateValidatorWeekdayCountInMonth`
- Any custom validator implementing a `.valid(DateTime)` method

And all Every implementations, including but not limited to:
- `EveryWeekday`
- `EveryDueDayMonth`
- `EveryWeekdayCountInMonth`
- `EveryDayInYear`
- Any custom implementation extending `Every`

**List of required custom matchers:**

**For Validators:**
- `isValid(DateTime date)` — Asserts that the validator accepts the date.
- `isInvalid(DateTime date)` — Asserts that the validator rejects the date.

**For Every implementations:**
- `startsAt(DateTime expectedDate).withInput(DateTime inputDate)` — Asserts that `startDate()` returns the expected date.
- `hasNext(DateTime expectedDate).withInput(DateTime inputDate)` — Asserts that `next()` returns the expected date.
- `hasPrevious(DateTime expectedDate).withInput(DateTime inputDate)` — Asserts that `previous()` returns the expected date.
- `startsAtSameDate().withInput(DateTime validDate)` — Asserts that `startDate()` returns the input when it's already valid.
- `nextIsAfter().withInput(DateTime inputDate)` — Asserts that `next()` generates a date after the input.
- `previousIsBefore().withInput(DateTime inputDate)` — Asserts that `previous()` generates a date before the input.

**Enforcement:**
- All test files for validators must import the appropriate matcher utility (e.g., `import '../src/date_validator_match.dart';`).
- All test files for Every implementations must import the Every matcher utility (e.g., `import '../src/every_validator_match.dart';`).
- PRs that do not use these matchers for validator or Every assertions will be rejected.

## Specific Testing Requirements for Every and PeriodGenerator Classes

### Explicit DateTime-to-DateTime Tests

**All Every and PeriodGenerator classes must include explicit datetime-to-datetime tests that verify the exact generated dates are correct.**

These tests must:

1. **Test specific date calculations** - Don't rely only on broad structural tests
2. **Verify exact output dates** - Use concrete input dates and assert exact expected output dates
3. **Cover edge cases** - Test boundary conditions, leap years, month boundaries, etc.

```dart
group('Explicit datetime tests:', () {
  test('Specific date calculation example', () {
    final every = EveryWeekday(Weekday.monday);
    // Tuesday.
    final inputDate = DateTime(2024, 1, 15);
    // Next Monday.
    final expected = DateTime(2024, 1, 22);
    
    expect(every, hasNext(expected).withInput(inputDate));
  });
  
  test('Edge case: leap year February', () {
    final every = EveryDueDayMonth(29);
    // Leap year.
    final inputDate = DateTime(2024, 2, 1);
    final expected = DateTime(2024, 2, 29);
    
    expect(every, hasNext(expected).withInput(inputDate));
  });
});
```

### Time Component Preservation Tests

**For classes that don't concern themselves with hour, minute, second, etc., you must test:**

1. **Time preservation** - When a DateTime with time components is passed, they should be maintained
2. **Both local and UTC DateTime cases** - Test with both `DateTime` and `DateTime.utc`

```dart
group('Time component preservation:', () {
  test('Maintains time components in local DateTime', () {
    final every = EveryDueDayMonth(15);
    final inputWithTime = DateTime(2024, 1, 10, 14, 30, 45, 123, 456);
    final result = every.next(inputWithTime);
    
    // Should preserve time components.
    expect(result.hour, equals(14));
    expect(result.minute, equals(30));
    expect(result.second, equals(45));
    expect(result.millisecond, equals(123));
    expect(result.microsecond, equals(456));
    expect(result.isUtc, isFalse);
  });
  
  test('Maintains time components in UTC DateTime', () {
    final every = EveryDueDayMonth(15);
    final inputWithTime = DateTime.utc(2024, 1, 10, 14, 30, 45, 123, 456);
    final result = every.next(inputWithTime);
    
    // Should preserve time components and UTC flag.
    expect(result.hour, equals(14));
    expect(result.minute, equals(30));
    expect(result.second, equals(45));
    expect(result.millisecond, equals(123));
    expect(result.microsecond, equals(456));
    expect(result.isUtc, isTrue);
  });
  
  test('Normal generation with date-only input (local)', () {
    final every = EveryDueDayMonth(15);
    final inputDate = DateTime(2024, 1, 10);
    final expected = DateTime(2024, 1, 15);
    
    expect(every, hasNext(expected).withInput(inputDate));
  });
  
  test('Normal generation with date-only input (UTC)', () {
    final every = EveryDueDayMonth(15);
    final inputDate = DateTime.utc(2024, 1, 10);
    final expected = DateTime.utc(2024, 1, 15);
    
    expect(every, hasNext(expected).withInput(inputDate));
  });
});
```

### Required Test Sections for Every/PeriodGenerator Classes

Every test file for Every and PeriodGenerator classes must include these sections:

```dart
void main() {
  group('ClassName:', () {
    group('Constructor', () { /* ... */ });
    group('Methods', () { /* ... */ });
    
    group('Explicit datetime tests:', () {
      // Test specific date calculations with concrete examples.
      // Cover edge cases like leap years, month boundaries.
      // Verify exact output dates.
    });
    
    group('Time component preservation:', () {
      // Test time preservation with local DateTime.
      // Test time preservation with UTC DateTime.
      // Test normal generation with date-only inputs.
    });
    
    group('Edge Cases', () { /* ... */ });
    group('Equality', () { /* ... */ });
  });
}
```

## Test Data and Helpers

### Custom Classes for Test Data

Create helper classes when needed for cleaner test data:

```dart
class _Date extends DateTime {
  _Date(super.year, super.month, super.day);

  factory _Date.from(DateTime date) => _Date(date.year, date.month, date.day);

  @override
  String toString() {
    return super.toIso8601String().substring(0, 10);
  }
}
```

If it makes sense, add them to `test/src/` for reuse across tests.

### Test Data Organization

```dart
// Use descriptive constants for test data.
const list = [
  // 23 workdays.
  MonthInYear(2024, DateTime.january),
  // 22 workdays.
  MonthInYear(2024, DateTime.december),
  // 22 workdays, ends on a weekend.
  MonthInYear(2022, DateTime.december),
];
```

## Error Testing Patterns

### Assertion Errors

```dart
test('Description of what should fail', () {
  expect(
    () => ClassName(invalidValue),
    throwsA(isA<AssertionError>()),
  );
});
```

### Argument Errors

```dart
test('Description of invalid argument', () {
  expect(
    () => method(invalidArgument),
    throwsA(isA<ArgumentError>()),
  );
});
```

### Range Errors

```dart
test('Value outside valid range', () {
  expect(() => ClassName.fromValue(outOfRangeValue), throwsRangeError);
});
```

## Iteration Testing

For enum-like classes, test all values:

```dart
group('Method for all values:', () {
  for (final value in EnumClass.values) {
    test(value.name, () {
      final result = value.method();
      expect(result, expectedResultForValue(value));
    });
  }
});
```

## Property Testing

Test default values and property behavior:

```dart
test('Property has expected default', () {
  expect(const ClassName(param).property, expectedDefault);
});
```

## Descriptive Test Names

- Use clear, descriptive test names that explain what is being tested
- Include parameter values in test descriptions when relevant
- Use present tense ("Is valid", "Throws error")
- Be specific about edge cases
- Use new variables when updating the values between `test`s because of how the `test` package works
- **When formatting dates or other domain objects for test descriptions, always use the provided test helper classes (such as `DateToString`) instead of manual string manipulation or `toIso8601String()`. This ensures consistency and readability across all tests.**

## Code Style in Tests

- Avoid using `const` constructors when testing equality (hence the ignore comment)
- Use meaningful variable names (`validator`, `testCase`, `expected`)
- Add comments to explain complex test logic
- Group related assertions logically
- Use consistent indentation and formatting

## Coverage Requirements

Ensure comprehensive coverage by testing:
- All public constructors (named and unnamed)
- All public methods and properties
- Edge cases and boundary conditions
- Error conditions and invalid inputs
- Equality (by equatable props) behavior
- All enum values or similar iterations
