import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('Month:', () {
    group('Throw on factory outside of range:', () {
      test('Value below 1', () {
        expect(() => Month.fromDateTimeValue(0), throwsRangeError);
      });
      test('Value above 12', () {
        expect(() => Month.fromDateTimeValue(13), throwsRangeError);
      });
    });
    group('Previous:', () {
      for (final month in Month.values) {
        test(month.name, () {
          if (month != Month.january) {
            expect(
              month.previous,
              equals(Month.fromDateTimeValue(month.dateTimeValue - 1)),
            );
          } else {
            expect(month.previous, equals(Month.december));
          }
        });
      }
    });
    group('Next:', () {
      for (final month in Month.values) {
        test(month.name, () {
          if (month != Month.december) {
            expect(
              month.next,
              equals(Month.fromDateTimeValue(month.dateTimeValue + 1)),
            );
          } else {
            expect(month.next, equals(Month.january));
          }
        });
      }
    });
    group('from', () {
      const monthGenerator = MonthGenerator();
      test('august', () {
        final august = monthGenerator.of(DateTime(2022, DateTime.august));
        expect(Month.august.of(2022, utc: false), equals(august));
      });
      test('august utc', () {
        final august = monthGenerator.of(DateTime.utc(2022, DateTime.august));
        expect(Month.august.of(2022), equals(august));
      });
      test('september', () {
        final september = monthGenerator.of(DateTime(2022, DateTime.september));
        expect(Month.september.of(2022, utc: false), equals(september));
      });
      test('september utc', () {
        final september = monthGenerator.of(
          DateTime.utc(2022, DateTime.september),
        );
        expect(Month.september.of(2022), equals(september));
      });
      test('february 2022', () {
        final february = monthGenerator.of(DateTime(2022, DateTime.february));
        expect(Month.february.of(2022, utc: false), equals(february));
      });
      test('february 2022 utc', () {
        final february = monthGenerator.of(
          DateTime.utc(2022, DateTime.february),
        );
        expect(Month.february.of(2022), equals(february));
      });
      test('february 2020', () {
        final february = monthGenerator.of(DateTime(2020, DateTime.february));
        expect(Month.february.of(2020, utc: false), equals(february));
      });
      test('february 2020 utc', () {
        final february = monthGenerator.of(
          DateTime.utc(2020, DateTime.february),
        );
        expect(Month.february.of(2020), equals(february));
      });
    });
  });
}
