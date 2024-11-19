import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('MonthPeriod', () {
    test('Days', () {
      const generator = MonthGenerator();
      const dayGenerator = DayGenerator();
      final month = generator.of(DateTime(2020));
      final days = month.days;
      expect(days, isA<List<DayPeriod>>());
      expect(days, hasLength(31));
      expect(days.none((day) => !dayGenerator.fitsGenerator(day)), isTrue);
      expect(
        days.first,
        equals(
          Period(
            start: DateTime(2020),
            end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
          ),
        ),
      );
      expect(
        days.last,
        equals(
          Period(
            start: DateTime(2020, 1, 31),
            end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
}
