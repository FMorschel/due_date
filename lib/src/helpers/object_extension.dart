/// Extension for [Object]s.
extension ObjectExt<T extends Object> on T {
  /// Returns the result of [orElse] if [predicate] returns false, otherwise
  /// returns this.
  T? when(bool Function(T self) predicate, {T? Function(T self)? orElse}) =>
      when2(predicate).ifElse(orElse);

  /// Returns an instance of [_When] that allows further processing.
  // ignore: library_private_types_in_public_api, should be used internally
  _When<T> when2(bool Function(T self) predicate) => _When(this, predicate);

  /// Special case when "there is no else", avoiding the curried invocation.
  T? whenn(bool Function(T self) predicate) => predicate(this) ? this : null;

  /// Applies [f] to this object and returns the result.
  R apply<R>(R Function(T self) f) => f(this);
}

class _When<T> {
  _When(this.self, this.predicate);

  final T self;
  final bool Function(T self) predicate;

  /// Non-nullable processing: Must pass `orElse` argument, returns non-null.
  T orElse(T Function(T self) orElse) => predicate(self) ? self : orElse(self);

  /// Nullable processing: Can omit `ifElse` argument, may return null.
  // ignore: essential_lints/optional_positional_parameters valid use
  T? ifElse([T? Function(T self)? ifElse]) =>
      predicate(self) ? self : ifElse?.call(self);

  /// Use null when the predicate is false ("there is no else").
  T? call() => predicate(self) ? self : null;
}
