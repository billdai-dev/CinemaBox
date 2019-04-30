// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSessionRes _$CreateSessionResFromJson(Map<String, dynamic> json) {
  return CreateSessionRes(
      json['success'] as bool, json['session_id'] as String);
}

Map<String, dynamic> _$CreateSessionResToJson(CreateSessionRes instance) =>
    <String, dynamic>{
      'success': instance.success,
      'session_id': instance.sessionId
    };
