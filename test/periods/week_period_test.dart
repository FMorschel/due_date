import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('WeekPeriod', () {
    test('Days', () {
      const generator = WeekGenerator();
      const dayGenerator = DayGenerator();
      final week = generator.of(DateTime(2020));
      final days = week.days;
      expect(days, isA<List<DayPeriod>>());
      expect(days, hasLength(7));
      expect(days.none((day) => !dayGenerator.fitsGenerator(day)), isTrue);
      expect(
        days.first,
        equals(
          Period(
            start: DateTime(2019, 12, 30),
            end: DateTime(2019, 12, 30, 23, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
}
