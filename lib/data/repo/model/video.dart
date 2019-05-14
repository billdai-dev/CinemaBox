import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
class Video extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'results')
  List<Result> results;

  Video(
    this.id,
    this.results,
  );

  factory Video.fromJson(Map<String, dynamic> srcJson) =>
      _$VideoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

@JsonSerializable()
class Result extends Object {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'iso_639_1')
  String iso6391;

  @JsonKey(name: 'iso_3166_1')
  String iso31661;

  @JsonKey(name: 'key')
  String key;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'site')
  String site;

  @JsonKey(name: 'size')
  int size;

  @JsonKey(name: 'type')
  String type;

  Result(
    this.id,
    this.iso6391,
    this.iso31661,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  );

  factory Result.fromJson(Map<String, dynamic> srcJson) =>
      _$ResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
