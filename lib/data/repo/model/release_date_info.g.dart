// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_date_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseDateInfo _$ReleaseDateInfoFromJson(Map<String, dynamic> json) {
  return ReleaseDateInfo(
      json['id'] as int,
      (json['results'] as List)
          ?.map((e) =>
              e == null ? null : Result.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ReleaseDateInfoToJson(ReleaseDateInfo instance) =>
    <String, dynamic>{'id': instance.id, 'results': instance.results};

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
      json['iso_3166_1'] as String,
      (json['release_dates'] as List)
          ?.map((e) => e == null
              ? null
              : ReleaseDate.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'iso_3166_1': instance.iso31661,
      'release_dates': instance.releaseDates
    };

ReleaseDate _$ReleaseDateFromJson(Map<String, dynamic> json) {
  return ReleaseDate(
      json['certification'] as String,
      json['iso_639_1'] as String,
      json['release_date'] as String,
      json['type'] as int);
}

Map<String, dynamic> _$ReleaseDateToJson(ReleaseDate instance) =>
    <String, dynamic>{
      'certification': instance.certification,
      'iso_639_1': instance.iso6391,
      'release_date': instance.releaseDate,
      'type': instance.type
    };
