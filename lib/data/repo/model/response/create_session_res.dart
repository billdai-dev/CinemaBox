import 'package:json_annotation/json_annotation.dart';

part 'create_session_res.g.dart';

@JsonSerializable()
class CreateSessionRes extends Object {
  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'session_id')
  String sessionId;

  CreateSessionRes(
    this.success,
    this.sessionId,
  );

  factory CreateSessionRes.fromJson(Map<String, dynamic> srcJson) =>
      _$CreateSessionResFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CreateSessionResToJson(this);
}
