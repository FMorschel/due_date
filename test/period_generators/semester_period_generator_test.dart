import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('SemesterPeriodGenerator', () {
    const semesterGenerator = SemesterGenerator();
    group('First semester of the year', () {
      final day = DateTime(2022);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      test('ends on june 30th', () {
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
    group('Second semester of the year', () {
      final day = DateTime(2022, DateTime.july);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('ends on december 31st', () {
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
    group('before', () {
      final period = Period(
        start: DateTime(2022, DateTime.july),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      test('returns the previous semester', () {
        expect(semesterGenerator.before(period), equals(expected));
      });
    });
    group('after', () {
      final period = Period(
        start: DateTime(2022),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, DateTime.july),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('returns the next semester', () {
        expect(semesterGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      test('first semester', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(semesterGenerator.fitsGenerator(period), isTrue);
      });
      test('second semester', () {
        final period = Period(
          start: DateTime(2022, DateTime.july),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(semesterGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
}
