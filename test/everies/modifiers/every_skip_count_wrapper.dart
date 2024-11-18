import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('EverySkipCountWrapper', () {
    final every = Weekday.monday.every;

    group('Test base methods logic', () {
      group('Count 0', () {
        final wrapper = EverySkipCountWrapper(every: every, count: 0);
        final date = DateTime(2022, DateTime.september, 27);
        final expected = DateTime(2022, DateTime.october, 3);
        group('startDate', () {
          test('If the given date would be generated, return it', () {
            expect(wrapper.startDate(expected), equals(expected));
          });
          test('If the given date would not be generated, use next', () {
            expect(wrapper.startDate(date), equals(wrapper.next(date)));
          });
        });
        group('next', () {
          test(
            'If the given date would be generated, generate a new one anyway',
            () => expect(
              wrapper.next(expected),
              equals(DateTime(2022, DateTime.october, 10)),
            ),
          );
          test(
            'If the given date would not be generated, generate the next valid '
            'date',
            () => expect(wrapper.next(date), equals(expected)),
          );
        });
        group('previous', () {
          final expectedPrevious = DateTime(2022, DateTime.september, 26);

          test(
            'If the given date would be generated, generate a new one anyway',
            () => expect(wrapper.previous(expected), equals(expectedPrevious)),
          );
          test(
            'If the given date would not be generated, generate the next valid '
            'date',
            () => expect(wrapper.previous(date), equals(expectedPrevious)),
          );
        });
      });
      group('Count 1', () {
        final wrapper = EverySkipCountWrapper(every: every, count: 1);
        final date = DateTime(2022, DateTime.september, 27);
        final expected = DateTime(2022, DateTime.october, 3);
        group('startDate', () {
          test('If the given date would be generated, return it', () {
            expect(wrapper.startDate(expected), equals(expected));
          });
          test('If the given date would not be generated, use next', () {
            expect(wrapper.startDate(date), equals(wrapper.next(date)));
          });
        });
        group('next', () {
          test(
            'If the given date would be generated, generate a new one anyway',
            () => expect(
              wrapper.next(expected),
              equals(DateTime(2022, DateTime.october, 17)),
            ),
          );
          test(
            'If the given date would not be generated, generate the next valid '
            'date',
            () => expect(
              wrapper.next(date),
              equals(DateTime(2022, DateTime.october, 10)),
            ),
          );
        });
        group('previous', () {
          final expectedPrevious = DateTime(2022, DateTime.september, 19);

          test(
            'If the given date would be generated, generate a new one anyway',
            () {
              expect(
                wrapper.previous(DateTime(2022, DateTime.october, 3)),
                equals(expectedPrevious),
              );
            },
          );
          test(
            'If the given date would not be generated, generate the next valid '
            'date',
            () => expect(wrapper.previous(date), equals(expectedPrevious)),
          );
        });
      });
    });

    group('constructor ', () {
      test('when count is 0', () {
        expect(
          EverySkipCountWrapper(every: every, count: 0),
          isA<EverySkipCountWrapper>(),
        );
      });
      test('when count is negative', () {
        expect(
          () => EverySkipCountWrapper(every: every, count: -1),
          throwsA(isA<AssertionError>()),
        );
      });
      test('when count is positive', () {
        expect(
          EverySkipCountWrapper(every: every, count: 1),
          isA<EverySkipCountWrapper>(),
        );
      });
    });

    final wrapper = EverySkipCountWrapper(every: every, count: 1);

    group('startDate', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 11);

      test('when limit is null', () {
        final result = wrapper.startDate(date);

        expect(result, equals(expectedDate));
      });

      group('when limit is not null', () {
        test('and limit is after date', () {
          final result = wrapper.startDate(
            date,
            limit: DateTime(2023, 12, 12),
          );

          expect(result, equals(expectedDate));
        });

        test('and limit is before date', () {
          expect(
            () => wrapper.startDate(date, limit: DateTime(2023, 12)),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('and limit is the expected date', () {
          final result = wrapper.startDate(date, limit: expectedDate);

          expect(result, equals(expectedDate));
        });
      });
    });

    group('next', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 11);

      test('when limit is null', () {
        final result = wrapper.next(date);

        expect(result, equals(expectedDate));
      });

      group('when limit is not null', () {
        test('and limit is after date', () {
          final result = wrapper.next(date, limit: DateTime(2023, 12, 12));

          expect(result, equals(expectedDate));
        });

        test('and limit is before date', () {
          expect(
            () => wrapper.next(date, limit: DateTime(2023, 12)),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('and limit is the expected date', () {
          final result = wrapper.next(date, limit: expectedDate);

          expect(result, equals(expectedDate));
        });
      });
    });

    group('previous', () {
      final date = DateTime(2023, 12, 10);
      final expectedDate = DateTime(2023, 11, 27);

      test('when limit is null', () {
        final result = wrapper.previous(date);

        expect(result, equals(expectedDate));
      });
      test('when limit is not null', () {
        final result = wrapper.previous(date, limit: DateTime(2023, 11, 26));

        expect(result, equals(expectedDate));
      });

      test('when limit is before date', () {
        expect(
          () => wrapper.previous(date, limit: DateTime(2023, 11, 29)),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('and limit is the expected date', () {
        final result = wrapper.previous(date, limit: expectedDate);

        expect(result, equals(expectedDate));
      });
    });
  });
}
