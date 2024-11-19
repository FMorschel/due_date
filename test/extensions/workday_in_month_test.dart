import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('WorkdayInMonth', () {
    group('isWorkday', () {
      test('sunday is not workday', () {
        final date = DateTime(2023);
        expect(date.isWorkday, false);
      });
      test('monday is workday', () {
        final date = DateTime(2023, 1, 2);
        expect(date.isWorkday, true);
      });
      test('tuesday is workday', () {
        final date = DateTime(2023, 1, 3);
        expect(date.isWorkday, true);
      });
      test('wednesday is workday', () {
        final date = DateTime(2023, 1, 4);
        expect(date.isWorkday, true);
      });
      test('thursday is workday', () {
        final date = DateTime(2023, 1, 5);
        expect(date.isWorkday, true);
      });
      test('friday is workday', () {
        final date = DateTime(2023, 1, 6);
        expect(date.isWorkday, true);
      });
      test('saturday is not workday', () {
        final date = DateTime(2023, 1, 7);
        expect(date.isWorkday, false);
      });
    });
    group('workdayInMonth', () {
      var workday = 0;
      for (var i = 1; i <= 31; i++) {
        test('$i get workday', () {
          final date = DateTime(2023, 1, i);
          if (date.isWorkday) {
            workday++;
            expect(date.workdayInMonth, workday);
          } else {
            expect(date.workdayInMonth, 0);
          }
        });
      }
    });
  });
}
