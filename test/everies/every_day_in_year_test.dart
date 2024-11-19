import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('EveryDayInYear:', () {
    final august12th2022 = DateTime(2022, DateTime.august, 12);
    final august12th2022Utc = DateTime.utc(2022, DateTime.august, 12);

    group('Test base methods logic', () {
      const every = EveryDayInYear(15);
      group('startDate', () {
        final january15th = DateTime(2022, DateTime.january, 15);
        test('If the given date would be generated, return it', () {
          expect(
            every.startDate(january15th),
            equals(january15th),
          );
        });
        test('If the given date would not be generated, use next', () {
          expect(
            every.startDate(DateTime(2022, DateTime.january, 14)),
            equals(every.next(DateTime(2022, DateTime.january, 14))),
          );
        });
      });
      group('next', () {
        final january15th2022 = DateTime(2022, DateTime.january, 15);
        final january15th2023 = DateTime(2023, DateTime.january, 15);
        test(
          'If the given date would be generated, generate a new one anyway',
          () => expect(every.next(january15th2022), equals(january15th2023)),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(
            every.next(DateTime(2022, DateTime.january, 14)),
            equals(january15th2022),
          ),
        );
      });
      group('previous', () {
        final january15th2022 = DateTime(2022, DateTime.january, 15);
        final january15th2021 = DateTime(2021, DateTime.january, 15);

        test(
          'If the given date would be generated, generate a new one anyway',
          () =>
              expect(every.previous(january15th2022), equals(january15th2021)),
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () => expect(
            every.previous(DateTime(2022, DateTime.january, 14)),
            equals(january15th2021),
          ),
        );
      });
    });

    group('Every Day 1', () {
      const everyDay1 = EveryDayInYear(1);
      group('Local', () {
        final nextYearsDayOne = DateTime(2023);
        test('Next Year', () {
          expect(everyDay1.startDate(august12th2022), equals(nextYearsDayOne));
        });
        test('Previous Year', () {
          final previousYearsDay1 = DateTime(2022);
          expect(
            everyDay1.addYears(august12th2022, -1),
            equals(previousYearsDay1),
          );
        });
        test('Next Two Years', () {
          final twoYearsDay1 = DateTime(2024);
          expect(
            everyDay1.addYears(nextYearsDayOne, 1),
            equals(twoYearsDay1),
          );
        });
      });
      group('UTC', () {
        final nextYearsDayOneUtc = DateTime.utc(2023);
        test('Next Year', () {
          expect(
            everyDay1.startDate(august12th2022Utc),
            equals(nextYearsDayOneUtc),
          );
        });
        test('Previous Year', () {
          final previousYearsDay1Utc = DateTime.utc(2022);
          expect(
            everyDay1.addYears(august12th2022Utc, -1),
            equals(previousYearsDay1Utc),
          );
        });
        test('Next Two Years', () {
          final twoYearsDay1Utc = DateTime.utc(2024);
          expect(
            everyDay1.addYears(nextYearsDayOneUtc, 1),
            equals(twoYearsDay1Utc),
          );
        });
      });
    });
    group("Every Programmer's Day", () {
      const programmersDay = EveryDayInYear(256);
      group('Local', () {
        test('This year', () {
          final programmersDay2022 = DateTime(2022, DateTime.september, 13);
          expect(
            programmersDay.startDate(august12th2022),
            equals(programmersDay2022),
          );
        });
        test('Next year', () {
          final programmersDay2022 = DateTime(2022, DateTime.september, 13);
          final programmersDay2023 = DateTime(2023, DateTime.september, 13);
          expect(
            programmersDay.addYears(august12th2022, 1),
            equals(programmersDay2023),
          );
          expect(
            programmersDay.addYears(programmersDay2022, 1),
            equals(programmersDay2023),
          );
        });
        test('Previous year', () {
          final programmersDay2021 = DateTime(2021, DateTime.september, 13);
          expect(
            programmersDay.addYears(august12th2022, -1),
            equals(programmersDay2021),
          );
        });
        test('Leap year', () {
          final programmersDay2024 = DateTime(2024, DateTime.september, 12);
          expect(
            programmersDay.addYears(august12th2022, 2),
            equals(programmersDay2024),
          );
        });
      });
      group('UTC', () {
        test('This year', () {
          final programmersDay2022Utc = DateTime.utc(
            2022,
            DateTime.september,
            13,
          );
          expect(
            programmersDay.startDate(august12th2022Utc),
            equals(programmersDay2022Utc),
          );
        });
        test('Next year', () {
          final programmersDay2022Utc = DateTime.utc(
            2022,
            DateTime.september,
            13,
          );
          final programmersDay2023Utc = DateTime.utc(
            2023,
            DateTime.september,
            13,
          );
          expect(
            programmersDay.addYears(august12th2022Utc, 1),
            equals(programmersDay2023Utc),
          );
          expect(
            programmersDay.addYears(programmersDay2022Utc, 1),
            equals(programmersDay2023Utc),
          );
        });
        test('Previous year', () {
          final programmersDay2021Utc = DateTime.utc(
            2021,
            DateTime.september,
            13,
          );
          expect(
            programmersDay.addYears(august12th2022Utc, -1),
            equals(programmersDay2021Utc),
          );
        });
        test('Leap year', () {
          final programmersDay2024Utc = DateTime.utc(
            2024,
            DateTime.september,
            12,
          );
          expect(
            programmersDay.addYears(august12th2022Utc, 2),
            equals(programmersDay2024Utc),
          );
        });
      });
    });
    group('End of year', () {
      const endOfYear = EveryDayInYear(366);
      group('Local', () {
        test('This year', () {
          final endOf2022 = DateTime(2022, DateTime.december, 31);
          expect(
            endOfYear.startDate(august12th2022),
            equals(endOf2022),
          );
        });
        test('Leap year', () {
          final endOf2024 = DateTime(2024, DateTime.december, 31);
          expect(
            endOfYear.addYears(august12th2022, 2),
            equals(endOf2024),
          );
        });
      });
      group('UTC', () {
        test('This year', () {
          final endOf2022Utc = DateTime.utc(2022, DateTime.december, 31);
          expect(
            endOfYear.startDate(august12th2022Utc),
            equals(endOf2022Utc),
          );
        });
        test('Leap year', () {
          final endOf2024Utc = DateTime.utc(2024, DateTime.december, 31);
          expect(
            endOfYear.addYears(august12th2022Utc, 2),
            equals(endOf2024Utc),
          );
        });
      });
    });
  });
}
