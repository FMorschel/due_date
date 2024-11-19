import 'package:due_date/src/helpers/helpers.dart';
import 'package:test/test.dart';

void main() {
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
