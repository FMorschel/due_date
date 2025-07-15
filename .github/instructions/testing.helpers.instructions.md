---
applyTo: 'test/helpers/**/*_test.dart'
---

# Helper Testing Standards

Testing standards specific to helper classes and utilities in the due_date library.

## Helper Method Testing

Test each helper method thoroughly:

```dart
group('methodName', () {
  test('Basic functionality', () {
    final result = HelperClass.methodName(params);
    expect(result, equals(expectedResult));
  });
  
  test('With different input types', () {
    final result = HelperClass.methodName(differentParams);
    expect(result, equals(expectedResult));
  });
  
  test('Error handling', () {
    expect(
      () => HelperClass.methodName(invalidParams),
      throwsA(isA<ArgumentError>()),
    );
  });
});
```

## Utility Function Testing

For utility functions, test all branches and edge cases:

```dart
group('Utility functions', () {
  test('boolCompare works correctly', () {
    expect(boolCompare(true, true), equals(0));
    expect(boolCompare(true, false), equals(1));
    expect(boolCompare(false, true), equals(-1));
    expect(boolCompare(false, false), equals(0));
  });
  
  test('dateReducer reduces correctly', () {
    final dates = [
      DateTime(2024, 1, 15),
      DateTime(2024, 1, 10),
      DateTime(2024, 1, 20),
    ];
    final result = dateReducer(dates, (a, b) => a.isBefore(b) ? a : b);
    expect(result, equals(DateTime(2024, 1, 10)));
  });
});
```

## Object Extension Testing

For object extensions and utilities:

```dart
group('Object extensions', () {
  test('Extension methods work correctly', () {
    final obj = SomeObject();
    expect(obj.someExtensionMethod(), equals(expectedResult));
  });
  
  test('Handles null objects', () {
    final obj = null;
    expect(obj?.someExtensionMethod(), isNull);
  });
});
```

## Helper Edge Cases

Test boundary conditions and special cases:

```dart
group('Edge cases', () {
  test('Handles empty collections', () {
    final result = HelperClass.processCollection([]);
    expect(result, isEmpty);
  });
  
  test('Handles single-item collections', () {
    final result = HelperClass.processCollection([singleItem]);
    expect(result, equals([expectedResult]));
  });
  
  test('Handles null inputs appropriately', () {
    expect(
      () => HelperClass.processValue(null),
      throwsArgumentError,
    );
  });
  
  test('Handles boundary date values', () {
    final minDate = DateTime(1970, 1, 1);
    final maxDate = DateTime(9999, 12, 31);
    
    expect(HelperClass.processDate(minDate), isNotNull);
    expect(HelperClass.processDate(maxDate), isNotNull);
  });
});
```
