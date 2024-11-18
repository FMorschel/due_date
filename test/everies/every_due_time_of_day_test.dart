import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('EveryDueTimeOfDay:', () {
    group('constructor', () {
      group('unnamed', () {
        group('valid durations', () {
          for (var duration = Duration.zero;
              duration < const Duration(days: 1);
              duration += const Duration(minutes: 1)) {
            test('Valid duration $duration', () {
              expect(EveryDueTimeOfDay(duration), isNotNull);
            });
          }
          test('last microsecond of day', () {
            expect(
              EveryDueTimeOfDay(
                const Duration(days: 1) - const Duration(microseconds: 1),
              ),
              isNotNull,
            );
          });
        });
        test('assert when duration is negative', () {
          expect(
            () => EveryDueTimeOfDay(
              -const Duration(microseconds: 1),
            ),
            throwsA(isA<AssertionError>()),
          );
        });
        group('assert when duration is 1 day or more', () {
          test('1 day', () {
            expect(
              () => EveryDueTimeOfDay(
                const Duration(days: 1),
              ),
              throwsA(isA<AssertionError>()),
            );
          });
          test('2 days', () {
            expect(
              () => EveryDueTimeOfDay(
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
          final every = EveryDueTimeOfDay.from(dateTime);

          expect(
            every.timeOfDay,
            equals(const Duration(hours: 13, minutes: 30)),
          );
        });
      });
    });
    group('startDate', () {
      final every = EveryDueTimeOfDay(
        const Duration(hours: 23, minutes: 30),
      );
      test('If the given date would be generated, return it', () {
        final date = DateTime(2022, 1, 1, 23, 30);
        expect(every.startDate(date), equals(date));
      });
      test('If the given date would not be generated, use next', () {
        final date = DateTime(2022, 1, 1, 23, 29);
        final expected = DateTime(2022, 1, 1, 23, 30);
        expect(every.startDate(date), equals(expected));
      });
    });
    group('next', () {
      final every = EveryDueTimeOfDay(
        const Duration(hours: 23, minutes: 30),
      );
      test('If the given date would be generated, generate a new one anyway',
          () {
        final date = DateTime(2022, 1, 1, 23, 30);
        final expected = DateTime(2022, 1, 2, 23, 30);
        expect(every.next(date), equals(expected));
      });
      test(
          'If the given date would not be generated, generate the next valid '
          'date', () {
        final date = DateTime(2022, 1, 1, 23, 29);
        final expected = DateTime(2022, 1, 1, 23, 30);
        expect(every.next(date), equals(expected));
      });
    });
    group('previous', () {
      final every = EveryDueTimeOfDay(
        const Duration(hours: 23, minutes: 30),
      );
      test('If the given date would be generated, generate a new one anyway',
          () {
        final date = DateTime(2022, 1, 2, 23, 30);
        final expected = DateTime(2022, 1, 1, 23, 30);
        expect(every.previous(date), equals(expected));
      });
      test(
          'If the given date would not be generated, generate the next valid '
          'date', () {
        final date = DateTime(2022, 1, 2, 23, 29);
        final expected = DateTime(2022, 1, 1, 23, 30);
        expect(every.previous(date), equals(expected));
      });
    });
  });
}
