import 'package:due_date/src/period_generators/day_generator.dart';
import 'package:due_date/src/periods/period.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('Period:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates Period with valid start and end', () {
          final start = DateTime(2022);
          final end = DateTime(2022, DateTime.january, 2);
          expect(Period(start: start, end: end), isNotNull);
        });

        test('Creates Period with equal start and end', () {
          final start = DateTime(2022);
          expect(Period(start: start, end: start), isNotNull);
        });

        test('Creates Period with UTC dates', () {
          final start = DateTime.utc(2022);
          final end = DateTime.utc(2022, DateTime.january, 2);
          expect(Period(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws ArgumentError if end is before start', () {
          final start = DateTime(2022);
          final end = DateTime(2022, DateTime.january, 2);
          expect(
            () => Period(start: end, end: start),
            throwsArgumentError,
          );
        });
      });
    });
    group('duration ->', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final period = Period(start: start, end: end);
      test('should be 1 day + 1 microsecond', () {
        expect(
          period.duration,
          equals(const Duration(days: 1, microseconds: 1)),
        );
      });
    });
    group('contains ->', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final period = Period(start: start, end: end);
      const microsecond = Duration(microseconds: 1);
      test('before start', () {
        expect(period.contains(start.subtract(microsecond)), isFalse);
      });
      test('start', () {
        expect(period.contains(start), isTrue);
      });
      test('start utc', () {
        expect(period.contains(start.toUtc()), isTrue);
      });
      test('middle', () {
        expect(period.contains(start.add(const Duration(hours: 12))), isTrue);
      });
      test('end', () {
        expect(period.contains(end), isTrue);
      });
      test('end utc', () {
        expect(period.contains(end.toUtc()), isTrue);
      });
      test('after end', () {
        expect(period.contains(end.add(microsecond)), isFalse);
      });
    });
    group('overlapsWith ->', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start2, end: end2);
      test('day 1, 12h', () {
        expect(period.overlapsWith(period2), isTrue);
      });
    });
    group('doesNotOverlapWith ->', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 2, 12);
      final end2 = DateTime(2022, DateTime.january, 3);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start2, end: end2);
      test('12h', () {
        expect(period.doesNotOverlapWith(period2), isTrue);
      });
    });
    group('getIntersection', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start2, end: end2);
      final period3 = Period(start: start2, end: end);
      test('day 1 (12h) - day 2', () {
        expect(period.getIntersection(period2), equals(period3));
      });
    });
    group('mergeWith', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start2, end: end2);
      final period3 = Period(start: start, end: end2);
      test('day 1 - day 3', () {
        expect(period.mergeWith(period2), equals(period3));
      });
    });
    group('differenceBetween', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start2, end: end2);
      final period3 = Period(start: start, end: start2);
      final period4 = Period(start: end, end: end2);
      test('[day 1 - day 1 (12h), day 2 - day 3]', () {
        expect(
          period.differenceBetween(period2),
          orderedEquals([period3, period4]),
        );
      });
    });
    group('sort', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);
      final start3 = DateTime(2022, DateTime.january, 3, 12);
      final end3 = DateTime(2022, DateTime.january, 4);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start2, end: end2);
      final period3 = Period(start: start3, end: end3);
      test('[day 1 - day 2, day 1 (12h) - day 3, day 3 (12h) - day 4]', () {
        final result = [period, period2, period3];
        expect([period3, period, period2]..sort(), orderedEquals(result));
        expect([period3, period2, period]..sort(), orderedEquals(result));
        expect([period2, period3, period]..sort(), orderedEquals(result));
        expect([period2, period, period3]..sort(), orderedEquals(result));
        expect([period, period3, period2]..sort(), orderedEquals(result));
        expect([period, period2, period3]..sort(), orderedEquals(result));
      });
    });
    group('mergeOverlappingPeriods', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);
      final start3 = DateTime(2022, DateTime.january, 3, 12);
      final end3 = DateTime(2022, DateTime.january, 4);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start2, end: end2);
      final period3 = Period(start: start3, end: end3);
      final period4 = Period(start: start, end: end2);
      test('[day 1 - day 3, day 3 (12h) - day 4]', () {
        expect(
          Period.mergeOverlappingPeriods([period, period2, period3]),
          orderedEquals([period4, period3]),
        );
      });
    });
    group('intersections', () {
      test('[day 1 (12h) - day 2, day 3 (12h) - day 4]', () {
        final start = DateTime(2022);
        final end = DateTime(2022, DateTime.january, 2);
        final start2 = DateTime(2022, DateTime.january, 1, 12);
        final end2 = DateTime(2022, DateTime.january, 3);
        final start3 = DateTime(2022, DateTime.january, 3, 12);
        final end3 = DateTime(2022, DateTime.january, 4);
        final period = Period(start: start, end: end);
        final period2 = Period(start: start2, end: end2);
        final period3 = Period(start: start3, end: end3);
        final period4 = Period(start: start2, end: end);
        expect(
          Period.intersections([period, period2, period3]),
          orderedEquals([period4, period3]),
        );
      });
      test(
          // ignore: missing_whitespace_between_adjacent_strings, it is a list
          '[Period(start: DateTime(2023, 03, 16), end: DateTime(2023, 03, 17)),'
          'Period(start: DateTime(2023, 03, 18), end: DateTime(2023, 03, 19))]',
          () {
        final list = [
          Period(start: DateTime(2023, 03, 15), end: DateTime(2023, 03, 17)),
          Period(start: DateTime(2023, 03, 16), end: DateTime(2023, 03, 19)),
          Period(start: DateTime(2023, 03, 18), end: DateTime(2023, 03, 20)),
        ];
        final expected = [
          Period(start: DateTime(2023, 03, 16), end: DateTime(2023, 03, 17)),
          Period(start: DateTime(2023, 03, 18), end: DateTime(2023, 03, 19)),
        ];
        expect(Period.intersections(list), orderedEquals(expected));
      });
      test(
          // ignore: missing_whitespace_between_adjacent_strings, it is a list
          '[Period(start: DateTime(2023, 03, 16), end: DateTime(2023, 03, 17)),'
          'Period('
          '  start: DateTime(2023, 03, 18, 12), '
          '  end: DateTime(2023, 03, 18, 13), '
          ')]', () {
        final list = [
          Period(start: DateTime(2023, 03, 15), end: DateTime(2023, 03, 17)),
          Period(start: DateTime(2023, 03, 16), end: DateTime(2023, 03, 19)),
          Period(
            start: DateTime(2023, 03, 18, 12),
            end: DateTime(2023, 03, 18, 13),
          ),
          Period(start: DateTime(2023, 03, 18), end: DateTime(2023, 03, 20)),
        ];
        final expected = [
          Period(start: DateTime(2023, 03, 16), end: DateTime(2023, 03, 17)),
          Period(
            start: DateTime(2023, 03, 18, 12),
            end: DateTime(2023, 03, 18, 13),
          ),
        ];
        expect(Period.intersections(list), orderedEquals(expected));
      });
    });
    group('Sort (compareTo)', () {
      test(
          '['
          'Period(2023-03-15 00:00:00.000, 2023-03-17 00:00:00.000), '
          'Period(2023-03-16 00:00:00.000, 2023-03-19 00:00:00.000), '
          'Period(2023-03-18 00:00:00.000, 2023-03-20 00:00:00.000) '
          ']', () {
        final period1 = Period(
          start: DateTime(2023, 4),
          end: DateTime(2023, 4, 15),
        );
        final period2 = Period(
          start: DateTime(2023, 4),
          end: DateTime(2023, 4, 30),
        );
        final period3 = Period(
          start: DateTime(2023, 4, 15),
          end: DateTime(2023, 4, 30),
        );

        final unsortedPeriods = [period3, period2, period1];
        final sortedPeriods = [period1, period2, period3];

        unsortedPeriods.sort();

        expect(unsortedPeriods, orderedEquals(sortedPeriods));
      });
      test(
          '[Period(2023-03-15 00:00:00.000, 2023-03-17 00:00:00.000), '
          'Period(2023-03-16 00:00:00.000, 2023-03-19 00:00:00.000), '
          'Period(2023-03-18 00:00:00.000, 2023-03-20 00:00:00.000), '
          'Period(2023-03-18 12:00:00.000, 2023-03-18 13:00:00.000)]', () {
        final period1 = Period(
          start: DateTime(2023, 03, 15),
          end: DateTime(2023, 03, 17),
        );
        final period2 = Period(
          start: DateTime(2023, 03, 16),
          end: DateTime(2023, 03, 19),
        );
        final period3 = Period(
          start: DateTime(2023, 03, 18),
          end: DateTime(2023, 03, 20),
        );
        final period4 = Period(
          start: DateTime(2023, 03, 18, 12),
          end: DateTime(2023, 03, 18, 13),
        );
        final expected = [
          period1,
          period2,
          period3,
          period4,
        ];
        final list = [
          period2,
          period4,
          period1,
          period3,
        ]..sort();
        expect(list, orderedEquals(expected));
      });
    });
    group('subtract', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);
      final start3 = DateTime(2022, DateTime.january, 3, 12);
      final end3 = DateTime(2022, DateTime.january, 4);
      final lastDay2021 = DateTime(2021, DateTime.december, 31);
      final end4 = DateTime(2022, DateTime.january, 31);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start2, end: end2);
      final period3 = Period(start: start3, end: end3);
      final period4 = Period(start: lastDay2021, end: start);
      final period5 = Period(start: end2, end: start3);
      final period6 = Period(start: end3, end: end4);
      final base = Period(start: lastDay2021, end: end4);
      test('[dec 31 - day 1, day 1 (12h) - day 3, day 4, day 31]', () {
        expect(
          base.subtract([period, period2, period3]),
          orderedEquals([period4, period5, period6]),
        );
      });
    });
    group('splitAt', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final split = DateTime(2022, DateTime.january, 1, 12);
      final base = Period(start: start, end: end);
      test('[day 1 - day 1 (12h), day 1 (12h) - day  2]', () {
        expect(
          base.splitAt({split}),
          orderedEquals([
            Period(start: start, end: split),
            Period(start: split, end: end),
          ]),
        );
      });
      test('[day 1 - day 1 (12h), day 1 (12h, 1seg) - day  2]', () {
        const second = Duration(seconds: 1);
        expect(
          base.splitAt({split}, periodBetween: const Duration(seconds: 1)),
          orderedEquals([
            Period(start: start, end: split),
            Period(start: split.add(second), end: end),
          ]),
        );
      });
      test('with empty dates set returns original period', () {
        expect(
          base.splitAt(<DateTime>{}),
          orderedEquals([base]),
        );
      });

      test('with dates outside period ignores them', () {
        // Dates before and after the period should be ignored.
        final beforePeriod = DateTime(2021, 12, 31);
        final afterPeriod = DateTime(2022, 1, 3);

        expect(
          base.splitAt({beforePeriod, split, afterPeriod}),
          orderedEquals([
            Period(start: start, end: split),
            Period(start: split, end: end),
          ]),
        );
      });

      test('with multiple dates splits correctly', () {
        // January 1 00:00 to January 3 00:00, split at Jan 1 12:00 and Jan 2
        // 12:00.
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 3),
        );
        final split1 = DateTime(2022, 1, 1, 12);
        final split2 = DateTime(2022, 1, 2, 12);

        expect(
          period.splitAt({split2, split1}), // Test that dates are sorted.
          orderedEquals([
            Period(start: DateTime(2022), end: split1),
            Period(start: split1, end: split2),
            Period(start: split2, end: DateTime(2022, 1, 3)),
          ]),
        );
      });

      test('with periodBetween creates gaps between periods', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 5),
        );
        final split1 = DateTime(2022, 1, 2);
        final split2 = DateTime(2022, 1, 3);
        const gap = Duration(hours: 6);

        expect(
          period.splitAt({split1, split2}, periodBetween: gap),
          orderedEquals([
            Period(start: DateTime(2022), end: split1),
            Period(start: split1.add(gap), end: split2),
            Period(start: split2.add(gap), end: DateTime(2022, 1, 5)),
          ]),
        );
      });

      test('handles single date at period boundary', () {
        // Split exactly at the start.
        expect(
          base.splitAt({start}),
          orderedEquals([
            Period(start: start, end: end),
          ]),
        );

        // Split exactly at the end.
        expect(
          base.splitAt({end}),
          orderedEquals([
            Period(start: start, end: end),
          ]),
        );
      });

      group('validation errors', () {
        test('throws ArgumentError when periodBetween is negative', () {
          expect(
            () => base.splitAt(
              {split},
              periodBetween: const Duration(seconds: -1),
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains(
                  'The period between dates must be greater than or equals '
                  'to zero',
                ),
              ),
            ),
          );
        });

        test('throws ArgumentError when periodBetween equals period duration',
            () {
          // Period duration is 1 day + 1 microsecond.
          final periodDuration = base.duration;

          expect(
            () => base.splitAt({split}, periodBetween: periodDuration),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains(
                  'The period between dates must be greater than or equals '
                  'to zero',
                ),
              ),
            ),
          );
        });

        test('throws ArgumentError when periodBetween exceeds period duration',
            () {
          const longDuration = Duration(days: 2);

          expect(
            () => base.splitAt({split}, periodBetween: longDuration),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains(
                  'The period between dates must be greater than or equals '
                  'to zero',
                ),
              ),
            ),
          );
        });

        test(
            'throws ArgumentError when sum of periodBetween exceeds period '
            'duration', () {
          // Period from Jan 1 to Jan 2 (1 day + 1 microsecond)
          // Two valid dates means periodBetween will be multiplied by 2
          // If periodBetween is 13 hours, total gap = 26 hours > 24 hours.
          final period = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 2),
          );
          final split1 = DateTime(2022, 1, 1, 6);
          final split2 = DateTime(2022, 1, 1, 18);
          const periodBetween = Duration(hours: 13);

          expect(
            () => period.splitAt(
              {split1, split2},
              periodBetween: periodBetween,
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains(
                  'The sum of the period between dates is greater than the '
                  'duration of the period',
                ),
              ),
            ),
          );
        });

        test(
            'throws ArgumentError when period between dates is less than '
            'periodBetween', () {
          // Create a period from Jan 1 to Jan 5.
          final period = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 5),
          );

          // Split dates that are only 12 hours apart.
          final split1 = DateTime(2022, 1, 2);
          final split2 = DateTime(2022, 1, 2, 12);

          // But require at least 24 hours between periods.
          const periodBetween = Duration(hours: 24);

          expect(
            () => period.splitAt(
              {split1, split2},
              periodBetween: periodBetween,
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains(
                  'The period between the provided dates must be greater than '
                  'or equal to',
                ),
              ),
            ),
          );
        });

        test('handles edge case with many small gaps', () {
          // Create a scenario where many small gaps add up to exceed duration.
          final period = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 1, 2), // 2 hours
          );

          // 10 dates means 10 gaps of 30 minutes each = 5 hours > 2 hours.
          final dates = List.generate(
            10,
            (i) =>
                // Every 6 minutes.
                DateTime(2022, 1, 1, 0, i * 6),
          ).toSet();

          const periodBetween = Duration(minutes: 30);

          expect(
            () => period.splitAt(dates, periodBetween: periodBetween),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains(
                  'The sum of the period between dates is greater than the '
                  'duration of the period',
                ),
              ),
            ),
          );
        });
      });
    });
    group('splitIn', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final split = DateTime(2022, DateTime.january, 1, 12);
      final base = Period(start: start, end: end);
      test('[day 1 - day 1 (12h), day 1 (12h) - day  2]', () {
        expect(
          base.splitIn(2),
          orderedEquals([
            Period(start: start, end: split),
            Period(start: split, end: end),
          ]),
        );
      });
      test('[day 1 - day 1 (11h, 59, 59, 500), day 1 (12h, 500ms) - day  2]',
          () {
        const halfSecond = Duration(milliseconds: 500);
        expect(
          base.splitIn(2, periodBetween: const Duration(seconds: 1)),
          orderedEquals([
            Period(start: start, end: split.subtract(halfSecond)),
            Period(start: split.add(halfSecond), end: end),
          ]),
        );
      });
      test('[day 1 - day 1 (12h), day 1 (12h, 1us) - day  2]', () {
        expect(
          base.splitIn(2, periodBetween: const Duration(microseconds: 1)),
          orderedEquals([
            Period(start: start, end: split),
            Period(start: split.add(const Duration(microseconds: 1)), end: end),
          ]),
        );
      });
      test(
          '[day 1 - day 1 (11h 59 59 999 999), '
          'day 1 (12h 2us) - day  2]', () {
        expect(
          base.splitIn(2, periodBetween: const Duration(microseconds: 3)),
          orderedEquals([
            Period(
              start: start,
              end: split.subtract(const Duration(microseconds: 1)),
            ),
            Period(start: split.add(const Duration(microseconds: 2)), end: end),
          ]),
        );
      });
      test(
          '[day 1 - day 1 (11h 59 59 999 998), '
          'day 1 (12h 2us) - day  2]', () {
        expect(
          base.splitIn(2, periodBetween: const Duration(microseconds: 4)),
          orderedEquals([
            Period(
              start: start,
              end: split.subtract(const Duration(microseconds: 2)),
            ),
            Period(start: split.add(const Duration(microseconds: 2)), end: end),
          ]),
        );
      });
      test(
          '[Period:Period(2020-01-01 00:00:00.000, 2020-01-10 08:00:00.000), '
          'Period:Period(2020-01-11 08:00:00.000, 2020-01-20 16:00:00.000), '
          'Period:Period(2020-01-21 16:00:00.000, 2020-01-31 00:00:00.000)]',
          () {
        final current = Period(
          start: DateTime(2020),
          end: DateTime(2020, 1, 31),
        );
        final expected = [
          Period(
            start: DateTime(2020),
            end: DateTime(2020, 1, 10, 8),
          ),
          Period(
            start: DateTime(2020, 1, 11, 8),
            end: DateTime(2020, 1, 20, 16),
          ),
          Period(
            start: DateTime(2020, 1, 21, 16),
            end: DateTime(2020, 1, 31),
          ),
        ];
        expect(
          current.splitIn(3, periodBetween: const Duration(days: 1)),
          orderedEquals(expected),
        );
        for (var i = 1; i < (expected.length - 1); i++) {
          expect(
            expected[i].duration,
            equals(expected[i - 1].duration),
          );
        }
      });

      group('Invalid arguments', () {
        final current = Period(
          start: DateTime(2022),
          end: DateTime(2022, DateTime.january, 2),
        );

        test('throws ArgumentError when times is zero', () {
          expect(
            () => current.splitIn(0),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Times must be greater than zero.',
              ),
            ),
          );
        });

        test('throws ArgumentError when times is negative', () {
          expect(
            () => current.splitIn(-1),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Times must be greater than zero.',
              ),
            ),
          );
        });

        test('throws ArgumentError when periodBetween is negative', () {
          expect(
            () => current.splitIn(
              2,
              periodBetween: const Duration(seconds: -1),
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Period between must be greater than or equals to zero and '
                    'less than the duration of the period.',
              ),
            ),
          );
        });

        test('throws ArgumentError when periodBetween equals period duration',
            () {
          // Period duration is 1 day + 1 microsecond.
          final periodDuration = current.duration;
          expect(
            () => current.splitIn(2, periodBetween: periodDuration),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Period between must be greater than or equals to zero and '
                    'less than the duration of the period.',
              ),
            ),
          );
        });

        test(
            'throws ArgumentError when periodBetween is greater than period '
            'duration', () {
          // Period duration is 1 day + 1 microsecond, so 2 days is greater.
          expect(
            () => current.splitIn(2, periodBetween: const Duration(days: 2)),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Period between must be greater than or equals to zero and '
                    'less than the duration of the period.',
              ),
            ),
          );
        });

        test(
            'throws ArgumentError when sum of periodBetween exceeds period '
            'duration', () {
          // Base period is 1 day + 1 microsecond
          // If we split into 3 parts with 12 hours between each, that's 24
          // hours total which exceeds the period duration.
          expect(
            () => current.splitIn(3, periodBetween: const Duration(hours: 12)),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'The sum of the period between dates is greater than the '
                    'duration of the period.',
              ),
            ),
          );
        });

        test(
            'throws ArgumentError when sum of periodBetween exactly equals '
            'period duration', () {
          // Base period is 1 day + 1 microsecond
          // If we split into 2 parts with 1 day + 1 microsecond between, that
          // equals the period duration.
          final periodDuration = current.duration;
          expect(
            () => current.splitIn(2, periodBetween: periodDuration),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Period between must be greater than or equals to zero and '
                    'less than the duration of the period.',
              ),
            ),
          );
        });

        test(
            'throws ArgumentError with edge case: very small period with large '
            'times', () {
          // Create a very small period (1 microsecond).
          final smallStart = DateTime(2022);
          final smallEnd = smallStart;
          final smallPeriod = Period(start: smallStart, end: smallEnd);

          expect(
            () => smallPeriod.splitIn(
              2,
              periodBetween: const Duration(microseconds: 1),
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Period between must be greater than or equals to zero and '
                    'less than the duration of the period.',
              ),
            ),
          );
        });

        test(
            'throws ArgumentError when sum of periodBetween exceeds duration '
            'but individual periodBetween is valid', () {
          // Create a period of 10 seconds.
          final startDate = DateTime(2022);
          final testPeriod = Period(
            start: startDate,
            end: startDate.add(const Duration(seconds: 10)),
          );

          // Individual periodBetween (3 seconds) is less than period duration
          // (10 seconds + 1 microsecond)
          // But sum: 3 seconds * 5 times = 15 seconds > 10 seconds + 1
          // microsecond.
          expect(
            () => testPeriod.splitIn(
              5,
              periodBetween: const Duration(seconds: 3),
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'The sum of the period between dates is greater than the '
                    'duration of the period.',
              ),
            ),
          );
        });
      });
    });
    test('isNotEmpty', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final period = Period(start: start, end: end);
      expect(period.isNotEmpty, isTrue);
      expect(period.isEmpty, isFalse);
    });
    test('isEmpty', () {
      final start = DateTime(2022);
      final period = Period(start: start, end: start);
      expect(period.isEmpty, isTrue);
      expect(period.isNotEmpty, isFalse);
    });
    test('equals', () {
      const dayGenerator = DayGenerator();
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      final period2 = Period(start: start, end: end);
      final period3 = dayGenerator.of(start);
      expect(period == period2, isTrue);
      expect(period2 == period, isTrue);
      expect(period == period3, isTrue);
      expect(period3 == period, isTrue);
      expect(period2 == period3, isTrue);
    });
    test('shift', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      final period2 = period.shift(const Duration(days: 1));
      expect(period2.start, start.add(const Duration(days: 1)));
      expect(period2.end, end.add(const Duration(days: 1)));
      final period3 = period.shift(const Duration(days: -1));
      expect(period3.start, start.subtract(const Duration(days: 1)));
      expect(period3.end, end.subtract(const Duration(days: 1)));
    });
    test('>> operator (shift forward)', () {
      // January 1, 2022 is Saturday.
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);

      final shiftedPeriod = period >> const Duration(days: 1);
      expect(shiftedPeriod.start, start.add(const Duration(days: 1)));
      expect(shiftedPeriod.end, end.add(const Duration(days: 1)));

      // Test with hours.
      final shiftedByHours = period >> const Duration(hours: 5);
      expect(shiftedByHours.start, start.add(const Duration(hours: 5)));
      expect(shiftedByHours.end, end.add(const Duration(hours: 5)));
    });

    test('<< operator (shift backward)', () {
      // January 1, 2022 is Saturday.
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);

      final shiftedPeriod = period << const Duration(days: 1);
      expect(shiftedPeriod.start, start.subtract(const Duration(days: 1)));
      expect(shiftedPeriod.end, end.subtract(const Duration(days: 1)));

      // Test with hours.
      final shiftedByHours = period << const Duration(hours: 3);
      expect(shiftedByHours.start, start.subtract(const Duration(hours: 3)));
      expect(shiftedByHours.end, end.subtract(const Duration(hours: 3)));
    });

    group('containsFully', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same', () {
        final period2 = Period(start: start, end: end);
        expect(period.containsFully(period2), isTrue);
      });
      test('smaller', () {
        final period2 = Period(start: start, end: start);
        expect(period.containsFully(period2), isTrue);
      });
      group('bigger', () {
        test('end', () {
          final period2 = Period(
            start: start,
            end: end.add(const Duration(days: 1)),
          );
          expect(period.containsFully(period2), isFalse);
        });
        test('start', () {
          final period2 = Period(
            start: start.subtract(const Duration(days: 1)),
            end: end,
          );
          expect(period.containsFully(period2), isFalse);
        });
        test('both', () {
          final period2 = Period(
            start: start.subtract(const Duration(days: 1)),
            end: end.add(const Duration(days: 1)),
          );
          expect(period.containsFully(period2), isFalse);
        });
      });
      test('shifted', () {
        final period2 = Period(start: start, end: end).shift(
          const Duration(hours: 12),
        );
        expect(period.containsFully(period2), isFalse);
      });
      test('Non overlapping', () {
        final period2 = Period(
          start: end.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period.containsFully(period2), isFalse);
      });
    });
    group('containedFullyBy', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same', () {
        final period2 = Period(start: start, end: end);
        expect(period2.containedFullyBy(period), isTrue);
      });
      test('smaller', () {
        final period2 = Period(start: start, end: start);
        expect(period2.containedFullyBy(period), isTrue);
      });
      group('bigger', () {
        test('end', () {
          final period2 = Period(
            start: start,
            end: end.add(const Duration(days: 1)),
          );
          expect(period2.containedFullyBy(period), isFalse);
        });
        test('start', () {
          final period2 = Period(
            start: start.subtract(const Duration(days: 1)),
            end: end,
          );
          expect(period2.containedFullyBy(period), isFalse);
        });
        test('both', () {
          final period2 = Period(
            start: start.subtract(const Duration(days: 1)),
            end: end.add(const Duration(days: 1)),
          );
          expect(period2.containedFullyBy(period), isFalse);
        });
      });
      test('shifted', () {
        final period2 = Period(start: start, end: end).shift(
          const Duration(hours: 12),
        );
        expect(period2.containedFullyBy(period), isFalse);
      });
      test('Non overlapping', () {
        final period2 = Period(
          start: end.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period2.containedFullyBy(period), isFalse);
      });
    });
    group('containsPartially', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same', () {
        final period2 = Period(start: start, end: end);
        expect(period.containsPartially(period2), isFalse);
      });
      test('smaller', () {
        final period2 = Period(start: start, end: start);
        expect(period.containsPartially(period2), isFalse);
      });
      group('bigger', () {
        test('end', () {
          final period2 = Period(
            start: start,
            end: end.add(const Duration(days: 1)),
          );
          expect(period.containsPartially(period2), isTrue);
        });
        test('start', () {
          final period2 = Period(
            start: start.subtract(const Duration(days: 1)),
            end: end,
          );
          expect(period.containsPartially(period2), isTrue);
        });
        test('both', () {
          final period2 = Period(
            start: start.subtract(const Duration(days: 1)),
            end: end.add(const Duration(days: 1)),
          );
          expect(period.containsPartially(period2), isTrue);
        });
      });
      test('shifted', () {
        final period2 = Period(start: start, end: end).shift(
          const Duration(hours: 12),
        );
        expect(period.containsPartially(period2), isTrue);
      });
      test('Non overlapping', () {
        final period2 = Period(
          start: end.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period.containsPartially(period2), isFalse);
      });
    });
    group('containedPartiallyBy', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same', () {
        final period2 = Period(start: start, end: end);
        expect(period2.containedPartiallyBy(period), isFalse);
      });
      test('smaller', () {
        final period2 = Period(start: start, end: start);
        expect(period2.containedPartiallyBy(period), isFalse);
      });
      group('bigger', () {
        test('end', () {
          final period2 = Period(
            start: start,
            end: end.add(const Duration(days: 1)),
          );
          expect(period2.containedPartiallyBy(period), isTrue);
        });
        test('start', () {
          final period2 = Period(
            start: start.subtract(const Duration(days: 1)),
            end: end,
          );
          expect(period2.containedPartiallyBy(period), isTrue);
        });
        test('both', () {
          final period2 = Period(
            start: start.subtract(const Duration(days: 1)),
            end: end.add(const Duration(days: 1)),
          );
          expect(period2.containedPartiallyBy(period), isTrue);
        });
      });
      test('shifted', () {
        final period2 = Period(start: start, end: end).shift(
          const Duration(hours: 12),
        );
        expect(period2.containedPartiallyBy(period), isTrue);
      });
      test('Non overlapping', () {
        final period2 = Period(
          start: end.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period2.containedPartiallyBy(period), isFalse);
      });
    });
    group('occursBefore', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same', () {
        expect(period.occursBefore(period), isFalse);
      });
      test('overlapping', () {
        final period2 = Period(
          start: start,
          end: start.add(const Duration(days: 1)),
        );
        expect(period.occursBefore(period2), isFalse);
      });
      test('before', () {
        final period2 = Period(
          start: start.subtract(const Duration(days: 2)),
          end: start.subtract(const Duration(days: 2)),
        );
        expect(period.occursBefore(period2), isFalse);
      });
      test('after', () {
        final period2 = Period(
          start: end.add(const Duration(days: 2)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period.occursBefore(period2), isTrue);
      });
    });
    group('occursAfter', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same', () {
        expect(period.occursAfter(period), isFalse);
      });
      test('overlapping', () {
        final period2 = Period(
          start: start,
          end: start.add(const Duration(days: 1)),
        );
        expect(period.occursAfter(period2), isFalse);
      });
      test('before', () {
        final period2 = Period(
          start: start.subtract(const Duration(days: 2)),
          end: start.subtract(const Duration(days: 2)),
        );
        expect(period.occursAfter(period2), isTrue);
      });
      test('after', () {
        final period2 = Period(
          start: end.add(const Duration(days: 2)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period.occursAfter(period2), isFalse);
      });
    });
    group('copyWith', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('start', () {
        final period2 = period.copyWith(
          start: start.subtract(const Duration(days: 1)),
        );
        expect(period2.start, equals(start.subtract(const Duration(days: 1))));
        expect(period2.end, isSameDateTime(end));
      });
      test('end', () {
        final period2 = period.copyWith(end: end.add(const Duration(days: 1)));
        expect(period2.start, isSameDateTime(start));
        expect(period2.end, equals(end.add(const Duration(days: 1))));
      });
      test('both', () {
        final period2 = period.copyWith(
          start: start.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 1)),
        );
        final result = Period(
          start: start.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 1)),
        );
        expect(period2, equals(result));
      });
      test('ArgumentError', () {
        expect(
          () => period.copyWith(start: end.add(const Duration(days: 1))),
          throwsArgumentError,
        );
      });
    });
    group('endsBefore', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same as end', () {
        expect(period.endsBefore(end), isFalse);
      });
      test('before end', () {
        expect(
          period.endsBefore(end.subtract(const Duration(days: 1))),
          isFalse,
        );
      });
      test('after end', () {
        expect(period.endsBefore(end.add(const Duration(days: 1))), isTrue);
      });
    });
    group('endsAfter', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same as end', () {
        expect(period.endsAfter(end), isFalse);
      });
      test('before end', () {
        expect(period.endsAfter(end.subtract(const Duration(days: 1))), isTrue);
      });
      test('after end', () {
        expect(period.endsAfter(end.add(const Duration(days: 1))), isFalse);
      });
    });
    group('startsAfter', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same as start', () {
        expect(period.startsAfter(start), isFalse);
      });
      test('before start', () {
        expect(
          period.startsAfter(start.subtract(const Duration(days: 1))),
          isTrue,
        );
      });
      test('after start', () {
        expect(period.startsAfter(start.add(const Duration(days: 1))), isFalse);
      });
    });
    group('startsBefore', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      test('same as start', () {
        expect(period.startsBefore(start), isFalse);
      });
      test('before start', () {
        expect(
          period.startsBefore(start.subtract(const Duration(days: 1))),
          isFalse,
        );
      });
      test('after start', () {
        expect(period.startsBefore(start.add(const Duration(days: 1))), isTrue);
      });
    });
    group('getNext', () {
      const dayGenerator = DayGenerator();
      final first = DateTime(2022);
      final period = dayGenerator.of(first);
      final second = DateTime(2022, DateTime.january, 2);
      final period2 = dayGenerator.of(second);
      test('next', () {
        expect(period.getNext(dayGenerator), equals(period2));
      });
    });
    group('getPrevious', () {
      const dayGenerator = DayGenerator();
      final first = DateTime(2022);
      final period = dayGenerator.of(first);
      final second = DateTime(2022, DateTime.january, 2);
      final period2 = dayGenerator.of(second);
      test('previous', () {
        expect(period2.getPrevious(dayGenerator), equals(period));
      });
    });
    group('inBetween', () {
      test('returns null when periods overlap', () {
        // January 1-3 and January 2-4 overlap.
        final first = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 3),
        );
        final second = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 4),
        );

        expect(Period.inBetween(first, second), isNull);
        expect(Period.inBetween(second, first), isNull);
      });

      test('returns period between when first occurs before second', () {
        // January 1-2 and January 4-5, gap is January 2-4.
        final first = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final second = Period(
          start: DateTime(2022, 1, 4),
          end: DateTime(2022, 1, 5),
        );
        final expected = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 4),
        );

        expect(Period.inBetween(first, second), equals(expected));
      });

      test('returns period between when first occurs after second', () {
        // January 4-5 and January 1-2, gap is January 2-4.
        final first = Period(
          start: DateTime(2022, 1, 4),
          end: DateTime(2022, 1, 5),
        );
        final second = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final expected = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 4),
        );
        expect(Period.inBetween(first, second), equals(expected));
      });

      test('returns zero-duration period when periods have minimal gap', () {
        // January 1-2 and January 3-4, gap is January 2-3.
        final first = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final second = Period(
          start: DateTime(2022, 1, 3),
          end: DateTime(2022, 1, 4),
        );
        final expected = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 3),
        );

        expect(Period.inBetween(first, second), equals(expected));
        expect(Period.inBetween(second, first), equals(expected));
      });

      test('returns null when periods are adjacent (touching)', () {
        // January 1-2 and January 2-3 touch at January 2, so they overlap.
        final first = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final second = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 3),
        );

        expect(Period.inBetween(first, second), isNull);
        expect(Period.inBetween(second, first), isNull);
      });

      test('handles UTC dates correctly', () {
        // January 1-2 and January 4-5 in UTC, gap is January 2-4.
        final first = Period(
          start: DateTime.utc(2022),
          end: DateTime.utc(2022, 1, 2),
        );
        final second = Period(
          start: DateTime.utc(2022, 1, 4),
          end: DateTime.utc(2022, 1, 5),
        );
        final expected = Period(
          start: DateTime.utc(2022, 1, 2),
          end: DateTime.utc(2022, 1, 4),
        );

        expect(Period.inBetween(first, second), equals(expected));
      });
    });
    group('calculateStartDifference', () {
      group('when periods overlap', () {
        test(
            'returns period from first start to second start when first starts '
            'before second', () {
          // January 1-4 and January 3-6 overlap, first starts before second.
          final first = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 4),
          );
          final second = Period(
            start: DateTime(2022, 1, 3),
            end: DateTime(2022, 1, 6),
          );
          final expected = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 3),
          );

          expect(
            Period.calculateStartDifference(first, second),
            equals(expected),
          );
        });

        test(
            'returns period from second start to first start when first starts '
            'after second', () {
          // January 3-6 and January 1-4 overlap, first starts after second.
          final first = Period(
            start: DateTime(2022, 1, 3),
            end: DateTime(2022, 1, 6),
          );
          final second = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 4),
          );
          final expected = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 3),
          );

          expect(
            Period.calculateStartDifference(first, second),
            equals(expected),
          );
        });

        test('returns null when both periods start at the same time', () {
          // January 1-3 and January 1-4 both start on January 1.
          final first = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 3),
          );
          final second = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 4),
          );

          expect(Period.calculateStartDifference(first, second), isNull);
        });
      });

      group('when periods do not overlap', () {
        test('returns first period when first occurs before second', () {
          // January 1-2 and January 4-5 do not overlap, first occurs before.
          final first = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 2),
          );
          final second = Period(
            start: DateTime(2022, 1, 4),
            end: DateTime(2022, 1, 5),
          );

          expect(Period.calculateStartDifference(first, second), equals(first));
        });

        test('returns second period when first occurs after second', () {
          // January 4-5 and January 1-2 do not overlap, first occurs after
          // second.
          final first = Period(
            start: DateTime(2022, 1, 4),
            end: DateTime(2022, 1, 5),
          );
          final second = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 2),
          );

          expect(
            Period.calculateStartDifference(first, second),
            equals(second),
          );
        });
      });

      test('handles UTC dates correctly', () {
        // January 1-4 UTC and January 3-6 UTC overlap.
        final first = Period(
          start: DateTime.utc(2022),
          end: DateTime.utc(2022, 1, 4),
        );
        final second = Period(
          start: DateTime.utc(2022, 1, 3),
          end: DateTime.utc(2022, 1, 6),
        );
        final expected = Period(
          start: DateTime.utc(2022),
          end: DateTime.utc(2022, 1, 3),
        );

        expect(
          Period.calculateStartDifference(first, second),
          equals(expected),
        );
      });
    });

    group('calculateEndDifference', () {
      group('when periods overlap', () {
        test(
            'returns period from second end to first end when first ends after '
            'second', () {
          // January 1-6 and January 3-4 overlap, first ends after second.
          final first = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 6),
          );
          final second = Period(
            start: DateTime(2022, 1, 3),
            end: DateTime(2022, 1, 4),
          );
          final expected = Period(
            start: DateTime(2022, 1, 4),
            end: DateTime(2022, 1, 6),
          );

          expect(
            Period.calculateEndDifference(first, second),
            equals(expected),
          );
        });

        test(
            'returns period from first end to second end when first ends '
            'before second', () {
          // January 3-4 and January 1-6 overlap, first ends before second.
          final first = Period(
            start: DateTime(2022, 1, 3),
            end: DateTime(2022, 1, 4),
          );
          final second = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 6),
          );
          final expected = Period(
            start: DateTime(2022, 1, 4),
            end: DateTime(2022, 1, 6),
          );

          expect(
            Period.calculateEndDifference(first, second),
            equals(expected),
          );
        });

        test('returns null when both periods end at the same time', () {
          // January 1-4 and January 2-4 both end on January 4.
          final first = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 4),
          );
          final second = Period(
            start: DateTime(2022, 1, 2),
            end: DateTime(2022, 1, 4),
          );

          expect(Period.calculateEndDifference(first, second), isNull);
        });
      });

      group('when periods do not overlap', () {
        test('returns first period when first occurs after second', () {
          // January 4-5 and January 1-2 do not overlap, first occurs after.
          final first = Period(
            start: DateTime(2022, 1, 4),
            end: DateTime(2022, 1, 5),
          );
          final second = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 2),
          );

          expect(Period.calculateEndDifference(first, second), equals(first));
        });

        test('returns second period when first occurs before second', () {
          // January 1-2 and January 4-5 do not overlap, first occurs before
          // second.
          final first = Period(
            start: DateTime(2022),
            end: DateTime(2022, 1, 2),
          );
          final second = Period(
            start: DateTime(2022, 1, 4),
            end: DateTime(2022, 1, 5),
          );

          expect(Period.calculateEndDifference(first, second), equals(second));
        });
      });

      test('handles UTC dates correctly', () {
        // January 1-6 UTC and January 3-4 UTC overlap.
        final first = Period(
          start: DateTime.utc(2022),
          end: DateTime.utc(2022, 1, 6),
        );
        final second = Period(
          start: DateTime.utc(2022, 1, 3),
          end: DateTime.utc(2022, 1, 4),
        );
        final expected = Period(
          start: DateTime.utc(2022, 1, 4),
          end: DateTime.utc(2022, 1, 6),
        );

        expect(Period.calculateEndDifference(first, second), equals(expected));
      });
    });
    group('operator &', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);

      test('returns intersection when periods overlap', () {
        final period = Period(start: start, end: end);
        final period2 = Period(start: start2, end: end2);
        final period3 = Period(start: start2, end: end);
        // Period 1: Jan 1 00:00 - Jan 2 00:00
        // Period 2: Jan 1 12:00 - Jan 3 00:00
        // Intersection: Jan 1 12:00 - Jan 2 00:00.
        expect(period & period2, equals(period3));
        expect(period2 & period, equals(period3));
      });

      test('returns null when periods do not overlap', () {
        // January 1-2 and January 3-4 do not overlap.
        final nonOverlapping1 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final nonOverlapping2 = Period(
          start: DateTime(2022, 1, 3),
          end: DateTime(2022, 1, 4),
        );

        expect(nonOverlapping1 & nonOverlapping2, isNull);
        expect(nonOverlapping2 & nonOverlapping1, isNull);
      });

      test('returns same period when periods are identical', () {
        final period1 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final period2 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );

        expect(period1 & period2, equals(period1));
        expect(period2 & period1, equals(period1));
      });

      test('returns smaller period when one fully contains the other', () {
        // January 1-5 contains January 2-3.
        final container = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 5),
        );
        final contained = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 3),
        );

        expect(container & contained, equals(contained));
        expect(contained & container, equals(contained));
      });

      test('returns null when periods are adjacent but do not overlap', () {
        // January 1-2 and January 2-3 are adjacent but overlap at the boundary.
        final adjacent1 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final adjacent2 = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 3),
        );

        // These periods overlap at Jan 2, so intersection should be a point.
        final expectedIntersection = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 2),
        );

        expect(adjacent1 & adjacent2, equals(expectedIntersection));
        expect(adjacent2 & adjacent1, equals(expectedIntersection));
      });

      test('works with UTC dates', () {
        final utcPeriod1 = Period(
          start: DateTime.utc(2022),
          end: DateTime.utc(2022, 1, 3),
        );
        final utcPeriod2 = Period(
          start: DateTime.utc(2022, 1, 2),
          end: DateTime.utc(2022, 1, 4),
        );
        final expectedIntersection = Period(
          start: DateTime.utc(2022, 1, 2),
          end: DateTime.utc(2022, 1, 3),
        );

        expect(utcPeriod1 & utcPeriod2, equals(expectedIntersection));
      });

      test('returns same result as getIntersection method', () {
        // Ensure operator & behaves identically to getIntersection.
        final period1 = Period(
          start: DateTime(2022, 1, 1, 6),
          end: DateTime(2022, 1, 2, 18),
        );
        final period2 = Period(
          start: DateTime(2022, 1, 1, 12),
          end: DateTime(2022, 1, 3),
        );

        expect(period1 & period2, equals(period1.getIntersection(period2)));
        expect(period2 & period1, equals(period2.getIntersection(period1)));
      });

      test('handles partial overlap correctly', () {
        // January 1 06:00 - January 2 18:00
        // overlaps with January 1 12:00 - January 3 00:00
        // Intersection: January 1 12:00 - January 2 18:00.
        final period1 = Period(
          start: DateTime(2022, 1, 1, 6),
          end: DateTime(2022, 1, 2, 18),
        );
        final period2 = Period(
          start: DateTime(2022, 1, 1, 12),
          end: DateTime(2022, 1, 3),
        );
        final expectedIntersection = Period(
          start: DateTime(2022, 1, 1, 12),
          end: DateTime(2022, 1, 2, 18),
        );

        expect(period1 & period2, equals(expectedIntersection));
        expect(period2 & period1, equals(expectedIntersection));
      });
    });
    group('operator |', () {
      final start = DateTime(2022);
      final end = DateTime(2022, DateTime.january, 2);
      final start2 = DateTime(2022, DateTime.january, 1, 12);
      final end2 = DateTime(2022, DateTime.january, 3);

      test('returns union when periods overlap', () {
        final period = Period(start: start, end: end);
        final period2 = Period(start: start2, end: end2);
        final period3 = Period(start: start, end: end2);
        // Period 1: Jan 1 00:00 - Jan 2 00:00
        // Period 2: Jan 1 12:00 - Jan 3 00:00
        // Union: Jan 1 00:00 - Jan 3 00:00.
        final result = period | period2;
        expect(result, hasLength(1));
        expect(result.first, equals(period3));

        final result2 = period2 | period;
        expect(result2, hasLength(1));
        expect(result2.first, equals(period3));
      });

      test('returns both periods when they do not overlap', () {
        // January 1-2 and January 3-4 do not overlap.
        final nonOverlapping1 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final nonOverlapping2 = Period(
          start: DateTime(2022, 1, 3),
          end: DateTime(2022, 1, 4),
        );

        final result1 = nonOverlapping1 | nonOverlapping2;
        expect(result1, hasLength(2));
        expect(result1, containsAllInOrder([nonOverlapping1, nonOverlapping2]));

        final result2 = nonOverlapping2 | nonOverlapping1;
        expect(result2, hasLength(2));
        expect(result2, containsAllInOrder([nonOverlapping2, nonOverlapping1]));
      });

      test('returns single period when periods are identical', () {
        final period1 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final period2 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );

        final result = period1 | period2;
        expect(result, hasLength(1));
        expect(result.first, equals(period1));
      });

      test('returns larger period when one fully contains the other', () {
        // January 1-5 contains January 2-3.
        final container = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 5),
        );
        final contained = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 3),
        );

        final result1 = container | contained;
        expect(result1, hasLength(1));
        expect(result1.first, equals(container));

        final result2 = contained | container;
        expect(result2, hasLength(1));
        expect(result2.first, equals(container));
      });

      test('returns union when periods are adjacent', () {
        // January 1-2 and January 2-3 are adjacent and overlap at the boundary.
        final adjacent1 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final adjacent2 = Period(
          start: DateTime(2022, 1, 2),
          end: DateTime(2022, 1, 3),
        );
        final expectedUnion = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 3),
        );

        final result1 = adjacent1 | adjacent2;
        expect(result1, hasLength(1));
        expect(result1.first, equals(expectedUnion));

        final result2 = adjacent2 | adjacent1;
        expect(result2, hasLength(1));
        expect(result2.first, equals(expectedUnion));
      });

      test('works with UTC dates', () {
        final utcPeriod1 = Period(
          start: DateTime.utc(2022),
          end: DateTime.utc(2022, 1, 3),
        );
        final utcPeriod2 = Period(
          start: DateTime.utc(2022, 1, 2),
          end: DateTime.utc(2022, 1, 4),
        );
        final expectedUnion = Period(
          start: DateTime.utc(2022),
          end: DateTime.utc(2022, 1, 4),
        );

        final result = utcPeriod1 | utcPeriod2;
        expect(result, hasLength(1));
        expect(result.first, equals(expectedUnion));
      });

      test(
        'behaves consistently with mergeWith method for overlapping periods',
        () {
          // Ensure operator | behaves consistently with mergeWith for
          // overlapping periods.
          final period1 = Period(
            start: DateTime(2022, 1, 1, 6),
            end: DateTime(2022, 1, 2, 18),
          );
          final period2 = Period(
            start: DateTime(2022, 1, 1, 12),
            end: DateTime(2022, 1, 3),
          );

          final operatorResult = period1 | period2;
          final mergeResult = period1.mergeWith(period2);

          if (mergeResult != null) {
            expect(operatorResult, hasLength(1));
            expect(operatorResult.first, equals(mergeResult));
          } else {
            expect(operatorResult, hasLength(2));
            expect(operatorResult, containsAllInOrder([period1, period2]));
          }
        },
      );

      test('handles partial overlap correctly', () {
        // January 1 06:00 - January 2 18:00
        // overlaps with January 1 12:00 - January 3 00:00
        // Union: January 1 06:00 - January 3 00:00.
        final period1 = Period(
          start: DateTime(2022, 1, 1, 6),
          end: DateTime(2022, 1, 2, 18),
        );
        final period2 = Period(
          start: DateTime(2022, 1, 1, 12),
          end: DateTime(2022, 1, 3),
        );
        final expectedUnion = Period(
          start: DateTime(2022, 1, 1, 6),
          end: DateTime(2022, 1, 3),
        );

        final result1 = period1 | period2;
        expect(result1, hasLength(1));
        expect(result1.first, equals(expectedUnion));

        final result2 = period2 | period1;
        expect(result2, hasLength(1));
        expect(result2.first, equals(expectedUnion));
      });

      test('returns both periods when there is a gap between them', () {
        // January 1-2 and January 4-5 with a gap on January 3.
        final period1 = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );
        final period2 = Period(
          start: DateTime(2022, 1, 4),
          end: DateTime(2022, 1, 5),
        );

        final result1 = period1 | period2;
        expect(result1, hasLength(2));
        expect(result1, containsAllInOrder([period1, period2]));

        final result2 = period2 | period1;
        expect(result2, hasLength(2));
        expect(result2, containsAllInOrder([period2, period1]));
      });
    });
    group('getDateTimeValues', () {
      test('returns list of dates generated by next function', () {
        // January 1, 2022 to January 3, 2022.
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 3),
        );

        // Generate daily dates.
        final dates = period.getDateTimeValues((last) {
          final next = last.add(const Duration(days: 1));
          return period.contains(next) ? next : null;
        });

        expect(
          dates,
          orderedEquals([
            DateTime(2022, 1, 2),
            DateTime(2022, 1, 3),
          ]),
        );
      });

      test('starts iteration with period start date', () {
        final period = Period(
          start: DateTime(2022, 1, 1, 12),
          end: DateTime(2022, 1, 2),
        );

        DateTime? capturedFirst;
        period.getDateTimeValues((last) {
          capturedFirst ??= last;
          return null; // Stop immediately.
        });

        expect(capturedFirst, equals(period.start));
      });

      test('stops when next function returns null', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 10),
        );

        var callCount = 0;
        final dates = period.getDateTimeValues((last) {
          callCount++;
          if (callCount <= 3) {
            return last.add(const Duration(days: 1));
          }
          return null; // Stop after 3 calls.
        });

        expect(dates, hasLength(3));
        expect(callCount, equals(4)); // Called once more after returning null.
      });

      test('handles empty period correctly', () {
        final start = DateTime(2022);
        final period = Period(start: start, end: start);

        final dates = period.getDateTimeValues((last) {
          return last.add(const Duration(hours: 1));
        });

        expect(dates, isEmpty);
      });

      test('throws ArgumentError when next returns date outside period', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );

        expect(
          () => period.getDateTimeValues((last) {
            // Return date outside period.
            return DateTime(2022, 1, 5);
          }),
          throwsA(
            isA<ArgumentError>().having((e) => e.name, 'name', 'next').having(
                  (e) => e.message,
                  'message',
                  'The next date must be contained in the period',
                ),
          ),
        );
      });

      test('handles hourly intervals within single day', () {
        // January 1, 2022 00:00 to January 1, 2022 06:00.
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 1, 6),
        );

        final dates = period.getDateTimeValues((last) {
          final next = last.add(const Duration(hours: 2));
          return period.contains(next) ? next : null;
        });

        expect(
          dates,
          orderedEquals([
            DateTime(2022, 1, 1, 2),
            DateTime(2022, 1, 1, 4),
            DateTime(2022, 1, 1, 6),
          ]),
        );
      });

      test('uses last generated date for next iteration', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 5),
        );

        final capturedInputs = <DateTime>[];
        period.getDateTimeValues((last) {
          capturedInputs.add(last);
          if (capturedInputs.length < 3) {
            return last.add(const Duration(days: 1));
          }
          return null;
        });

        expect(
          capturedInputs,
          orderedEquals([
            DateTime(2022), // Start date.
            DateTime(2022, 1, 2), // Last generated.
            DateTime(2022, 1, 3), // Last generated.
          ]),
        );
      });

      test('handles next function returning same date', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 2),
        );

        var callCount = 0;
        final dates = period.getDateTimeValues((last) {
          callCount++;
          if (callCount == 1) {
            return last; // Return same date.
          }
          return null;
        });

        expect(dates, orderedEquals([DateTime(2022)]));
      });

      test('continues until end boundary is reached', () {
        // January 1, 2022 to January 1, 2022 03:00.
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 1, 3),
        );

        final dates = period.getDateTimeValues((last) {
          final next = last.add(const Duration(hours: 1));
          return next;
        });

        expect(
          dates,
          orderedEquals([
            DateTime(2022, 1, 1, 1),
            DateTime(2022, 1, 1, 2),
            DateTime(2022, 1, 1, 3),
          ]),
        );
      });

      test('stops when generated date exceeds end boundary', () {
        final end = DateTime(2022, 1, 1, 2, 30);
        final period = Period(
          start: DateTime(2022),
          end: end,
        );

        expect(
          () => period.getDateTimeValues((last) {
            return end.add(const Duration(hours: 1));
          }),
          throwsArgumentError,
        );
      });

      test('handles microsecond precision', () {
        final start = DateTime(2022);
        final period = Period(
          start: start,
          end: start.add(const Duration(microseconds: 5)),
        );

        final dates = period.getDateTimeValues((last) {
          final next = last.add(const Duration(microseconds: 2));
          return period.contains(next) ? next : null;
        });

        expect(
          dates,
          orderedEquals([
            start.add(const Duration(microseconds: 2)),
            start.add(const Duration(microseconds: 4)),
          ]),
        );
      });
    });
    group('toString', () {
      test('Returns formatted string with default formatting', () {
        // July 1, 2024 is Monday.
        final start = DateTime(2024, 7);
        final end = DateTime(2024, 7, 10);
        final period = Period(start: start, end: end);

        final result = period.toString();

        expect(result, contains('2024-07-01'));
        expect(result, contains('2024-07-10'));
      });

      test('Uses custom date formatter when provided', () {
        // July 1, 2024 is Monday.
        final start = DateTime(2024, 7);
        final end = DateTime(2024, 7, 10);
        final period = Period(start: start, end: end);

        final result = period.toString(
          dateFormat: (date) => '${date.year}-${date.month}-${date.day} custom',
        );

        expect(result, equals('2024-7-1 custom, 2024-7-10 custom'));
      });
    });

    group('trim', () {
      test('Removes periods that do not overlap', () {
        // July 2024 period.
        final period = Period(
          start: DateTime(2024, 7),
          end: DateTime(2024, 7, 31),
        );

        // June and August periods do not overlap.
        final periods = [
          Period(start: DateTime(2024, 6), end: DateTime(2024, 6, 30)),
          Period(start: DateTime(2024, 8), end: DateTime(2024, 8, 31)),
        ];

        final result = period.trim(periods);

        expect(result, isEmpty);
      });

      test('Keeps periods that are fully contained', () {
        // July 2024 period.
        final period = Period(
          start: DateTime(2024, 7),
          end: DateTime(2024, 7, 31),
        );

        // Mid-July period is fully contained.
        final containedPeriod = Period(
          start: DateTime(2024, 7, 10),
          end: DateTime(2024, 7, 20),
        );
        final periods = [containedPeriod];

        final result = period.trim(periods);

        expect(result.length, equals(1));
        expect(result.first, equals(containedPeriod));
      });

      test('Trims periods that partially overlap', () {
        // July 2024 period.
        final period = Period(
          start: DateTime(2024, 7),
          end: DateTime(2024, 7, 31),
        );

        // Periods that partially overlap with July.
        final periods = [
          Period(start: DateTime(2024, 6, 25), end: DateTime(2024, 7, 5)),
          Period(start: DateTime(2024, 7, 25), end: DateTime(2024, 8, 5)),
        ];

        final result = period.trim(periods);

        expect(result.length, equals(2));
        // First period should be trimmed to July 1-5.
        expect(result.first.start, equals(DateTime(2024, 7)));
        expect(result.first.end, equals(DateTime(2024, 7, 5)));
        // Second period should be trimmed to July 25-31.
        expect(result[1].start, equals(DateTime(2024, 7, 25)));
        expect(result[1].end, equals(DateTime(2024, 7, 31)));
      });

      test(
          'Mixed case with overlapping, contained, and non-overlapping periods',
          () {
        // July 2024 period.
        final period = Period(
          start: DateTime(2024, 7),
          end: DateTime(2024, 7, 31),
        );

        final periods = [
          // Non-overlapping - should be removed.
          Period(start: DateTime(2024, 6), end: DateTime(2024, 6, 30)),
          // Partially overlapping - should be trimmed.
          Period(start: DateTime(2024, 6, 25), end: DateTime(2024, 7, 5)),
          // Fully contained - should remain unchanged.
          Period(start: DateTime(2024, 7, 10), end: DateTime(2024, 7, 20)),
          // Partially overlapping - should be trimmed.
          Period(start: DateTime(2024, 7, 25), end: DateTime(2024, 8, 5)),
          // Non-overlapping - should be removed.
          Period(start: DateTime(2024, 8, 10), end: DateTime(2024, 8, 15)),
        ];

        final result = period.trim(periods);

        expect(result.length, equals(3));
        // First period should be trimmed to July 1-5.
        expect(result.first.start, equals(DateTime(2024, 7)));
        expect(result.first.end, equals(DateTime(2024, 7, 5)));
        // Second period should remain unchanged.
        expect(result[1].start, equals(DateTime(2024, 7, 10)));
        expect(result[1].end, equals(DateTime(2024, 7, 20)));
        // Third period should be trimmed to July 25-31.
        expect(result.last.start, equals(DateTime(2024, 7, 25)));
        expect(result.last.end, equals(DateTime(2024, 7, 31)));
      });
    });
    group('UTC and local time handling', () {
      group('isUtc getter', () {
        test('Returns true for UTC dates', () {
          final period = Period(
            start: DateTime.utc(2024, 7),
            end: DateTime.utc(2024, 7, 31),
          );
          expect(period.isUtc, isTrue);
        });

        test('Returns false for local dates', () {
          final period = Period(
            start: DateTime(2024, 7),
            end: DateTime(2024, 7, 31),
          );
          expect(period.isUtc, isFalse);
        });

        test('Returns null for mixed UTC and local dates', () {
          final period = Period(
            start: DateTime.utc(2024, 7),
            end: DateTime(2024, 7, 31),
          );
          expect(period.isUtc, isNull);
        });
      });

      group('isLocal getter', () {
        test('Returns true for local dates', () {
          final period = Period(
            start: DateTime(2024, 7),
            end: DateTime(2024, 7, 31),
          );
          expect(period.isLocal, isTrue);
        });

        test('Returns false for UTC dates', () {
          final period = Period(
            start: DateTime.utc(2024, 7),
            end: DateTime.utc(2024, 7, 31),
          );
          expect(period.isLocal, isFalse);
        });

        test('Returns null for mixed UTC and local dates', () {
          final period = Period(
            start: DateTime(2024, 7),
            end: DateTime.utc(2024, 7, 31),
          );
          expect(period.isLocal, isNull);
        });
      });

      group('toUtc method', () {
        test('Returns same instance when already in UTC', () {
          final period = Period(
            start: DateTime.utc(2024, 7),
            end: DateTime.utc(2024, 7, 31),
          );

          final result = period.toUtc();

          expect(identical(result, period), isTrue);
          expect(result.start.isUtc, isTrue);
          expect(result.end.isUtc, isTrue);
        });

        test('Converts local dates to UTC', () {
          final localStart = DateTime(2024, 7);
          final localEnd = DateTime(2024, 7, 31);
          final period = Period(
            start: localStart,
            end: localEnd,
          );

          final result = period.toUtc();

          expect(identical(result, period), isFalse);
          expect(result.start, equals(localStart.toUtc()));
          expect(result.end, equals(localEnd.toUtc()));
          expect(result.start.isUtc, isTrue);
          expect(result.end.isUtc, isTrue);
        });

        test('Converts mixed dates to UTC', () {
          final localStart = DateTime(2024, 7);
          final utcEnd = DateTime.utc(2024, 7, 31);
          final period = Period(
            start: localStart,
            end: utcEnd,
          );

          final result = period.toUtc();

          expect(identical(result, period), isFalse);
          expect(result.start, equals(localStart.toUtc()));
          expect(result.end, equals(utcEnd));
          expect(result.start.isUtc, isTrue);
          expect(result.end.isUtc, isTrue);
        });
      });

      group('toLocal method', () {
        test('Returns same instance when already in local time', () {
          final period = Period(
            start: DateTime(2024, 7),
            end: DateTime(2024, 7, 31),
          );

          final result = period.toLocal();

          expect(identical(result, period), isTrue);
          expect(result.start.isUtc, isFalse);
          expect(result.end.isUtc, isFalse);
        });

        test('Converts UTC dates to local', () {
          final utcStart = DateTime.utc(2024, 7);
          final utcEnd = DateTime.utc(2024, 7, 31);
          final period = Period(
            start: utcStart,
            end: utcEnd,
          );

          final result = period.toLocal();

          expect(identical(result, period), isFalse);
          expect(result.start, equals(utcStart.toLocal()));
          expect(result.end, equals(utcEnd.toLocal()));
          expect(result.start.isUtc, isFalse);
          expect(result.end.isUtc, isFalse);
        });

        test('Converts mixed dates to local', () {
          final utcStart = DateTime.utc(2024, 7);
          final localEnd = DateTime(2024, 7, 31);
          final period = Period(
            start: utcStart,
            end: localEnd,
          );

          final result = period.toLocal();

          expect(identical(result, period), isFalse);
          expect(result.start, equals(utcStart.toLocal()));
          expect(result.end, equals(localEnd));
          expect(result.start.isUtc, isFalse);
          expect(result.end.isUtc, isFalse);
        });
      });
    });
  });
}
