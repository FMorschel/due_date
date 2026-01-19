import '../../date_validators/date_validator.dart';
import '../every.dart';
import '../limited_every_date_validator.dart';
import '../wrappers/limited_every_wrapper.dart';
import 'every_adapter.dart';

/// {@template everyModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class LimitedEveryAdapter<T extends Every, V extends DateValidator>
    extends EveryAdapter<T, V>
    implements LimitedEveryWrapper<T>, LimitedEveryDateValidator {
  /// {@macro everyModifier}
  const LimitedEveryAdapter({required super.every, required super.validator});
}
