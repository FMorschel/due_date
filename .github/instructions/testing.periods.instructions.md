---
applyTo: 'test/periods/**/*_test.dart'
---

# Period Testing Standards

Testing standards specific to Period classes in the due_date library.

## Test Structure Extensions for Period Classes

In addition to the standard test structure, Period classes must include these specific test groups:

```dart
group('Constructor', () {
  group('Valid cases', () {
    // Test valid period creation with both local and UTC DateTime.
  });
  group('Validation errors', () {
    // Test ArgumentError for invalid date ranges.
    // Test AssertionError for invalid duration.
  });
});

group('Properties', () {
  // Test duration calculation.
  // Test start and end date properties.
  // Test any period-specific properties.
});

group('Sub-period property', () {
  // Test sub-period collections (e.g., hours in day, months in semester).
  // Verify correct count and type.
  // Test first and last sub-periods.
  // Test continuity (no gaps between sub-periods).
});
```

## Constructor Testing for Period Classes

Period constructors must be tested with both valid and invalid inputs:

```dart
group('Constructor', () {
  group('Valid cases', () {
    test('Creates PeriodType with valid start and end', () {
      final start = DateTime(2024, 1, 15);
      final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
      expect(PeriodType(start: start, end: end), isNotNull);
    });

    test('Creates PeriodType with UTC dates', () {
      final start = DateTime.utc(2024, 1, 15);
      final end = DateTime.utc(2024, 1, 15, 23, 59, 59, 999, 999);
      expect(PeriodType(start: start, end: end), isNotNull);
    });
  });

  group('Validation errors', () {
    test('Throws ArgumentError for invalid date range', () {
      final start = DateTime(2024, 1, 15);
      final end = DateTime(2024, 1, 16, 23, 59, 59, 999, 999);
      expect(
        () => PeriodType(start: start, end: end),
        throwsArgumentError,
      );
    });

    test('Throws ArgumentError if end is not last microsecond of period', () {
      final start = DateTime(2024, 1, 15);
      final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 998);
      expect(
        () => PeriodType(start: start, end: end),
        throwsArgumentError,
      );
    });
  });
});
```

## Property Testing for Period Classes

Test all period properties comprehensively:

```dart
group('Properties', () {
  test('Duration is calculated correctly', () {
    const generator = PeriodGenerator();
    final period = generator.of(DateTime(2024, 1, 15));
    expect(period.duration, equals(expectedDuration));
  });

  test('Start and end are properly set', () {
    final start = DateTime(2024, 1, 15);
    final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
    final period = PeriodType(start: start, end: end);
    expect(period.start, equals(start));
    expect(period.end, equals(end));
  });

  test('Duration varies correctly for different periods', () {
    // Test duration calculations for periods with variable lengths.
    // Example: leap year vs non-leap year, months with different days.
  });
});
```

## Sub-period Property Testing

Test collections of sub-periods (e.g., hours in a day, months in a semester):

```dart
group('Sub-period property', () {
  test('Returns correct number of sub-periods', () {
    const generator = PeriodGenerator();
    final period = generator.of(DateTime(2020));
    final subPeriods = period.subPeriods;
    expect(subPeriods, isA<List<SubPeriodType>>());
    expect(subPeriods, hasLength(expectedCount));
  });

  test('First sub-period starts at period start', () {
    const generator = PeriodGenerator();
    final period = generator.of(DateTime(2020));
    final subPeriods = period.subPeriods;
    expect(subPeriods.first.start, equals(period.start));
  });

  test('Last sub-period ends at period end', () {
    const generator = PeriodGenerator();
    final period = generator.of(DateTime(2020));
    final subPeriods = period.subPeriods;
    expect(subPeriods.last.end, equals(period.end));
  });

  test('All sub-periods fit their generator', () {
    const generator = PeriodGenerator();
    const subGenerator = SubPeriodGenerator();
    final period = generator.of(DateTime(2020));
    final subPeriods = period.subPeriods;
    expect(
      subPeriods.none((sub) => !subGenerator.fitsGenerator(sub)),
      isTrue,
    );
  });

  test('Sub-periods cover entire period with no gaps', () {
    const generator = PeriodGenerator();
    final period = generator.of(DateTime(2020));
    final subPeriods = period.subPeriods;
    
    // Check no gaps between consecutive sub-periods.
    for (var i = 0; i < subPeriods.length - 1; i++) {
      final currentEnd = subPeriods[i].end;
      final nextStart = subPeriods[i + 1].start;
      expect(
        nextStart.difference(currentEnd),
        equals(Duration(microseconds: 1)),
      );
    }
  });
});
```

## Edge Case Testing for Period Classes

Test edge cases specific to calendar and time calculations:

```dart
group('Edge cases', () {
  test('Works with leap year dates', () {
    // Test February 29 in leap years.
    const generator = PeriodGenerator();
    final period = generator.of(DateTime(2024, 2, 29));
    expect(period.subPeriods, hasLength(expectedCount));
  });

  test('Works with daylight saving time changes', () {
    // Test DST transition dates.
    const generator = PeriodGenerator();
    final period = generator.of(DateTime(2024, 3, 10));
    expect(period.subPeriods, hasLength(expectedCount));
  });

  test('Works with month/year boundaries', () {
    // Test periods that span month or year boundaries.
    const generator = PeriodGenerator();
    final period = generator.of(DateTime(2023, 12, 31));
    expect(period.start.day, equals(expectedDay));
    expect(period.start.month, equals(expectedMonth));
  });

  test('Handles variable period lengths correctly', () {
    // Test periods with different lengths (e.g., months with different day counts).
    const generator = PeriodGenerator();
    
    // February in leap year vs non-leap year.
    final leapYear = generator.of(DateTime(2024, 2, 15));
    final nonLeapYear = generator.of(DateTime(2023, 2, 15));
    
    expect(leapYear.duration, isNot(equals(nonLeapYear.duration)));
  });
});
```

## Required Coverage for Period Classes

Every period class test must cover:

1. **Constructor validation** - Both valid and invalid inputs
2. **Property testing** - Duration, start/end, and period-specific properties
3. **Sub-period collections** - Count, type, continuity, and generator compliance
4. **Edge cases** - Calendar boundaries, leap years, DST, variable lengths
5. **Equality behavior** - Object equality and hashCode consistency
6. **Generator integration** - Verify periods work correctly with their generators
