import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('EveryWeekdayCountInMonth:', () {
    final august12th2022 = DateTime(2022, DateTime.august, 12);
    final august12th2022Utc = DateTime.utc(2022, DateTime.august, 12);

    group('Test base methods logic', () {
      const every = EveryWeekdayCountInMonth(
        day: Weekday.saturday,
        week: Week.second,
      );
      group('startDate', () {
        final august13th = DateTime(2022, DateTime.august, 13);
        test('If the given date would be generated, return it', () {
          expect(every.startDate(august13th), equals(august13th));
        });
        test('If the given date would not be generated, use next', () {
          expect(
            every.startDate(DateTime(2022, DateTime.august, 14)),
            equals(every.next(DateTime(2022, DateTime.august, 14))),
          );
        });
      });
      group('next', () {
        final august13th = DateTime(2022, DateTime.august, 13);
        final september10th = DateTime(2022, DateTime.september, 10);
        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(every.next(august13th), equals(september10th)),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(every.next(august12th2022), equals(august13th)),
        );
      });
      group('previous', () {
        final august13th = DateTime(2022, DateTime.august, 13);
        final july9th = DateTime(2022, DateTime.july, 9);
        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(every.previous(august13th), equals(july9th)),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(every.previous(august12th2022), equals(july9th)),
        );
      });
    });

    group('First Monday', () {
      const firstMondayOfMonth = EveryWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.monday,
      );
      group('Local', () {
        test('Day 1', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.july, 15);
          final matcher = DateTime(2022, DateTime.august);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            equals(matcher),
          );
        });
        test('Day 2', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.december, 15);
          final matcher = DateTime(2023, DateTime.january, 2);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            equals(matcher),
          );
        });
        test('Day 3', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.september, 15);
          final matcher = DateTime(2022, DateTime.october, 3);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            equals(matcher),
          );
        });
        test('Day 4', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.june, 15);
          final matcher = DateTime(2022, DateTime.july, 4);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            equals(matcher),
          );
        });
        test('Day 5', () {
          final matcher = DateTime(2022, DateTime.september, 5);
          expect(firstMondayOfMonth.startDate(august12th2022), equals(matcher));
          expect(
            firstMondayOfMonth.addMonths(august12th2022, 0),
            equals(matcher),
          );
        });
        test('Day 6', () {
          final middleOfPreviousMonth = DateTime(2023, DateTime.january, 15);
          final matcher = DateTime(2023, DateTime.february, 6);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            equals(matcher),
          );
        });
        test('Day 7', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.october, 15);
          final matcher = DateTime(2022, DateTime.november, 7);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            equals(matcher),
          );
        });
      });
      group('UTC', () {
        test('Day 1', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.july,
            15,
          );
          final matcher = DateTime.utc(2022, DateTime.august);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            equals(matcher),
          );
        });
        test('Day 2', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.december,
            15,
          );
          final matcher = DateTime.utc(2023, DateTime.january, 2);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            equals(matcher),
          );
        });
        test('Day 3', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.september,
            15,
          );
          final matcher = DateTime.utc(2022, DateTime.october, 3);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            equals(matcher),
          );
        });
        test('Day 4', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.june,
            15,
          );
          final matcher = DateTime.utc(2022, DateTime.july, 4);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            equals(matcher),
          );
        });
        test('Day 5', () {
          final matcher = DateTime.utc(2022, DateTime.september, 5);
          expect(
            firstMondayOfMonth.startDate(august12th2022Utc),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(august12th2022Utc, 0),
            equals(matcher),
          );
        });
        test('Day 6', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2023,
            DateTime.january,
            15,
          );
          final matcher = DateTime.utc(2023, DateTime.february, 6);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            equals(matcher),
          );
        });
        test('Day 7', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.october,
            15,
          );
          final matcher = DateTime.utc(2022, DateTime.november, 7);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            equals(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            equals(matcher),
          );
        });
      });
    });
    group('Last wednesday', () {
      const lastWednesdayOfMonth = EveryWeekdayCountInMonth(
        week: Week.last,
        day: Weekday.wednesday,
      );
      group('Local', () {
        final middleOfMonth = DateTime(2024, DateTime.february, 15);
        test('Subtract months so is March', () {
          final matcher = DateTime(2023, DateTime.march, 29);
          expect(
            lastWednesdayOfMonth.addMonths(middleOfMonth, -11),
            equals(matcher),
          );
        });
        test('Add months so is March in leap year', () {
          final matcher = DateTime(2024, DateTime.march, 27);
          expect(
            lastWednesdayOfMonth.addMonths(middleOfMonth, 1),
            equals(matcher),
          );
        });
      });
      group('UTC', () {
        final middleOfMonthUtc = DateTime.utc(2024, DateTime.february, 15);
        test('Subtract months so is March', () {
          final matcher = DateTime.utc(2023, DateTime.march, 29);
          expect(
            lastWednesdayOfMonth.addMonths(middleOfMonthUtc, -11),
            equals(matcher),
          );
        });
        test('Add months so is March in leap year', () {
          final matcher = DateTime.utc(2024, DateTime.march, 27);
          expect(
            lastWednesdayOfMonth.addMonths(middleOfMonthUtc, 1),
            equals(matcher),
          );
        });
      });
    });
  });
}
