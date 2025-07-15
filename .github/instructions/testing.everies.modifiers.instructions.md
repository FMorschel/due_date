---
applyTo: 'test/everies/modifiers/**/*_test.dart'
---

# Every Modifier Testing Standards

Testing standards specific to Every modifier classes (limit, skip, take, etc.) in the due_date library.

## Test Structure Extensions for Every Modifier Classes

In addition to the standard test structure, Every modifier classes must include these specific test groups:

```dart
group('Base every integration', () { /* ... */ });
group('Modifier behavior', () { /* ... */ });
```

## Modifier-Specific Testing Requirements

### Base Every Integration Tests

Test that modifiers work correctly with various base Every implementations:

```dart
group('Base every integration', () {
  test('Works with EveryWeekday', () {
    final base = EveryWeekday(Weekday.monday);
    final modified = base.take(3);
    // Test specific behavior
  });
  
  test('Works with EveryDueDayMonth', () {
    final base = EveryDueDayMonth(15);
    final modified = base.skip(2);
    // Test specific behavior
  });
  
  // Test with other Every implementations
});
```

### Modifier Behavior Tests

Test the specific behavior of each modifier:

```dart
group('Modifier behavior', () {
  test('Limit modifier stops at specified count', () {
    final every = EveryWeekday(Weekday.monday).take(3);
    // Test that only 3 occurrences are generated
  });
  
  test('Skip modifier skips specified count', () {
    final every = EveryWeekday(Weekday.monday).skip(2);
    // Test that first 2 occurrences are skipped
  });
  
  test('Combination of modifiers', () {
    final every = EveryWeekday(Weekday.monday).skip(1).take(3);
    // Test combined behavior
  });
});
```

## Custom Matchers for Every Modifiers

**All Every modifier assertions MUST use the custom matchers provided in `every_match.dart`.**

The same custom matchers apply to modifiers as to base Every implementations:

- `expect(every, startsAt(expectedDate).withInput(inputDate));`
- `expect(every, hasNext(expectedDate).withInput(inputDate));`
- `expect(every, hasPrevious(expectedDate).withInput(inputDate));`
- `expect(every, startsAtSameDate().withInput(validDate));`
- `expect(every, nextIsAfter().withInput(inputDate));`
- `expect(every, previousIsBefore().withInput(inputDate));`

## Required Import for Every Modifier Tests

```dart
import '../../src/every_match.dart';
```
