import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('EverySkipInvalidModifier', () {
    final every = Weekday.monday.every;
    const invalidator = DateValidatorWeekdayCountInMonth(
      week: Week.first,
      day: Weekday.monday,
    );
    final modifier =
        EverySkipInvalidModifier(every: every, invalidator: invalidator);

    group('Test base methods logic', () {
      final date = DateTime(2022, DateTime.october, 7);
      final expected = DateTime(2022, DateTime.october, 10);
      group('startDate', () {
        test('If the given date would be generated, return it', () {
          expect(
            modifier.startDate(expected),
            equals(expected),
          );
        });
        test('If the given date would not be generated, use next', () {
          expect(
            modifier.startDate(date),
            equals(modifier.next(date)),
          );
        });
      });
      group('next', () {
        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(
            modifier.next(expected),
            equals(DateTime(2022, DateTime.october, 17)),
          ),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(modifier.next(date), equals(expected)),
        );
      });
      group('previous', () {
        final expectedPrevious = DateTime(2022, DateTime.september, 26);

        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(modifier.previous(expected), equals(expectedPrevious)),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(modifier.previous(date), equals(expectedPrevious)),
        );
      });
    });

    group('startDate', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 11);

      test('when limit is null', () {
        final result = modifier.startDate(date);

        expect(result, equals(expectedDate));
      });

      group('when limit is not null', () {
        test('and limit is after date', () {
          final result = modifier.startDate(
            date,
            limit: DateTime(2023, 12, 12),
          );

          expect(result, equals(expectedDate));
        });

        test('and limit is before date', () {
          expect(
            () => modifier.startDate(date, limit: DateTime(2023, 12)),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('and limit is the expected date', () {
          final result = modifier.startDate(date, limit: expectedDate);

          expect(result, equals(expectedDate));
        });
      });
    });

    group('next', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 11);

      test('when limit is null', () {
        final result = modifier.next(date);

        expect(result, equals(expectedDate));
      });

      group('when limit is not null', () {
        test('and limit is after date', () {
          final result = modifier.next(date, limit: DateTime(2023, 12, 12));

          expect(result, equals(expectedDate));
        });

        test('and limit is before date', () {
          expect(
            () => modifier.next(date, limit: DateTime(2023, 12)),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('and limit is the expected date', () {
          final result = modifier.next(date, limit: expectedDate);

          expect(result, equals(expectedDate));
        });
      });
    });

    group('previous', () {
      final date = DateTime(2023, 12, 10);
      final expectedDate = DateTime(2023, 11, 27);

      test('when limit is null', () {
        final result = modifier.previous(date);

        expect(result, equals(expectedDate));
      });
      test('when limit is not null', () {
        final result = modifier.previous(date, limit: DateTime(2023, 11, 26));

        expect(result, equals(expectedDate));
      });

      test('when limit is before date', () {
        expect(
          () => modifier.previous(date, limit: DateTime(2023, 11, 28)),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('and limit is the expected date', () {
        final result = modifier.previous(date, limit: expectedDate);

        expect(result, equals(expectedDate));
      });
    });

    group('valid', () {
      test('should return true', () {
        final result = modifier.valid(DateTime(2023, 12, 11));

        expect(result, isTrue);
      });

      group('should return false', () {
        test('when date is invalid because of invalidator', () {
          final result = modifier.valid(DateTime(2023, 12, 4));

          expect(result, isFalse);
        });

        test('when date is invalid because of every', () {
          final result = modifier.valid(DateTime(2023, 12, 3));

          expect(result, isFalse);
        });
      });
    });

    group('invalid', () {
      test('should return false', () {
        final result = modifier.invalid(DateTime(2023, 12, 11));

        expect(result, isFalse);
      });
      group('should return true', () {
        test('when date is invalid because of invalidator', () {
          final result = modifier.invalid(DateTime(2023, 12, 4));

          expect(result, isTrue);
        });

        test('when date is invalid because of every', () {
          final result = modifier.invalid(DateTime(2023, 12, 3));

          expect(result, isTrue);
        });
      });
    });
  });
}
