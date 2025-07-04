// ignore_for_file: prefer_const_constructors
import 'package:clock/clock.dart';
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
        expect(DueDateTime.now(), isSameDueDateTime(now));
      });
    });
    group('FromDate:', () {
      final matcher = DateTime.utc(year, 2, 28);
      test('No every', () {
        expect(DueDateTime.fromDate(matcher), equals(matcher));
      });
      test('With every', () {
        expect(DueDateTime.fromDate(matcher, every: dueDay30), equals(matcher));
      });
    });
  });
  group('Parsing:', () {
    test('January 1st, 2022', () {
      expect(DueDateTime.parse('2022-01-01'), equals(DateTime(2022)));
    });
    test('FormatException', () {
      expect(() => DueDateTime.parse(''), throwsFormatException);
    });
    test('With every', () {
      expect(
        DueDateTime.parse('2022-01-01', every: dueDay15),
        equals(DateTime(2022, 1, 15)),
      );
    });
    test('Malformed date string', () {
      expect(() => DueDateTime.parse('not-a-date'), throwsFormatException);
      expect(DueDateTime.tryParse('not-a-date'), equals(null));
    });
  });
  group('Trying to Parse:', () {
    test('January 1st, 2022', () {
      expect(DueDateTime.tryParse('2022-01-01'), equals(DateTime(2022)));
    });
    test('Returns null', () {
      expect(DueDateTime.tryParse(''), equals(null));
    });
    test('With every', () {
      expect(
        DueDateTime.tryParse('2022-01-01', every: dueDay15),
        equals(DateTime(2022, 1, 15)),
      );
    });
  });
  group('FromMillisecondsSinceEpoch:', () {
    final date = DateTime(2022);
    test('January 1st, 2022', () {
      expect(
        DueDateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch),
        equals(date),
      );
    });
    test('With every', () {
      expect(
        DueDateTime.fromMillisecondsSinceEpoch(
          date.millisecondsSinceEpoch,
          every: dueDay15,
        ),
        equals(DateTime(2022, 1, 15)),
      );
    });
    test('With every UTC', () {
      expect(
        DueDateTime.fromMillisecondsSinceEpoch(
          date.millisecondsSinceEpoch,
          every: dueDay15,
          isUtc: true,
        ),
        equals(DateTime(2022, 1, 15).toUtc()),
      );
    });
  });
  group('FromMicrosecondsSinceEpoch:', () {
    final date = DateTime(2022);
    test('January 1st, 2022', () {
      expect(
        DueDateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch),
        equals(date),
      );
    });
    test('With every', () {
      expect(
        DueDateTime.fromMicrosecondsSinceEpoch(
          date.microsecondsSinceEpoch,
          every: dueDay15,
        ),
        equals(DateTime(2022, 1, 15)),
      );
    });
    test('With every UTC', () {
      expect(
        DueDateTime.fromMicrosecondsSinceEpoch(
          date.microsecondsSinceEpoch,
          every: dueDay15,
          isUtc: true,
        ),
        equals(DateTime(2022, 1, 15).toUtc()),
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
        equals(DateTime(2022, 1, 15)),
      );
    });
    test('Different year', () {
      expect(
        dueDate2.copyWith(year: 2021),
        equals(DateTime(2021)),
      );
    });
    test('Different month', () {
      expect(
        dueDate2.copyWith(month: 2),
        equals(DateTime(2022, 2)),
      );
    });
    test('Different day', () {
      expect(
        dueDate2.copyWith(day: 2),
        equals(DateTime(2022, 2)),
      );
    });
    test('Different hour', () {
      expect(
        dueDate2.copyWith(hour: 1),
        equals(DateTime(2022, 1, 1, 1)),
      );
    });
    test('Different minute', () {
      expect(
        dueDate2.copyWith(minute: 1),
        equals(DateTime(2022, 1, 1, 0, 1)),
      );
    });
    test('Different second', () {
      expect(
        dueDate2.copyWith(second: 1),
        equals(DateTime(2022, 1, 1, 0, 0, 1)),
      );
    });
    test('Different millisecond', () {
      expect(
        dueDate2.copyWith(millisecond: 1),
        equals(DateTime(2022, 1, 1, 0, 0, 0, 1)),
      );
    });
    test('Different microsecond', () {
      expect(
        dueDate2.copyWith(microsecond: 1),
        equals(DateTime(2022, 1, 1, 0, 0, 0, 0, 1)),
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
        equals(DateTime(2022, 2, 28)),
      );
    });
    test("2 days, don't keep every", () {
      expect(
        dueDate2.add(const Duration(days: 2), sameEvery: false),
        equals(DateTime(2022, 2)),
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
        equals(DateTime(2022, 1, 30)),
      );
    });
    test("2 days, don't keep every", () {
      expect(
        dueDate2.subtract(const Duration(days: 2), sameEvery: false),
        equals(DateTime(2022, 1, 28)),
      );
    });
  });
  group('AddWeeks:', () {
    final dueDate = DueDateTime(every: const EveryDueDayMonth(30), year: 2022);
    test('1 week', () {
      expect(
        dueDate.addWeeks(1),
        equals(DateTime(2022, 2, 28)),
      );
    });
    test('2 weeks', () {
      expect(
        dueDate.addWeeks(2),
        equals(DateTime(2022, 2, 28)),
      );
    });
    test("2 weeks, don't keep every", () {
      expect(
        dueDate.addWeeks(2, sameEvery: false),
        equals(DateTime(2022, 2, 13)),
      );
    });
  });
  group('SubtractWeeks:', () {
    final dueDate = DueDateTime(every: const EveryDueDayMonth(30), year: 2022);
    test('1 week', () {
      expect(
        dueDate.subtractWeeks(1),
        equals(dueDate),
      );
    });
    test('2 weeks', () {
      expect(
        dueDate.subtractWeeks(2),
        equals(dueDate),
      );
    });
    test("2 weeks, don't keep every", () {
      expect(
        dueDate.subtractWeeks(2, sameEvery: false),
        equals(DateTime(2022, 1, 16)),
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
        equals(DateTime(2022, 2, 27)),
      );
    });
    test('Add 3 month', () {
      expect(
        dueDate.addMonths(3),
        equals(DateTime(2022, 4, 24)),
      );
    });
    test("Add 3 month don't keep every", () {
      final newDueDate = DueDateTime.fromDate(dueDate.addMonths(3));
      final actual = dueDate.addMonths(3, sameEvery: false);
      expect(actual, equals(newDueDate));
      expect(actual.day, equals(24));
      expect(
        (actual.every as EveryDueDayMonth).dueDay,
        equals(24),
      );
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
        equals(DateTime(2021, 12, 26)),
      );
    });
    test('Subtract 11 month', () {
      expect(
        dueDate.subtractMonths(11),
        equals(DateTime(2021, 2, 28)),
      );
    });
    test('Subtract 11 month', () {
      final newDueDate = DueDateTime.fromDate(dueDate.subtractMonths(11));
      final actual = dueDate.subtractMonths(11, sameEvery: false);
      expect(actual, equals(newDueDate));
      expect(actual.day, equals(28));
      expect(
        dueDate.subtractYears(1).every,
        isNot(newDueDate.every),
      );
    });
  });
  test('Subtract 1 year', () {
    final dueDate = DueDateTime(every: const EveryDayInYear(30), year: 2022);
    final newDueDate = DueDateTime.fromDate(dueDate.subtractYears(1));
    expect(
      dueDate.subtractYears(1),
      equals(DateTime(2021, 1, 30)),
    );
    expect(
      dueDate.subtractYears(1, sameEvery: false),
      equals(newDueDate),
    );
    expect(
      dueDate.subtractYears(1, sameEvery: false).every,
      isNot(dueDate.every),
    );
  });
  test('Add 1 year', () {
    final dueDate = DueDateTime(every: const EveryDayInYear(30), year: 2022);
    final newDueDate = DueDateTime.fromDate(dueDate.addYears(1));
    expect(
      dueDate.addYears(1),
      equals(DateTime(2023, 1, 30)),
    );
    expect(
      dueDate.addYears(1, sameEvery: false),
      equals(newDueDate),
    );
    expect(
      dueDate.addYears(1, sameEvery: false).every,
      isNot(dueDate.every),
    );
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
          equals(DateTime(2022, DateTime.august, 29)),
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
          equals(DateTime(2022, DateTime.september, 22)),
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
        expect(everyWeekday.next(), equals(matcher));
        expect(everyWeekday2.next(), equals(matcher));
      });
      test('EveryDayOfYear', () {
        final day = DateTime(2022, DateTime.august, 22);
        final everyWeekday = DueDateTime.fromDate(
          day,
          every: EveryDayInYear.from(day),
        );
        expect(
          everyWeekday.next(),
          equals(DateTime(2023, DateTime.august, 22)),
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
          equals(DateTime.utc(2022, DateTime.august, 29)),
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
          equals(DateTime.utc(2022, DateTime.september, 22)),
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
        expect(everyWeekday.next(), equals(matcher));
        expect(everyWeekday2.next(), equals(matcher));
      });
      test('EveryDayOfYear', () {
        final day = DateTime.utc(2022, DateTime.august, 22);
        final everyWeekday = DueDateTime.fromDate(
          day,
          every: EveryDayInYear.from(day),
        );
        expect(
          everyWeekday.next(),
          equals(DateTime.utc(2023, DateTime.august, 22)),
        );
      });
    });
  });
  group('Equality', () {
    // Equality group for DueDateTime.
    final a = DueDateTime(
      every: const EveryDueDayMonth(15),
      year: 2022,
      day: 15,
    );
    final b = DueDateTime(
      every: const EveryDueDayMonth(15),
      year: 2022,
      day: 15,
    );
    final c = DueDateTime(
      every: const EveryDueDayMonth(30),
      year: 2022,
      day: 30,
    );
    final d = DueDateTime(
      every: const EveryDueDayMonth(15),
      year: 2023,
      day: 15,
    );
    test('Same values are equal', () {
      expect(a, isSameDueDateTime(b));
    });
    test('Different every', () {
      expect(a, isNot(isSameDueDateTime(c)));
    });
    test('Different year', () {
      expect(a, isNot(isSameDueDateTime(d)));
    });
    test('Same instance', () {
      expect(a, isSameDueDateTime(a));
    });
  });
}
