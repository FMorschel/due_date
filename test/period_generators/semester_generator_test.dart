import 'package:due_date/src/period_generators/month_generator.dart';
import 'package:due_date/src/period_generators/semester_generator.dart';
import 'package:due_date/src/periods/month_period.dart';
import 'package:due_date/src/periods/period.dart';
import 'package:due_date/src/periods/semester_period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('SemesterPeriodGenerator', () {
    const semesterGenerator = SemesterGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const SemesterGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of first semester', () {
        // January 1, 2022.
        final period = semesterGenerator.of(DateTime(2022));
        final expected = SemesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('End of first semester', () {
        // June 30, 2022.
        final period = semesterGenerator.of(DateTime(2022, 6, 30));
        final expected = SemesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Middle of first semester', () {
        // March 15, 2022.
        final period = semesterGenerator.of(DateTime(2022, 3, 15));
        final expected = SemesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Start of second semester', () {
        // July 1, 2022.
        final period = semesterGenerator.of(DateTime(2022, 7));
        final expected = SemesterPeriod(
          start: DateTime(2022, 7),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('End of second semester', () {
        // December 31, 2022.
        final period = semesterGenerator.of(DateTime(2022, 12, 31));
        final expected = SemesterPeriod(
          start: DateTime(2022, 7),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Middle of second semester', () {
        // September 15, 2022.
        final period = semesterGenerator.of(DateTime(2022, 9, 15));
        final expected = SemesterPeriod(
          start: DateTime(2022, 7),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });
    });

    group('before', () {
      test('Start of first semester', () {
        final period = semesterGenerator.of(DateTime(2022));
        final previous = semesterGenerator.before(period);
        final expected = SemesterPeriod(
          start: DateTime(2021, 7),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of first semester', () {
        final period = semesterGenerator.of(DateTime(2022, 6, 30));
        final previous = semesterGenerator.before(period);
        final expected = SemesterPeriod(
          start: DateTime(2021, 7),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('Start of second semester', () {
        final period = semesterGenerator.of(DateTime(2022, 7));
        final previous = semesterGenerator.before(period);
        final expected = SemesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of second semester', () {
        final period = semesterGenerator.of(DateTime(2022, 12, 31));
        final previous = semesterGenerator.before(period);
        final expected = SemesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of first semester', () {
        final period = semesterGenerator.of(DateTime(2022));
        final next = semesterGenerator.after(period);
        final expected = SemesterPeriod(
          start: DateTime(2022, 7),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of first semester', () {
        final period = semesterGenerator.of(DateTime(2022, 6, 30));
        final next = semesterGenerator.after(period);
        final expected = SemesterPeriod(
          start: DateTime(2022, 7),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('Start of second semester', () {
        final period = semesterGenerator.of(DateTime(2022, 7));
        final next = semesterGenerator.after(period);
        final expected = SemesterPeriod(
          start: DateTime(2023),
          end: DateTime(2023, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of second semester', () {
        final period = semesterGenerator.of(DateTime(2022, 12, 31));
        final next = semesterGenerator.after(period);
        final expected = SemesterPeriod(
          start: DateTime(2023),
          end: DateTime(2023, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      test('Type', () {
        final period = semesterGenerator.of(DateTime(2022));
        final months = period.months;
        expect(months, isA<List<MonthPeriod>>());
      });

      test('Length', () {
        final period = semesterGenerator.of(DateTime(2022));
        final months = period.months;
        expect(months.length, equals(6));
      });

      test('Start of first semester', () {
        const monthGenerator = MonthGenerator();
        final period = semesterGenerator.of(DateTime(2022));
        final months = period.months;
        expect(months.first, equals(monthGenerator.of(DateTime(2022))));
      });

      test('End of first semester', () {
        const monthGenerator = MonthGenerator();
        final period = semesterGenerator.of(DateTime(2022));
        final months = period.months;
        expect(months.last, equals(monthGenerator.of(DateTime(2022, 6, 30))));
      });
    });

    group('Time component preservation', () {
      test('Maintains time components in local DateTime', () {
        final input = DateTime(2022, 1, 15, 10, 30, 45, 123, 456);
        final period = semesterGenerator.of(input);
        expect(period.start.isUtc, isFalse);
        expect(period.end.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        final input = DateTime.utc(2022, 1, 15, 10, 30, 45, 123, 456);
        final period = semesterGenerator.of(input);
        expect(period.start.isUtc, isTrue);
        expect(period.end.isUtc, isTrue);
      });
    });

    group('Edge cases', () {
      group('First semester (January-June)', () {
        // January 2022.
        final day = DateTime(2022);
        final period = SemesterPeriod(
          start: day.date,
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        test('ends on June 30th', () {
          expect(semesterGenerator.of(day), equals(period));
        });
        group('months', () {
          const monthGenerator = MonthGenerator();
          final semester = semesterGenerator.of(day);
          final months = semester.months;
          test('type', () {
            expect(months, isA<List<MonthPeriod>>());
          });
          test('length', () {
            expect(months.length, equals(6));
          });
          test('start', () {
            expect(months.first, equals(monthGenerator.of(day)));
          });
          test('end', () {
            expect(
              months.last,
              equals(monthGenerator.of(DateTime(2022, 6, 30))),
            );
          });
        });
      });

      group('Second semester (July-December)', () {
        // July 2022.
        final day = DateTime(2022, DateTime.july);
        final period = SemesterPeriod(
          start: day.date,
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        test('ends on December 31st', () {
          expect(semesterGenerator.of(day), equals(period));
        });
        group('months', () {
          const monthGenerator = MonthGenerator();
          final semester = semesterGenerator.of(day);
          final months = semester.months;
          test('type', () {
            expect(months, isA<List<MonthPeriod>>());
          });
          test('length', () {
            expect(months.length, equals(6));
          });
          test('start', () {
            expect(months.first, equals(monthGenerator.of(day)));
          });
          test('end', () {
            expect(
              months.last,
              equals(monthGenerator.of(DateTime(2022, 12, 31))),
            );
          });
        });
      });

      test('Leap year first semester', () {
        // 2020 is a leap year.
        final period = semesterGenerator.of(DateTime(2020, 2, 29));
        expect(period.start.year, equals(2020));
        expect(period.start.month, equals(1));
        expect(period.end.month, equals(6));
        expect(period.end.day, equals(30));
      });

      test('Year boundary crossing', () {
        // December 31, 2021 second semester crosses into 2022.
        final period = semesterGenerator.of(DateTime(2021, 12, 31));
        final next = semesterGenerator.after(period);
        expect(next.start.year, equals(2022));
        expect(next.start.month, equals(1));
        expect(next.start.day, equals(1));
      });
    });

    test('fits generator', () {
      final firstSemester = SemesterPeriod(
        start: DateTime(2022),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      expect(semesterGenerator.fitsGenerator(firstSemester), isTrue);

      final secondSemester = SemesterPeriod(
        start: DateTime(2022, DateTime.july),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      expect(semesterGenerator.fitsGenerator(secondSemester), isTrue);

      final leapYearSemester = SemesterPeriod(
        start: DateTime(2020),
        end: DateTime(2020, 6, 30, 23, 59, 59, 999, 999),
      );
      expect(semesterGenerator.fitsGenerator(leapYearSemester), isTrue);
    });

    test('does not fit generator', () {
      final wrongStartDate = Period(
        start: DateTime(2022, 1, 2),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      expect(semesterGenerator.fitsGenerator(wrongStartDate), isFalse);

      final wrongEndDate = Period(
        start: DateTime(2022),
        end: DateTime(2022, 6, 29, 23, 59, 59, 999, 999),
      );
      expect(semesterGenerator.fitsGenerator(wrongEndDate), isFalse);

      final wrongSemester = Period(
        start: DateTime(2022),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      expect(semesterGenerator.fitsGenerator(wrongSemester), isFalse);
    });

    group('Equality', () {
      final generator1 = SemesterGenerator();
      final generator2 = SemesterGenerator();

      test('Same instance', () {
        expect(generator1, equals(generator1));
      });

      test('Different instances', () {
        expect(generator1, equals(generator2));
      });

      test('Hash codes', () {
        expect(generator1.hashCode, equals(generator2.hashCode));
      });
    });
  });
}
