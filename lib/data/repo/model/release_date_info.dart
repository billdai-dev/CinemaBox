import 'package:json_annotation/json_annotation.dart';

part 'release_date_info.g.dart';

@JsonSerializable()
class ReleaseDateInfo extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'results')
  List<Result> results;

  ReleaseDateInfo(
    this.id,
    this.results,
  );

  factory ReleaseDateInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$ReleaseDateInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReleaseDateInfoToJson(this);
}

@JsonSerializable()
class Result extends Object {
  @JsonKey(name: 'iso_3166_1')
  String iso31661;

  @JsonKey(name: 'release_dates')
  List<ReleaseDate> releaseDates;

  Result(
    this.iso31661,
    this.releaseDates,
  );

  factory Result.fromJson(Map<String, dynamic> srcJson) =>
      _$ResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class ReleaseDate extends Object {
  @JsonKey(name: 'certification')
  String certification;

  @JsonKey(name: 'iso_639_1')
  String iso6391;

  @JsonKey(name: 'release_date')
  String releaseDate;

  @JsonKey(name: 'type')
  int type;

  ReleaseDate(
    this.certification,
    this.iso6391,
    this.releaseDate,
    this.type,
  );

  factory ReleaseDate.fromJson(Map<String, dynamic> srcJson) =>
      _$ReleaseDateFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReleaseDateToJson(this);
}
