import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('Period ->', () {
    group('Constructor ->', () {
      group('Default ->', () {
        final start = DateTime(2022, DateTime.january, 1);
        final end = DateTime(2022, DateTime.january, 2);
        test('Works if start is before end', () {
          expect(Period(start: start, end: end), isA<Period>());
        });
        test('Works if start is equal to end', () {
          expect(Period(start: start, end: start), isA<Period>());
        });
        test('Doesn\'t work if end is before start', () {
          expect(
            () => Period(start: end, end: start),
            throwsArgumentError,
          );
        });
        test('Throws if one of the parameters is utc and the other not', () {
          expect(
            () => Period(start: start, end: end.toUtc()),
            throwsArgumentError,
          );
        });
        test('Throws if one of the parameters is not utc and the other is', () {
          expect(
            () => Period(start: start.toUtc(), end: end),
            throwsArgumentError,
          );
        });
      });
    });
    group('duration ->', () {
      final start = DateTime(2022, DateTime.january, 1);
      final end = DateTime(2022, DateTime.january, 2);
      final period = Period(start: start, end: end);
      test('deve dar um dia + 1 microsecond', () {
        expect(
          period.duration,
          equals(const Duration(days: 1, microseconds: 1)),
        );
      });
    });
    group('contains ->', () {
      final start = DateTime(2022, DateTime.january, 1);
      final end = DateTime(2022, DateTime.january, 2);
      final period = Period(start: start, end: end);
      const microssecond = Duration(microseconds: 1);
      test('before start', () {
        expect(period.contains(start.subtract(microssecond)), isFalse);
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
        expect(period.contains(end.add(microssecond)), isFalse);
      });
    });
    group('overlapsWith ->', () {
      final start = DateTime(2022, DateTime.january, 1);
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
      final start = DateTime(2022, DateTime.january, 1);
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
      final start = DateTime(2022, DateTime.january, 1);
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
      final start = DateTime(2022, DateTime.january, 1);
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
      final start = DateTime(2022, DateTime.january, 1);
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
      final start = DateTime(2022, DateTime.january, 1);
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
      final start = DateTime(2022, DateTime.january, 1);
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
        final start = DateTime(2022, DateTime.january, 1);
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
          '[Period(start: DateTime(2023, 03, 16), end: DateTime(2023, 03, 17)),'
          'Period('
          '  start: DateTime(2023, 03, 18, 12), '
          '  end: DateTime(2023, 03, 18, 13),'
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
          'Period(2023-03-18 00:00:00.000, 2023-03-20 00:00:00.000)'
          ']', () {
        final period1 = Period(
          start: DateTime(2023, 4, 1),
          end: DateTime(2023, 4, 15),
        );
        final period2 = Period(
          start: DateTime(2023, 4, 1),
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
        ];
        list.sort();
        expect(list, orderedEquals(expected));
      });
    });
    group('subtract', () {
      final start = DateTime(2022, DateTime.january, 1);
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
      final start = DateTime(2022, DateTime.january, 1);
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
    });
    group('splitIn', () {
      final start = DateTime(2022, DateTime.january, 1);
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
          '[Period:Period(2020-01-01 00:00:00.000, 2020-01-10 08:00:00.000),'
          'Period:Period(2020-01-11 08:00:00.000, 2020-01-20 16:00:00.000),'
          'Period:Period(2020-01-21 16:00:00.000, 2020-01-31 00:00:00.000)]',
          () {
        final base = Period(
          start: DateTime(2020, 1, 1),
          end: DateTime(2020, 1, 31),
        );
        final expected = [
          Period(
            start: DateTime(2020, 1, 1),
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
          base.splitIn(3, periodBetween: Duration(days: 1)),
          orderedEquals(expected),
        );
        for (int i = 1; i < (expected.length - 1); i++) {
          expect(expected[i].duration, equals(expected[i - 1].duration));
        }
      });
    });
    test('isNotEmpty', () {
      final start = DateTime(2022, DateTime.january, 1);
      final end = DateTime(2022, DateTime.january, 2);
      final period = Period(start: start, end: end);
      expect(period.isNotEmpty, isTrue);
      expect(period.isEmpty, isFalse);
    });
    test('isEmpty', () {
      final start = DateTime(2022, DateTime.january, 1);
      final period = Period(start: start, end: start);
      expect(period.isEmpty, isTrue);
      expect(period.isNotEmpty, isFalse);
    });
    test('equals', () {
      const dayGenerator = DayGenerator();
      final start = DateTime(2022, DateTime.january, 1);
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
      final start = DateTime(2022, DateTime.january, 1);
      final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
      final period = Period(start: start, end: end);
      final period2 = period.shift(const Duration(days: 1));
      expect(period2.start, start.add(const Duration(days: 1)));
      expect(period2.end, end.add(const Duration(days: 1)));
      final period3 = period.shift(const Duration(days: -1));
      expect(period3.start, start.subtract(const Duration(days: 1)));
      expect(period3.end, end.subtract(const Duration(days: 1)));
    });
    group('containsFully', () {
      final start = DateTime(2022, DateTime.january, 1);
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
      test('Non overlaping', () {
        final period2 = Period(
          start: end.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period.containsFully(period2), isFalse);
      });
    });
    group('containedFullyBy', () {
      final start = DateTime(2022, DateTime.january, 1);
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
      test('Non overlaping', () {
        final period2 = Period(
          start: end.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period2.containedFullyBy(period), isFalse);
      });
    });
    group('containsPartially', () {
      final start = DateTime(2022, DateTime.january, 1);
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
      test('Non overlaping', () {
        final period2 = Period(
          start: end.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period.containsPartially(period2), isFalse);
      });
    });
    group('containedPartiallyBy', () {
      final start = DateTime(2022, DateTime.january, 1);
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
      test('Non overlaping', () {
        final period2 = Period(
          start: end.add(const Duration(days: 1)),
          end: end.add(const Duration(days: 2)),
        );
        expect(period2.containedPartiallyBy(period), isFalse);
      });
    });
    group('occursBefore', () {
      final start = DateTime(2022, DateTime.january, 1);
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
  });
  group('occursAfter', () {
    final start = DateTime(2022, DateTime.january, 1);
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
    final start = DateTime(2022, DateTime.january, 1);
    final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
    final period = Period(start: start, end: end);
    test('start', () {
      final period2 = period.copyWith(
        start: start.subtract(const Duration(days: 1)),
      );
      expect(period2.start, equals(start.subtract(const Duration(days: 1))));
      expect(period2.end, equals(end));
    });
    test('end', () {
      final period2 = period.copyWith(end: end.add(const Duration(days: 1)));
      expect(period2.start, equals(start));
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
    final start = DateTime(2022, DateTime.january, 1);
    final end = DateTime(2022, DateTime.january, 1, 23, 59, 59, 999, 999);
    final period = Period(start: start, end: end);
    test('same as end', () {
      expect(period.endsBefore(end), isFalse);
    });
    test('before end', () {
      expect(period.endsBefore(end.subtract(const Duration(days: 1))), isFalse);
    });
    test('after end', () {
      expect(period.endsBefore(end.add(const Duration(days: 1))), isTrue);
    });
  });
  group('endsAfter', () {
    final start = DateTime(2022, DateTime.january, 1);
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
    final start = DateTime(2022, DateTime.january, 1);
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
    final start = DateTime(2022, DateTime.january, 1);
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
    final first = DateTime(2022, DateTime.january, 1);
    final period = dayGenerator.of(first);
    final second = DateTime(2022, DateTime.january, 2);
    final period2 = dayGenerator.of(second);
    test('next', () {
      expect(period.getNext(dayGenerator), equals(period2));
    });
  });
  group('getPrevious', () {
    const dayGenerator = DayGenerator();
    final first = DateTime(2022, DateTime.january, 1);
    final period = dayGenerator.of(first);
    final second = DateTime(2022, DateTime.january, 2);
    final period2 = dayGenerator.of(second);
    test('previous', () {
      expect(period2.getPrevious(dayGenerator), equals(period));
    });
  });
  group('MinutePeriod', () {
    test('Seconds', () {
      const generator = MinuteGenerator();
      const oneSecond = Duration(seconds: 1);
      final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final seconds = minute.seconds;
      expect(seconds, isA<List<SecondPeriod>>());
      expect(seconds, hasLength(60));
      expect(seconds.none((second) => second.duration != oneSecond), isTrue);
      expect(
        seconds.first,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 0),
            end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
          ),
        ),
      );
      expect(
        seconds.last,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 59),
            end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
          ),
        ),
      );
    });
  });
  group('HourPeriod', () {
    test('Minutes', () {
      const generator = HourGenerator();
      const oneMinute = Duration(minutes: 1);
      final hour = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final minutes = hour.minutes;
      expect(minutes, isA<List<MinutePeriod>>());
      expect(minutes, hasLength(60));
      expect(minutes.none((minute) => minute.duration != oneMinute), isTrue);
      expect(
        minutes.first,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 0),
            end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
          ),
        ),
      );
      expect(
        minutes.last,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 59, 0),
            end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
  group('DayPeriod', () {
    test('Hours', () {
      const generator = DayGenerator();
      const oneHour = Duration(hours: 1);
      final day = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final hours = day.hours;
      expect(hours, isA<List<HourPeriod>>());
      expect(hours, hasLength(24));
      expect(hours.none((hour) => hour.duration != oneHour), isTrue);
      expect(
        hours.first,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 0),
            end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
  group('WeekPeriod', () {
    test('Days', () {
      const generator = WeekGenerator();
      const dayGenerator = DayGenerator();
      final week = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final days = week.days;
      expect(days, isA<List<DayPeriod>>());
      expect(days, hasLength(7));
      expect(days.none((day) => !dayGenerator.fitsGenerator(day)), isTrue);
      expect(
        days.first,
        equals(
          Period(
            start: DateTime(2019, 12, 30, 0, 0, 0),
            end: DateTime(2019, 12, 30, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
  group('FortnightPeriod', () {
    test('Days', () {
      const generator = FortnightGenerator();
      const dayGenerator = DayGenerator();
      final fortnight = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final days = fortnight.days;
      expect(days, isA<List<DayPeriod>>());
      expect(days, hasLength(15));
      expect(days.none((day) => !dayGenerator.fitsGenerator(day)), isTrue);
      expect(
        days.first,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 0),
            end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
          ),
        ),
      );
      expect(
        days.last,
        equals(
          Period(
            start: DateTime(2020, 1, 15, 0, 0, 0),
            end: DateTime(2020, 1, 15, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
  group('MonthPeriod', () {
    test('Days', () {
      const generator = MonthGenerator();
      const dayGenerator = DayGenerator();
      final month = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final days = month.days;
      expect(days, isA<List<DayPeriod>>());
      expect(days, hasLength(31));
      expect(days.none((day) => !dayGenerator.fitsGenerator(day)), isTrue);
      expect(
        days.first,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 0),
            end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
          ),
        ),
      );
      expect(
        days.last,
        equals(
          Period(
            start: DateTime(2020, 1, 31, 0, 0, 0),
            end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
  group('TrimesterPeriod', () {
    test('Months', () {
      const generator = TrimesterGenerator();
      const monthGenerator = MonthGenerator();
      final trimester = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final months = trimester.months;
      expect(months, isA<List<MonthPeriod>>());
      expect(months, hasLength(3));
      expect(
        months.none((month) => !monthGenerator.fitsGenerator(month)),
        isTrue,
      );
      expect(
        months.first,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 0),
            end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
          ),
        ),
      );
      expect(
        months.last,
        equals(
          Period(
            start: DateTime(2020, 3, 1, 0, 0, 0),
            end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
  group('SemesterPeriod', () {
    test('Months', () {
      const generator = SemesterGenerator();
      const monthGenerator = MonthGenerator();
      final semester = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final months = semester.months;
      expect(months, isA<List<MonthPeriod>>());
      expect(months, hasLength(6));
      expect(
        months.none((month) => !monthGenerator.fitsGenerator(month)),
        isTrue,
      );
      expect(
        months.first,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 0),
            end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
          ),
        ),
      );
      expect(
        months.last,
        equals(
          Period(
            start: DateTime(2020, 6, 1, 0, 0, 0),
            end: DateTime(2020, 6, 30, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
    group('YearPeriod', () {
      test('Months', () {
        const generator = YearGenerator();
        const monthGenerator = MonthGenerator();
        final year = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final months = year.months;
        expect(months, isA<List<MonthPeriod>>());
        expect(months, hasLength(12));
        expect(
          months.none((month) => !monthGenerator.fitsGenerator(month)),
          isTrue,
        );
        expect(
          months.first,
          equals(
            Period(
              start: DateTime(2020, 1, 1, 0, 0, 0),
              end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
        expect(
          months.last,
          equals(
            Period(
              start: DateTime(2020, 12, 1, 0, 0, 0),
              end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });
    });
  });
}
