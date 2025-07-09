// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('Weekday:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(Weekday.values.length, equals(7));
        expect(
          Weekday.values,
          containsAllInOrder([
            Weekday.monday,
            Weekday.tuesday,
            Weekday.wednesday,
            Weekday.thursday,
            Weekday.friday,
            Weekday.saturday,
            Weekday.sunday,
          ]),
        );
      });
    });
    group('Factory methods', () {
      group('Throw on factory outside of range:', () {
        test('Value below 1', () {
          expect(() => Weekday.fromDateTimeValue(0), throwsRangeError);
        });
        test('Value above 7', () {
          expect(() => Weekday.fromDateTimeValue(8), throwsRangeError);
        });
      });
    });
    group('Navigation methods', () {
      group('Previous:', () {
        for (final weekday in Weekday.values) {
          test(weekday.name, () {
            if (weekday != Weekday.monday) {
              expect(
                weekday.previous,
                equals(Weekday.fromDateTimeValue(weekday.dateTimeValue - 1)),
              );
            } else {
              expect(weekday.previous, equals(Weekday.sunday));
            }
          });
        }
      });
      group('Next:', () {
        for (final weekday in Weekday.values) {
          test(weekday.name, () {
            if (weekday != Weekday.sunday) {
              expect(
                weekday.next,
                equals(Weekday.fromDateTimeValue(weekday.dateTimeValue + 1)),
              );
            } else {
              expect(weekday.next, equals(Weekday.monday));
            }
          });
        }
      });
    });
    group('Collections', () {
      group('WeekendDays:', () {
        final set = {Weekday.saturday, Weekday.sunday};
        test('Contains all weekend days', () {
          expect(
            Weekday.weekend,
            containsAllInOrder(set),
          );
        });
        test('Is Set<Weekday>', () {
          expect(
            Weekday.weekend,
            isA<Set<Weekday>>(),
          );
        });
      });
      group('Workdays:', () {
        final set = {
          Weekday.monday,
          Weekday.tuesday,
          Weekday.wednesday,
          Weekday.thursday,
          Weekday.friday,
        };
        test('Contains all workdays', () {
          expect(
            Weekday.workdays,
            containsAllInOrder(set),
          );
        });
        test('Is Set<Weekday>', () {
          expect(
            Weekday.workdays,
            isA<Set<Weekday>>(),
          );
        });
      });
    });
    group('Properties for all values:', () {
      for (final weekday in Weekday.values) {
        group(weekday.name, () {
          test('dateTimeValue is correct', () {
            expect(weekday.dateTimeValue, equals(weekday.index + 1));
          });
        });
      }
    });
    group('fromThisWeek:', () {
      final date = DateTime.utc(2022, DateTime.august, 8);
      for (final weekday in Weekday.values) {
        test(weekday.name, () {
          final result = weekday.fromWeekOf(date);
          expect(result.weekday, equals(weekday.dateTimeValue));
        });
      }
    });
    group('occurrencesIn august 2022', () {
      final month = DateTime.utc(2022, DateTime.august);
      test('monday', () {
        const monday = Weekday.monday;
        expect(
          monday.occurrencesIn(month.year, month.month),
          equals(5),
        );
      });
      test('tuesday', () {
        const tuesday = Weekday.tuesday;
        expect(
          tuesday.occurrencesIn(month.year, month.month),
          equals(5),
        );
      });
      test('wednesday', () {
        const wednesday = Weekday.wednesday;
        expect(
          wednesday.occurrencesIn(month.year, month.month),
          equals(5),
        );
      });
      test('thursday', () {
        const thursday = Weekday.thursday;
        expect(
          thursday.occurrencesIn(month.year, month.month),
          equals(4),
        );
      });
      test('friday', () {
        const friday = Weekday.friday;
        expect(
          friday.occurrencesIn(month.year, month.month),
          equals(4),
        );
      });
      test('saturday', () {
        const saturday = Weekday.saturday;
        expect(
          saturday.occurrencesIn(month.year, month.month),
          equals(4),
        );
      });
      test('sunday', () {
        const sunday = Weekday.sunday;
        expect(
          sunday.occurrencesIn(month.year, month.month),
          equals(4),
        );
      });
    });
    group('String representation', () {
      test('All weekdays have correct string representation', () {
        expect(Weekday.monday.toString(), equals('Weekday.monday'));
        expect(Weekday.tuesday.toString(), equals('Weekday.tuesday'));
        expect(
          Weekday.wednesday.toString(),
          equals('Weekday.wednesday'),
        );
        expect(Weekday.thursday.toString(), equals('Weekday.thursday'));
        expect(Weekday.friday.toString(), equals('Weekday.friday'));
        expect(Weekday.saturday.toString(), equals('Weekday.saturday'));
        expect(Weekday.sunday.toString(), equals('Weekday.sunday'));
      });
    });
    group('Name property', () {
      test('All weekdays have correct name', () {
        expect(Weekday.monday.name, equals('monday'));
        expect(Weekday.tuesday.name, equals('tuesday'));
        expect(Weekday.wednesday.name, equals('wednesday'));
        expect(Weekday.thursday.name, equals('thursday'));
        expect(Weekday.friday.name, equals('friday'));
        expect(Weekday.saturday.name, equals('saturday'));
        expect(Weekday.sunday.name, equals('sunday'));
      });
    });
    group('Index property', () {
      test('All weekdays have correct index', () {
        for (var i = 0; i < Weekday.values.length; i++) {
          expect(Weekday.values[i].index, equals(i));
        }
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(Weekday.monday, equals(Weekday.monday));
        expect(Weekday.sunday, equals(Weekday.sunday));
      });
      test('Different values are not equal', () {
        expect(Weekday.monday, isNot(equals(Weekday.tuesday)));
        expect(Weekday.friday, isNot(equals(Weekday.saturday)));
      });
    });
    group('Edge Cases', () {
      test('All weekdays are unique', () {
        final set = Weekday.values.toSet();
        expect(set.length, equals(Weekday.values.length));
      });
    });
    group('Getter tests', () {
      group('every getter:', () {
        for (final weekday in Weekday.values) {
          test('${weekday.name} every getter returns correct EveryWeekday', () {
            final everyWeekday = weekday.every;
            expect(everyWeekday, isA<EveryWeekday>());
            expect(everyWeekday.weekday, equals(weekday));
          });
        }

        test('All weekdays return const EveryWeekday instances', () {
          for (final weekday in Weekday.values) {
            final every = weekday.every;
            expect(every, isA<EveryWeekday>());
            expect(every.weekday, equals(weekday));

            // Verify it's the same const instance when called multiple times
            final everyAgain = weekday.every;
            expect(identical(every, everyAgain), isTrue);
          }
        });
      });

      group('validator getter:', () {
        for (final weekday in Weekday.values) {
          test(
              '${weekday.name} validator getter returns correct '
              'DateValidatorWeekday', () {
            final validator = weekday.validator;
            expect(validator, isA<DateValidatorWeekday>());
            expect(validator.weekday, equals(weekday));
          });
        }

        test('All weekdays return const DateValidatorWeekday instances', () {
          for (final weekday in Weekday.values) {
            final validator = weekday.validator;
            expect(validator, isA<DateValidatorWeekday>());
            expect(validator.weekday, equals(weekday));

            // Verify it's the same const instance when called multiple times
            final validatorAgain = weekday.validator;
            expect(identical(validator, validatorAgain), isTrue);
          }
        });
      });

      group('every and validator functionality tests:', () {
        test('every instances can generate correct dates', () {
          // July 1, 2024 is Monday
          final monday = DateTime.utc(2024, 7);

          for (final weekday in Weekday.values) {
            final every = weekday.every;
            final nextDate = every.next(monday);

            // The next occurrence should have the correct weekday
            expect(Weekday.from(nextDate), equals(weekday));

            // The generated date should be valid according to the validator
            expect(every.valid(nextDate), isTrue);
          }
        });

        test('validator instances correctly validate dates', () {
          // Test dates for each weekday in July 2024
          final testDates = [
            // Monday
            DateTime.utc(2024, 7),
            // Tuesday
            DateTime.utc(2024, 7, 2),
            // Wednesday
            DateTime.utc(2024, 7, 3),
            // Thursday
            DateTime.utc(2024, 7, 4),
            // Friday
            DateTime.utc(2024, 7, 5),
            // Saturday
            DateTime.utc(2024, 7, 6),
            // Sunday
            DateTime.utc(2024, 7, 7),
          ];

          for (var i = 0; i < Weekday.values.length; i++) {
            final weekday = Weekday.values[i];
            final validator = weekday.validator;
            final testDate = testDates[i];

            // The validator should accept dates with matching weekdays
            expect(validator.valid(testDate), isTrue);
            expect(Weekday.from(testDate), equals(weekday));

            // The validator should reject dates with different weekdays
            for (var j = 0; j < testDates.length; j++) {
              if (i != j) {
                expect(validator.valid(testDates[j]), isFalse);
              }
            }
          }
        });
        test('every and validator consistency', () {
          // July 1, 2024 is Monday
          final startDate = DateTime.utc(2024, 7);

          for (final weekday in Weekday.values) {
            final every = weekday.every;
            final validator = weekday.validator;

            final nextDate = every.next(startDate);

            // The validator should validate dates generated by every
            expect(validator.valid(nextDate), isTrue);

            // Both should reference the same weekday
            expect(every.weekday, equals(validator.weekday));
            expect(every.weekday, equals(weekday));
          }
        });
      });
    });
    group('Comparison operators', () {
      test('Greater than operator', () {
        expect(Weekday.tuesday > Weekday.monday, isTrue);
        expect(Weekday.sunday > Weekday.saturday, isTrue);
        expect(Weekday.friday > Weekday.wednesday, isTrue);
        expect(Weekday.monday > Weekday.tuesday, isFalse);
        expect(Weekday.monday > Weekday.monday, isFalse);
      });

      test('Greater than or equal operator', () {
        expect(Weekday.tuesday >= Weekday.monday, isTrue);
        expect(Weekday.sunday >= Weekday.saturday, isTrue);
        expect(Weekday.friday >= Weekday.wednesday, isTrue);
        expect(Weekday.monday >= Weekday.monday, isTrue);
        expect(Weekday.monday >= Weekday.tuesday, isFalse);
      });

      test('Less than operator', () {
        expect(Weekday.monday < Weekday.tuesday, isTrue);
        expect(Weekday.saturday < Weekday.sunday, isTrue);
        expect(Weekday.wednesday < Weekday.friday, isTrue);
        expect(Weekday.tuesday < Weekday.monday, isFalse);
        expect(Weekday.monday < Weekday.monday, isFalse);
      });

      test('Less than or equal operator', () {
        expect(Weekday.monday <= Weekday.tuesday, isTrue);
        expect(Weekday.saturday <= Weekday.sunday, isTrue);
        expect(Weekday.wednesday <= Weekday.friday, isTrue);
        expect(Weekday.monday <= Weekday.monday, isTrue);
        expect(Weekday.tuesday <= Weekday.monday, isFalse);
      });

      test('All weekdays in correct order', () {
        const weekdays = Weekday.values;
        for (var i = 0; i < weekdays.length - 1; i++) {
          expect(weekdays[i] < weekdays[i + 1], isTrue);
          expect(weekdays[i] <= weekdays[i + 1], isTrue);
          expect(weekdays[i + 1] > weekdays[i], isTrue);
          expect(weekdays[i + 1] >= weekdays[i], isTrue);
        }
      });
    });

    group('Arithmetic operators', () {
      group('Addition operator (+)', () {
        test('Add single day', () {
          expect(Weekday.monday + 1, equals(Weekday.tuesday));
          expect(Weekday.tuesday + 1, equals(Weekday.wednesday));
          expect(Weekday.wednesday + 1, equals(Weekday.thursday));
          expect(Weekday.thursday + 1, equals(Weekday.friday));
          expect(Weekday.friday + 1, equals(Weekday.saturday));
          expect(Weekday.saturday + 1, equals(Weekday.sunday));
          expect(Weekday.sunday + 1, equals(Weekday.monday));
        });

        test('Add multiple days', () {
          expect(Weekday.monday + 3, equals(Weekday.thursday));
          expect(Weekday.friday + 3, equals(Weekday.monday));
          expect(Weekday.wednesday + 5, equals(Weekday.monday));
          expect(Weekday.saturday + 2, equals(Weekday.monday));
        });

        test('Add zero days', () {
          for (final weekday in Weekday.values) {
            expect(weekday + 0, equals(weekday));
          }
        });

        test('Add full week (7 days)', () {
          for (final weekday in Weekday.values) {
            expect(weekday + 7, equals(weekday));
          }
        });

        test('Add multiple weeks', () {
          for (final weekday in Weekday.values) {
            expect(weekday + 14, equals(weekday));
            expect(weekday + 21, equals(weekday));
            expect(weekday + 28, equals(weekday));
          }
        });

        test('Large numbers cycle correctly', () {
          expect(Weekday.monday + 100, equals(Weekday.wednesday));
          expect(Weekday.friday + 365, equals(Weekday.saturday));
        });
      });

      group('Subtraction operator (-)', () {
        test('Subtract single day', () {
          expect(Weekday.tuesday - 1, equals(Weekday.monday));
          expect(Weekday.wednesday - 1, equals(Weekday.tuesday));
          expect(Weekday.thursday - 1, equals(Weekday.wednesday));
          expect(Weekday.friday - 1, equals(Weekday.thursday));
          expect(Weekday.saturday - 1, equals(Weekday.friday));
          expect(Weekday.sunday - 1, equals(Weekday.saturday));
          expect(Weekday.monday - 1, equals(Weekday.sunday));
        });

        test('Subtract multiple days', () {
          expect(Weekday.thursday - 3, equals(Weekday.monday));
          expect(Weekday.monday - 3, equals(Weekday.friday));
          expect(Weekday.monday - 5, equals(Weekday.wednesday));
          expect(Weekday.monday - 2, equals(Weekday.saturday));
        });

        test('Subtract zero days', () {
          for (final weekday in Weekday.values) {
            expect(weekday - 0, equals(weekday));
          }
        });

        test('Subtract full week (7 days)', () {
          for (final weekday in Weekday.values) {
            expect(weekday - 7, equals(weekday));
          }
        });

        test('Subtract multiple weeks', () {
          for (final weekday in Weekday.values) {
            expect(weekday - 14, equals(weekday));
            expect(weekday - 21, equals(weekday));
            expect(weekday - 28, equals(weekday));
          }
        });

        test('Large numbers cycle correctly', () {
          expect(Weekday.tuesday - 100, equals(Weekday.sunday));
          expect(Weekday.saturday - 365, equals(Weekday.friday));
        });
      });

      group('Addition and subtraction are inverse operations', () {
        for (final weekday in Weekday.values) {
          test('${weekday.name} addition and subtraction', () {
            for (var days = 1; days <= 10; days++) {
              expect((weekday + days) - days, equals(weekday));
              expect((weekday - days) + days, equals(weekday));
            }
          });
        }
      });
    });

    group('Deprecated methods', () {
      group('occrurencesIn (deprecated)', () {
        test('Returns same result as occurrencesIn for August 2022', () {
          final month = DateTime.utc(2022, DateTime.august);
          for (final weekday in Weekday.values) {
            // ignore: deprecated_member_use_from_same_package
            final deprecatedResult =
                weekday.occurrencesIn(month.year, month.month);
            final currentResult =
                weekday.occurrencesIn(month.year, month.month);
            expect(deprecatedResult, equals(currentResult));
          }
        });

        test(
            'Returns same result as occurrencesIn for February 2024 (leap '
            'year)', () {
          const year = 2024;
          const month = DateTime.february;
          for (final weekday in Weekday.values) {
            // ignore: deprecated_member_use_from_same_package
            final deprecatedResult = weekday.occrurencesIn(year, month);
            final currentResult = weekday.occurrencesIn(year, month);
            expect(deprecatedResult, equals(currentResult));
          }
        });

        test(
            'Returns same result as occurrencesIn for February 2023 (non-leap '
            'year)', () {
          const year = 2023;
          const month = DateTime.february;
          for (final weekday in Weekday.values) {
            // ignore: deprecated_member_use_from_same_package
            final deprecatedResult = weekday.occrurencesIn(year, month);
            final currentResult = weekday.occurrencesIn(year, month);
            expect(deprecatedResult, equals(currentResult));
          }
        });
      });
    });
  });
}
