import 'package:json_annotation/json_annotation.dart';

part 'access_token_res.g.dart';

@JsonSerializable()
class AccessTokenRes {
  @JsonKey(name: 'account_id')
  String accountId;

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'status_message')
  String statusMessage;

  @JsonKey(name: 'status_code')
  int statusCode;

  AccessTokenRes(
    this.accountId,
    this.accessToken,
    this.success,
    this.statusMessage,
    this.statusCode,
  );

  factory AccessTokenRes.fromJson(Map<String, dynamic> srcJson) =>
      _$AccessTokenResFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccessTokenResToJson(this);
}
