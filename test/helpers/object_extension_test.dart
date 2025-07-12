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

    group('when2', () {
      final object = Object();
      test('predicate parameter is the same object as the caller', () {
        object.when2((self) {
          expect(self, same(object));
          return false;
        });
      });
      test('returns _When instance', () {
        final result = object.when2((_) => true);
        // _When is private, so check it's an object.
        expect(result, isA<Object>());
      });
      test('predicate is called once', () {
        var callCount = 0;
        object.when2((_) {
          callCount++;
          return true;
        })();
        expect(callCount, equals(1));
      });
    });

    group('whenn', () {
      final object = Object();
      test('predicate parameter is the same object as the caller', () {
        object.whenn((self) {
          expect(self, same(object));
          return false;
        });
      });
      test('predicate is true returns object', () {
        expect(object.whenn((_) => true), equals(object));
      });
      test('predicate is false returns null', () {
        expect(object.whenn((_) => false), isNull);
      });
      test('predicate is called once', () {
        var callCount = 0;
        object.whenn((_) {
          callCount++;
          return true;
        });
        expect(callCount, equals(1));
      });
    });

    group('_When class methods', () {
      final object = Object();

      group('orElse', () {
        test('predicate true returns original object', () {
          final newObject = Object();
          final result = object.when2((_) => true).orElse((_) => newObject);
          expect(result, same(object));
        });
        test('predicate false calls orElse function', () {
          final newObject = Object();
          final result = object.when2((_) => false).orElse((_) => newObject);
          expect(result, same(newObject));
        });
        test('orElse parameter is the same object as the caller', () {
          object.when2((_) => false).orElse((self) {
            expect(self, same(object));
            return Object();
          });
        });
        test('orElse is not called if predicate is true', () {
          object.when2((_) => true).orElse((_) {
            throw AssertionError('orElse should not be called');
          });
        });
        test('orElse must be called if predicate is false', () {
          var orElseCalled = false;
          object.when2((_) => false).orElse((_) {
            orElseCalled = true;
            return Object();
          });
          expect(orElseCalled, isTrue);
        });
      });

      group('ifElse', () {
        test('predicate true returns original object', () {
          final result = object.when2((_) => true).ifElse();
          expect(result, same(object));
        });
        test('predicate false with no ifElse returns null', () {
          final result = object.when2((_) => false).ifElse();
          expect(result, isNull);
        });
        test('predicate false with ifElse function calls it', () {
          final newObject = Object();
          final result = object.when2((_) => false).ifElse((_) => newObject);
          expect(result, same(newObject));
        });
        test('predicate false with ifElse returning null', () {
          final result = object.when2((_) => false).ifElse((_) => null);
          expect(result, isNull);
        });
        test('ifElse parameter is the same object as the caller', () {
          object.when2((_) => false).ifElse((self) {
            expect(self, same(object));
            return null;
          });
        });
        test('ifElse is not called if predicate is true', () {
          object.when2((_) => true).ifElse((_) {
            throw AssertionError('ifElse should not be called');
          });
        });
        test('ifElse can be omitted when predicate is false', () {
          final result = object.when2((_) => false).ifElse();
          expect(result, isNull);
        });
      });

      group('call', () {
        test('predicate true returns original object', () {
          final result = object.when2((_) => true).call();
          expect(result, same(object));
        });
        test('predicate false returns null', () {
          final result = object.when2((_) => false).call();
          expect(result, isNull);
        });
        test('call can be invoked without parentheses', () {
          final result = object.when2((_) => true)();
          expect(result, same(object));
        });
        test('equivalent to whenn', () {
          final result1 = object.whenn((_) => true);
          final result2 = object.when2((_) => true).call();
          expect(result1, equals(result2));

          final result3 = object.whenn((_) => false);
          final result4 = object.when2((_) => false).call();
          expect(result3, equals(result4));
        });
      });
    });

    group('Integration tests', () {
      test('when2 chaining with different methods', () {
        final object = Object();
        final newObject = Object();

        // Test when2().orElse() vs when() with orElse.
        final result1 = object.when((_) => false, orElse: (_) => newObject);
        final result2 = object.when2((_) => false).orElse((_) => newObject);
        expect(result1, equals(result2));

        // Test when2().ifElse() vs when() without orElse.
        final result3 = object.when((_) => false);
        final result4 = object.when2((_) => false).ifElse();
        expect(result3, equals(result4));
      });

      test('Complex predicate logic', () {
        const number = 42;

        // Test with integer predicates.
        expect(number.when2((n) => n > 40).orElse((_) => 0), equals(42));
        expect(number.when2((n) => n > 50).orElse((_) => 0), equals(0));
        expect(number.whenn((n) => n.isEven), equals(42));
        expect(number.whenn((n) => n.isOdd), isNull);
      });
    });
  });
}
