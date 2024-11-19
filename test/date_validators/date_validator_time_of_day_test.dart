import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorTimeOfDay:', () {
    group('constructor', () {
      group('unnamed', () {
        group('valid durations', () {
          for (var duration = Duration.zero;
              duration < const Duration(days: 1);
              duration += const Duration(minutes: 1)) {
            test('Valid duration $duration', () {
              expect(DateValidatorTimeOfDay(duration), isNotNull);
            });
          }
          test('last microsecond of day', () {
            expect(
              DateValidatorTimeOfDay(
                const Duration(days: 1) - const Duration(microseconds: 1),
              ),
              isNotNull,
            );
          });
        });
        test('assert when duration is negative', () {
          expect(
            () => DateValidatorTimeOfDay(
              -const Duration(microseconds: 1),
            ),
            throwsA(isA<AssertionError>()),
          );
        });
        group('assert when duration is 1 day or more', () {
          test('1 day', () {
            expect(
              () => DateValidatorTimeOfDay(
                const Duration(days: 1),
              ),
              throwsA(isA<AssertionError>()),
            );
          });
          test('2 days', () {
            expect(
              () => DateValidatorTimeOfDay(
                const Duration(days: 2),
              ),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
      group('from', () {
        test('creates instance with correct timeOfDay', () {
          final dateTime = DateTime(2022, 1, 1, 13, 30);
          final validator = DateValidatorTimeOfDay.from(dateTime);

          expect(
            validator.timeOfDay,
            equals(const Duration(hours: 13, minutes: 30)),
          );
        });
      });
    });
    group('valid', () {
      final validator = DateValidatorTimeOfDay(
        const Duration(hours: 23, minutes: 30),
      );
      test('valid time', () {
        final date = DateTime(2022, 1, 1, 23, 30);
        expect(validator.valid(date), isTrue);
      });
      test('invalid time', () {
        final date = DateTime(2022, 1, 1, 23, 31);
        expect(validator.valid(date), isFalse);
      });
    });
  });
}
