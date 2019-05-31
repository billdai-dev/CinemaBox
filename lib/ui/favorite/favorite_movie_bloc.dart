import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/app_repo.dart';
import 'package:cinema_box/data/repo/model/response/movie_poster_info_list_res.dart';
import 'package:cinema_box/util/pair.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteMovieBloc extends BlocBase {
  final AppRepo _repo;

  final BehaviorSubject<MoviePosterInfoListRes> _favoriteMovies =
      BehaviorSubject();

  Stream<MoviePosterInfoListRes> get favoriteMovies => _favoriteMovies.stream;

  final BehaviorSubject<Pair<bool, int>> _fetchFavoriteMovies =
      BehaviorSubject();

  Observable<Pair<bool, int>> _fetchFavoriteMoviesStream;

  int get favoriteMoviesLength => _favoriteMovies.value?.results?.length ?? 0;

  FavoriteMovieBloc({AppRepo repo}) : _repo = repo ?? AppRepo.repo {
    _fetchFavoriteMoviesStream = Observable(_fetchFavoriteMovies.stream);
    _fetchFavoriteMoviesStream.distinct((prev, next) {
      if (next.first == true) {
        return false;
      }
      return prev.second == next.second;
    }).listen((fetchConfig) {
      _repo.getFavoriteMovies(fetchConfig.second).then((res) {
        if (res == null || _favoriteMovies.isClosed) {
          return;
        }
        bool isRefreshed = fetchConfig.first;
        if (!isRefreshed) {
          res.results = res.results
            ..insertAll(0, _favoriteMovies.value.results);
        }
        _favoriteMovies.add(res);
      });
    });

    fetchFavoriteMovies(refresh: true);
  }

  void fetchFavoriteMovies({bool refresh = false}) {
    if (refresh) {
      _fetchFavoriteMovies.add(Pair(refresh, 1));
      return;
    }
    int currentPage = _favoriteMovies.value?.page;
    if (currentPage == _favoriteMovies.value.totalPages) {
      return;
    }
    _fetchFavoriteMovies.add(Pair(false, currentPage + 1));
  }

  Future<bool> setAsFavorite(int movieId, bool shouldSetFavorite) async {
    if (movieId == null || shouldSetFavorite == null) {
      return false;
    }
    bool setFavoriteSuccess =
        await _repo.markAsFavorite(movieId, shouldSetFavorite);
    if (setFavoriteSuccess) {
      MoviePosterInfoListRes favoriteMovieData = _favoriteMovies.value;
      favoriteMovieData.results.removeWhere((movie) => movie.id == movieId);
      _favoriteMovies.add(favoriteMovieData);
    }
    return setFavoriteSuccess;
  }

  @override
  void dispose() {
    _favoriteMovies?.close();
    _fetchFavoriteMovies?.close();
  }
}
