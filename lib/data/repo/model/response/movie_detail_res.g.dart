// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailRes _$MovieDetailResFromJson(Map<String, dynamic> json) {
  return MovieDetailRes(
      json['adult'] as bool,
      json['backdrop_path'] as String,
      json['budget'] as int,
      (json['genres'] as List)
          ?.map((e) =>
              e == null ? null : Genres.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['homepage'] as String,
      json['id'] as int,
      json['imdb_id'] as String,
      json['original_language'] as String,
      json['original_title'] as String,
      json['overview'] as String,
      (json['popularity'] as num)?.toDouble(),
      json['poster_path'] as String,
      (json['production_companies'] as List)
          ?.map((e) => e == null
              ? null
              : ProductionCompany.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['production_countries'] as List)
          ?.map((e) => e == null
              ? null
              : ProductionCountry.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['release_date'] as String,
      json['revenue'] as int,
      json['runtime'] as int,
      (json['spoken_languages'] as List)
          ?.map((e) => e == null
              ? null
              : SpokenLanguage.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['status'] as String,
      json['tagline'] as String,
      json['title'] as String,
      json['video'] as bool,
      json['vote_average'] as int,
      json['vote_count'] as int,
      json['credits'] == null
          ? null
          : Credit.fromJson(json['credits'] as Map<String, dynamic>),
      json['release_dates'] == null
          ? null
          : ReleaseDate.fromJson(json['release_dates'] as Map<String, dynamic>),
      json['videos'] == null
          ? null
          : Video.fromJson(json['videos'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MovieDetailResToJson(MovieDetailRes instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'budget': instance.budget,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'production_companies': instance.productionCompanies,
      'production_countries': instance.productionCountries,
      'release_date': instance.releaseDate,
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'spoken_languages': instance.spokenLanguages,
      'status': instance.status,
      'tagline': instance.tagline,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'credits': instance.credits,
      'release_dates': instance.releaseDates,
      'videos': instance.videos
    };

Genres _$GenresFromJson(Map<String, dynamic> json) {
  return Genres(json['id'] as int, json['name'] as String);
}

Map<String, dynamic> _$GenresToJson(Genres instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

ProductionCompany _$ProductionCompanyFromJson(Map<String, dynamic> json) {
  return ProductionCompany(json['id'] as int, json['logo_path'] as String,
      json['name'] as String, json['origin_country'] as String);
}

Map<String, dynamic> _$ProductionCompanyToJson(ProductionCompany instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo_path': instance.logoPath,
      'name': instance.name,
      'origin_country': instance.originCountry
    };

ProductionCountry _$ProductionCountryFromJson(Map<String, dynamic> json) {
  return ProductionCountry(
      json['iso_3166_1'] as String, json['name'] as String);
}

Map<String, dynamic> _$ProductionCountryToJson(ProductionCountry instance) =>
    <String, dynamic>{'iso_3166_1': instance.iso31661, 'name': instance.name};

SpokenLanguage _$SpokenLanguageFromJson(Map<String, dynamic> json) {
  return SpokenLanguage(json['iso_639_1'] as String, json['name'] as String);
}

Map<String, dynamic> _$SpokenLanguageToJson(SpokenLanguage instance) =>
    <String, dynamic>{'iso_639_1': instance.iso6391, 'name': instance.name};
