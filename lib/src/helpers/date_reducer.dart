/// Helper class to reduce a list of dates to a single date.
class DateReducer {
  const DateReducer._();

  /// Reduces a list of dates to the oldest date.
  static DateTime reduceFuture(DateTime value, DateTime element) {
    return value.isBefore(element) ? value : element;
  }

  /// Reduces a list of dates to the newest date.
  static DateTime reducePast(DateTime value, DateTime element) {
    return value.isAfter(element) ? value : element;
  }
}
