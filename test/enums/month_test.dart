// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('Month:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(Month.values.length, equals(12));
        expect(
          Month.values,
          containsAllInOrder([
            Month.january,
            Month.february,
            Month.march,
            Month.april,
            Month.may,
            Month.june,
            Month.july,
            Month.august,
            Month.september,
            Month.october,
            Month.november,
            Month.december,
          ]),
        );
      });
    });
    group('Factory methods', () {
      group('Throw on factory outside of range:', () {
        test('Value below 1', () {
          expect(() => Month.fromDateTimeValue(0), throwsRangeError);
        });
        test('Value above 12', () {
          expect(() => Month.fromDateTimeValue(13), throwsRangeError);
        });
      });
    });
    group('Navigation methods', () {
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
    group('String representation', () {
      test('All months have correct string representation', () {
        expect(Month.january.toString(), equals('Month.january'));
        expect(Month.february.toString(), equals('Month.february'));
        expect(Month.march.toString(), equals('Month.march'));
        expect(Month.april.toString(), equals('Month.april'));
        expect(Month.may.toString(), equals('Month.may'));
        expect(Month.june.toString(), equals('Month.june'));
        expect(Month.july.toString(), equals('Month.july'));
        expect(Month.august.toString(), equals('Month.august'));
        expect(Month.september.toString(), equals('Month.september'));
        expect(Month.october.toString(), equals('Month.october'));
        expect(Month.november.toString(), equals('Month.november'));
        expect(Month.december.toString(), equals('Month.december'));
      });
    });
    group('Name property', () {
      test('All months have correct name', () {
        expect(Month.january.name, equals('january'));
        expect(Month.february.name, equals('february'));
        expect(Month.march.name, equals('march'));
        expect(Month.april.name, equals('april'));
        expect(Month.may.name, equals('may'));
        expect(Month.june.name, equals('june'));
        expect(Month.july.name, equals('july'));
        expect(Month.august.name, equals('august'));
        expect(Month.september.name, equals('september'));
        expect(Month.october.name, equals('october'));
        expect(Month.november.name, equals('november'));
        expect(Month.december.name, equals('december'));
      });
    });
    group('Index property', () {
      test('All months have correct index', () {
        for (var i = 0; i < Month.values.length; i++) {
          expect(Month.values[i].index, equals(i));
        }
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(Month.january, equals(Month.january));
        expect(Month.december, equals(Month.december));
      });
      test('Different values are not equal', () {
        expect(Month.january, isNot(equals(Month.february)));
        expect(Month.march, isNot(equals(Month.april)));
      });
    });
    group('Edge Cases', () {
      test('All months are unique', () {
        final set = Month.values.toSet();
        expect(set.length, equals(Month.values.length));
      });
    });
  });
}
