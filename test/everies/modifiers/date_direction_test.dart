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
          expect(DateDirection.next.isStart, isFalse);
          expect(DateDirection.previous.isStart, isFalse);
        });
      });

      group('isNext', () {
        test('Returns true for next direction', () {
          expect(DateDirection.next.isNext, isTrue);
        });

        test('Returns false for non-next directions', () {
          expect(DateDirection.start.isNext, isFalse);
          expect(DateDirection.previous.isNext, isFalse);
        });
      });

      group('isPrevious', () {
        test('Returns true for previous direction', () {
          expect(DateDirection.previous.isPrevious, isTrue);
        });

        test('Returns false for non-previous directions', () {
          expect(DateDirection.start.isPrevious, isFalse);
          expect(DateDirection.next.isPrevious, isFalse);
        });
      });
    });

    group('Properties for all values:', () {
      for (final direction in DateDirection.values) {
        group(direction.name, () {
          test('isStart property', () {
            final expected = direction == DateDirection.start;
            expect(direction.isStart, equals(expected));
          });

          test('isNext property', () {
            final expected = direction == DateDirection.next;
            expect(direction.isNext, equals(expected));
          });

          test('isPrevious property', () {
            final expected = direction == DateDirection.previous;
            expect(direction.isPrevious, equals(expected));
          });

          test('Only one property is true', () {
            final trueCount = [
              direction.isStart,
              direction.isNext,
              direction.isPrevious,
            ].where((value) => value).length;
            expect(trueCount, equals(1));
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
        expect(DateDirection.next, equals(DateDirection.next));
        expect(DateDirection.previous, equals(DateDirection.previous));
      });

      test('Different values are not equal', () {
        expect(DateDirection.start, isNot(equals(DateDirection.next)));
        expect(DateDirection.start, isNot(equals(DateDirection.previous)));
        expect(DateDirection.next, isNot(equals(DateDirection.previous)));
      });
    });

    group('Edge Cases', () {
      test('All boolean properties are mutually exclusive', () {
        for (final direction in DateDirection.values) {
          final properties = [
            direction.isStart,
            direction.isNext,
            direction.isPrevious,
          ];
          final trueCount = properties.where((p) => p).length;
          expect(
            trueCount,
            equals(1),
            reason: 'Each direction should have exactly one true property',
          );
        }
      });
    });
  });
}
