// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenRes _$AccessTokenResFromJson(Map<String, dynamic> json) {
  return AccessTokenRes(
      json['account_id'] as String,
      json['access_token'] as String,
      json['success'] as bool,
      json['status_message'] as String,
      json['status_code'] as int);
}

Map<String, dynamic> _$AccessTokenResToJson(AccessTokenRes instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'access_token': instance.accessToken,
      'success': instance.success,
      'status_message': instance.statusMessage,
      'status_code': instance.statusCode
    };
