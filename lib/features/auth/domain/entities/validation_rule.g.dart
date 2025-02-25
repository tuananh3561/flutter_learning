// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValidationRuleImpl _$$ValidationRuleImplFromJson(Map<String, dynamic> json) =>
    _$ValidationRuleImpl(
      type: $enumDecode(_$ValidationTypeEnumMap, json['type']),
      value: json['value'],
      message: json['message'] as String,
      validator: const ValidatorFunctionConverter()
          .fromJson(json['validator'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$$ValidationRuleImplToJson(
        _$ValidationRuleImpl instance) =>
    <String, dynamic>{
      'type': _$ValidationTypeEnumMap[instance.type]!,
      'value': instance.value,
      'message': instance.message,
      'validator':
          const ValidatorFunctionConverter().toJson(instance.validator),
    };

const _$ValidationTypeEnumMap = {
  ValidationType.required: 'required',
  ValidationType.minLength: 'minLength',
  ValidationType.maxLength: 'maxLength',
  ValidationType.pattern: 'pattern',
  ValidationType.custom: 'custom',
};
