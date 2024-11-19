import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorListExt on List<DateValidator>', () {
    const tuesday = DateValidatorWeekday(Weekday.tuesday);
    const thursday = DateValidatorWeekday(Weekday.thursday);
    final list = [tuesday, thursday];
    test('Intersection', () {
      final result = DateValidatorIntersection(list);
      expect(list.intersection, equals(result));
    });
    test('Union', () {
      final result = DateValidatorUnion(list);
      expect(list.union, equals(result));
    });
    test('Difference', () {
      final result = DateValidatorDifference(list);
      expect(list.difference, equals(result));
    });
  });
}
