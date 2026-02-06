import 'package:collection/collection.dart';
import 'package:due_date/src/date_validators/date_validator_mixin.dart';
import 'package:due_date/src/date_validators/group/date_validator_list_mixin.dart';
import 'package:due_date/src/everies/every_date_validator.dart';
import 'package:due_date/src/everies/group/every_date_validator_list_mixin.dart';
import 'package:due_date/src/helpers/workday_helper.dart';
import 'package:test/test.dart';

import '../src/every_match.dart';

class EveryDateValidatorListMixinTest extends DelegatingList<EveryDateValidator>
    with
        DateValidatorListMixin,
        EveryDateValidatorListMixin,
        DateValidatorMixin {
  const EveryDateValidatorListMixinTest(super.base);

  @override
  DateTime next(DateTime date, {DateTime? limit}) =>
      date.add(const Duration(days: 1));

  @override
  DateTime previous(DateTime date, {DateTime? limit}) =>
      date.subtract(const Duration(days: 1));

  @override
  bool valid(DateTime date) => date.day.isOdd;
}

void main() {
  group('EveryDateValidatorListMixin', () {
    const every = EveryDateValidatorListMixinTest([]);
    test('constructor', () {
      expect(every, isA<EveryDateValidatorListMixin>());
    });
    final date1 = DateTime(2024, 1, 1);
    final date2 = DateTime(2024, 1, 2);
    final date3 = DateTime(2024, 1, 3);
    group('startDate', () {
      test('valid', () {
        expect(every, startsAt(date1).withInput(date1));
      });
      test('invalid', () {
        expect(every, startsAt(date3).withInput(date2));
      });
    });
    test('next', () {
      expect(every, hasNext(date3).withInput(date2));
    });
    test('previous', () {
      expect(every, hasPrevious(date1).withInput(date2));
    });
    group('endDate', () {
      test('valid', () {
        expect(every, endsAt(date3).withInput(date3));
      });
      test('invalid', () {
        expect(every, endsAt(date1).withInput(date2));
      });
    });
    group('everies', () {
      test('is empty list', () {
        expect(every.everies, isEmpty);
      });
      test('is same', () {
        expect(
          EveryDateValidatorListMixinTest(WorkdayHelper.every),
          equals(WorkdayHelper.every),
        );
      });
    });
  });
}
