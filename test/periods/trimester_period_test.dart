import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('TrimesterPeriod', () {
    test('Months', () {
      const generator = TrimesterGenerator();
      const monthGenerator = MonthGenerator();
      final trimester = generator.of(DateTime(2020));
      final months = trimester.months;
      expect(months, isA<List<MonthPeriod>>());
      expect(months, hasLength(3));
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
            start: DateTime(2020, 3),
            end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
}
