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

**All Every implementation assertions MUST use the custom matchers provided in `every_match.dart`.**

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
- All test files for Every implementations must import the Every matcher utility (e.g., `import '../src/every_match.dart';`).
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

## Enum Testing Patterns

When testing enum classes, follow these comprehensive patterns to ensure all enum functionality is properly validated.

### Standard Enum Test Structure

```dart
void main() {
  group('EnumName:', () {
    group('Values', () {
      // Test enum values collection
    });
    group('Factory methods', () {
      // Test range validation for factory constructors
    });
    group('Properties', () {
      // Test individual properties
    });
    group('Properties for all values:', () {
      // Test properties across all enum values
    });
    group('Collections', () {
      // Test static collections (e.g., weekdays, weekend)
    });
    group('String representation', () {
      // Test toString() and name properties
    });
    group('Navigation methods', () {
      // Test next/previous methods
    });
    group('Edge Cases', () {
      // Test mutual exclusivity, boundary conditions
    });
  });
}
```

### Values Collection Testing

Test the enum values collection and its contents:

```dart
group('Values', () {
  test('Has all expected values', () {
    expect(EnumName.values.length, equals(expectedCount));
    expect(
      EnumName.values,
      containsAllInOrder([
        EnumName.value1,
        EnumName.value2,
        EnumName.value3,
      ]),
    );
  });
});
```

### Factory Range Validation

Test factory constructors with range validation:

```dart
group('Factory methods', () {
  group('Throw on factory outside of range:', () {
    test('Value below minimum', () {
      expect(() => EnumName.fromValue(belowMinValue), throwsRangeError);
    });
    test('Value above maximum', () {
      expect(() => EnumName.fromValue(aboveMaxValue), throwsRangeError);
    });
  });
});
```

### Property Testing for All Values

Test properties across all enum values systematically:

```dart
group('Properties for all values:', () {
  for (final enumValue in EnumName.values) {
    group(enumValue.name, () {
      test('property1', () {
        final expected = calculateExpectedValue(enumValue);
        expect(enumValue.property1, equals(expected));
      });
      
      test('property2', () {
        final expected = calculateExpectedValue2(enumValue);
        expect(enumValue.property2, equals(expected));
      });
      
      test('Only one boolean property is true', () {
        final trueCount = [
          enumValue.boolProperty1,
          enumValue.boolProperty2,
          enumValue.boolProperty3,
        ].where((value) => value).length;
        expect(trueCount, equals(1));
      });
    });
  }
});
```

### Boolean Property Testing

For enums with boolean properties, test individual properties and mutual exclusivity:

```dart
group('Properties', () {
  group('isProperty1', () {
    test('Returns true for correct value', () {
      expect(EnumName.correctValue.isProperty1, isTrue);
    });
    
    test('Returns false for other values', () {
      expect(EnumName.otherValue1.isProperty1, isFalse);
      expect(EnumName.otherValue2.isProperty1, isFalse);
    });
  });
});
```

### Navigation Method Testing

Test next/previous methods with wrap-around behavior:

```dart
group('Navigation methods', () {
  group('Previous:', () {
    for (final enumValue in EnumName.values) {
      test(enumValue.name, () {
        if (enumValue != EnumName.firstValue) {
          expect(
            enumValue.previous,
            equals(EnumName.fromValue(enumValue.value - 1)),
          );
        } else {
          expect(enumValue.previous, equals(EnumName.lastValue));
        }
      });
    }
  });
  
  group('Next:', () {
    for (final enumValue in EnumName.values) {
      test(enumValue.name, () {
        if (enumValue != EnumName.lastValue) {
          expect(
            enumValue.next,
            equals(EnumName.fromValue(enumValue.value + 1)),
          );
        } else {
          expect(enumValue.next, equals(EnumName.firstValue));
        }
      });
    }
  });
});
```

### Collection Property Testing

Test static collections like sets of related enum values:

```dart
group('Collections', () {
  group('specialSet:', () {
    final expectedSet = {EnumName.value1, EnumName.value2};
    test('Contains expected values', () {
      expect(
        EnumName.specialSet,
        containsAllInOrder(expectedSet),
      );
    });
    test('Is correct type', () {
      expect(
        EnumName.specialSet,
        isA<Set<EnumName>>(),
      );
    });
  });
});
```

### String Representation Testing

Test toString() and name properties:

```dart
group('String representation', () {
  test('value1 has correct string representation', () {
    expect(EnumName.value1.toString(), equals('EnumName.value1'));
  });
  
  test('value2 has correct string representation', () {
    expect(EnumName.value2.toString(), equals('EnumName.value2'));
  });
});

group('Name property', () {
  test('value1 has correct name', () {
    expect(EnumName.value1.name, equals('value1'));
  });
  
  test('value2 has correct name', () {
    expect(EnumName.value2.name, equals('value2'));
  });
});
```

### Index Property Testing

Test index values match expected order:

```dart
group('Index property', () {
  test('value1 has correct index', () {
    expect(EnumName.value1.index, equals(0));
  });
  
  test('value2 has correct index', () {
    expect(EnumName.value2.index, equals(1));
  });
  
  test('value3 has correct index', () {
    expect(EnumName.value3.index, equals(2));
  });
});
```

### Equality Testing

Test equality behavior for enum values:

```dart
group('Equality', () {
  test('Same values are equal', () {
    expect(EnumName.value1, equals(EnumName.value1));
    expect(EnumName.value2, equals(EnumName.value2));
  });
  
  test('Different values are not equal', () {
    expect(EnumName.value1, isNot(equals(EnumName.value2)));
    expect(EnumName.value1, isNot(equals(EnumName.value3)));
    expect(EnumName.value2, isNot(equals(EnumName.value3)));
  });
});
```

### Edge Cases and Mutual Exclusivity

Test edge cases and ensure boolean properties are mutually exclusive:

```dart
group('Edge Cases', () {
  test('All boolean properties are mutually exclusive', () {
    for (final enumValue in EnumName.values) {
      final properties = [
        enumValue.boolProperty1,
        enumValue.boolProperty2,
        enumValue.boolProperty3,
      ];
      final trueCount = properties.where((p) => p).length;
      expect(
        trueCount,
        equals(1),
        reason: 'Each enum value should have exactly one true property',
      );
    }
  });
});
```

### Method Testing with Date/Time Inputs

For enums that work with dates, test methods with specific date inputs:

```dart
group('Method with date inputs', () {
  final testDate = DateTime.utc(2022, DateTime.august, 8);
  for (final enumValue in EnumName.values) {
    test(enumValue.name, () {
      expect(
        enumValue.methodWithDate(testDate),
        equals(expectedResult(enumValue, testDate)),
      );
    });
  }
});
```

### Calculation Method Testing

For enums with calculation methods, test with specific parameters:

```dart
group('Calculation methods', () {
  final testMonth = DateTime.utc(2022, DateTime.august);
  test('value1 calculation', () {
    expect(
      EnumName.value1.calculate(testMonth.year, testMonth.month),
      equals(expectedResult1),
    );
  });
  
  test('value2 calculation', () {
    expect(
      EnumName.value2.calculate(testMonth.year, testMonth.month),
      equals(expectedResult2),
    );
  });
});
```

### Range-Based Testing

For enums representing ranges or periods, test boundary conditions:

```dart
group('Range testing', () {
  const year = 2022;
  const month = Month.august;
  
  group('EnumValue.from', () {
    for (final enumValue in EnumName.values) {
      group(enumValue.name, () {
        final startDate = calculateStartDate(enumValue, year, month);
        final endDate = calculateEndDate(enumValue, year, month);
        
        test('Start date maps correctly', () {
          expect(EnumName.from(startDate), equals(enumValue));
        });
        
        for (final day in startDate.to(endDate)) {
          test('Day ${day.day} maps correctly', () {
            expect(EnumName.from(day), equals(enumValue));
          });
        }
      });
    }
  });
});
```
