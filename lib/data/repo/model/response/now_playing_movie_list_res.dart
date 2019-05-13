import 'package:json_annotation/json_annotation.dart';
part 'now_playing_movie_list_res.g.dart';

@JsonSerializable()
class NowPlayingMovieListRes extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'results')
  List<NowPlayingMovie> results;

  @JsonKey(name: 'dates')
  Dates dates;

  @JsonKey(name: 'total_pages')
  int totalPages;

  @JsonKey(name: 'total_results')
  int totalResults;

  NowPlayingMovieListRes(
    this.page,
    this.results,
    this.dates,
    this.totalPages,
    this.totalResults,
  );

  factory NowPlayingMovieListRes.fromJson(Map<String, dynamic> srcJson) =>
      _$NowPlayingMovieListResFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NowPlayingMovieListResToJson(this);
}

@JsonSerializable()
class NowPlayingMovie extends Object {
  @JsonKey(name: 'poster_path')
  String posterPath;

  @JsonKey(name: 'adult')
  bool adult;

  @JsonKey(name: 'overview')
  String overview;

  @JsonKey(name: 'release_date')
  String releaseDate;

  @JsonKey(name: 'genre_ids')
  List<int> genreIds;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'original_title')
  String originalTitle;

  @JsonKey(name: 'original_language')
  String originalLanguage;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'backdrop_path')
  String backdropPath;

  @JsonKey(name: 'popularity')
  double popularity;

  @JsonKey(name: 'vote_count')
  int voteCount;

  @JsonKey(name: 'video')
  bool video;

  @JsonKey(name: 'vote_average')
  double voteAverage;

  NowPlayingMovie(
    this.posterPath,
    this.adult,
    this.overview,
    this.releaseDate,
    this.genreIds,
    this.id,
    this.originalTitle,
    this.originalLanguage,
    this.title,
    this.backdropPath,
    this.popularity,
    this.voteCount,
    this.video,
    this.voteAverage,
  );

  factory NowPlayingMovie.fromJson(Map<String, dynamic> srcJson) =>
      _$NowPlayingMovieFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NowPlayingMovieToJson(this);
}

@JsonSerializable()
class Dates extends Object {
  @JsonKey(name: 'maximum')
  String maximum;

  @JsonKey(name: 'minimum')
  String minimum;

  Dates(
    this.maximum,
    this.minimum,
  );

  factory Dates.fromJson(Map<String, dynamic> srcJson) =>
      _$DatesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DatesToJson(this);
}
