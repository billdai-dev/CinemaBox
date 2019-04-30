library requesttokenres;

import 'package:json_annotation/json_annotation.dart';

part 'request_token_res.g.dart';

@JsonSerializable()
class RequestTokenRes {
  factory RequestTokenRes.fromJson(Map<String, dynamic> json) =>
      _$RequestTokenResFromJson(json);

  Map<String, dynamic> toJson(RequestTokenRes instance) =>
      _$RequestTokenResToJson(instance);

  @JsonKey(name: "status_message")
  String statusMessage;
  @JsonKey(name: "request_token")
  String requestToken;
  bool success;
  @JsonKey(name: "status_code")
  int statusCode;

  RequestTokenRes(
      this.statusMessage, this.requestToken, this.success, this.statusCode);
}
