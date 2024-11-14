/// Extension for [Object]s.
extension ObjectExt<T extends Object> on T {
  /// Returns the result of [orElse] if [predicate] returns false, otherwise
  /// returns this.
  T? when(bool Function(T self) predicate, {T? Function(T self)? orElse}) =>
      predicate(this) ? this : orElse?.call(this);

  /// Applies [f] to this object and returns the result.
  R apply<R>(R Function(T self) f) => f(this);
}
