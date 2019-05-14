import 'package:cinema_box/data/repo/model/credit.dart';
import 'package:cinema_box/data/repo/model/release_date_info.dart';
import 'package:cinema_box/data/repo/model/video.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_detail_res.g.dart';

@JsonSerializable()
class MovieDetailRes extends Object {
  @JsonKey(name: 'adult')
  bool adult;

  @JsonKey(name: 'backdrop_path')
  String backdropPath;

  @JsonKey(name: 'budget')
  int budget;

  @JsonKey(name: 'genres')
  List<Genres> genres;

  @JsonKey(name: 'homepage')
  String homepage;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'imdb_id')
  String imdbId;

  @JsonKey(name: 'original_language')
  String originalLanguage;

  @JsonKey(name: 'original_title')
  String originalTitle;

  @JsonKey(name: 'overview')
  String overview;

  @JsonKey(name: 'popularity')
  double popularity;

  @JsonKey(name: 'poster_path')
  String posterPath;

  @JsonKey(name: 'production_companies')
  List<ProductionCompany> productionCompanies;

  @JsonKey(name: 'production_countries')
  List<ProductionCountry> productionCountries;

  @JsonKey(name: 'release_date')
  String releaseDate;

  @JsonKey(name: 'revenue')
  int revenue;

  @JsonKey(name: 'runtime')
  int runtime;

  @JsonKey(name: 'spoken_languages')
  List<SpokenLanguage> spokenLanguages;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'tagline')
  String tagline;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'video')
  bool video;

  @JsonKey(name: 'vote_average')
  int voteAverage;

  @JsonKey(name: 'vote_count')
  int voteCount;

  @JsonKey(name: 'credits')
  Credit credits;

  @JsonKey(name: 'release_dates')
  ReleaseDate releaseDates;

  @JsonKey(name: 'videos')
  Video videos;

  MovieDetailRes(
    this.adult,
    this.backdropPath,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.credits,
    this.releaseDates,
    this.videos,
  );

  factory MovieDetailRes.fromJson(Map<String, dynamic> srcJson) =>
      _$MovieDetailResFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MovieDetailResToJson(this);
}

@JsonSerializable()
class Genres extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  Genres(
    this.id,
    this.name,
  );

  factory Genres.fromJson(Map<String, dynamic> srcJson) =>
      _$GenresFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GenresToJson(this);
}

@JsonSerializable()
class ProductionCompany extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'logo_path')
  String logoPath;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'origin_country')
  String originCountry;

  ProductionCompany(
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  );

  factory ProductionCompany.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductionCompanyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductionCompanyToJson(this);
}

@JsonSerializable()
class ProductionCountry extends Object {
  @JsonKey(name: 'iso_3166_1')
  String iso31661;

  @JsonKey(name: 'name')
  String name;

  ProductionCountry(
    this.iso31661,
    this.name,
  );

  factory ProductionCountry.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductionCountryFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductionCountryToJson(this);
}

@JsonSerializable()
class SpokenLanguage extends Object {
  @JsonKey(name: 'iso_639_1')
  String iso6391;

  @JsonKey(name: 'name')
  String name;

  SpokenLanguage(
    this.iso6391,
    this.name,
  );

  factory SpokenLanguage.fromJson(Map<String, dynamic> srcJson) =>
      _$SpokenLanguageFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SpokenLanguageToJson(this);
}
