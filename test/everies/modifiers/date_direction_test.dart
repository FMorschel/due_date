// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('DateDirection:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(DateDirection.values.length, equals(3));
        expect(
          DateDirection.values,
          containsAllInOrder([
            DateDirection.start,
            DateDirection.next,
            DateDirection.previous,
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
        });
      });
      group('isNext', () {
        test('Returns true for next direction', () {
          expect(DateDirection.next.isNext, isTrue);
        });
        test('Returns false for non-next directions', () {
          expect(DateDirection.previous.isNext, isFalse);
          expect(DateDirection.start.isNext, isFalse);
        });
      });
      group('isPrevious', () {
        test('Returns true for previous direction', () {
          expect(DateDirection.previous.isPrevious, isTrue);
        });
        test('Returns false for non-previous directions', () {
          expect(DateDirection.next.isPrevious, isFalse);
          expect(DateDirection.start.isPrevious, isFalse);
        });
      });
    });
    group('Properties for all values:', () {
      for (final direction in DateDirection.values) {
        group(direction.name, () {
          test('index is correct', () {
            expect(
              direction.index,
              equals(DateDirection.values.indexOf(direction)),
            );
          });
        });
      }
    });
    group('String representation', () {
      test('start has correct string representation', () {
        expect(DateDirection.start.toString(), equals('DateDirection.start'));
      });
      test('next has correct string representation', () {
        expect(DateDirection.next.toString(), equals('DateDirection.next'));
      });
      test('previous has correct string representation', () {
        expect(
          DateDirection.previous.toString(),
          equals('DateDirection.previous'),
        );
      });
    });
    group('Name property', () {
      test('start has correct name', () {
        expect(DateDirection.start.name, equals('start'));
      });
      test('next has correct name', () {
        expect(DateDirection.next.name, equals('next'));
      });
      test('previous has correct name', () {
        expect(DateDirection.previous.name, equals('previous'));
      });
    });
    group('Index property', () {
      test('start has correct index', () {
        expect(DateDirection.start.index, equals(0));
      });
      test('next has correct index', () {
        expect(DateDirection.next.index, equals(1));
      });
      test('previous has correct index', () {
        expect(DateDirection.previous.index, equals(2));
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(DateDirection.start, equals(DateDirection.start));
        expect(DateDirection.previous, equals(DateDirection.previous));
        expect(DateDirection.next, equals(DateDirection.next));
      });
      test('Different values are not equal', () {
        expect(DateDirection.next, isNot(equals(DateDirection.previous)));
        expect(DateDirection.start, isNot(equals(DateDirection.next)));
        expect(DateDirection.start, isNot(equals(DateDirection.previous)));
      });
    });
    group('Edge Cases', () {
      test('All boolean properties are mutually exclusive', () {
        for (final direction in DateDirection.values) {
          final bools = [
            direction.isStart,
            direction.isNext,
            direction.isPrevious,
          ];
          expect(bools.where((b) => b).length, equals(1));
        }
      });
      test('All values are unique', () {
        final set = DateDirection.values.toSet();
        expect(set.length, equals(DateDirection.values.length));
      });
    });
  });
}
