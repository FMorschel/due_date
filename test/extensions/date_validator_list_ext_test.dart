import 'package:due_date/src/date_validators/group/date_validator_difference.dart';
import 'package:due_date/src/date_validators/group/date_validator_intersection.dart';
import 'package:due_date/src/date_validators/group/date_validator_union.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_weekday.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/extensions/date_validator_list_ext.dart';
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
