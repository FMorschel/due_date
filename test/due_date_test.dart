import 'package:due_date/due_date.dart';
import 'package:due_date/src/every.dart';
import 'package:test/test.dart';

void main() {
  const dueDay15 = EveryDueDayMonth(15);
  group('Constructors:', () {
    const year = 2022;
    const dueDay30 = EveryDueDayMonth(30);
    group('Unnamed:', () {
      group('EveryDueDay:', () {
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
      group('EveryDayOfWeek:', () {
        const lastMonday =
            EveryDayOfWeekInMonth(day: Weekday.monday, week: Week.last);
        final matcher = DateTime(year, 2, 28);
        test('Month start', () {
          expect(
            DueDateTime(every: lastMonday, year: year, month: 2),
            equals(matcher),
          );
        });
        group('Midlle of the month:', () {
          test('First Friday', () {
            final firstFirday = EveryDayOfWeekInMonth(
              week: Week.first,
              day: Weekday.friday,
            );
            expect(
              DueDateTime(every: firstFirday, year: year, month: 2, day: 15),
              equals(DateTime(year, 3, 4)),
            );
          });
          test('Last Monday', () {
            expect(
              DueDateTime(every: lastMonday, year: year, month: 2, day: 15),
              equals(matcher),
            );
          });
        });
        test('Not UTC', () {
          expect(
            DueDateTime(every: dueDay30, year: year).isUtc,
            isFalse,
          );
        });
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
      test('Not UTC', () {
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
      test('No DueDay', () {
        expect(DueDateTime.fromDate(matcher), equals(matcher));
      });
      test('With DueDay', () {
        expect(DueDateTime.fromDate(matcher, dueDay30), equals(matcher));
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
    test('With DueDay', () {
      expect(
        DueDateTime.parse('2022-01-01', dueDay15),
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
    test('With DueDay', () {
      expect(
        DueDateTime.tryParse('2022-01-01', dueDay15),
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
    test('With DueDay', () {
      expect(
        DueDateTime.fromMillisecondsSinceEpoch(
          date.millisecondsSinceEpoch,
          every: dueDay15,
        ),
        equals(DateTime(2022, 1, 15)),
      );
    });
    test('With DueDay UTC', () {
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
    test('With DueDay', () {
      expect(
        DueDateTime.fromMicrosecondsSinceEpoch(
          date.microsecondsSinceEpoch,
          every: dueDay15,
        ),
        equals(DateTime(2022, 1, 15)),
      );
    });
    test('With DueDay UTC', () {
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
    test('Different dueDay', () {
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
  group('AddMonths', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
    test('Add 1 month', () {
      expect(
        dueDate.addMonths(1),
        equals(DateTime(2022, 2, 28)),
      );
      expect(
        dueDate.nextMonth,
        equals(DateTime(2022, 2, 28)),
      );
    });
    test('Add 3 month', () {
      expect(
        dueDate.addMonths(4),
        equals(DateTime(2022, 5, 30)),
      );
    });
    test('Add 1 year (12 months)', () {
      expect(
        dueDate.addMonths(12),
        equals(DateTime(2023, 1, 30)),
      );
      expect(
        dueDate.nextYear,
        equals(DateTime(2023, 1, 30)),
      );
    });
  });
  group('SubtractMonths', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
    test('Subtract 1 month', () {
      expect(
        dueDate.subtractMonths(1),
        equals(DateTime(2021, 12, 30)),
      );
      expect(
        dueDate.previousMonth,
        equals(DateTime(2021, 12, 30)),
      );
    });
    test('Subtract 11 month', () {
      expect(
        dueDate.subtractMonths(11),
        equals(DateTime(2021, 2, 28)),
      );
    });
    test('Subtract 1 year (12 months)', () {
      expect(
        dueDate.subtractMonths(12),
        equals(DateTime(2021, 1, 30)),
      );
      expect(
        dueDate.previousYear,
        equals(DateTime(2021, 1, 30)),
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
        equals(DateTime(2022, 2, 1)),
      );
    });
    test('2 days, keep dueDay', () {
      expect(
        dueDate.add(const Duration(days: 2), sameEvery: true),
        equals(DateTime(2022, 2, 28)),
      );
    });
  });
  group('Subtract:', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
    test('2 days', () {
      expect(
        dueDate.subtract(const Duration(days: 2)),
        equals(DateTime(2022, 1, 28)),
      );
    });
    test('2 days, keep dueDay', () {
      expect(
        dueDate.subtract(const Duration(days: 2), sameEvery: true),
        equals(dueDate),
      );
    });
  });
  group('AddWeeks:', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
    test('1 week', () {
      final matcher = DateTime(2022, 2, 6);
      expect(
        dueDate.addWeeks(1),
        equals(matcher),
      );
      expect(
        dueDate.nextWeek,
        equals(matcher),
      );
    });
    test('2 weeks', () {
      expect(
        dueDate.addWeeks(2),
        equals(DateTime(2022, 2, 13)),
      );
    });
    test('2 weeks, keep dueDay', () {
      expect(
        dueDate.addWeeks(2, sameEvery: true),
        equals(DateTime(2022, 2, 28)),
      );
    });
  });
  group('SubtractWeeks:', () {
    final dueDate = DueDateTime(every: EveryDueDayMonth(30), year: 2022);
    test('1 week', () {
      final matcher = DateTime(2022, 1, 23);
      expect(
        dueDate.subtractWeeks(1),
        equals(matcher),
      );
      expect(
        dueDate.previousWeek,
        equals(matcher),
      );
    });
    test('2 weeks', () {
      expect(
        dueDate.subtractWeeks(2),
        equals(DateTime(2022, 1, 16)),
      );
    });
    test('2 weeks, keep dueDay', () {
      expect(
        dueDate.subtractWeeks(2, sameEvery: true),
        equals(dueDate),
      );
    });
  });
}
