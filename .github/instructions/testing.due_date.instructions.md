---
applyTo: 'test/due_date_test.dart'
---

# DueDateTime Testing Standards

Testing standards specific to the main DueDateTime class test file.

## Test Structure Extensions for DueDateTime

In addition to the standard test structure, the DueDateTime test file must include these specific test groups:

```dart
group('Constructors:', () {
  // Test all constructor variations
});

group('Parsing:', () {
  // Test string parsing methods
});

group('Trying to Parse:', () {
  // Test tryParse methods
});

group('FromMillisecondsSinceEpoch:', () {
  // Test creation from milliseconds
});

group('FromMicrosecondsSinceEpoch:', () {
  // Test creation from microseconds
});

group('CopyWith:', () {
  // Test copyWith method variations
});

group('Add:', () {
  // Test Duration addition
});

group('Subtract:', () {
  // Test Duration subtraction
});

group('AddWeeks:', () {
  // Test week addition
});

group('SubtractWeeks:', () {
  // Test week subtraction
});

group('AddMonths:', () {
  // Test month addition
});

group('SubtractMonths:', () {
  // Test month subtraction
});

group('Previous/Next:', () {
  // Test Every-based navigation
});

group('Equality:', () {
  // Test DueDateTime equality
});
```

## Constructor Testing Pattern

Test all constructor variations including leap year handling:

```dart
group('Constructors:', () {
  test('Leap year February 29', () {
    // February 29, 2024 is a valid leap day.
    final leapMatcher = DateTime(2024, 2, 29);
    expect(
      DueDateTime(every: dueDay30, year: 2024, month: 2),
      isSameDueDateTime(leapMatcher),
    );
    expect(
      DueDateTime.utc(every: dueDay30, year: 2024, month: 2),
      isSameDueDateTime(DateTime.utc(2024, 2, 29)),
    );
  });
  
  test('Now', () {
    final now = DateTime.now();
    withClock(Clock.fixed(now), () {
      expect(DueDateTime.now(), isSameDueDateTime(now));
    });
  });
  
  group('FromDate:', () {
    test('No every', () {
      expect(DueDateTime.fromDate(matcher), equals(matcher));
    });
    test('With every', () {
      expect(DueDateTime.fromDate(matcher, every: dueDay30), equals(matcher));
    });
  });
});
```

## Parsing Testing Pattern

Test all string parsing methods with both valid and invalid inputs:

```dart
group('Parsing:', () {
  test('January 1st, 2022', () {
    expect(DueDateTime.parse('2022-01-01'), equals(DateTime(2022)));
  });
  test('FormatException', () {
    expect(() => DueDateTime.parse(''), throwsFormatException);
  });
  test('With every', () {
    expect(
      DueDateTime.parse('2022-01-01', every: dueDay15),
      equals(DateTime(2022, 1, 15)),
    );
  });
  test('Malformed date string', () {
    expect(() => DueDateTime.parse('not-a-date'), throwsFormatException);
    expect(DueDateTime.tryParse('not-a-date'), equals(null));
  });
});
```

## Time Component Preservation Testing

**Critical requirement**: All time manipulation methods must preserve time components and test both UTC and local DateTime handling:

```dart
group('CopyWith:', () {
  final dueDate = DueDateTime.fromDate(DateTime(2022, 1, 2, 3, 4, 5, 6, 7));
  
  test('Preserves time components', () {
    final updated = dueDate.copyWith(minute: 59);
    expect(updated.hour, equals(3));
    expect(updated.minute, equals(59));
    expect(updated.second, equals(5));
    expect(updated.millisecond, equals(6));
    expect(updated.microsecond, equals(7));
  });
  
  test('Preserves time components (UTC)', () {
    final utcDueDate = DueDateTime.fromDate(
      DateTime.utc(2022, 1, 2, 3, 4, 5, 6, 7),
    );
    final updated = utcDueDate.copyWith(second: 59);
    expect(updated, isUtcDateTime);
    expect(updated.hour, equals(3));
    expect(updated.minute, equals(4));
    expect(updated.second, equals(59));
    expect(updated.millisecond, equals(6));
    expect(updated.microsecond, equals(7));
  });
  
  test('Preserves time components UTC to Local', () {
    final utcDueDate = DueDateTime.fromDate(
      DateTime.utc(2022, 1, 2, 3, 4, 5, 6, 7),
    );
    final updated = utcDueDate.copyWith(utc: false);
    expect(updated, isLocalDateTime);
    // Test all time components preserved
  });
});
```

## sameEvery Parameter Testing

**All time manipulation methods must test both `sameEvery: true` (default) and `sameEvery: false` scenarios:**

```dart
group('Add:', () {
  final dueDate2 = DueDateTime(every: const EveryDueDayMonth(30), year: 2022);
  
  test('2 days', () {
    expect(
      dueDate2.add(const Duration(days: 2)),
      equals(DateTime(2022, 2, 28)),
    );
  });
  
  test("2 days, don't keep every", () {
    expect(
      dueDate2.add(const Duration(days: 2), sameEvery: false),
      equals(DateTime(2022, 2)),
    );
  });
});
```

## Every Integration Testing

Test DueDateTime with various Every implementations:

```dart
group('Previous/Next', () {
  group('Local', () {
    test('EveryWeek', () {
      final everyWeekday = DueDateTime(
        every: const EveryWeekday(Weekday.monday),
        year: 2022,
        month: DateTime.august,
        day: 22,
      );
      expect(
        everyWeekday.next(),
        equals(DateTime(2022, DateTime.august, 29)),
      );
    });
    
    test('EveryDueDayMonth', () {
      final everyWeekday = DueDateTime(
        every: const EveryDueDayMonth(22),
        year: 2022,
        month: DateTime.august,
        day: 22,
      );
      expect(
        everyWeekday.next(),
        equals(DateTime(2022, DateTime.september, 22)),
      );
    });
  });
  
  group('UTC', () {
    // Test same scenarios with UTC dates
  });
});
```

## Custom Matchers (REQUIRED for DueDateTime)

**All DueDateTime equality assertions MUST use the custom matchers provided:**

- `expect(dueDateTime, isSameDueDateTime(expected));` - Compare all DueDateTime fields including Every
- `expect(dateTime, isUtcDateTime);` - Assert DateTime is UTC
- `expect(dateTime, isLocalDateTime);` - Assert DateTime is local

**Required imports:**
```dart
import 'src/date_time_match.dart';
import 'src/due_date_time_match.dart';
```

## Clock Testing

Use `withClock` for testing time-dependent functionality:

```dart
test('Now', () {
  final now = DateTime.now();
  withClock(Clock.fixed(now), () {
    expect(DueDateTime.now(), isSameDueDateTime(now));
  });
});
```

## Epoch Testing Pattern

Test creation from milliseconds and microseconds with Every integration:

```dart
group('FromMillisecondsSinceEpoch:', () {
  final date = DateTime(2022);
  
  test('January 1st, 2022', () {
    expect(
      DueDateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch),
      equals(date),
    );
  });
  
  test('With every', () {
    expect(
      DueDateTime.fromMillisecondsSinceEpoch(
        date.millisecondsSinceEpoch,
        every: dueDay15,
      ),
      equals(DateTime(2022, 1, 15)),
    );
  });
  
  test('With every UTC', () {
    expect(
      DueDateTime.fromMillisecondsSinceEpoch(
        date.millisecondsSinceEpoch,
        every: dueDay15,
        isUtc: true,
      ),
      equals(DateTime(2022, 1, 15).toUtc()),
    );
  });
});
```

## Required Test Categories

Every DueDateTime test must cover:

1. **Constructor variations** - All constructor types with Every integration
2. **Parsing methods** - parse, tryParse with valid/invalid inputs
3. **Epoch constructors** - fromMilliseconds/Microseconds with Every
4. **Time manipulation** - add, subtract, copyWith with time preservation
5. **Calendar methods** - addWeeks, addMonths, addYears with sameEvery parameter
6. **Every integration** - next, previous with various Every implementations
7. **UTC/Local handling** - Test both time zones consistently
8. **Equality behavior** - Using custom matchers for DueDateTime comparison
