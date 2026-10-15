import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:due_date/src/everies/every.dart';
import 'package:due_date/src/period_generators/every_generator.dart';
import 'package:due_date/src/periods/period.dart';
import 'package:test/test.dart';

import '../src/every_day.dart';

void main() {
  group('EveryGenerator:', () {
    group('Constructor', () {
      test('Uses start as end when end is omitted', () {
        const every = Every.dueDayMonth(15);
        expect(
          const EveryGenerator(every),
          equals(const EveryGenerator(every, end: every)),
        );
      });
    });

    group('Single every', () {
      const generator = EveryGenerator(Every.dueDayMonth(15));
      final march = Period(
        start: DateTime(2024, 3, 15),
        end: DateTime(2024, 4, 14, 23, 59, 59, 999, 999),
      );

      test('of date between occurrences', () {
        expect(generator.of(DateTime(2024, 3, 20)), equals(march));
      });

      test('of date on an occurrence', () {
        expect(generator.of(DateTime(2024, 3, 15)), equals(march));
      });

      test('after', () {
        expect(
          generator.after(march),
          equals(
            Period(
              start: DateTime(2024, 4, 15),
              end: DateTime(2024, 5, 14, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('before', () {
        expect(
          generator.before(march),
          equals(
            Period(
              start: DateTime(2024, 2, 15),
              end: DateTime(2024, 3, 14, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Keeps the time of day of the given date', () {
        expect(
          generator.of(DateTime(2024, 3, 20, 10)),
          equals(
            Period(
              start: DateTime(2024, 3, 15, 10),
              end: DateTime(2024, 4, 15, 9, 59, 59, 999, 999),
            ),
          ),
        );
      });
    });

    group('Plain Every', () {
      const generator = EveryGenerator(EveryDay());

      test('of date on an occurrence', () {
        expect(
          generator.of(DateTime(2024, 1, 3, 10)),
          equals(
            Period(
              start: DateTime(2024, 1, 3, 10),
              end: DateTime(2024, 1, 4, 9, 59, 59, 999, 999),
            ),
          ),
        );
      });
    });

    group('Start and end everies', () {
      const generator = EveryGenerator(
        Every.weekday(Weekday.monday),
        end: Every.weekday(Weekday.saturday),
      );
      // January 1, 2024 is a Monday.
      final firstWeek = Period(
        start: DateTime(2024),
        end: DateTime(2024, 1, 5, 23, 59, 59, 999, 999),
      );
      final secondWeek = Period(
        start: DateTime(2024, 1, 8),
        end: DateTime(2024, 1, 12, 23, 59, 59, 999, 999),
      );

      test('of date inside a period', () {
        expect(generator.of(DateTime(2024, 1, 3)), equals(firstWeek));
      });

      test('of date in a gap returns the period of the latest start', () {
        expect(generator.of(DateTime(2024, 1, 6)), equals(firstWeek));
      });

      test('after skips the gap', () {
        expect(generator.after(firstWeek), equals(secondWeek));
      });

      test('after asserts that no duration is passed', () {
        expect(
          () => generator.after(firstWeek, duration: const Duration(days: 1)),
          throwsA(isA<AssertionError>()),
        );
      });

      test('before asserts that no duration is passed', () {
        expect(
          () => generator.before(secondWeek, duration: const Duration(days: 1)),
          throwsA(isA<AssertionError>()),
        );
      });

      test('before skips the gap', () {
        expect(generator.before(secondWeek), equals(firstWeek));
      });
    });

    group('LimitedEvery without occurrences', () {
      // No date is both a Monday and a Tuesday, and the generator passes no
      // limit, so the search recurses until the stack overflows.
      const generator = EveryGenerator(
        Every.intersection([
          EveryWeekday(Weekday.monday),
          EveryWeekday(Weekday.tuesday),
        ]),
      );

      test('of throws a StackOverflowError', () {
        expect(
          () => generator.of(DateTime(2024)),
          throwsA(isA<StackOverflowError>()),
        );
      });

      test('of throws DateTimeLimitReachedException when given a limit', () {
        expect(
          () => generator.of(DateTime(2024), limit: DateTime(2023)),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });
    });
  });
}
