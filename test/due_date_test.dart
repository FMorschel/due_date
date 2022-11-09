import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  const dueDay15 = EveryDueDayMonth(15);
  group('Constructors:', () {
    const year = 2022;
    const dueDay30 = EveryDueDayMonth(30);
    group('Unnamed:', () {
      final matcher = DateTime(year, 2, 28);
      test('Month start', () {
        expect(
          DueDateTime(every: dueDay30, year: year, month: 2),
          equals(matcher),
        );
      });
      test('Fits in month', () {
        final matcherFitted = DateTime(year, 2, 15);
        expect(
          DueDateTime(every: dueDay15, year: year, month: 2),
          equals(matcherFitted),
        );
      });
      test('Midlle of the month', () {
        expect(
          DueDateTime(every: dueDay30, year: year, month: 2, day: 15),
          equals(matcher),
        );
      });
      test('Previous month end', () {
        expect(
          DueDateTime(every: dueDay30, year: year, month: 1, day: 31),
          equals(matcher),
        );
      });
      test('Not UTC', () {
        expect(
          DueDateTime(every: dueDay30, year: year).isUtc,
          isFalse,
        );
      });
    });
    group('UTC:', () {
      final matcher = DateTime.utc(year, 2, 28);
      test('Month start', () {
        expect(
          DueDateTime.utc(every: dueDay30, year: year, month: 2),
          equals(matcher),
        );
      });
      test('Fits in month', () {
        final matcherFitted = DateTime.utc(year, 2, 15);
        expect(
          DueDateTime.utc(every: dueDay15, year: year, month: 2),
          equals(matcherFitted),
        );
      });
      test('Midlle of the month', () {
        expect(
          DueDateTime.utc(every: dueDay30, year: year, month: 2, day: 15),
          equals(matcher),
        );
      });
      test('Previous month end', () {
        expect(
          DueDateTime.utc(every: dueDay30, year: year, month: 1, day: 31),
          equals(matcher),
        );
      });
      test('Is UTC', () {
        expect(
          DueDateTime.utc(every: dueDay30, year: year).isUtc,
          isTrue,
        );
      });
    });
    test('Now', () {
      expect(DueDateTime.now(), equals(DateTime.now()));
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
    final dueDate = DueDateTime.fromDate(DateTime(2022));
    test('Different every', () {
      expect(
        dueDate.copyWith(every: dueDay15),
        equals(DateTime(2022, 1, 15)),
      );
    });
    test('Different year', () {
      expect(
        dueDate.copyWith(year: 2021),
        equals(DateTime(2021)),
      );
    });
    test('Different month', () {
      expect(
        dueDate.copyWith(month: 2),
        equals(DateTime(2022, 2)),
      );
    });
    test('Different day', () {
      expect(
        dueDate.copyWith(day: 2),
        equals(DateTime(2022, 2, 1)),
      );
    });
    test('Different hour', () {
      expect(
        dueDate.copyWith(hour: 1),
        equals(DateTime(2022, 1, 1, 1)),
      );
    });
    test('Different minute', () {
      expect(
        dueDate.copyWith(minute: 1),
        equals(DateTime(2022, 1, 1, 0, 1)),
      );
    });
    test('Different second', () {
      expect(
        dueDate.copyWith(second: 1),
        equals(DateTime(2022, 1, 1, 0, 0, 1)),
      );
    });
    test('Different millisecond', () {
      expect(
        dueDate.copyWith(millisecond: 1),
        equals(DateTime(2022, 1, 1, 0, 0, 0, 1)),
      );
    });
    test('Different microsecond', () {
      expect(
        dueDate.copyWith(microsecond: 1),
        equals(DateTime(2022, 1, 1, 0, 0, 0, 0, 1)),
      );
    });
  });
  test('toUtc', () {
    final dueDate =
        DueDateTime(every: EveryDueDayMonth(30), year: 2022).toUtc();
    expect(
      dueDate.isUtc,
      isTrue,
    );
  });
  test('toLocal', () {
    final dueDate =
        DueDateTime.utc(every: EveryDueDayMonth(30), year: 2022).toLocal();
    expect(
      dueDate.isUtc,
      isFalse,
    );
  });
  group('Add:', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
    test('2 days', () {
      expect(
        dueDate.add(const Duration(days: 2)),
        equals(DateTime(2022, 2, 28)),
      );
    });
    test('2 days, don\'t keep every', () {
      expect(
        dueDate.add(const Duration(days: 2), sameEvery: false),
        equals(DateTime(2022, 2, 1)),
      );
    });
  });
  group('Subtract:', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
    test('2 days', () {
      expect(
        dueDate.subtract(const Duration(days: 2)),
        equals(DateTime(2022, 1, 30)),
      );
    });
    test('2 days, don\'t keep every', () {
      expect(
        dueDate.subtract(const Duration(days: 2), sameEvery: false),
        equals(DateTime(2022, 1, 28)),
      );
    });
  });
  group('AddWeeks:', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
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
    test('2 weeks, don\'t keep every', () {
      expect(
        dueDate.addWeeks(2, sameEvery: false),
        equals(DateTime(2022, 2, 13)),
      );
    });
  });
  group('SubtractWeeks:', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
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
    test('2 weeks, don\'t keep every', () {
      expect(
        dueDate.subtractWeeks(2, sameEvery: false),
        equals(DateTime(2022, 1, 16)),
      );
    });
  });
  group('AddMonths', () {
    final dueDate = DueDateTime(
      every: EveryWeekdayCountInMonth(
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
    test('Add 3 month don\'t keep every', () {
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
      every: EveryWeekdayCountInMonth(
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
    final dueDate = DueDateTime(every: EveryDayInYear(30), year: 2022);
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
    final dueDate = DueDateTime(every: EveryDayInYear(30), year: 2022);
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
          every: EveryWeekday(Weekday.monday),
          year: 2022,
          month: DateTime.august,
          day: 22,
        );
        expect(everyWeekday.next(), equals(DateTime(2022, DateTime.august, 29)));
      });
      test('EveryDueDayMonth', () {
        final everyWeekday = DueDateTime(
          every: EveryDueDayMonth(22),
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
          every: EveryWeekdayCountInMonth(
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
          every: EveryWeekday(Weekday.monday),
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
          every: EveryDueDayMonth(22),
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
          every: EveryWeekdayCountInMonth(
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
}
