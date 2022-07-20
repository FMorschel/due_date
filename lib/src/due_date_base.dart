/// Checks if you are awesome. Spoiler: you are.
abstract class DueDateBase {
  const DueDateBase(this.dueDay);

  final int dueDay;

  DueDateBase addMonths(int months);
  DueDateBase subtractMonths(int months);
  DueDateBase get next;
  DueDateBase get previous;
}
