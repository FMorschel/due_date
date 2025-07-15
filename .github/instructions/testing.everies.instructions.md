---
applyTo: 'test/everies/**/*_test.dart'
---

# Every Implementation Testing Standards

Testing standards specific to Every implementation classes in the due_date library.

## Test Structure Extensions for Every Classes

In addition to the standard test structure, Every classes must include these specific test groups:

```dart
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
```

## Explicit DateTime-to-DateTime Tests

**All Every classes must include explicit datetime-to-datetime tests that verify the exact generated dates are correct.**

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

## Time Component Preservation Tests

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

## Custom Matchers (REQUIRED for Every Implementations)

**All Every implementation assertions MUST use the custom matchers provided in `every_match.dart`.**

- Do NOT use direct method calls like `expect(every.next(date), equals(expectedDate))`.
- Instead, always use:
  - `expect(every, startsAt(expectedDate).withInput(inputDate));`
  - `expect(every, hasNext(expectedDate).withInput(inputDate));`
  - `expect(every, hasPrevious(expectedDate).withInput(inputDate));`
  - `expect(every, startsAtSameDate().withInput(validDate));`
  - `expect(every, nextIsAfter().withInput(inputDate));`
  - `expect(every, previousIsBefore().withInput(inputDate));`

This applies to all Every implementations, including but not limited to:
- `EveryWeekday`
- `EveryDueDayMonth`
- `EveryWeekdayCountInMonth`
- `EveryDayInYear`
- Any custom implementation extending `Every`

**List of required custom matchers:**

**For Every implementations:**
- `startsAt(DateTime expectedDate).withInput(DateTime inputDate)` — Asserts that `startDate()` returns the expected date.
- `hasNext(DateTime expectedDate).withInput(DateTime inputDate)` — Asserts that `next()` returns the expected date.
- `hasPrevious(DateTime expectedDate).withInput(DateTime inputDate)` — Asserts that `previous()` returns the expected date.
- `startsAtSameDate().withInput(DateTime validDate)` — Asserts that `startDate()` returns the input when it's already valid.
- `nextIsAfter().withInput(DateTime inputDate)` — Asserts that `next()` generates a date after the input.
- `previousIsBefore().withInput(DateTime inputDate)` — Asserts that `previous()` generates a date before the input.

**Enforcement:**
- All test files for Every implementations must import the Every matcher utility (e.g., `import '../src/every_match.dart';`).
- PRs that do not use these matchers for Every assertions will be rejected.

## Required Import for Every Tests

```dart
import '../src/every_match.dart';
```
