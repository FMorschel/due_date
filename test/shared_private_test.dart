import 'package:due_date/src/every.dart';
import 'package:due_date/src/shared_private.dart';
import 'package:test/test.dart';

void main() {
  group('getWorkdayNumberInMonth', () {
    test('should throw when date is a weekend', () {
      expect(
        () => getWorkdayNumberInMonth(
          DateTime(2022),
          shouldThrow: true,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
    test(
        'should not throw when date shouldThrow is false and date is a weekend',
        () {
      expect(getWorkdayNumberInMonth(DateTime(2022)), 0);
    });
    test('should not throw when date is a workday', () {
      expect(getWorkdayNumberInMonth(DateTime(2022, DateTime.june, 7)), 5);
    });
    test('If weekend, should always return 0', () {
      const every = EveryWeekday.weekend;
      for (var date = every.next(DateTime(2021, 12, 31));
          date.month < 2;
          date = every.next(date)) {
        expect(getWorkdayNumberInMonth(date), 0);
      }
    });
    test('If workday, should never return 0', () {
      const every = EveryWeekday.workdays;
      for (var date = every.next(DateTime(2021, 12, 31));
          date.month < 2;
          date = every.next(date)) {
        expect(getWorkdayNumberInMonth(date), isNot(0));
      }
      for (var date = every.next(DateTime(2023, 12, 31));
          date.month < 2;
          date = every.next(date)) {
        expect(getWorkdayNumberInMonth(date), isNot(0));
      }
    });
  });
  group('ObjectExt', () {
    group('when', () {
      final object = Object();
      test('predicate parameter is the same object as the caller', () {
        object.when((self) {
          expect(self, same(object));
          return false;
        });
      });
      test('orElse parameter is the same object as the caller', () {
        object.when(
          (_) => false,
          orElse: (self) {
            expect(self, same(object));
            return false;
          },
        );
      });
      test('orElse is not called if predicate is true', () {
        expect(
          object.when(
            (_) => true,
            orElse: (_) {
              throw AssertionError('orElse should not be called');
            },
          ),
          equals(object),
        );
      });
      test('predicate is true', () {
        expect(object.when((_) => true), equals(object));
      });
      group('predicate is false', () {
        test('orElse is null', () {
          expect(object.when((_) => false), isNull);
        });
        group('orElse is not null', () {
          test('orElse returns null', () {
            expect(object.when((_) => false, orElse: (_) => null), isNull);
          });
          test('orElse returns value', () {
            final newObject = Object();
            expect(
              object.when((_) => false, orElse: (_) => newObject),
              equals(newObject),
            );
          });
        });
      });
    });
    group('apply', () {
      final object = Object();
      test('returns self, parameter is the same as object', () {
        expect(object.apply((self) => self), equals(object));
      });
      test('returns new object', () {
        final newObject = Object();
        expect(object.apply((_) => newObject), equals(newObject));
      });
    });
  });
}
