// GENERATED CODE - DO NOT MODIFY BY HAND

part of requesttokenres;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestTokenRes _$RequestTokenResFromJson(Map<String, dynamic> json) {
  return RequestTokenRes(
      json['status_message'] as String,
      json['request_token'] as String,
      json['success'] as bool,
      json['status_code'] as int);
}

Map<String, dynamic> _$RequestTokenResToJson(RequestTokenRes instance) =>
    <String, dynamic>{
      'status_message': instance.statusMessage,
      'request_token': instance.requestToken,
      'success': instance.success,
      'status_code': instance.statusCode
    };
