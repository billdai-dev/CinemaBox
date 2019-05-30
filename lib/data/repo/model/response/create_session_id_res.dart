import 'package:json_annotation/json_annotation.dart';

part 'create_session_id_res.g.dart';

@JsonSerializable()
class CreateSessionIdRes extends Object {
  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'session_id')
  String sessionId;

  CreateSessionIdRes(
    this.success,
    this.sessionId,
  );

  factory CreateSessionIdRes.fromJson(Map<String, dynamic> srcJson) =>
      _$CreateSessionIdResFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CreateSessionIdResToJson(this);
}
