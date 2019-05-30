import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/app_repo.dart';
import 'package:cinema_box/data/repo/model/response/movie_detail_res.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc extends BlocBase {
  final AppRepo _repo;

  final BehaviorSubject<MovieDetailRes> _movieDetail = BehaviorSubject();

  Stream<MovieDetailRes> get movieDetail => _movieDetail.stream;

  final PublishSubject<int> _fetchMovieDetail = PublishSubject();

  Sink<int> get fetchMovieDetail => _fetchMovieDetail.sink;

  final BehaviorSubject<bool> isFavorite = BehaviorSubject();

  MovieDetailBloc({AppRepo repo}) : _repo = repo ?? AppRepo.repo {
    print("BLOC REBUILD");
    _fetchMovieDetail.listen((movieId) {
      Future<MovieDetailRes> chineseMovieDetail = _repo.getMovieDetail(
        movieId,
        appendToResponse: ["credits", "release_dates", "videos"],
      );
      Future<MovieDetailRes> englishMovieDetail = _repo.getMovieDetail(
        movieId,
        appendToResponse: ["videos"],
        isChinese: false,
      );
      Future.wait([chineseMovieDetail, englishMovieDetail]).then((responses) {
        if (_movieDetail.isClosed) {
          return;
        }
        MovieDetailRes chineseMovieData = responses.first;
        MovieDetailRes englishMovieData = responses.last;
        //Combine two results
        chineseMovieData?.videos?.results
            ?.addAll(englishMovieData?.videos?.results ?? []);
        _movieDetail.add(chineseMovieData);
      });

      getFavoriteState(movieId: movieId);
    });
  }

  @override
  void dispose() {
    _movieDetail?.close();
    _fetchMovieDetail?.close();
    isFavorite?.close();
  }

  Future<bool> setAsFavorite() async {
    int movieId = _movieDetail.value?.id;
    if (movieId == null) {
      return false;
    }
    bool originalFavorite = isFavorite.value;
    if (originalFavorite == null) {
      return false;
    }
    isFavorite.add(!originalFavorite);
    return _repo.markAsFavorite(movieId, !originalFavorite);
  }

  Future<void> getFavoriteState({int movieId}) {
    movieId ??= _movieDetail.value?.id;
    return _repo.getAccountState(movieId).then((accountState) {
      if (accountState == null || isFavorite.isClosed) {
        return;
      }
      isFavorite.add(accountState.favorite);
    });
  }
}
