import 'package:due_date/due_date.dart';
import 'package:due_date/src/every.dart';
import 'package:test/test.dart';

void main() {
  group('EveryWeekday:', () {
    final today = DateTime(2022, DateTime.august, 12);
    final todayUtc = DateTime.utc(2022, DateTime.august, 12);
    group('Every Saturday', () {
      const everySaturday = EveryWeekday(Weekday.saturday);
      group('Local', () {
        final thisSaturday = DateTime(2022, DateTime.august, 13);
        test('This saturday', () {
          expect(everySaturday.startDate(today), equals(thisSaturday));
        });
        test('Previous Saturday', () {
          final previousSaturday = DateTime(2022, DateTime.august, 6);
          expect(
            everySaturday.addWeeks(thisSaturday, -1),
            equals(previousSaturday),
          );
        });
        test('Next Saturday', () {
          final nextSaturday = DateTime(2022, DateTime.august, 20);
          expect(
            everySaturday.addWeeks(thisSaturday, 1),
            equals(nextSaturday),
          );
          expect(everySaturday.addWeeks(today, 1), equals(nextSaturday));
        });
      });
      group('UTC', () {
        final thisSaturdayUtc = DateTime.utc(2022, DateTime.august, 13);
        test('This saturday', () {
          expect(everySaturday.startDate(todayUtc), equals(thisSaturdayUtc));
        });
        test('Previous Saturday', () {
          final previousSaturdayUtc = DateTime.utc(2022, DateTime.august, 6);
          expect(
            everySaturday.addWeeks(thisSaturdayUtc, -1),
            equals(previousSaturdayUtc),
          );
        });
        test('Next Saturday', () {
          final nextSaturdayUtc = DateTime.utc(2022, DateTime.august, 20);
          expect(
            everySaturday.addWeeks(thisSaturdayUtc, 1),
            equals(nextSaturdayUtc),
          );
          expect(everySaturday.addWeeks(todayUtc, 1), equals(nextSaturdayUtc));
        });
      });
    });
    group('Every Wednesday', () {
      const everyWednesday = EveryWeekday(Weekday.wednesday);
      test('Local', () {
        final wednesday = DateTime(2022, DateTime.august, 17);
        expect(everyWednesday.startDate(today), equals(wednesday));
      });
      test('UTC', () {
        final wednesdayUtc = DateTime.utc(2022, DateTime.august, 17);
        expect(everyWednesday.startDate(todayUtc), equals(wednesdayUtc));
      });
    });
  });
  // TODO: test EveryDayOfWeekInMonth && EveryDueDayMonth.
  group('EveryDayOfYear:', () {
    final today = DateTime(2022, DateTime.august, 12);
    final todayUtc = DateTime.utc(2022, DateTime.august, 12);
    group('Every Day 1', () {
      const everyDay1 = EveryDayOfYear(1);
      group('Local', () {
        final nextYearsDayOne = DateTime(2023);
        test('Next Year', () {
          expect(everyDay1.startDate(today), equals(nextYearsDayOne));
        });
        test('Previous Year', () {
          final previousYearsDay1 = DateTime(2021);
          expect(
            everyDay1.addYears(today, -1),
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
          expect(everyDay1.startDate(todayUtc), equals(nextYearsDayOneUtc));
        });
        test('Previous Year', () {
          final previousYearsDay1Utc = DateTime.utc(2021);
          expect(
            everyDay1.addYears(todayUtc, -1),
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
    group('Every Programmer\'s Day', () {
      const programmersDay = EveryDayOfYear(256);
      group('Local', () {
        test('This year', () {
          final programmersDay2022 = DateTime(2022, DateTime.september, 13);
          expect(
            programmersDay.startDate(today),
            equals(programmersDay2022),
          );
        });
        test('Next year', () {
          final programmersDay2022 = DateTime(2022, DateTime.september, 13);
          final programmersDay2023 = DateTime(2023, DateTime.september, 13);
          expect(
            programmersDay.addYears(today, 1),
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
            programmersDay.addYears(today, -1),
            equals(programmersDay2021),
          );
        });
        test('Leap year', () {
          final programmersDay2024 = DateTime(2024, DateTime.september, 12);
          expect(
            programmersDay.addYears(today, 2),
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
            programmersDay.startDate(todayUtc),
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
            programmersDay.addYears(todayUtc, 1),
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
            programmersDay.addYears(todayUtc, -1),
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
            programmersDay.addYears(todayUtc, 2),
            equals(programmersDay2024Utc),
          );
        });
      });
    });
    group('End of year', () {
      const endOfYear = EveryDayOfYear(366);
      group('Local', () {
        test('This year', () {
          final endOf2022 = DateTime(2022, DateTime.december, 31);
          expect(
            endOfYear.startDate(today),
            equals(endOf2022),
          );
        });
        test('Leap year', () {
          final endOf2024 = DateTime(2024, DateTime.december, 31);
          expect(
            endOfYear.addYears(today, 2),
            equals(endOf2024),
          );
        });
      });
      group('UTC', () {
        test('This year', () {
          final endOf2022Utc = DateTime.utc(2022, DateTime.december, 31);
          expect(
            endOfYear.startDate(todayUtc),
            equals(endOf2022Utc),
          );
        });
        test('Leap year', () {
          final endOf2024Utc = DateTime.utc(2024, DateTime.december, 31);
          expect(
            endOfYear.addYears(todayUtc, 2),
            equals(endOf2024Utc),
          );
        });
      });
    });
  });
}
