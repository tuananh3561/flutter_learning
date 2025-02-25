// lib/features/auth/domain/usecases/validate_field_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/validation_repository.dart';

part 'validate_field_usecase.freezed.dart';
part 'validate_field_usecase.g.dart';

@injectable
class ValidateFieldUseCase implements UseCase<bool, ValidateFieldParams> {
  final ValidationRepository repository;

  ValidateFieldUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateFieldParams params) async {
    final rules = repository.getRulesForField(params.fieldName);
    return repository.validateField(params.value, rules);
  }
}

@freezed
class ValidateFieldParams with _$ValidateFieldParams {
  const factory ValidateFieldParams({
    required String fieldName,
    required String value,
  }) = _ValidateFieldParams;

  factory ValidateFieldParams.fromJson(Map<String, dynamic> json) =>
      _$ValidateFieldParamsFromJson(json);
}
