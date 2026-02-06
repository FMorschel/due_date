import 'package:due_date/src/everies/workday_direction.dart';
import 'package:test/test.dart';

void main() {
  group('WorkdayDirection:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(WorkdayDirection.values.length, equals(3));
        expect(
          WorkdayDirection.values,
          containsAllInOrder([
            WorkdayDirection.none,
            WorkdayDirection.forward,
            WorkdayDirection.backward,
          ]),
        );
      });
    });

    group('String representation', () {
      test('All have correct string representation', () {
        expect(
          WorkdayDirection.none.toString(),
          equals('WorkdayDirection.none'),
        );
        expect(
          WorkdayDirection.forward.toString(),
          equals('WorkdayDirection.forward'),
        );
        expect(
          WorkdayDirection.backward.toString(),
          equals('WorkdayDirection.backward'),
        );
      });
    });

    group('Getters', () {
      group('isNone', () {
        test('Returns true for WorkdayDirection.none', () {
          expect(WorkdayDirection.none.isNone, isTrue);
        });

        test('Returns false for WorkdayDirection.forward', () {
          expect(WorkdayDirection.forward.isNone, isFalse);
        });

        test('Returns false for WorkdayDirection.backward', () {
          expect(WorkdayDirection.backward.isNone, isFalse);
        });
      });

      group('isForward', () {
        test('Returns false for WorkdayDirection.none', () {
          expect(WorkdayDirection.none.isForward, isFalse);
        });

        test('Returns true for WorkdayDirection.forward', () {
          expect(WorkdayDirection.forward.isForward, isTrue);
        });

        test('Returns false for WorkdayDirection.backward', () {
          expect(WorkdayDirection.backward.isForward, isFalse);
        });
      });

      group('isBackward', () {
        test('Returns false for WorkdayDirection.none', () {
          expect(WorkdayDirection.none.isBackward, isFalse);
        });

        test('Returns false for WorkdayDirection.forward', () {
          expect(WorkdayDirection.forward.isBackward, isFalse);
        });

        test('Returns true for WorkdayDirection.backward', () {
          expect(WorkdayDirection.backward.isBackward, isTrue);
        });
      });
    });
    group('Enum properties', () {
      test('All values have correct index', () {
        expect(WorkdayDirection.none.index, equals(0));
        expect(WorkdayDirection.forward.index, equals(1));
        expect(WorkdayDirection.backward.index, equals(2));
      });

      test('All values have correct name', () {
        expect(WorkdayDirection.none.name, equals('none'));
        expect(WorkdayDirection.forward.name, equals('forward'));
        expect(WorkdayDirection.backward.name, equals('backward'));
      });
    });
  });
}
