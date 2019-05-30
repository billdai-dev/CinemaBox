// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_id_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSessionIdRes _$CreateSessionIdResFromJson(Map<String, dynamic> json) {
  return CreateSessionIdRes(
      json['success'] as bool, json['session_id'] as String);
}

Map<String, dynamic> _$CreateSessionIdResToJson(CreateSessionIdRes instance) =>
    <String, dynamic>{
      'success': instance.success,
      'session_id': instance.sessionId
    };
