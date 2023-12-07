import 'package:due_date/due_date.dart'
    show DateTimeLimitReachedException, DateValidatorWeekdayCountInMonth;
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('DateDirection', () {
    test('isStart should return true for start direction', () {
      const direction = DateDirection.start;
      expect(direction.isStart, isTrue);
    });

    test('isStart should return false for non-start directions', () {
      const nextDirection = DateDirection.next;
      const previousDirection = DateDirection.previous;
      expect(nextDirection.isStart, isFalse);
      expect(previousDirection.isStart, isFalse);
    });

    test('isNext should return true for next direction', () {
      const direction = DateDirection.next;
      expect(direction.isNext, isTrue);
    });

    test('isNext should return false for non-next directions', () {
      const startDirection = DateDirection.start;
      const previousDirection = DateDirection.previous;
      expect(startDirection.isNext, isFalse);
      expect(previousDirection.isNext, isFalse);
    });

    test('isPrevious should return true for previous direction', () {
      const direction = DateDirection.previous;
      expect(direction.isPrevious, isTrue);
    });

    test('isPrevious should return false for non-previous directions', () {
      const startDirection = DateDirection.start;
      const nextDirection = DateDirection.next;
      expect(startDirection.isPrevious, isFalse);
      expect(nextDirection.isPrevious, isFalse);
    });
  });

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

  group('EveryOverrideWrapper', () {
    final every = Weekday.monday.every;
    const invalidator = DateValidatorWeekdayCountInMonth(
      week: Week.first,
      day: Weekday.monday,
    );
    final wrapper = EveryOverrideWrapper(
      every: every,
      invalidator: invalidator,
      overrider: Weekday.tuesday.every,
    );

    group('Test base methods logic', () {
      final date = DateTime(2022, DateTime.september, 27);
      final expected = DateTime(2022, DateTime.october, 4);
      group('startDate', () {
        test('If the given date would be generated, return it', () {
          expect(
            wrapper.startDate(expected),
            equals(expected),
          );
        });
        test('If the given date would not be generated, use next', () {
          expect(
            wrapper.startDate(date),
            equals(wrapper.next(date)),
          );
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
          () => expect(
            wrapper.next(date),
            equals(expected),
          ),
        );
      });
      group('previous', () {
        final expectedPrevious = DateTime(2022, DateTime.september, 26);

        test(
          'If the given date would be generated, generate a new one anyway',
          () {
            expect(
              wrapper.previous(DateTime(2022, DateTime.october, 3)),
              equals(expectedPrevious),
            );
            expect(
              wrapper.previous(DateTime(2022, DateTime.october, 4)),
              equals(DateTime(2022, DateTime.september, 27)),
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

    group('startDate', () {
      final date = DateTime(2023, 12, 3);
      final expectedDate = DateTime(2023, 12, 5);

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
      final expectedDate = DateTime(2023, 12, 5);

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
      final expectedDate = DateTime(2023, 11, 28);

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
