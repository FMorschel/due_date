---
applyTo: 'test/extensions/**/*_test.dart'
---

# Extension Testing Standards

Testing standards specific to extension classes in the due_date library.

## Extension Method Testing

Test each extension method thoroughly:

```dart
group('methodName', () {
  test('Basic functionality', () {
    final result = baseObject.methodName(params);
    expect(result, equals(expectedResult));
  });
  
  test('With different parameters', () {
    final result = baseObject.methodName(differentParams);
    expect(result, equals(expectedResult));
  });
  
  test('Edge case handling', () {
    final result = baseObject.methodName(edgeCaseParams);
    expect(result, equals(expectedResult));
  });
});
```

## DateTime Extension Testing

For DateTime extensions, test time-related functionality:

```dart
group('DateTime extensions', () {
  test('addDays works correctly', () {
    final date = DateTime(2024, 1, 15);
    final result = date.addDays(5);
    expect(result, isSameDateTime(DateTime(2024, 1, 20)));
  });
  
  test('preserves time components', () {
    final date = DateTime(2024, 1, 15, 10, 30, 45);
    final result = date.addDays(1);
    expect(result.hour, equals(10));
    expect(result.minute, equals(30));
    expect(result.second, equals(45));
  });
  
  test('handles month boundaries', () {
    final date = DateTime(2024, 1, 31);
    final result = date.addDays(1);
    expect(result, isSameDateTime(DateTime(2024, 2, 1)));
  });
});
```

## List Extension Testing

For List extensions, test collection functionality:

```dart
group('List extensions', () {
  test('containsAllInOrder works correctly', () {
    final list = [1, 2, 3, 4, 5];
    expect(list.containsAllInOrder([2, 3, 4]), isTrue);
    expect(list.containsAllInOrder([2, 4, 3]), isFalse);
  });
  
  test('handles empty lists', () {
    final list = <int>[];
    expect(list.containsAllInOrder([]), isTrue);
    expect(list.containsAllInOrder([1]), isFalse);
  });
});
```

## Extension Edge Cases

Test boundary conditions and special cases:

```dart
group('Edge cases', () {
  test('Handles null inputs gracefully', () {
    // Test null handling where applicable
  });
  
  test('Handles empty collections', () {
    // Test empty collection handling
  });
  
  test('Handles boundary values', () {
    // Test minimum/maximum values
  });
});
```
