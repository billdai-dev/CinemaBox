// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_poster_info_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoviePosterInfoListRes _$MoviePosterInfoListResFromJson(
    Map<String, dynamic> json) {
  return MoviePosterInfoListRes(
      json['page'] as int,
      (json['results'] as List)
          ?.map((e) => e == null
              ? null
              : MoviePosterInfo.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['dates'] == null
          ? null
          : Dates.fromJson(json['dates'] as Map<String, dynamic>),
      json['total_pages'] as int,
      json['total_results'] as int);
}

Map<String, dynamic> _$MoviePosterInfoListResToJson(
        MoviePosterInfoListRes instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'dates': instance.dates,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults
    };

MoviePosterInfo _$MoviePosterInfoFromJson(Map<String, dynamic> json) {
  return MoviePosterInfo(
      json['poster_path'] as String,
      json['adult'] as bool,
      json['overview'] as String,
      json['release_date'] as String,
      (json['genre_ids'] as List)?.map((e) => e as int)?.toList(),
      json['id'] as int,
      json['original_title'] as String,
      json['original_language'] as String,
      json['title'] as String,
      json['backdrop_path'] as String,
      (json['popularity'] as num)?.toDouble(),
      json['vote_count'] as int,
      json['video'] as bool,
      (json['vote_average'] as num)?.toDouble());
}

Map<String, dynamic> _$MoviePosterInfoToJson(MoviePosterInfo instance) =>
    <String, dynamic>{
      'poster_path': instance.posterPath,
      'adult': instance.adult,
      'overview': instance.overview,
      'release_date': instance.releaseDate,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_title': instance.originalTitle,
      'original_language': instance.originalLanguage,
      'title': instance.title,
      'backdrop_path': instance.backdropPath,
      'popularity': instance.popularity,
      'vote_count': instance.voteCount,
      'video': instance.video,
      'vote_average': instance.voteAverage
    };

Dates _$DatesFromJson(Map<String, dynamic> json) {
  return Dates(json['maximum'] as String, json['minimum'] as String);
}

Map<String, dynamic> _$DatesToJson(Dates instance) =>
    <String, dynamic>{'maximum': instance.maximum, 'minimum': instance.minimum};
