// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
      json['id'] as int,
      (json['results'] as List)
          ?.map((e) =>
              e == null ? null : Result.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$VideoToJson(Video instance) =>
    <String, dynamic>{'id': instance.id, 'results': instance.results};

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
      json['id'] as String,
      json['iso_639_1'] as String,
      json['iso_3166_1'] as String,
      json['key'] as String,
      json['name'] as String,
      json['site'] as String,
      json['size'] as int,
      json['type'] as String);
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'id': instance.id,
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'key': instance.key,
      'name': instance.name,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type
    };
