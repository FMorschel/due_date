import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('EveryDateValidatorUnion', () {
    const everies = EveryDateValidatorUnion([
      EveryDueDayMonth(24),
      EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
    ]);

    group('Test base methods logic', () {
      final date = DateTime(2022, DateTime.september, 23);
      final expected = DateTime(2022, DateTime.september, 24);
      group('startDate', () {
        test('If the given date would be generated, return it', () {
          expect(
            everies.startDate(expected),
            equals(expected),
          );
        });
        test('If the given date would not be generated, use next', () {
          expect(
            everies.startDate(date),
            equals(everies.next(date)),
          );
        });
      });
      group('next', () {
        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(
            everies.next(expected),
            equals(DateTime(2022, DateTime.october)),
          ),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(
            everies.next(DateTime(2022, DateTime.september, 17)),
            equals(expected),
          ),
        );
      });
      group('previous', () {
        final expectedPrevious = DateTime(2022, DateTime.september, 17);

        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(everies.previous(expected), equals(expectedPrevious)),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(everies.previous(date), equals(expectedPrevious)),
        );
      });
    });

    group('Start Date', () {
      test('All valid', () {
        final date = DateTime(2022, DateTime.september, 23);
        final expected = DateTime(2022, DateTime.september, 24);
        expect(everies.startDate(date), equals(expected));
      });
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 16);
        final expected = DateTime(2022, DateTime.september, 17);
        expect(everies.startDate(date), equals(expected));
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 23);
        final expected = DateTime(2022, DateTime.august, 24);
        expect(everies.startDate(date), equals(expected));
      });
      group('Throws DateTimeLimitReachedException', () {
        final date = DateTime(2021, DateTime.july, 22);
        final throwsDateTimeLimitReachedException = throwsA(
          isA<DateTimeLimitReachedException>(),
        );
        test('Inner every', () {
          final limit = DateTime(2021, DateTime.july, 23);
          expect(
            () => everies.startDate(date, limit: limit),
            throwsDateTimeLimitReachedException,
          );
        });
      });
      test('The limit is the expected date', () {
        final date = DateTime(2021, DateTime.july, 23);
        final expected = DateTime(2021, DateTime.july, 24);

        expect(everies.startDate(date, limit: expected), equals(expected));
      });
    });
    group('Next', () {
      test('All valid', () {
        final date = DateTime(2022, DateTime.september, 17);
        final expected = DateTime(2022, DateTime.september, 24);
        expect(everies.next(date), equals(expected));
      });
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 16);
        final expected = DateTime(2022, DateTime.september, 17);
        expect(everies.next(date), equals(expected));
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 23);
        final expected = DateTime(2022, DateTime.august, 24);
        expect(everies.next(date), equals(expected));
      });
      group('Throws DateTimeLimitReachedException', () {
        final date = DateTime(2021, DateTime.july, 22);
        final throwsDateTimeLimitReachedException = throwsA(
          isA<DateTimeLimitReachedException>(),
        );
        test('Inner every', () {
          final limit = DateTime(2021, DateTime.july, 23);
          expect(
            () => everies.next(date, limit: limit),
            throwsDateTimeLimitReachedException,
          );
        });
      });
      test('The limit is the expected date', () {
        final date = DateTime(2021, DateTime.july, 23);
        final expected = DateTime(2021, DateTime.july, 24);

        expect(everies.next(date, limit: expected), equals(expected));
      });
    });
    group('Previous', () {
      test('All valid', () {
        final date = DateTime(2022, DateTime.september, 25);
        final expected = DateTime(2022, DateTime.september, 24);
        expect(everies.previous(date), equals(expected));
      });
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 24);
        final expected = DateTime(2022, DateTime.september, 17);
        expect(everies.previous(date), equals(expected));
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 25);
        final expected = DateTime(2022, DateTime.august, 24);
        expect(everies.previous(date), equals(expected));
      });
      group('Throws DateTimeLimitReachedException', () {
        final date = DateTime(2022, DateTime.september, 26);
        final throwsDateTimeLimitReachedException = throwsA(
          isA<DateTimeLimitReachedException>(),
        );
        test('Inner every', () {
          final limit = DateTime(2022, DateTime.september, 25);
          expect(
            () => everies.previous(date, limit: limit),
            throwsDateTimeLimitReachedException,
          );
        });
      });
      test('The limit is the expected date', () {
        final date = DateTime(2022, DateTime.september, 25);
        final expected = DateTime(2022, DateTime.september, 24);

        expect(everies.previous(date, limit: expected), equals(expected));
      });
    });
  });
}