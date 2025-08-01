import 'package:due_date/due_date.dart';
import 'package:due_date/src/helpers/helpers.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('LimitedOrEveryHandler', () {
    const every = EveryWeekday(Weekday.monday);
    const limited = EverySkipInvalidModifier(
      every: EveryWeekday(Weekday.monday),
      invalidator: DateValidatorWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.monday,
      ),
    );

    group('startDate for Every', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 4);

      test('when limit is null', () {
        final result = LimitedOrEveryHandler.startDate(
          every,
          date,
          limit: null,
        );

        expect(result, isSameDateTime(expectedDate));
      });
      test('when limit is not null', () {
        final result = LimitedOrEveryHandler.startDate(
          every,
          date,
          limit: DateTime(2023, 12, 12),
        );

        expect(result, isSameDateTime(expectedDate));
      });

      test('when limit is before date', () {
        final result = LimitedOrEveryHandler.startDate(
          every,
          date,
          limit: DateTime(2023, 12, 2),
        );

        expect(result, isSameDateTime(expectedDate));
      });
    });

    group('startDate for LimitedEvery', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 11);

      test('when limit is null', () {
        final result =
            LimitedOrEveryHandler.startDate(limited, date, limit: null);

        expect(result, isSameDateTime(expectedDate));
      });

      group('when limit is not null', () {
        test('and limit is after date', () {
          final result = LimitedOrEveryHandler.startDate(
            limited,
            date,
            limit: DateTime(2023, 12, 12),
          );

          expect(result, isSameDateTime(expectedDate));
        });

        test('and limit is before date', () {
          expect(
            () => LimitedOrEveryHandler.startDate(
              limited,
              date,
              limit: DateTime(2023, 12),
            ),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('and limit is the expected date', () {
          final result = LimitedOrEveryHandler.startDate(
            limited,
            date,
            limit: expectedDate,
          );

          expect(result, isSameDateTime(expectedDate));
        });
      });
    });

    group('next Every', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 4);

      test('when limit is null', () {
        final result = LimitedOrEveryHandler.next(every, date, limit: null);

        expect(result, isSameDateTime(expectedDate));
      });
      test('when limit is not null', () {
        final result = LimitedOrEveryHandler.next(
          every,
          date,
          limit: DateTime(2023, 12, 12),
        );

        expect(result, isSameDateTime(expectedDate));
      });

      test('when limit is before date', () {
        final result = LimitedOrEveryHandler.next(
          every,
          date,
          limit: DateTime(2023, 12, 2),
        );

        expect(result, isSameDateTime(expectedDate));
      });
    });

    group('next for LimitedEvery', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 11);

      test('when limit is null', () {
        final result = LimitedOrEveryHandler.next(limited, date, limit: null);

        expect(result, isSameDateTime(expectedDate));
      });

      group('when limit is not null', () {
        test('and limit is after date', () {
          final result = LimitedOrEveryHandler.next(
            limited,
            date,
            limit: DateTime(2023, 12, 12),
          );

          expect(result, isSameDateTime(expectedDate));
        });

        test('and limit is before date', () {
          expect(
            () => LimitedOrEveryHandler.next(
              limited,
              date,
              limit: DateTime(2023, 12),
            ),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('and limit is the expected date', () {
          final result = LimitedOrEveryHandler.next(
            limited,
            date,
            limit: expectedDate,
          );

          expect(result, isSameDateTime(expectedDate));
        });
      });
    });

    group('previous for Every', () {
      final date = DateTime(2023, 12, 11);
      final expectedDate = DateTime(2023, 12, 4);

      test('when limit is null', () {
        final result = LimitedOrEveryHandler.previous(every, date, limit: null);

        expect(result, isSameDateTime(expectedDate));
      });
      test('when limit is not null', () {
        final result = LimitedOrEveryHandler.previous(
          every,
          date,
          limit: DateTime(2023, 12, 3),
        );

        expect(result, isSameDateTime(expectedDate));
      });

      test('when limit is after date', () {
        final result = LimitedOrEveryHandler.previous(
          every,
          date,
          limit: DateTime(2023, 12, 5),
        );

        expect(result, isSameDateTime(expectedDate));
      });
    });

    group('previous for LimitedEvery', () {
      final date = DateTime(2023, 12, 10);
      final expectedDate = DateTime(2023, 11, 27);

      test('when limit is null', () {
        final result =
            LimitedOrEveryHandler.previous(limited, date, limit: null);

        expect(result, isSameDateTime(expectedDate));
      });
      test('when limit is not null', () {
        final result = LimitedOrEveryHandler.previous(
          limited,
          date,
          limit: DateTime(2023, 11, 26),
        );

        expect(result, isSameDateTime(expectedDate));
      });

      test('when limit is before date', () {
        expect(
          () => LimitedOrEveryHandler.previous(
            limited,
            date,
            limit: DateTime(2023, 11, 28),
          ),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('and limit is the expected date', () {
        final result = LimitedOrEveryHandler.previous(
          limited,
          date,
          limit: expectedDate,
        );

        expect(result, isSameDateTime(expectedDate));
      });
    });
  });
}
