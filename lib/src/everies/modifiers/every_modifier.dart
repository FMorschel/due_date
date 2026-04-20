import 'package:essential_lints_annotations/essential_lints_annotations.dart';

import '../../date_validators/date_validator_mixin.dart';
import '../date_direction.dart';
import '../every_date_validator.dart';
import '../wrappers/every_wrapper.dart';

/// {@template everyModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
@SubtypeNaming(containing: 'Modifier', packageOption: PackageOption.private)
@SubtypeUnnaming(containing: 'Wrapper', packageOption: PackageOption.private)
abstract class EveryModifier<T extends EveryDateValidator>
    extends EveryDateValidator
    with DateValidatorMixin
    implements EveryWrapper<T> {
  /// {@macro everyModifier}
  const EveryModifier({required this.every});

  /// The base generator for this [EveryModifier].
  @override
  final T every;

  /// A method that processes [date] with custom logic.
  @override
  DateTime processDate(DateTime date, DateDirection direction);
}
