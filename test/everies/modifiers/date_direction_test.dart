import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('DateDirection', () {
    test('isStart should return true for start direction', () {
      const direction = DateDirection.start;
      expect(direction.isStart, isTrue);
    });

    test('isStart should return false for non-start directions', () {
      const nextDirection = DateDirection.next;
      const previousDirection = DateDirection.previous;
      expect(nextDirection.isStart, isFalse);
      expect(previousDirection.isStart, isFalse);
    });

    test('isNext should return true for next direction', () {
      const direction = DateDirection.next;
      expect(direction.isNext, isTrue);
    });

    test('isNext should return false for non-next directions', () {
      const startDirection = DateDirection.start;
      const previousDirection = DateDirection.previous;
      expect(startDirection.isNext, isFalse);
      expect(previousDirection.isNext, isFalse);
    });

    test('isPrevious should return true for previous direction', () {
      const direction = DateDirection.previous;
      expect(direction.isPrevious, isTrue);
    });

    test('isPrevious should return false for non-previous directions', () {
      const startDirection = DateDirection.start;
      const nextDirection = DateDirection.next;
      expect(startDirection.isPrevious, isFalse);
      expect(nextDirection.isPrevious, isFalse);
    });
  });
}
