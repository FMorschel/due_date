import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/group/every_date_validator_difference.dart';
import 'package:due_date/src/everies/group/every_date_validator_intersection.dart';
import 'package:due_date/src/everies/group/every_date_validator_union.dart';
import 'package:due_date/src/extensions/every_date_validator_list_ext.dart';
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
