// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('Week:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(Week.values.length, equals(5));
        expect(
          Week.values,
          containsAllInOrder([
            Week.first,
            Week.second,
            Week.third,
            Week.fourth,
            Week.last,
          ]),
        );
      });
    });
    group('Factory methods', () {
      group('from', () {
        // Test that Week.from returns the correct Week for various days in
        // August 2022.
        const year = 2022;
        const month = 8;
        test('Returns Week.first for days 1-7', () {
          for (var day = 1; day <= 7; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.first),
              reason: 'Day $day should be Week.first',
            );
          }
        });
        test('Returns Week.second for days 8-14', () {
          for (var day = 8; day <= 14; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.second),
              reason: 'Day $day should be Week.second',
            );
          }
        });
        test('Returns Week.third for days 15-21', () {
          for (var day = 15; day <= 21; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.third),
              reason: 'Day $day should be Week.third',
            );
          }
        });
        test('Returns Week.fourth for days 22-28', () {
          for (var day = 22; day <= 28; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.fourth),
              reason: 'Day $day should be Week.fourth',
            );
          }
        });
        test('Returns Week.last for days 29-31', () {
          for (var day = 29; day <= 31; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.last),
              reason: 'Day $day should be Week.last',
            );
          }
        });
      });
    });
    group('Navigation methods', () {
      group('Previous:', () {
        for (final week in Week.values) {
          test(week.name, () {
            if (week != Week.first) {
              expect(
                week.previous,
                equals(Week.values[week.index - 1]),
              );
            } else {
              expect(week.previous, equals(Week.last));
            }
          });
        }
      });
      group('Next:', () {
        for (final week in Week.values) {
          test(week.name, () {
            if (week != Week.last) {
              expect(
                week.next,
                equals(Week.values[week.index + 1]),
              );
            } else {
              expect(week.next, equals(Week.first));
            }
          });
        }
      });
    });
    group('Properties for all values:', () {
      for (final week in Week.values) {
        group(week.name, () {
          test('index is correct', () {
            expect(week.index, equals(Week.values.indexOf(week)));
          });
        });
      }
    });
    group('String representation', () {
      test('All weeks have correct string representation', () {
        expect(Week.first.toString(), equals('Week.first'));
        expect(Week.second.toString(), equals('Week.second'));
        expect(Week.third.toString(), equals('Week.third'));
        expect(Week.fourth.toString(), equals('Week.fourth'));
        expect(Week.last.toString(), equals('Week.last'));
      });
    });
    group('Name property', () {
      test('All weeks have correct name', () {
        expect(Week.first.name, equals('first'));
        expect(Week.second.name, equals('second'));
        expect(Week.third.name, equals('third'));
        expect(Week.fourth.name, equals('fourth'));
        expect(Week.last.name, equals('last'));
      });
    });
    group('Index property', () {
      test('All weeks have correct index', () {
        for (var i = 0; i < Week.values.length; i++) {
          expect(Week.values[i].index, equals(i));
        }
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(Week.first, equals(Week.first));
        expect(Week.last, equals(Week.last));
      });
      test('Different values are not equal', () {
        expect(Week.first, isNot(equals(Week.second)));
        expect(Week.third, isNot(equals(Week.fourth)));
      });
    });
    group('Edge Cases', () {
      test('All weeks are unique', () {
        final set = Week.values.toSet();
        expect(set.length, equals(Week.values.length));
      });
    });
  });
}
