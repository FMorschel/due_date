---
applyTo: 'test/enums/**/*_test.dart'
---

# Enum Testing Standards

Testing standards specific to enum classes in the due_date library.

## Test Structure Extensions for Enum Classes

In addition to the standard test structure, Enum classes must include these specific test groups:

```dart
group('Values', () {
  // Test all enum values are present and correct
});
group('Properties', () {
  // Test enum-specific properties and methods
});
group('Conversions', () {
  // Test string/int conversions if applicable
});
```

## Enum Values Testing

Test that all expected enum values are present:

```dart
group('Values', () {
  test('Has all expected values', () {
    expect(EnumName.values, hasLength(expectedCount));
    expect(EnumName.values, containsAll([
      EnumName.value1,
      EnumName.value2,
      EnumName.value3,
      // ... all expected values
    ]));
  });
  
  test('Values are in correct order', () {
    expect(EnumName.values, equals([
      EnumName.value1,
      EnumName.value2,
      EnumName.value3,
      // ... in expected order
    ]));
  });
});
```

## Enum Properties Testing

Test enum-specific properties and methods:

```dart
group('Properties', () {
  test('Index values are correct', () {
    expect(EnumName.value1.index, equals(0));
    expect(EnumName.value2.index, equals(1));
    expect(EnumName.value3.index, equals(2));
  });
  
  test('Custom properties work correctly', () {
    expect(Weekday.monday.name, equals('Monday'));
    expect(Weekday.monday.abbreviation, equals('Mon'));
    expect(Weekday.monday.isWeekend, isFalse);
  });
  
  test('Custom methods work correctly', () {
    expect(Weekday.monday.next(), equals(Weekday.tuesday));
    expect(Weekday.sunday.previous(), equals(Weekday.saturday));
  });
});
```

## Enum Conversions Testing

Test string/int conversions and parsing:

```dart
group('Conversions', () {
  test('toString returns correct values', () {
    expect(EnumName.value1.toString(), equals('EnumName.value1'));
    expect(EnumName.value2.toString(), equals('EnumName.value2'));
  });
  
  test('fromString parses correctly', () {
    expect(EnumName.fromString('value1'), equals(EnumName.value1));
    expect(EnumName.fromString('value2'), equals(EnumName.value2));
  });
  
  test('fromString throws for invalid values', () {
    expect(
      () => EnumName.fromString('invalid'),
      throwsArgumentError,
    );
  });
});
```

## Specific Enum Testing Requirements

### Weekday Testing

For `Weekday` enum, test weekday-specific functionality:

```dart
group('Weekday operations', () {
  test('next() cycles correctly', () {
    expect(Weekday.monday.next(), equals(Weekday.tuesday));
    expect(Weekday.sunday.next(), equals(Weekday.monday));
  });
  
  test('previous() cycles correctly', () {
    expect(Weekday.tuesday.previous(), equals(Weekday.monday));
    expect(Weekday.monday.previous(), equals(Weekday.sunday));
  });
  
  test('isWeekend identifies correctly', () {
    expect(Weekday.saturday.isWeekend, isTrue);
    expect(Weekday.sunday.isWeekend, isTrue);
    expect(Weekday.monday.isWeekend, isFalse);
  });
});
```

### Month Testing

For `Month` enum, test month-specific functionality:

```dart
group('Month operations', () {
  test('daysInMonth returns correct values', () {
    expect(Month.january.daysInMonth(2020), equals(31));
    expect(Month.february.daysInMonth(2020), equals(29)); // leap year
    expect(Month.february.daysInMonth(2021), equals(28)); // non-leap year
  });
  
  test('next() cycles correctly', () {
    expect(Month.january.next(), equals(Month.february));
    expect(Month.december.next(), equals(Month.january));
  });
  
  test('previous() cycles correctly', () {
    expect(Month.february.previous(), equals(Month.january));
    expect(Month.january.previous(), equals(Month.december));
  });
});
```
