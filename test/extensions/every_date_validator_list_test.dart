import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('EveryDateValidatorListExt on List<EveryDateValidator>', () {
    const tuesday = EveryWeekday(Weekday.tuesday);
    const thursday = EveryWeekday(Weekday.thursday);
    final list = [tuesday, thursday];
    test('Intersection', () {
      final result = EveryDateValidatorIntersection(list);
      expect(list.intersection, equals(result));
    });
    test('Union', () {
      final result = EveryDateValidatorUnion(list);
      expect(list.union, equals(result));
    });
    test('Difference', () {
      final result = EveryDateValidatorDifference(list);
      expect(list.difference, equals(result));
    });
  });
}
