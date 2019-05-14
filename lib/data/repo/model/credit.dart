import 'package:json_annotation/json_annotation.dart';

part 'credit.g.dart';

@JsonSerializable()
class Credit extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'cast')
  List<Cast> cast;

  @JsonKey(name: 'crew')
  List<Crew> crew;

  Credit(
    this.id,
    this.cast,
    this.crew,
  );

  factory Credit.fromJson(Map<String, dynamic> srcJson) =>
      _$CreditFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CreditToJson(this);
}

@JsonSerializable()
class Cast extends Object {
  @JsonKey(name: 'cast_id')
  int castId;

  @JsonKey(name: 'character')
  String character;

  @JsonKey(name: 'credit_id')
  String creditId;

  @JsonKey(name: 'gender')
  int gender;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'order')
  int order;

  @JsonKey(name: 'profile_path')
  String profilePath;

  Cast(
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  );

  factory Cast.fromJson(Map<String, dynamic> srcJson) =>
      _$CastFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CastToJson(this);
}

@JsonSerializable()
class Crew extends Object {
  @JsonKey(name: 'credit_id')
  String creditId;

  @JsonKey(name: 'department')
  String department;

  @JsonKey(name: 'gender')
  int gender;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'job')
  String job;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'profile_path')
  String profilePath;

  Crew(
    this.creditId,
    this.department,
    this.gender,
    this.id,
    this.job,
    this.name,
    this.profilePath,
  );

  factory Crew.fromJson(Map<String, dynamic> srcJson) =>
      _$CrewFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CrewToJson(this);
}
