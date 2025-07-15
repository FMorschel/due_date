import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('extensions.dart export check', () {
    test('All extension symbols are available', () {
      // This test will fail to compile if any export is missing.
      // Just reference one symbol from each extension file.
      final _ = [
        DateTime.now().addDays(1),
        DateTime.now().clampInMonth(DateTime.now()),
        <DateValidator>[].intersection,
        DateTime.now().dayInYear,
        <EveryDateValidator>[].intersection,
        DateTime.now().exactTimeOfDay,
        [Weekday.monday].previousWeekdays,
        DateTime.now().nextWeekday(Weekday.monday),
        DateTime.now().workdayInMonth,
      ];
      expect(_, isNotNull);
    });
  });
}
