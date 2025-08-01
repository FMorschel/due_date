import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import 'src/date_time_match.dart';
import 'src/due_date_time_match.dart';

void main() {
  const dueDay15 = EveryDueDayMonth(15);
  group('Constructors:', () {
    const year = 2022;
    const dueDay30 = EveryDueDayMonth(30);
    // Leap year test: February 29, 2024.
    test('Leap year February 29', () {
      // February 29, 2024 is a valid leap day.
      final leapMatcher = DateTime(2024, 2, 29);
      expect(
        DueDateTime(every: dueDay30, year: 2024, month: 2),
        isSameDueDateTime(leapMatcher),
      );
      expect(
        DueDateTime.utc(every: dueDay30, year: 2024, month: 2),
        isSameDueDateTime(DateTime.utc(2024, 2, 29)),
      );
    });
    // ...existing code...
    test('Now', () {
      final now = DateTime.now();
      withClock(Clock.fixed(now), () {
        expect(DueDateTime.now(), isSameDateTime(now));
      });
    });
    group('FromDate:', () {
      final matcher = DateTime.utc(year, 2, 28);
      test('No every', () {
        expect(DueDateTime.fromDate(matcher), isSameDateTime(matcher));
      });
      test('With every', () {
        expect(
          DueDateTime.fromDate(matcher, every: dueDay30),
          isSameDateTime(matcher),
        );
      });
      test('With limited every', () {
        // February 28, 2022 is Monday.
        final limitedEvery = EverySkipInvalidModifier(
          every: const EveryWeekday(Weekday.monday),
          invalidator: const DateValidatorWeekday(Weekday.sunday),
        );
        expect(
          DueDateTime.fromDate(matcher, every: limitedEvery),
          isSameDateTime(matcher),
        );
      });
      test('With limited every and limit', () {
        // February 28, 2022 is Monday.
        final limitedEvery = EverySkipInvalidModifier(
          every: const EveryWeekday(Weekday.monday),
          invalidator: const DateValidatorWeekday(Weekday.sunday),
        );
        final limit = DateTime.utc(year, 3, 15);
        expect(
          DueDateTime.fromDate(matcher, every: limitedEvery, limit: limit),
          isSameDateTime(matcher),
        );
      });
      test('With limited every and wrong limit', () {
        final limitedEvery = EverySkipInvalidModifier(
          every: const EveryWeekday(Weekday.monday),
          invalidator: const DateValidatorWeekday(Weekday.sunday),
        );
        final limit = DateTime.utc(year, 2);
        expect(
          () => DueDateTime.fromDate(
            matcher,
            every: limitedEvery,
            limit: limit,
          ),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });
    });
  });
  group('Parsing:', () {
    test('January 1st, 2022', () {
      expect(DueDateTime.parse('2022-01-01'), isSameDateTime(DateTime(2022)));
    });
    test('FormatException', () {
      expect(() => DueDateTime.parse(''), throwsFormatException);
    });
    test('With every', () {
      expect(
        DueDateTime.parse('2022-01-01', every: dueDay15),
        isSameDateTime(DateTime(2022, 1, 15)),
      );
    });
    test('Malformed date string', () {
      expect(() => DueDateTime.parse('not-a-date'), throwsFormatException);
      expect(DueDateTime.tryParse('not-a-date'), equals(null));
    });
  });
  group('Trying to Parse:', () {
    test('January 1st, 2022', () {
      expect(
        DueDateTime.tryParse('2022-01-01'),
        isSameDateTime(DateTime(2022)),
      );
    });
    test('Returns null', () {
      expect(DueDateTime.tryParse(''), equals(null));
    });
    test('With every', () {
      expect(
        DueDateTime.tryParse('2022-01-01', every: dueDay15),
        isSameDateTime(DateTime(2022, 1, 15)),
      );
    });
  });
  group('FromMillisecondsSinceEpoch:', () {
    final date = DateTime(2022);
    test('January 1st, 2022', () {
      expect(
        DueDateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch),
        isSameDateTime(date),
      );
    });
    test('With every', () {
      expect(
        DueDateTime.fromMillisecondsSinceEpoch(
          date.millisecondsSinceEpoch,
          every: dueDay15,
        ),
        isSameDateTime(DateTime(2022, 1, 15)),
      );
    });
    test('With every UTC', () {
      expect(
        DueDateTime.fromMillisecondsSinceEpoch(
          date.millisecondsSinceEpoch,
          every: dueDay15,
          isUtc: true,
        ),
        isSameDateTime(DateTime(2022, 1, 15).toUtc()),
      );
    });
  });
  group('FromMicrosecondsSinceEpoch:', () {
    final date = DateTime(2022);
    test('January 1st, 2022', () {
      expect(
        DueDateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch),
        isSameDateTime(date),
      );
    });
    test('With every', () {
      expect(
        DueDateTime.fromMicrosecondsSinceEpoch(
          date.microsecondsSinceEpoch,
          every: dueDay15,
        ),
        isSameDateTime(DateTime(2022, 1, 15)),
      );
    });
    test('With every UTC', () {
      expect(
        DueDateTime.fromMicrosecondsSinceEpoch(
          date.microsecondsSinceEpoch,
          every: dueDay15,
          isUtc: true,
        ),
        isSameDateTime(DateTime(2022, 1, 15).toUtc()),
      );
    });
  });
  group('CopyWith:', () {
    final dueDate = DueDateTime.fromDate(DateTime(2022, 1, 2, 3, 4, 5, 6, 7));
    // Time component preservation.
    test('Preserves time components', () {
      final updated = dueDate.copyWith(minute: 59);
      expect(updated.hour, equals(3));
      expect(updated.minute, equals(59));
      expect(updated.second, equals(5));
      expect(updated.millisecond, equals(6));
      expect(updated.microsecond, equals(7));
    });
    test('Preserves time components (UTC)', () {
      final utcDueDate = DueDateTime.fromDate(
        DateTime.utc(2022, 1, 2, 3, 4, 5, 6, 7),
      );
      final updated = utcDueDate.copyWith(second: 59);
      expect(updated, isUtcDateTime);
      expect(updated.hour, equals(3));
      expect(updated.minute, equals(4));
      expect(updated.second, equals(59));
      expect(updated.millisecond, equals(6));
      expect(updated.microsecond, equals(7));
    });
    test('Preserves time components UTC to Local', () {
      final utcDueDate = DueDateTime.fromDate(
        DateTime.utc(2022, 1, 2, 3, 4, 5, 6, 7),
      );
      final updated = utcDueDate.copyWith(utc: false);
      expect(updated, isLocalDateTime);
      expect(updated.hour, equals(3));
      expect(updated.minute, equals(4));
      expect(updated.second, equals(5));
      expect(updated.millisecond, equals(6));
      expect(updated.microsecond, equals(7));
    });
    test('Preserves time components Local to UTC', () {
      final utcDueDate = DueDateTime.fromDate(
        DateTime(2022, 1, 2, 3, 4, 5, 6, 7),
      );
      final updated = utcDueDate.copyWith(utc: true);
      expect(updated, isUtcDateTime);
      expect(updated.hour, equals(3));
      expect(updated.minute, equals(4));
      expect(updated.second, equals(5));
      expect(updated.millisecond, equals(6));
      expect(updated.microsecond, equals(7));
    });
    final dueDate2 = DueDateTime.fromDate(DateTime(2022));
    test('Different every', () {
      expect(
        dueDate2.copyWith(every: dueDay15),
        isSameDateTime(DateTime(2022, 1, 15)),
      );
    });
    test('Different year', () {
      expect(
        dueDate2.copyWith(year: 2021),
        isSameDateTime(DateTime(2021)),
      );
    });
    test('Different month', () {
      expect(
        dueDate2.copyWith(month: 2),
        isSameDateTime(DateTime(2022, 2)),
      );
    });
    test('Different day', () {
      expect(
        dueDate2.copyWith(day: 2),
        isSameDateTime(DateTime(2022, 2)),
      );
    });
    test('Different hour', () {
      expect(
        dueDate2.copyWith(hour: 1),
        isSameDateTime(DateTime(2022, 1, 1, 1)),
      );
    });
    test('Different minute', () {
      expect(
        dueDate2.copyWith(minute: 1),
        isSameDateTime(DateTime(2022, 1, 1, 0, 1)),
      );
    });
    test('Different second', () {
      expect(
        dueDate2.copyWith(second: 1),
        isSameDateTime(DateTime(2022, 1, 1, 0, 0, 1)),
      );
    });
    test('Different millisecond', () {
      expect(
        dueDate2.copyWith(millisecond: 1),
        isSameDateTime(DateTime(2022, 1, 1, 0, 0, 0, 1)),
      );
    });
    test('Different microsecond', () {
      expect(
        dueDate2.copyWith(microsecond: 1),
        isSameDateTime(DateTime(2022, 1, 1, 0, 0, 0, 0, 1)),
      );
    });
  });
  test('toUtc', () {
    final dueDate =
        DueDateTime(every: const EveryDueDayMonth(30), year: 2022).toUtc();
    expect(
      dueDate,
      isUtcDateTime,
    );
  });
  test('toLocal', () {
    final dueDate =
        DueDateTime.utc(every: const EveryDueDayMonth(30), year: 2022)
            .toLocal();
    expect(
      dueDate,
      isLocalDateTime,
    );
  });
  group('Add:', () {
    final dueDate = DueDateTime(
      every: const EveryDueDayMonth(30),
      year: 2022,
      hour: 10,
      minute: 11,
      second: 12,
      millisecond: 13,
      microsecond: 14,
    );
    test('Preserves time components', () {
      final result = dueDate.add(const Duration(days: 2));
      expect(result.hour, equals(10));
      expect(result.minute, equals(11));
      expect(result.second, equals(12));
      expect(result.millisecond, equals(13));
      expect(result.microsecond, equals(14));
    });
    test('Preserves time components (UTC)', () {
      final utcDueDate = DueDateTime.utc(
        every: const EveryDueDayMonth(30),
        year: 2022,
        hour: 10,
        minute: 11,
        second: 12,
        millisecond: 13,
        microsecond: 14,
      );
      final result = utcDueDate.add(const Duration(days: 2));
      expect(result, isUtcDateTime);
      expect(result.hour, equals(10));
      expect(result.minute, equals(11));
      expect(result.second, equals(12));
      expect(result.millisecond, equals(13));
      expect(result.microsecond, equals(14));
    });
    final dueDate2 = DueDateTime(every: const EveryDueDayMonth(30), year: 2022);
    test('2 days', () {
      expect(
        dueDate2.add(const Duration(days: 2)),
        isSameDateTime(DateTime(2022, 2, 28)),
      );
    });
    test("2 days, don't keep every", () {
      expect(
        dueDate2.add(const Duration(days: 2), sameEvery: false),
        isSameDateTime(DateTime(2022, 2)),
      );
    });
  });
  group('Subtract:', () {
    final dueDate = DueDateTime(
      every: const EveryDueDayMonth(30),
      year: 2022,
      hour: 10,
      minute: 11,
      second: 12,
      millisecond: 13,
      microsecond: 14,
    );
    test('Preserves time components', () {
      final result = dueDate.subtract(const Duration(days: 2));
      expect(result.hour, equals(10));
      expect(result.minute, equals(11));
      expect(result.second, equals(12));
      expect(result.millisecond, equals(13));
      expect(result.microsecond, equals(14));
    });
    test('Preserves time components (UTC)', () {
      final utcDueDate = DueDateTime.utc(
        every: const EveryDueDayMonth(30),
        year: 2022,
        hour: 10,
        minute: 11,
        second: 12,
        millisecond: 13,
        microsecond: 14,
      );
      final result = utcDueDate.subtract(const Duration(days: 2));
      expect(result, isUtcDateTime);
      expect(result.hour, equals(10));
      expect(result.minute, equals(11));
      expect(result.second, equals(12));
      expect(result.millisecond, equals(13));
      expect(result.microsecond, equals(14));
    });
    final dueDate2 = DueDateTime(every: const EveryDueDayMonth(30), year: 2022);
    test('2 days', () {
      expect(
        dueDate2.subtract(const Duration(days: 2)),
        isSameDateTime(DateTime(2022, 1, 30)),
      );
    });
    test("2 days, don't keep every", () {
      expect(
        dueDate2.subtract(const Duration(days: 2), sameEvery: false),
        isSameDateTime(DateTime(2022, 1, 28)),
      );
    });
  });
  group('AddWeeks:', () {
    final dueDate = DueDateTime(every: const EveryDueDayMonth(30), year: 2022);
    test('1 week', () {
      expect(
        dueDate.addWeeks(1),
        isSameDateTime(DateTime(2022, 2, 28)),
      );
    });
    test('2 weeks', () {
      expect(
        dueDate.addWeeks(2),
        isSameDateTime(DateTime(2022, 2, 28)),
      );
    });
    test("2 weeks, don't keep every", () {
      expect(
        dueDate.addWeeks(2, sameEvery: false),
        isSameDateTime(DateTime(2022, 2, 13)),
      );
    });

    group('With EveryWeek:', () {
      // January 3, 2022 is Monday.
      final dueDateWeek = DueDateTime(
        every: const EveryWeekday(Weekday.monday),
        year: 2022,
        day: 3,
      );

      test('Add 1 week', () {
        // January 10, 2022 is Monday.
        expect(
          dueDateWeek.addWeeks(1),
          isSameDateTime(DateTime(2022, 1, 10)),
        );
      });

      test('Add 2 weeks', () {
        // January 17, 2022 is Monday.
        expect(
          dueDateWeek.addWeeks(2),
          isSameDateTime(DateTime(2022, 1, 17)),
        );
      });

      test("Add 2 weeks, don't keep every", () {
        expect(
          dueDateWeek.addWeeks(2, sameEvery: false),
          isSameDateTime(DateTime(2022, 1, 17)),
        );
      });

      test('Preserves time components', () {
        final dueDateWithTime = DueDateTime(
          every: const EveryWeekday(Weekday.monday),
          year: 2022,
          day: 3,
          hour: 14,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );
        final result = dueDateWithTime.addWeeks(1);
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
      });
    });

    group('With LimitedEvery:', () {
      test('Add weeks when every is LimitedEvery', () {
        // January 3, 2022 is Monday.
        final limitedEvery = EverySkipInvalidModifier(
          every: const EveryWeekday(Weekday.monday),
          invalidator: const DateValidatorWeekday(Weekday.sunday),
        );
        final dueDateLimited = DueDateTime.fromDate(
          DateTime(2022, 1, 3),
          every: limitedEvery,
        );

        // January 10, 2022 is Monday.
        expect(
          dueDateLimited.addWeeks(1),
          isSameDateTime(DateTime(2022, 1, 10)),
        );
      });

      test('Add weeks with LimitedEvery and sameEvery false', () {
        // January 3, 2022 is Monday.
        final limitedEvery = EverySkipInvalidModifier(
          every: const EveryWeekday(Weekday.monday),
          invalidator: const DateValidatorWeekday(Weekday.sunday),
        );
        final dueDateLimited = DueDateTime.fromDate(
          DateTime(2022, 1, 3),
          every: limitedEvery,
        );

        // When sameEvery is false, it should use EveryDueDayMonth instead
        final result = dueDateLimited.addWeeks(1, sameEvery: false);
        expect(result.day, equals(10));
        expect(result.year, equals(2022));
        expect(result.month, equals(1));
      });
    });
  });
  group('SubtractWeeks:', () {
    final dueDate = DueDateTime(every: const EveryDueDayMonth(30), year: 2022);
    test('1 week', () {
      expect(
        dueDate.subtractWeeks(1),
        isSameDateTime(dueDate),
      );
    });
    test('2 weeks', () {
      expect(
        dueDate.subtractWeeks(2),
        isSameDateTime(dueDate),
      );
    });
    test("2 weeks, don't keep every", () {
      expect(
        dueDate.subtractWeeks(2, sameEvery: false),
        isSameDateTime(DateTime(2022, 1, 16)),
      );
    });
  });
  group('AddMonths', () {
    final dueDate = DueDateTime(
      every: const EveryWeekdayCountInMonth(
        day: Weekday.sunday,
        week: Week.last,
      ),
      year: 2022,
    );
    test('Add 1 month', () {
      expect(
        dueDate.addMonths(1),
        isSameDateTime(DateTime(2022, 2, 27)),
      );
    });
    test('Add 3 month', () {
      expect(
        dueDate.addMonths(3),
        isSameDateTime(DateTime(2022, 4, 24)),
      );
    });
    test("Add 3 month don't keep every", () {
      final newDueDate = DueDateTime.fromDate(dueDate.addMonths(3));
      final actual = dueDate.addMonths(3, sameEvery: false);
      expect(actual, isSameDateTime(newDueDate));
      expect(actual.day, equals(24));
      expect(
        (actual.every as EveryDueDayMonth).dueDay,
        equals(24),
      );
    });

    group('With non-month Every types:', () {
      group('EveryWeekday:', () {
        final dueDateWeekday = DueDateTime(
          every: const EveryWeekday(Weekday.monday),
          year: 2022,
          day: 3, // January 3, 2022 is Monday
        );

        test('Add 1 month', () {
          // Should return February 7, 2022 (first Monday in February)
          expect(
            dueDateWeekday.addMonths(1),
            isSameDateTime(DateTime(2022, 2, 7)),
          );
        });

        test('Add 3 months', () {
          // Should return April 4, 2022 (first Monday in April)
          expect(
            dueDateWeekday.addMonths(3),
            isSameDateTime(DateTime(2022, 4, 4)),
          );
        });

        test("Add 3 months, don't keep every", () {
          final newDueDate = DueDateTime.fromDate(dueDateWeekday.addMonths(3));
          final actual = dueDateWeekday.addMonths(3, sameEvery: false);
          expect(actual, isSameDateTime(newDueDate));
          expect(actual.day, equals(4));
          expect(
            (actual.every as EveryDueDayMonth).dueDay,
            equals(4),
          );
        });

        test('Preserves time components', () {
          final dueDateWithTime = DueDateTime(
            every: const EveryWeekday(Weekday.monday),
            year: 2022,
            day: 3,
            hour: 14,
            minute: 30,
            second: 45,
            millisecond: 123,
            microsecond: 456,
          );
          final result = dueDateWithTime.addMonths(1);
          expect(result.hour, equals(14));
          expect(result.minute, equals(30));
          expect(result.second, equals(45));
          expect(result.millisecond, equals(123));
          expect(result.microsecond, equals(456));
        });
      });

      group('EveryDayInYear:', () {
        final dueDateDayInYear = DueDateTime(
          every: const EveryDayInYear(100), // 100th day of the year
          year: 2022,
        );

        test('Add 1 month', () {
          // Starting from April 10, 2022 (100th day), should return next
          // occurrence
          expect(
            dueDateDayInYear.addMonths(1),
            isSameDateTime(DateTime(2023, 4, 10)), // Next year's 100th day
          );
        });

        test('Add 6 months', () {
          // Should return next year's 100th day
          expect(
            dueDateDayInYear.addMonths(6),
            isSameDateTime(DateTime(2023, 4, 10)),
          );
        });

        test("Add 6 months, don't keep every", () {
          final actual = dueDateDayInYear.addMonths(6, sameEvery: false);
          // When sameEvery is false, it uses EveryDueDayMonth(day) logic
          // Starting from 2022-04-10, adding 6 months with day=10 gives
          // 2022-10-10
          expect(actual, isSameDateTime(DateTime(2022, 10, 10)));
          expect(actual.day, equals(10));
          expect(
            (actual.every as EveryDueDayMonth).dueDay,
            equals(10),
          );
        });
      });

      group('With LimitedEvery:', () {
        test('Add months when every is LimitedEvery', () {
          final limitedEvery = EverySkipInvalidModifier(
            every: const EveryWeekday(Weekday.monday),
            invalidator: const DateValidatorWeekday(Weekday.sunday),
          );
          final dueDateLimited = DueDateTime.fromDate(
            DateTime(2022, 1, 3), // Monday
            every: limitedEvery,
          );

          // Should return February 7, 2022 (first Monday in February)
          expect(
            dueDateLimited.addMonths(1),
            isSameDateTime(DateTime(2022, 2, 7)),
          );
        });

        test('Add months with LimitedEvery and sameEvery false', () {
          final limitedEvery = EverySkipInvalidModifier(
            every: const EveryWeekday(Weekday.monday),
            invalidator: const DateValidatorWeekday(Weekday.sunday),
          );
          final dueDateLimited = DueDateTime.fromDate(
            DateTime(2022, 1, 3), // Monday
            every: limitedEvery,
          );

          final result = dueDateLimited.addMonths(1, sameEvery: false);
          // When sameEvery is false, it uses EveryDueDayMonth(day) logic
          // Starting from 2022-01-03, adding 1 month with day=3 gives
          // 2022-02-03
          expect(result, isSameDateTime(DateTime(2022, 2, 3)));
          expect((result.every as EveryDueDayMonth).dueDay, equals(3));
        });
      });
    });
  });
  group('SubtractMonths', () {
    final dueDate = DueDateTime(
      every: const EveryWeekdayCountInMonth(
        day: Weekday.sunday,
        week: Week.last,
      ),
      year: 2022,
    );
    test('Subtract 1 month', () {
      expect(
        dueDate.subtractMonths(1),
        isSameDateTime(DateTime(2021, 12, 26)),
      );
    });
    test('Subtract 11 month', () {
      expect(
        dueDate.subtractMonths(11),
        isSameDateTime(DateTime(2021, 2, 28)),
      );
    });
    test('Subtract 11 month', () {
      final newDueDate = DueDateTime.fromDate(dueDate.subtractMonths(11));
      final actual = dueDate.subtractMonths(11, sameEvery: false);
      expect(actual, isSameDateTime(newDueDate));
      expect(actual.day, equals(28));
      expect(
        dueDate.subtractYears(1).every,
        isNot(newDueDate.every),
      );
    });
  });
  group('SubtractYears:', () {
    test('With EveryDayInYear', () {
      final dueDate = DueDateTime(every: const EveryDayInYear(30), year: 2022);
      final newDueDate = DueDateTime.fromDate(dueDate.subtractYears(1));
      expect(
        dueDate.subtractYears(1),
        isSameDateTime(DateTime(2021, 1, 30)),
      );
      expect(
        dueDate.subtractYears(1, sameEvery: false),
        isSameDateTime(newDueDate),
      );
      expect(
        dueDate.subtractYears(1, sameEvery: false).every,
        isNot(dueDate.every),
      );
    });
  });

  group('AddYears:', () {
    test('With EveryDayInYear', () {
      final dueDate = DueDateTime(every: const EveryDayInYear(30), year: 2022);
      final newDueDate = DueDateTime.fromDate(dueDate.addYears(1));
      expect(
        dueDate.addYears(1),
        isSameDateTime(DateTime(2023, 1, 30)),
      );
      expect(
        dueDate.addYears(1, sameEvery: false),
        isSameDateTime(newDueDate),
      );
      expect(
        dueDate.addYears(1, sameEvery: false).every,
        isNot(dueDate.every),
      );
    });

    group('With non-year Every types:', () {
      group('EveryDueTimeOfDay:', () {
        final dueDateTimeOfDay = DueDateTime(
          every: EveryDueTimeOfDay(const Duration(hours: 14, minutes: 30)),
          year: 2022,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
        );

        test('Add 1 year', () {
          // Should return same time next year
          expect(
            dueDateTimeOfDay.addYears(1),
            isSameDateTime(DateTime(2023, 6, 15, 14, 30)),
          );
        });

        test('Add 2 years', () {
          // Should return same time in 2 years
          expect(
            dueDateTimeOfDay.addYears(2),
            isSameDateTime(DateTime(2024, 6, 15, 14, 30)),
          );
        });

        test("Add 1 year, don't keep every", () {
          final actual = dueDateTimeOfDay.addYears(1, sameEvery: false);
          // When sameEvery is false, it uses EveryDueDayMonth(day) logic
          expect(actual, isSameDateTime(DateTime(2023, 6, 15, 14, 30)));
          expect(actual.day, equals(15));
          expect(
            (actual.every as EveryDueDayMonth).dueDay,
            equals(15),
          );
        });

        test('Preserves time components with every', () {
          final dueDateWithTime = DueDateTime(
            every: EveryDueTimeOfDay(const Duration(hours: 9, minutes: 45)),
            year: 2022,
            month: 3,
            day: 20,
            hour: 8,
            minute: 45,
            second: 30,
            millisecond: 250,
            microsecond: 500,
          );

          final result = dueDateWithTime.addYears(1);
          expect(result.year, equals(2023));
          expect(result.month, equals(3));
          expect(result.day, equals(20));
          expect(result.hour, equals(9));
          expect(result.minute, equals(45));
          expect(result.second, equals(0));
          expect(result.millisecond, equals(0));
          expect(result.microsecond, equals(0));
        });
      });

      group('EveryDueDayMonth:', () {
        final dueDateDayMonth = DueDateTime(
          every: const EveryDueDayMonth(15),
          year: 2022,
          month: 4,
        );

        test('Add 1 year', () {
          // Should return April 15, 2023
          expect(
            dueDateDayMonth.addYears(1),
            isSameDateTime(DateTime(2023, 4, 15)),
          );
        });

        test('Add 5 years', () {
          // Should return April 15, 2027
          expect(
            dueDateDayMonth.addYears(5),
            isSameDateTime(DateTime(2027, 4, 15)),
          );
        });

        test("Add 1 year, don't keep every", () {
          final actual = dueDateDayMonth.addYears(1, sameEvery: false);
          // Should be same since it's already EveryDueDayMonth
          expect(actual, isSameDateTime(DateTime(2023, 4, 15)));
          expect(actual.day, equals(15));
          expect(
            (actual.every as EveryDueDayMonth).dueDay,
            equals(15),
          );
        });
      });
    });
  });
  group('Previous/Next', () {
    group('Local', () {
      test('EveryWeek', () {
        final everyWeekday = DueDateTime(
          every: const EveryWeekday(Weekday.monday),
          year: 2022,
          month: DateTime.august,
          day: 22,
        );
        expect(
          everyWeekday.next(),
          isSameDateTime(DateTime(2022, DateTime.august, 29)),
        );
      });
      test('EveryDueDayMonth', () {
        final everyWeekday = DueDateTime(
          every: const EveryDueDayMonth(22),
          year: 2022,
          month: DateTime.august,
          day: 22,
        );
        expect(
          everyWeekday.next(),
          isSameDateTime(DateTime(2022, DateTime.september, 22)),
        );
      });
      test('EveryWeekdayCountInMonth', () {
        final day = DateTime(2022, DateTime.august, 22);
        final everyWeekday = DueDateTime.fromDate(
          day,
          every: const EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.fourth,
          ),
        );
        final everyWeekday2 = DueDateTime.fromDate(
          day,
          every: WeekdayOccurrence.fourthMonday,
        );
        final matcher = DateTime(2022, DateTime.september, 26);
        expect(everyWeekday.next(), isSameDateTime(matcher));
        expect(everyWeekday2.next(), isSameDateTime(matcher));
      });
      test('EveryDayOfYear', () {
        final day = DateTime(2022, DateTime.august, 22);
        final everyWeekday = DueDateTime.fromDate(
          day,
          every: EveryDayInYear.from(day),
        );
        expect(
          everyWeekday.next(),
          isSameDateTime(DateTime(2023, DateTime.august, 22)),
        );
      });
    });
    group('UTC', () {
      test('EveryWeek', () {
        final everyWeekday = DueDateTime.utc(
          every: const EveryWeekday(Weekday.monday),
          year: 2022,
          month: DateTime.august,
          day: 22,
        );
        expect(
          everyWeekday.next(),
          isSameDateTime(DateTime.utc(2022, DateTime.august, 29)),
        );
      });
      test('EveryDueDayMonth', () {
        final everyWeekday = DueDateTime.utc(
          every: const EveryDueDayMonth(22),
          year: 2022,
          month: DateTime.august,
          day: 22,
        );
        expect(
          everyWeekday.next(),
          isSameDateTime(DateTime.utc(2022, DateTime.september, 22)),
        );
      });
      test('EveryWeekdayCountInMonth', () {
        final day = DateTime.utc(2022, DateTime.august, 22);
        final everyWeekday = DueDateTime.fromDate(
          day,
          every: const EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.fourth,
          ),
        );
        final everyWeekday2 = DueDateTime.fromDate(
          day,
          every: WeekdayOccurrence.fourthMonday,
        );
        final matcher = DateTime.utc(2022, DateTime.september, 26);
        expect(everyWeekday.next(), isSameDateTime(matcher));
        expect(everyWeekday2.next(), isSameDateTime(matcher));
      });
      test('EveryDayOfYear', () {
        final day = DateTime.utc(2022, DateTime.august, 22);
        final everyWeekday = DueDateTime.fromDate(
          day,
          every: EveryDayInYear.from(day),
        );
        expect(
          everyWeekday.next(),
          isSameDateTime(DateTime.utc(2023, DateTime.august, 22)),
        );
      });
    });

    group('LimitedEvery', () {
      group('next', () {
        test('EverySkipInvalidModifier Local', () {
          // February 28, 2022 is Monday.
          final limitedEvery = EverySkipInvalidModifier(
            every: const EveryWeekday(Weekday.monday),
            invalidator: const DateValidatorWeekday(Weekday.sunday),
          );
          final dueDate = DueDateTime.fromDate(
            DateTime(2022, 2, 28),
            every: limitedEvery,
          );
          // Next Monday is March 7, 2022.
          expect(
            dueDate.next(),
            isSameDateTime(DateTime(2022, 3, 7)),
          );
        });

        test('EverySkipInvalidModifier UTC', () {
          // February 28, 2022 is Monday.
          final limitedEvery = EverySkipInvalidModifier(
            every: const EveryWeekday(Weekday.monday),
            invalidator: const DateValidatorWeekday(Weekday.sunday),
          );
          final dueDate = DueDateTime.fromDate(
            DateTime.utc(2022, 2, 28),
            every: limitedEvery,
          );
          // Next Monday is March 7, 2022.
          expect(
            dueDate.next(),
            isSameDateTime(DateTime.utc(2022, 3, 7)),
          );
        });

        test('EverySkipCountWrapper Local', () {
          // August 22, 2022 is Monday.
          final limitedEvery = EverySkipCountWrapper(
            every: const EveryWeekday(Weekday.monday),
            count: 1,
          );
          final dueDate = DueDateTime.fromDate(
            DateTime(2022, DateTime.august, 22),
            every: limitedEvery,
          );
          // Skip one Monday, next is September 5, 2022.
          expect(
            dueDate.next(),
            isSameDateTime(DateTime(2022, DateTime.september, 5)),
          );
        });

        test('EverySkipCountWrapper UTC', () {
          // August 22, 2022 is Monday.
          final limitedEvery = EverySkipCountWrapper(
            every: const EveryWeekday(Weekday.monday),
            count: 1,
          );
          final dueDate = DueDateTime.fromDate(
            DateTime.utc(2022, DateTime.august, 22),
            every: limitedEvery,
          );
          // Skip one Monday, next is September 5, 2022.
          expect(
            dueDate.next(),
            isSameDateTime(DateTime.utc(2022, DateTime.september, 5)),
          );
        });
      });
    });

    group('previous', () {
      group('Local', () {
        test('EveryWeek', () {
          final everyWeekday = DueDateTime(
            every: const EveryWeekday(Weekday.monday),
            year: 2022,
            month: DateTime.august,
            day: 29,
          );
          // Previous Monday is August 22, 2022.
          expect(
            everyWeekday.previous(),
            isSameDateTime(DateTime(2022, DateTime.august, 22)),
          );
        });

        test('EveryDueDayMonth', () {
          final everyDueDay = DueDateTime(
            every: const EveryDueDayMonth(22),
            year: 2022,
            month: DateTime.september,
            day: 22,
          );
          // Previous 22nd is August 22, 2022.
          expect(
            everyDueDay.previous(),
            isSameDateTime(DateTime(2022, DateTime.august, 22)),
          );
        });

        test('EveryWeekdayCountInMonth', () {
          final day = DateTime(2022, DateTime.september, 26);
          final everyWeekday = DueDateTime.fromDate(
            day,
            every: const EveryWeekdayCountInMonth(
              day: Weekday.monday,
              week: Week.fourth,
            ),
          );
          final everyWeekday2 = DueDateTime.fromDate(
            day,
            every: WeekdayOccurrence.fourthMonday,
          );
          // Previous fourth Monday is August 22, 2022.
          final matcher = DateTime(2022, DateTime.august, 22);
          expect(everyWeekday.previous(), isSameDateTime(matcher));
          expect(everyWeekday2.previous(), isSameDateTime(matcher));
        });

        test('EveryDayOfYear', () {
          final day = DateTime(2023, DateTime.august, 22);
          final everyYearDay = DueDateTime.fromDate(
            day,
            every: EveryDayInYear.from(day),
          );
          // Previous year's same day is August 22, 2022.
          expect(
            everyYearDay.previous(),
            isSameDateTime(DateTime(2022, DateTime.august, 22)),
          );
        });
      });

      group('UTC', () {
        test('EveryWeek', () {
          final everyWeekday = DueDateTime.utc(
            every: const EveryWeekday(Weekday.monday),
            year: 2022,
            month: DateTime.august,
            day: 29,
          );
          // Previous Monday is August 22, 2022.
          expect(
            everyWeekday.previous(),
            isSameDateTime(DateTime.utc(2022, DateTime.august, 22)),
          );
        });

        test('EveryDueDayMonth', () {
          final everyDueDay = DueDateTime.utc(
            every: const EveryDueDayMonth(22),
            year: 2022,
            month: DateTime.september,
            day: 22,
          );
          // Previous 22nd is August 22, 2022.
          expect(
            everyDueDay.previous(),
            isSameDateTime(DateTime.utc(2022, DateTime.august, 22)),
          );
        });

        test('EveryWeekdayCountInMonth', () {
          final day = DateTime.utc(2022, DateTime.september, 26);
          final everyWeekday = DueDateTime.fromDate(
            day,
            every: const EveryWeekdayCountInMonth(
              day: Weekday.monday,
              week: Week.fourth,
            ),
          );
          final everyWeekday2 = DueDateTime.fromDate(
            day,
            every: WeekdayOccurrence.fourthMonday,
          );
          // Previous fourth Monday is August 22, 2022.
          final matcher = DateTime.utc(2022, DateTime.august, 22);
          expect(everyWeekday.previous(), isSameDateTime(matcher));
          expect(everyWeekday2.previous(), isSameDateTime(matcher));
        });

        test('EveryDayOfYear', () {
          final day = DateTime.utc(2023, DateTime.august, 22);
          final everyYearDay = DueDateTime.fromDate(
            day,
            every: EveryDayInYear.from(day),
          );
          // Previous year's same day is August 22, 2022.
          expect(
            everyYearDay.previous(),
            isSameDateTime(DateTime.utc(2022, DateTime.august, 22)),
          );
        });
      });

      group('LimitedEvery', () {
        test('EverySkipInvalidModifier Local', () {
          // March 7, 2022 is Monday.
          final limitedEvery = EverySkipInvalidModifier(
            every: const EveryWeekday(Weekday.monday),
            invalidator: const DateValidatorWeekday(Weekday.sunday),
          );
          final dueDate = DueDateTime.fromDate(
            DateTime(2022, 3, 7),
            every: limitedEvery,
          );
          // Previous Monday is February 28, 2022.
          expect(
            dueDate.previous(),
            isSameDateTime(DateTime(2022, 2, 28)),
          );
        });

        test('EverySkipInvalidModifier UTC', () {
          // March 7, 2022 is Monday.
          final limitedEvery = EverySkipInvalidModifier(
            every: const EveryWeekday(Weekday.monday),
            invalidator: const DateValidatorWeekday(Weekday.sunday),
          );
          final dueDate = DueDateTime.fromDate(
            DateTime.utc(2022, 3, 7),
            every: limitedEvery,
          );
          // Previous Monday is February 28, 2022.
          expect(
            dueDate.previous(),
            isSameDateTime(DateTime.utc(2022, 2, 28)),
          );
        });

        test('EverySkipCountWrapper Local', () {
          // September 5, 2022 is Monday.
          final limitedEvery = EverySkipCountWrapper(
            every: const EveryWeekday(Weekday.monday),
            count: 1,
          );
          final dueDate = DueDateTime.fromDate(
            DateTime(2022, DateTime.september, 5),
            every: limitedEvery,
          );
          expect(
            dueDate.previous(),
            isSameDateTime(DateTime(2022, DateTime.august, 22)),
          );
        });

        test('EverySkipCountWrapper UTC', () {
          // September 5, 2022 is Monday.
          final limitedEvery = EverySkipCountWrapper(
            every: const EveryWeekday(Weekday.monday),
            count: 1,
          );
          final dueDate = DueDateTime.fromDate(
            DateTime.utc(2022, DateTime.september, 5),
            every: limitedEvery,
          );
          // Skip one Monday back, previous is August 22, 2022.
          expect(
            dueDate.previous(),
            isSameDateTime(DateTime.utc(2022, DateTime.august, 22)),
          );
        });
      });
    });
  });
  group('Equality', () {
    // Base instance for comparison.
    final baseInstance = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 15,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    // Same values as base instance.
    final sameInstance = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 15,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    // Different every.
    final differentEvery = DueDateTime(
      every: EveryDueDayMonth(30),
      year: 2022,
      month: 6,
      day: 30,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    // Different year.
    final differentYear = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2023,
      month: 6,
      day: 15,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    // Different month.
    final differentMonth = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 7,
      day: 15,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    // Different day.
    final differentDay = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 16,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    // Different hour.
    final differentHour = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 15,
      hour: 11,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    // Different minute.
    final differentMinute = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 15,
      hour: 10,
      minute: 31,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    // Different second.
    final differentSecond = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 15,
      hour: 10,
      minute: 30,
      second: 46,
      millisecond: 123,
      microsecond: 456,
    );

    // Different millisecond.
    final differentMillisecond = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 15,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 124,
      microsecond: 456,
    );

    // Different microsecond.
    final differentMicrosecond = DueDateTime(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 15,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 457,
    );

    // Different UTC flag.
    final differentUtc = DueDateTime.utc(
      every: EveryDueDayMonth(15),
      year: 2022,
      month: 6,
      day: 15,
      hour: 10,
      minute: 30,
      second: 45,
      millisecond: 123,
      microsecond: 456,
    );

    test('Same instance', () {
      expect(baseInstance, isSameDueDateTime(baseInstance));
    });

    test('Same values are equal', () {
      expect(baseInstance, isSameDueDateTime(sameInstance));
    });

    test('Different every', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentEvery)));
    });

    test('Different year', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentYear)));
    });

    test('Different month', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentMonth)));
    });

    test('Different day', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentDay)));
    });

    test('Different hour', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentHour)));
    });

    test('Different minute', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentMinute)));
    });

    test('Different second', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentSecond)));
    });

    test('Different millisecond', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentMillisecond)));
    });

    test('Different microsecond', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentMicrosecond)));
    });

    test('Different UTC flag', () {
      expect(baseInstance, isNot(isSameDueDateTime(differentUtc)));
    });

    group('HashCode consistency', () {
      test('Same values have same hashCode', () {
        expect(baseInstance.hashCode, equals(sameInstance.hashCode));
      });

      test('Different every has different hashCode', () {
        expect(baseInstance.hashCode, isNot(equals(differentEvery.hashCode)));
      });

      test('Different year has different hashCode', () {
        expect(baseInstance.hashCode, isNot(equals(differentYear.hashCode)));
      });

      test('Different UTC flag has different hashCode', () {
        expect(baseInstance.hashCode, isNot(equals(differentUtc.hashCode)));
      });
    });

    group('Different Every types', () {
      final everyWeekday = DueDateTime(
        every: EveryWeekday(Weekday.monday),
        year: 2022,
        month: 6,
        day: 13, // Monday in June 2022.
        hour: 10,
        minute: 30,
        second: 45,
        millisecond: 123,
        microsecond: 456,
      );

      final everyDayInYear = DueDateTime(
        every: EveryDayInYear(166), // June 15th in non-leap year.
        year: 2022,
        month: 6,
        day: 15,
        hour: 10,
        minute: 30,
        second: 45,
        millisecond: 123,
        microsecond: 456,
      );

      test('EveryDueDayMonth vs EveryWeekday', () {
        expect(baseInstance, isNot(isSameDueDateTime(everyWeekday)));
      });

      test('EveryDueDayMonth vs EveryDayInYear', () {
        expect(baseInstance, isNot(isSameDueDateTime(everyDayInYear)));
      });

      test('EveryWeekday vs EveryDayInYear', () {
        expect(everyWeekday, isNot(isSameDueDateTime(everyDayInYear)));
      });
    });

    group('Subclass equality', () {
      // Custom implementation for testing inheritance equality.
      final implementationInstance = _TestDueDateTimeImplementation.create(
        every: EveryDueDayMonth(15),
        year: 2022,
        month: 6,
        day: 15,
        hour: 10,
        minute: 30,
        second: 45,
        millisecond: 123,
        microsecond: 456,
      );

      // Implementation with different additional property.
      final implementationWithDifferentProperty =
          _TestDueDateTimeImplementation.create(
        every: EveryDueDayMonth(15),
        year: 2022,
        month: 6,
        day: 15,
        hour: 10,
        minute: 30,
        second: 45,
        millisecond: 123,
        microsecond: 456,
        customProperty: 'different',
      );

      test('DueDateTime vs implementation with same values', () {
        // Base DueDateTime should not equal implementation, even with same core
        // values, since they are different types.
        expect(baseInstance, isNot(equals(implementationInstance)));
      });

      test('Implementation vs DueDateTime with same values', () {
        // Implementation should not equal base DueDateTime, even with same core
        // values, since they are different types.
        expect(implementationInstance, isNot(equals(baseInstance)));
      });

      test('Same implementation instances with same values', () {
        final anotherImplementationInstance =
            _TestDueDateTimeImplementation.create(
          every: EveryDueDayMonth(15),
          year: 2022,
          month: 6,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );
        expect(implementationInstance, equals(anotherImplementationInstance));
      });

      test('Same implementation with different additional properties', () {
        expect(
          implementationInstance,
          isNot(equals(implementationWithDifferentProperty)),
        );
      });

      test('Implementation hashCode consistency', () {
        final anotherImplementationInstance =
            _TestDueDateTimeImplementation.create(
          every: EveryDueDayMonth(15),
          year: 2022,
          month: 6,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );
        expect(
          implementationInstance.hashCode,
          equals(anotherImplementationInstance.hashCode),
        );
      });

      test('Implementation different from base class hashCode', () {
        // Implementation and base class should have different hashCodes.
        expect(
          implementationInstance.hashCode,
          isNot(equals(baseInstance.hashCode)),
        );
      });
    });
  });
  group('toString:', () {
    test('Shows date and every', () {
      final dueDate = DueDateTime(
        every: const EveryDueDayMonth(15),
        year: 2022,
        month: 6,
        day: 15,
        hour: 14,
        minute: 30,
        second: 45,
        millisecond: 123,
        microsecond: 456,
      );
      // The toString method formats: date.add(timeOfDay) - every
      const expectedString =
          '2022-06-15 14:30:45.123456 - EveryDueDayMonth<15>';
      expect(dueDate.toString(), equals(expectedString));
    });

    test('Shows UTC date and every', () {
      final dueDate = DueDateTime.utc(
        every: const EveryWeekday(Weekday.monday),
        year: 2022,
        month: 8,
        day: 22,
        hour: 9,
        minute: 15,
      );
      // UTC dates should show Z suffix
      const expectedString =
          '2022-08-22 09:15:00.000Z - EveryWeekday<Weekday.monday>';
      expect(dueDate.toString(), equals(expectedString));
    });

    test('Shows different Every types correctly', () {
      final dueDateWorkday = DueDateTime(
        every: const EveryDueWorkdayMonth(5),
        year: 2022,
        month: 3,
        day: 7, // 5th workday in March 2022
      );
      expect(
        dueDateWorkday.toString(),
        contains('EveryDueWorkdayMonth<5>'),
      );

      final dueDateDayInYear = DueDateTime(
        every: const EveryDayInYear(100),
        year: 2022,
        month: 4,
        day: 10, // 100th day of 2022
      );
      expect(
        dueDateDayInYear.toString(),
        contains('EveryDayInYear<100>'),
      );
    });

    test('Shows midnight time correctly', () {
      final dueDateMidnight = DueDateTime(
        every: const EveryDueDayMonth(1),
        year: 2022,
      );
      expect(
        dueDateMidnight.toString(),
        contains('2022-01-01 00:00:00.000'),
      );
    });
  });
}

/// Test class that implements [DueDateTime] for equality testing.
/// Uses composition and implements required getters explicitly.
class _TestDueDateTimeImplementation implements DueDateTime {
  /// Creates a test implementation instance.
  _TestDueDateTimeImplementation({
    required DueDateTime dueDateTime,
    this.customProperty = 'default',
  }) : _wrappedDueDateTime = dueDateTime;

  /// Factory constructor that creates an implementation instance.
  factory _TestDueDateTimeImplementation.create({
    required Every every,
    required int year,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    bool utc = false,
    String customProperty = 'default',
  }) {
    // Create the base DueDateTime instance.
    final baseDueDateTime = DueDateTime(
      every: every,
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
      utc: utc,
    );

    return _TestDueDateTimeImplementation(
      dueDateTime: baseDueDateTime,
      customProperty: customProperty,
    );
  }

  /// The wrapped DueDateTime instance.
  final DueDateTime _wrappedDueDateTime;

  /// Additional property to test implementation equality.
  final String customProperty;

  // Implement required getters from DueDateTime/DateTime.
  @override
  Every get every => _wrappedDueDateTime.every;

  @override
  int get year => _wrappedDueDateTime.year;

  @override
  int get month => _wrappedDueDateTime.month;

  @override
  int get day => _wrappedDueDateTime.day;

  @override
  int get hour => _wrappedDueDateTime.hour;

  @override
  int get minute => _wrappedDueDateTime.minute;

  @override
  int get second => _wrappedDueDateTime.second;

  @override
  int get millisecond => _wrappedDueDateTime.millisecond;

  @override
  int get microsecond => _wrappedDueDateTime.microsecond;

  @override
  bool get isUtc => _wrappedDueDateTime.isUtc;

  @override
  List<Object> get props => [
        every,
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
        isUtc,
        // Additional property for testing.
        customProperty,
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! _TestDueDateTimeImplementation) return false;
    return const DeepCollectionEquality().equals(props, other.props);
  }

  @override
  int get hashCode => Object.hashAll(props);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return _wrappedDueDateTime.noSuchMethod(invocation);
  }
}
