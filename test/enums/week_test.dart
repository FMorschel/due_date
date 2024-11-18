import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('Week', () {
    group('Week.from', () {
      const year = 2022;
      const month = Month.august;
      group('First', () {
        const matcher = Week.first;
        final firstDayOfWeek = DateTime(year, month.dateTimeValue);
        final lastDayOfWeek = DateTime(year, month.dateTimeValue, 7);
        test(Weekday.fromDateTimeValue(firstDayOfWeek.weekday).name, () {
          expect(Week.from(firstDayOfWeek), equals(matcher));
        });
        for (final day in firstDayOfWeek.to(lastDayOfWeek)) {
          test(Weekday.fromDateTimeValue(day.weekday).name, () {
            expect(Week.from(day), equals(matcher));
          });
        }
      });
      group('Second', () {
        const matcher = Week.second;
        final firstDayOfWeek = DateTime(year, month.dateTimeValue, 8);
        final lastDayOfWeek = DateTime(year, month.dateTimeValue, 14);
        test(Weekday.fromDateTimeValue(firstDayOfWeek.weekday).name, () {
          expect(Week.from(firstDayOfWeek), equals(matcher));
        });
        for (final day in firstDayOfWeek.to(lastDayOfWeek)) {
          test(Weekday.fromDateTimeValue(day.weekday).name, () {
            expect(Week.from(day), equals(matcher));
          });
        }
      });
      group('Third', () {
        const matcher = Week.third;
        final firstDayOfWeek = DateTime(year, month.dateTimeValue, 15);
        final lastDayOfWeek = DateTime(year, month.dateTimeValue, 21);
        test(Weekday.fromDateTimeValue(firstDayOfWeek.weekday).name, () {
          expect(Week.from(firstDayOfWeek), equals(matcher));
        });
        for (final day in firstDayOfWeek.to(lastDayOfWeek)) {
          test(Weekday.fromDateTimeValue(day.weekday).name, () {
            expect(Week.from(day), equals(matcher));
          });
        }
      });
      group('Fourth', () {
        const matcher = Week.fourth;
        final firstDayOfWeek = DateTime(year, month.dateTimeValue, 22);
        final lastDayOfWeek = DateTime(year, month.dateTimeValue, 28);
        test(Weekday.fromDateTimeValue(firstDayOfWeek.weekday).name, () {
          expect(Week.from(firstDayOfWeek), equals(matcher));
        });
        for (final day in firstDayOfWeek.to(lastDayOfWeek)) {
          test(Weekday.fromDateTimeValue(day.weekday).name, () {
            expect(Week.from(day), equals(matcher));
          });
        }
      });
      group('Last', () {
        const matcher = Week.last;
        final firstDayOfWeek = DateTime(year, month.dateTimeValue, 29);
        final lastDayOfWeek = DateTime(year, month.dateTimeValue, 31);
        test(Weekday.fromDateTimeValue(firstDayOfWeek.weekday).name, () {
          expect(Week.from(firstDayOfWeek), equals(matcher));
        });
        for (final day in firstDayOfWeek.to(lastDayOfWeek)) {
          test(Weekday.fromDateTimeValue(day.weekday).name, () {
            expect(Week.from(day), equals(matcher));
          });
        }
      });
    });
    group('First', () {
      const weekGenerator = WeekGenerator();
      const first = Week.first;
      test('Starts six days before the first day of the month', () {
        expect(
          first.of(2023, Month.january.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.december, 26))),
        );
        expect(
          first.of(2023, Month.january.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.january, -5))),
        );
      });
      test('Starts five days before the first day of the month', () {
        expect(
          first.of(2023, Month.april.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.march, 27))),
        );
        expect(
          first.of(2023, Month.april.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.april, -4))),
        );
      });
      test('Starts four days before the first day of the month', () {
        expect(
          first.of(2022, Month.july.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.june, 27))),
        );
        expect(
          first.of(2022, Month.july.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.july, -3))),
        );
      });
      test('Starts three days before the first day of the month', () {
        expect(
          first.of(2022, Month.september.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.august, 29))),
        );
        expect(
          first.of(2022, Month.september.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.september, -2))),
        );
      });
      test("Starts at the previous month's second to last day", () {
        expect(
          first.of(2022, Month.june.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.may, 30))),
        );
        expect(
          first.of(2022, Month.june.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.june, -1))),
        );
      });
      test("Starts at the previous month's last day", () {
        expect(
          first.of(2022, Month.march.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.february, 28))),
        );
        expect(
          first.of(2022, Month.march.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.march, 0))),
        );
      });
      test('Starts at the actual first day of the month', () {
        expect(
          first.of(2022, Month.august.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.august))),
        );
      });
    });
    group('Second', () {
      const weekGenerator = WeekGenerator();
      const second = Week.second;
      test('Starts at the 2nd day of the month', () {
        expect(
          second.of(2023, Month.january.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.january, 2))),
        );
      });
      test('Starts at the 3rd day of the month', () {
        expect(
          second.of(2023, Month.april.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.april, 3))),
        );
      });
      test('Starts at the 4th day of the month', () {
        expect(
          second.of(2022, Month.july.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.july, 4))),
        );
      });
      test('Starts at the 5th day of the month', () {
        expect(
          second.of(2022, Month.september.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.september, 5))),
        );
      });
      test('Starts at the 6th day of the month', () {
        expect(
          second.of(2022, Month.june.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.june, 6))),
        );
      });
      test('Starts at the 7th day of the month', () {
        expect(
          second.of(2022, Month.march.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.march, 7))),
        );
      });
      test('Starts at the 8th day of the month', () {
        expect(
          second.of(2022, Month.august.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.august, 8))),
        );
      });
    });
    group('Third', () {
      const weekGenerator = WeekGenerator();
      const third = Week.third;
      test('Starts at the 9th day of the month', () {
        expect(
          third.of(2023, Month.january.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.january, 9))),
        );
      });
      test('Starts at the 10th day of the month', () {
        expect(
          third.of(2023, Month.april.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.april, 10))),
        );
      });
      test('Starts at the 11th day of the month', () {
        expect(
          third.of(2022, Month.july.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.july, 11))),
        );
      });
      test('Starts at the 12th day of the month', () {
        expect(
          third.of(2022, Month.september.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.september, 12))),
        );
      });
      test('Starts at the 13th day of the month', () {
        expect(
          third.of(2022, Month.june.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.june, 13))),
        );
      });
      test('Starts at the 14th day of the month', () {
        expect(
          third.of(2022, Month.march.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.march, 14))),
        );
      });
      test('Starts at the 15th day of the month', () {
        expect(
          third.of(2022, Month.august.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.august, 15))),
        );
      });
    });
    group('Fourth', () {
      const weekGenerator = WeekGenerator();
      const fourth = Week.fourth;
      test('Starts at the 16th day of the month', () {
        expect(
          fourth.of(2023, Month.january.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.january, 16))),
        );
      });
      test('Starts at the 17th day of the month', () {
        expect(
          fourth.of(2023, Month.april.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.april, 17))),
        );
      });
      test('Starts at the 18th day of the month', () {
        expect(
          fourth.of(2022, Month.july.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.july, 18))),
        );
      });
      test('Starts at the 19th day of the month', () {
        expect(
          fourth.of(2022, Month.september.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.september, 19))),
        );
      });
      test('Starts at the 20th day of the month', () {
        expect(
          fourth.of(2022, Month.june.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.june, 20))),
        );
      });
      test('Starts at the 21st day of the month', () {
        expect(
          fourth.of(2022, Month.march.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.march, 21))),
        );
      });
      test('Starts at the 22nd day of the month', () {
        expect(
          fourth.of(2022, Month.august.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.august, 22))),
        );
      });
    });
    group('Last', () {
      const weekGenerator = WeekGenerator();
      const last = Week.last;
      test('Starts at the 23th day of the month', () {
        expect(
          last.of(2026, Month.february.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2026, DateTime.february, 23))),
        );
      });
      test('Starts at the 24th day of the month', () {
        expect(
          last.of(2025, Month.february.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2025, DateTime.february, 24))),
        );
      });
      test('Starts at the 25th day of the month', () {
        expect(
          last.of(2019, Month.february.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2019, DateTime.february, 25))),
        );
      });
      test('Starts at the 26th day of the month', () {
        expect(
          last.of(2024, Month.february.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2024, DateTime.february, 26))),
        );
      });
      test('Starts at the 27th day of the month', () {
        expect(
          last.of(2023, Month.february.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2023, DateTime.february, 27))),
        );
      });
      test('Starts at the 28th day of the month', () {
        expect(
          last.of(2022, Month.february.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.february, 28))),
        );
      });
      test('Starts at the 29th day of the month', () {
        expect(
          last.of(2022, Month.august.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.august, 29))),
        );
      });
      test('Starts at the 30th day of the month', () {
        expect(
          last.of(2022, Month.may.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.may, 30))),
        );
      });
      test('Starts at the 31st day of the month', () {
        expect(
          last.of(2022, Month.october.dateTimeValue),
          equals(weekGenerator.of(DateTime.utc(2022, DateTime.october, 31))),
        );
      });
    });
    group('Weekday Of', () {
      group('Mondays of August 2022', () {
        final mondays = [
          DateTime.utc(2022, DateTime.august),
          DateTime.utc(2022, DateTime.august, 8),
          DateTime.utc(2022, DateTime.august, 15),
          DateTime.utc(2022, DateTime.august, 22),
          DateTime.utc(2022, DateTime.august, 29),
        ];
        const weekValues = Week.values;
        for (var i = 0; i < weekValues.length; i++) {
          test('${mondays[i].year}/${mondays[i].month}/${mondays[i].day}', () {
            expect(
              weekValues[i].weekdayOf(
                year: 2022,
                month: DateTime.august,
                day: Weekday.monday,
              ),
              equals(mondays[i]),
            );
          });
        }
      });
      group('Fridays of August 2022', () {
        final fridays = [
          DateTime.utc(2022, DateTime.august, 5),
          DateTime.utc(2022, DateTime.august, 12),
          DateTime.utc(2022, DateTime.august, 19),
          DateTime.utc(2022, DateTime.august, 26),
          DateTime.utc(2022, DateTime.august, 26),
        ];
        const weekValues = Week.values;
        for (var i = 0; i < weekValues.length; i++) {
          test('${fridays[i].year}/${fridays[i].month}/${fridays[i].day}', () {
            expect(
              weekValues[i].weekdayOf(
                year: 2022,
                month: DateTime.august,
                day: Weekday.friday,
              ),
              equals(fridays[i]),
            );
          });
        }
      });
    });
  });
}
