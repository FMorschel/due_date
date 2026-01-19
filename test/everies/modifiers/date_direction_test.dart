import 'package:due_date/src/everies/date_direction.dart';
import 'package:test/test.dart';

void main() {
  group('DateDirection:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(DateDirection.values.length, equals(4));
        expect(
          DateDirection.values,
          containsAllInOrder([
            DateDirection.start,
            DateDirection.next,
            DateDirection.previous,
            DateDirection.end,
          ]),
        );
      });
    });
    group('Properties', () {
      group('isStart', () {
        test('Returns true for start direction', () {
          expect(DateDirection.start.isStart, isTrue);
        });
        test('Returns false for non-start directions', () {
          expect(DateDirection.previous.isStart, isFalse);
          expect(DateDirection.next.isStart, isFalse);
          expect(DateDirection.end.isStart, isFalse);
        });
      });
      group('isNext', () {
        test('Returns true for next direction', () {
          expect(DateDirection.next.isNext, isTrue);
        });
        test('Returns false for non-next directions', () {
          expect(DateDirection.previous.isNext, isFalse);
          expect(DateDirection.start.isNext, isFalse);
          expect(DateDirection.end.isNext, isFalse);
        });
      });
      group('isPrevious', () {
        test('Returns true for previous direction', () {
          expect(DateDirection.previous.isPrevious, isTrue);
        });
        test('Returns false for non-previous directions', () {
          expect(DateDirection.next.isPrevious, isFalse);
          expect(DateDirection.start.isPrevious, isFalse);
          expect(DateDirection.end.isPrevious, isFalse);
        });
      });
      group('isEnd', () {
        test('Returns true for end direction', () {
          expect(DateDirection.end.isEnd, isTrue);
        });
        test('Returns false for non-end directions', () {
          expect(DateDirection.next.isEnd, isFalse);
          expect(DateDirection.start.isEnd, isFalse);
          expect(DateDirection.previous.isEnd, isFalse);
        });
      });
    });
    group('Edge Cases', () {
      test('All boolean properties are mutually exclusive', () {
        for (final direction in DateDirection.values) {
          final bools = [
            direction.isStart,
            direction.isNext,
            direction.isPrevious,
            direction.isEnd,
          ];
          expect(bools.where((b) => b).length, equals(1));
        }
      });
    });
  });
}
