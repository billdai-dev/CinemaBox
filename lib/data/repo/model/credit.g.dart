// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credit _$CreditFromJson(Map<String, dynamic> json) {
  return Credit(
      json['id'] as int,
      (json['cast'] as List)
          ?.map((e) =>
              e == null ? null : Cast.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['crew'] as List)
          ?.map((e) =>
              e == null ? null : Crew.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CreditToJson(Credit instance) => <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast,
      'crew': instance.crew
    };

Cast _$CastFromJson(Map<String, dynamic> json) {
  return Cast(
      json['cast_id'] as int,
      json['character'] as String,
      json['credit_id'] as String,
      json['gender'] as int,
      json['id'] as int,
      json['name'] as String,
      json['order'] as int,
      json['profile_path'] as String);
}

Map<String, dynamic> _$CastToJson(Cast instance) => <String, dynamic>{
      'cast_id': instance.castId,
      'character': instance.character,
      'credit_id': instance.creditId,
      'gender': instance.gender,
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'profile_path': instance.profilePath
    };

Crew _$CrewFromJson(Map<String, dynamic> json) {
  return Crew(
      json['credit_id'] as String,
      json['department'] as String,
      json['gender'] as int,
      json['id'] as int,
      json['job'] as String,
      json['name'] as String,
      json['profile_path'] as String);
}

Map<String, dynamic> _$CrewToJson(Crew instance) => <String, dynamic>{
      'credit_id': instance.creditId,
      'department': instance.department,
      'gender': instance.gender,
      'id': instance.id,
      'job': instance.job,
      'name': instance.name,
      'profile_path': instance.profilePath
    };
