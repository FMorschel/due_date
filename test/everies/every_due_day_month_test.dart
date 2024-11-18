import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('EveryDueDayMonth:', () {
    group('Test base methods logic', () {
      const every = EveryDueDayMonth(15);
      group('startDate', () {
        final august15th = DateTime(2022, DateTime.august, 15);
        test('If the given date would be generated, return it', () {
          expect(every.startDate(august15th), equals(august15th));
        });
        test('If the given date would not be generated, use next', () {
          expect(
            every.startDate(DateTime(2022, DateTime.august, 14)),
            equals(every.next(DateTime(2022, DateTime.august, 14))),
          );
        });
      });
      group('next', () {
        final august15th = DateTime(2022, DateTime.august, 15);
        final september15th = DateTime(2022, DateTime.september, 15);
        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(every.next(august15th), equals(september15th)),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(
            every.next(DateTime(2022, DateTime.august, 14)),
            equals(august15th),
          ),
        );
      });
      group('previous', () {
        final august15th = DateTime(2022, DateTime.august, 15);
        final july15th = DateTime(2022, DateTime.july, 15);
        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(every.previous(august15th), equals(july15th)),
        );
        test(
          'If the given date would not be generated, generate the previous '
          'valid date',
          () => expect(
            every.previous(DateTime(2022, DateTime.august, 16)),
            equals(august15th),
          ),
        );
      });
    });

    group('Every day 31', () {
      const everyDay31 = EveryDueDayMonth(31);
      group('Local', () {
        test('Month ending in 31', () {
          final august12th2022 = DateTime(2022, DateTime.august, 12);
          final matcher = DateTime(2022, DateTime.august, 31);
          expect(everyDay31.startDate(august12th2022), equals(matcher));
        });
        test('Month ending in 30', () {
          final endOfAugust = DateTime(2022, DateTime.august, 31);
          final matcher = DateTime(2022, DateTime.september, 30);
          expect(everyDay31.addMonths(endOfAugust, 1), equals(matcher));
        });
        test('Month ending in 29', () {
          final previousMonth = DateTime(2024, DateTime.january, 31);
          final matcher = DateTime(2024, DateTime.february, 29);
          expect(everyDay31.addMonths(previousMonth, 1), equals(matcher));
        });
        test('Month ending in 28', () {
          final previousMonth = DateTime(2022, DateTime.january, 31);
          final nextMonth = DateTime(2022, DateTime.march, 31);
          final matcher = DateTime(2022, DateTime.february, 28);
          expect(everyDay31.addMonths(previousMonth, 1), equals(matcher));
          expect(everyDay31.addMonths(nextMonth, -1), equals(matcher));
        });
      });
      group('UTC', () {
        test('Month ending in 31', () {
          final august12th2022Utc = DateTime.utc(2022, DateTime.august, 12);
          final matcher = DateTime.utc(2022, DateTime.august, 31);
          expect(everyDay31.startDate(august12th2022Utc), equals(matcher));
        });
        test('Month ending in 30', () {
          final endOfAugustUtc = DateTime.utc(2022, DateTime.august, 31);
          final matcher = DateTime.utc(2022, DateTime.september, 30);
          expect(everyDay31.addMonths(endOfAugustUtc, 1), equals(matcher));
        });
        test('Month ending in 29', () {
          final previousMonthUtc = DateTime.utc(2024, DateTime.january, 31);
          final matcher = DateTime.utc(2024, DateTime.february, 29);
          expect(everyDay31.addMonths(previousMonthUtc, 1), equals(matcher));
        });
        test('Month ending in 28', () {
          final previousMonthUtc = DateTime.utc(2022, DateTime.january, 31);
          final nextMonthUtc = DateTime.utc(2022, DateTime.march, 31);
          final matcher = DateTime.utc(2022, DateTime.february, 28);
          expect(everyDay31.addMonths(previousMonthUtc, 1), equals(matcher));
          expect(everyDay31.addMonths(nextMonthUtc, -1), equals(matcher));
        });
      });
    });
    group('Every day 15', () {
      const everyDay15 = EveryDueDayMonth(15);
      test('Local', () {
        final august12th2022 = DateTime(2022, DateTime.august, 12);
        final matcher = DateTime(2022, DateTime.august, 15);
        expect(everyDay15.startDate(august12th2022), equals(matcher));
      });
      test('UTC', () {
        final august12th2022Utc = DateTime.utc(2022, DateTime.august, 12);
        final matcher = DateTime.utc(2022, DateTime.august, 15);
        expect(everyDay15.startDate(august12th2022Utc), equals(matcher));
      });
    });
  });
}
