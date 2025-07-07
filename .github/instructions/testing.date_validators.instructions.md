---
applyTo: 'test/date_validators/**/*_test.dart'
---

# Date Validator Testing Standards

Testing standards specific to date validator classes in the due_date library.

## Validation Testing Pattern

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

## Custom Matchers (REQUIRED for Validators)

**All validator assertions MUST use the custom matchers provided in `date_validator_match.dart`.**

- Do NOT use `expect(validator.valid(date), isTrue)` or `isFalse` directly.
- Instead, always use:
  - `expect(validator, isValid(date));`
  - `expect(validator, isInvalid(date));`

This applies to all validator types, including but not limited to:
- `DateValidatorDueDayMonth`
- `DateValidatorWeekday`
- `DateValidatorUnion`
- `DateValidatorTimeOfDay`
- `DateValidatorDayInYear`
- `DateValidatorWeekdayCountInMonth`
- Any custom validator implementing a `.valid(DateTime)` method

**List of required custom matchers:**

**For Validators:**
- `isValid(DateTime date)` — Asserts that the validator accepts the date.
- `isInvalid(DateTime date)` — Asserts that the validator rejects the date.

**Enforcement:**
- All test files for validators must import the appropriate matcher utility (e.g., `import '../src/date_validator_match.dart';`).
- PRs that do not use these matchers for validator assertions will be rejected.

## Required Import for Validator Tests

```dart
import '../src/date_validator_match.dart';
```
