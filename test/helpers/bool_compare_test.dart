import 'package:due_date/src/helpers/bool_compare.dart';
import 'package:test/test.dart';

void main() {
  group('boolCompareTo:', () {
    group('Same values', () {
      test('Both null', () {
        expect(boolCompareTo(null, null), equals(0));
      });
      test('Both true', () {
        expect(boolCompareTo(true, true), equals(0));
      });
      test('Both false', () {
        expect(boolCompareTo(false, false), equals(0));
      });
    });

    group('Null handling', () {
      test('First null, second true', () {
        expect(boolCompareTo(null, true), equals(-1));
      });
      test('First null, second false', () {
        expect(boolCompareTo(null, false), equals(-1));
      });
      test('First true, second null', () {
        expect(boolCompareTo(true, null), equals(1));
      });
      test('First false, second null', () {
        expect(boolCompareTo(false, null), equals(1));
      });
    });

    group('Boolean comparison', () {
      test('True vs false', () {
        expect(boolCompareTo(true, false), equals(1));
      });
      test('False vs true', () {
        expect(boolCompareTo(false, true), equals(-1));
      });
    });

    group('Ordering consistency', () {
      test('Reflexive: a compared to a is 0', () {
        expect(boolCompareTo(true, true), equals(0));
        expect(boolCompareTo(false, false), equals(0));
        expect(boolCompareTo(null, null), equals(0));
      });

      test('Antisymmetric: if a < b then b > a', () {
        expect(boolCompareTo(null, true), isNegative);
        expect(boolCompareTo(true, null), isPositive);

        expect(boolCompareTo(null, false), isNegative);
        expect(boolCompareTo(false, null), isPositive);

        expect(boolCompareTo(false, true), isNegative);
        expect(boolCompareTo(true, false), isPositive);
      });

      test('Transitive ordering: null < false < true', () {
        // Null < false.
        expect(boolCompareTo(null, false), isNegative);
        // False < true.
        expect(boolCompareTo(false, true), isNegative);
        // Null < true (transitivity).
        expect(boolCompareTo(null, true), isNegative);
      });
    });

    group('Edge cases', () {
      test('Return value is exactly -1, 0, or 1', () {
        expect(boolCompareTo(null, true), equals(-1));
        expect(boolCompareTo(true, true), equals(0));
        expect(boolCompareTo(true, false), equals(1));
      });

      test('Can be used for sorting', () {
        final values = [true, null, false, true, null, false]
          ..sort(boolCompareTo);
        expect(values, equals([null, null, false, false, true, true]));
      });
    });

    group('Performance characteristics', () {
      test('Handles many comparisons efficiently', () {
        // This test ensures the function can handle many calls without issues.
        var count = 0;
        for (var i = 0; i < 1000; i++) {
          final result1 = boolCompareTo(i.isEven, i.isOdd);
          final result2 = boolCompareTo(null, i.isEven);
          final result3 = boolCompareTo(i.isOdd, null);
          count += result1 + result2 + result3;
        }
        // Just verify it completes without throwing.
        expect(count, isA<int>());
      });
    });
  });
}
