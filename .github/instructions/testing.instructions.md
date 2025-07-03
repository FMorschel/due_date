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

```dart
// Always include this comment at the top for constructor tests
// ignore_for_file: prefer_const_constructors

// Standard imports order:
import 'package:due_date/due_date.dart';           // Main library
import 'package:due_date/src/helpers/helpers.dart'; // Internal helpers (if needed)
import 'package:test/test.dart';                   // Test framework
import 'package:time/time.dart';                   // External packages

// Relative imports for test utilities
import '../src/date_validator_match.dart';
import '../src/month_in_year.dart';
```

## Test Structure

### Main Test Organization

```dart
void main() {
  group('ClassName:', () {
    // Group tests by major functionality
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
  
  // Test named constructors separately
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
  // Define test data sets with descriptive comments
  const testCases = [
    TestCase(params), // Description of what this tests
    TestCase(params), // Another scenario
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
// For date validators, use custom matchers
expect(validator, isValid(date));
expect(validator, isInvalid(date));

// For collections
expect(collection, containsAllInOrder(expectedItems));
```

## Custom Matchers (REQUIRED for Validators)

**All validator assertions MUST use the custom matchers provided in `date_validator_match.dart` or other relevant matcher utility files.**

- Do NOT use `expect(validator.valid(date), isTrue)` or `isFalse` directly.
- Instead, always use:
  - `expect(validator, isValid(date));`
  - `expect(validator, isInvalid(date));`
- This applies to all validator types, including but not limited to:
  - `DateValidatorDueDayMonth`
  - `DateValidatorWeekday`
  - `DateValidatorUnion`
  - `DateValidatorTimeOfDay`
  - `DateValidatorDayInYear`
  - `DateValidatorWeekdayCountInMonth`
  - Any custom validator implementing a `.valid(DateTime)` method

**List of required custom matchers:**
- `isValid(DateTime date)` — Asserts that the validator accepts the date.
- `isInvalid(DateTime date)` — Asserts that the validator rejects the date.

**Enforcement:**
- All test files for validators must import the appropriate matcher utility (e.g., `import '../src/date_validator_match.dart';`).
- PRs that do not use these matchers for validator assertions will be rejected.

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
// Use descriptive constants for test data
const list = [
  MonthInYear(2024, DateTime.january), // 23 workdays.
  MonthInYear(2024, DateTime.december), // 22 workdays.
  MonthInYear(2022, DateTime.december), // 22 workdays, ends on a weekend.
];

// Convert to sets when order doesn't matter
final set = list.toSet();
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
