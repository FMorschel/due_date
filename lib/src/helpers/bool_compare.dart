// ignore_for_file: avoid_positional_boolean_parameters, clear positionals

/// Helper function to compare two nullable booleans.
int boolCompareTo(bool? a, bool? b) {
  if (a == b) return 0;
  if (a == null) return -1;
  if (b == null) return 1;
  return a ? 1 : -1;
}
