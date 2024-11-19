import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('SemesterPeriod', () {
    test('Months', () {
      const generator = SemesterGenerator();
      const monthGenerator = MonthGenerator();
      final semester = generator.of(DateTime(2020));
      final months = semester.months;
      expect(months, isA<List<MonthPeriod>>());
      expect(months, hasLength(6));
      expect(
        months.none((month) => !monthGenerator.fitsGenerator(month)),
        isTrue,
      );
      expect(
        months.first,
        equals(
          Period(
            start: DateTime(2020),
            end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
          ),
        ),
      );
      expect(
        months.last,
        equals(
          Period(
            start: DateTime(2020, 6),
            end: DateTime(2020, 6, 30, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
    group('YearPeriod', () {
      test('Months', () {
        const generator = YearGenerator();
        const monthGenerator = MonthGenerator();
        final year = generator.of(DateTime(2020));
        final months = year.months;
        expect(months, isA<List<MonthPeriod>>());
        expect(months, hasLength(12));
        expect(
          months.none((month) => !monthGenerator.fitsGenerator(month)),
          isTrue,
        );
        expect(
          months.first,
          equals(
            Period(
              start: DateTime(2020),
              end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
        expect(
          months.last,
          equals(
            Period(
              start: DateTime(2020, 12),
              end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });
    });
  });
}
