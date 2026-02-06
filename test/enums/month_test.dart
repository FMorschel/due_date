import 'package:due_date/src/enums/month.dart';
import 'package:due_date/src/period_generators/month_generator.dart';
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
      group('Month.of', () {
        test('Creates correct month from DateTime', () {
          expect(Month.of(DateTime(2024, 1, 15)), equals(Month.january));
          expect(Month.of(DateTime(2024, 2, 28)), equals(Month.february));
          expect(Month.of(DateTime(2024, 3, 10)), equals(Month.march));
          expect(Month.of(DateTime(2024, 4, 5)), equals(Month.april));
          expect(Month.of(DateTime(2024, 5, 20)), equals(Month.may));
          expect(Month.of(DateTime(2024, 6, 30)), equals(Month.june));
          expect(Month.of(DateTime(2024, 7)), equals(Month.july));
          expect(Month.of(DateTime(2024, 8, 15)), equals(Month.august));
          expect(Month.of(DateTime(2024, 9, 25)), equals(Month.september));
          expect(Month.of(DateTime(2024, 10, 31)), equals(Month.october));
          expect(Month.of(DateTime(2024, 11, 11)), equals(Month.november));
          expect(Month.of(DateTime(2024, 12, 25)), equals(Month.december));
        });
        test('Works with UTC DateTime', () {
          expect(Month.of(DateTime.utc(2024, 1, 15)), equals(Month.january));
          expect(Month.of(DateTime.utc(2024, 6, 30)), equals(Month.june));
          expect(Month.of(DateTime.utc(2024, 12, 25)), equals(Month.december));
        });
        test('Works with different years', () {
          expect(Month.of(DateTime(2020, 2, 29)), equals(Month.february));
          expect(Month.of(DateTime(2021, 2, 28)), equals(Month.february));
          expect(Month.of(DateTime(1999, 12, 31)), equals(Month.december));
          expect(Month.of(DateTime(2030, 7, 4)), equals(Month.july));
        });
        test('Day and time components do not affect result', () {
          expect(Month.of(DateTime(2024, 3)), equals(Month.march));
          expect(
            Month.of(DateTime(2024, 3, 15, 12, 30, 45)),
            equals(Month.march),
          );
          expect(
            Month.of(DateTime(2024, 3, 31, 23, 59, 59)),
            equals(Month.march),
          );
        });
      });
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
    group('Comparison operators', () {
      group('compareTo', () {
        test('Same month returns 0', () {
          expect(Month.june.compareTo(Month.june), equals(0));
          expect(Month.january.compareTo(Month.january), equals(0));
          expect(Month.december.compareTo(Month.december), equals(0));
        });
        test('Earlier month returns negative', () {
          expect(Month.january.compareTo(Month.february), lessThan(0));
          expect(Month.march.compareTo(Month.december), lessThan(0));
          expect(Month.june.compareTo(Month.november), lessThan(0));
        });
        test('Later month returns positive', () {
          expect(Month.february.compareTo(Month.january), greaterThan(0));
          expect(Month.december.compareTo(Month.march), greaterThan(0));
          expect(Month.november.compareTo(Month.june), greaterThan(0));
        });
        test('All months comparison consistency', () {
          for (var i = 0; i < Month.values.length; i++) {
            for (var j = 0; j < Month.values.length; j++) {
              final month1 = Month.values[i];
              final month2 = Month.values[j];
              final result = month1.compareTo(month2);
              if (i == j) {
                expect(
                  result,
                  equals(0),
                  reason: '$month1 should equal $month2',
                );
              } else if (i < j) {
                expect(
                  result,
                  lessThan(0),
                  reason: '$month1 should be less than $month2',
                );
              } else {
                expect(
                  result,
                  greaterThan(0),
                  reason: '$month1 should be greater than $month2',
                );
              }
            }
          }
        });
      });
      group('Greater than operator (>)', () {
        test('Later months are greater than earlier months', () {
          expect(Month.february > Month.january, isTrue);
          expect(Month.december > Month.november, isTrue);
          expect(Month.june > Month.march, isTrue);
        });
        test('Earlier months are not greater than later months', () {
          expect(Month.january > Month.february, isFalse);
          expect(Month.november > Month.december, isFalse);
          expect(Month.march > Month.june, isFalse);
        });
        test('Same months are not greater than each other', () {
          expect(Month.june > Month.june, isFalse);
          expect(Month.january > Month.january, isFalse);
          expect(Month.december > Month.december, isFalse);
        });
      });
      group('Greater than or equal operator (>=)', () {
        test('Later months are greater than or equal to earlier months', () {
          expect(Month.february >= Month.january, isTrue);
          expect(Month.december >= Month.november, isTrue);
          expect(Month.june >= Month.march, isTrue);
        });
        test('Same months are greater than or equal to each other', () {
          expect(Month.june >= Month.june, isTrue);
          expect(Month.january >= Month.january, isTrue);
          expect(Month.december >= Month.december, isTrue);
        });
        test('Earlier months are not greater than or equal to later months',
            () {
          expect(Month.january >= Month.february, isFalse);
          expect(Month.november >= Month.december, isFalse);
          expect(Month.march >= Month.june, isFalse);
        });
      });
      group('Less than operator (<)', () {
        test('Earlier months are less than later months', () {
          expect(Month.january < Month.february, isTrue);
          expect(Month.november < Month.december, isTrue);
          expect(Month.march < Month.june, isTrue);
        });
        test('Later months are not less than earlier months', () {
          expect(Month.february < Month.january, isFalse);
          expect(Month.december < Month.november, isFalse);
          expect(Month.june < Month.march, isFalse);
        });
        test('Same months are not less than each other', () {
          expect(Month.june < Month.june, isFalse);
          expect(Month.january < Month.january, isFalse);
          expect(Month.december < Month.december, isFalse);
        });
      });
      group('Less than or equal operator (<=)', () {
        test('Earlier months are less than or equal to later months', () {
          expect(Month.january <= Month.february, isTrue);
          expect(Month.november <= Month.december, isTrue);
          expect(Month.march <= Month.june, isTrue);
        });
        test('Same months are less than or equal to each other', () {
          expect(Month.june <= Month.june, isTrue);
          expect(Month.january <= Month.january, isTrue);
          expect(Month.december <= Month.december, isTrue);
        });
        test('Later months are not less than or equal to earlier months', () {
          expect(Month.february <= Month.january, isFalse);
          expect(Month.december <= Month.november, isFalse);
          expect(Month.june <= Month.march, isFalse);
        });
      });
    });
    group('Arithmetic operators', () {
      group('Addition operator (+)', () {
        test('Adding 1 month advances to next month', () {
          expect(Month.january + 1, equals(Month.february));
          expect(Month.june + 1, equals(Month.july));
          expect(Month.november + 1, equals(Month.december));
        });
        test('Adding multiple months advances correctly', () {
          expect(Month.january + 3, equals(Month.april));
          expect(Month.march + 5, equals(Month.august));
          expect(Month.june + 4, equals(Month.october));
        });
        test('Adding wraps around year boundary', () {
          expect(Month.december + 1, equals(Month.january));
          expect(Month.december + 3, equals(Month.march));
          expect(Month.november + 5, equals(Month.april));
        });
        test('Adding 12 months returns same month', () {
          for (final month in Month.values) {
            expect(month + 12, equals(month));
          }
        });
        test('Adding 0 returns same month', () {
          for (final month in Month.values) {
            expect(month + 0, equals(month));
          }
        });
        test('Adding large numbers wraps correctly', () {
          expect(Month.january + 13, equals(Month.february));
          expect(Month.june + 25, equals(Month.july));
          expect(Month.december + 24, equals(Month.december));
        });
        test('Adding negative numbers subtracts correctly', () {
          expect(Month.february + (-1), equals(Month.january));
          expect(Month.january + (-1), equals(Month.december));
          expect(Month.march + (-3), equals(Month.december));
        });
      });
      group('Subtraction operator (-)', () {
        test('Subtracting 1 month goes to previous month', () {
          expect(Month.february - 1, equals(Month.january));
          expect(Month.july - 1, equals(Month.june));
          expect(Month.december - 1, equals(Month.november));
        });
        test('Subtracting multiple months goes back correctly', () {
          expect(Month.april - 3, equals(Month.january));
          expect(Month.august - 5, equals(Month.march));
          expect(Month.october - 4, equals(Month.june));
        });
        test('Subtracting wraps around year boundary', () {
          expect(Month.january - 1, equals(Month.december));
          expect(Month.march - 3, equals(Month.december));
          expect(Month.april - 5, equals(Month.november));
        });
        test('Subtracting 12 months returns same month', () {
          for (final month in Month.values) {
            expect(month - 12, equals(month));
          }
        });
        test('Subtracting 0 returns same month', () {
          for (final month in Month.values) {
            expect(month - 0, equals(month));
          }
        });
        test('Subtracting large numbers wraps correctly', () {
          expect(Month.february - 13, equals(Month.january));
          expect(Month.july - 25, equals(Month.june));
          expect(Month.december - 24, equals(Month.december));
        });
        test('Subtracting negative numbers adds correctly', () {
          expect(Month.january - (-1), equals(Month.february));
          expect(Month.december - (-1), equals(Month.january));
          expect(Month.december - (-3), equals(Month.march));
        });
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
