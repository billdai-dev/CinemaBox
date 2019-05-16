import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/app_repo.dart';
import 'package:cinema_box/data/repo/model/response/movie_poster_info_list_res.dart';
import 'package:cinema_box/util/pair.dart';
import 'package:rxdart/rxdart.dart';

class MovieWallBloc extends BlocBase {
  final AppRepo _repo;

  final BehaviorSubject<MoviePosterInfoListRes> _nowPlayingMovies =
      BehaviorSubject();

  Stream<MoviePosterInfoListRes> get nowPlayingMovies =>
      _nowPlayingMovies.stream;

  final BehaviorSubject<Pair<bool, int>> _fetchNowPlayingMovies =
      BehaviorSubject(seedValue: Pair(true, 1));

  Observable<Pair<bool, int>> _fetchNowPlayingMoviesStream;

  int get nowPlayingMoviesLength =>
      _nowPlayingMovies.value?.results?.length ?? 0;

  final BehaviorSubject<MoviePosterInfoListRes> _upcomingMovies =
      BehaviorSubject();

  Stream<MoviePosterInfoListRes> get upcomingMovies => _upcomingMovies.stream;

  final BehaviorSubject<Pair<bool, int>> _fetchUpcomingMovies =
      BehaviorSubject(seedValue: Pair(true, 1));

  Observable<Pair<bool, int>> _fetchUpcomingMoviesStream;

  int get upcomingMoviesLength => _upcomingMovies.value?.results?.length ?? 0;

  MovieWallBloc({AppRepo repo}) : _repo = repo ?? AppRepo.repo {
    _fetchNowPlayingMoviesStream = Observable(_fetchNowPlayingMovies.stream);
    _fetchNowPlayingMoviesStream.distinct((prev, next) {
      if (next.first == true) {
        return false;
      }
      return prev.second == next.second;
    }).listen((fetchConfig) {
      _repo.getNowPlayingMovies(fetchConfig.second).then((res) {
        if (_nowPlayingMovies.isClosed) {
          return;
        }
        bool isRefreshed = fetchConfig.first;
        if (!isRefreshed) {
          res.results = res.results
            ..insertAll(0, _nowPlayingMovies.value.results);
        }
        _nowPlayingMovies.add(res);
      });
    });

    _fetchUpcomingMoviesStream = Observable(_fetchUpcomingMovies.stream);
    _fetchUpcomingMoviesStream.distinct((prev, next) {
      if (next.first == true) {
        return false;
      }
      return prev.second == next.second;
    }).listen((fetchConfig) {
      _repo.getUpcomingMovies(fetchConfig.second).then((res) {
        if (_upcomingMovies.isClosed) {
          return;
        }
        bool isRefreshed = fetchConfig.first;
        if (!isRefreshed) {
          res.results = res.results
            ..insertAll(0, _upcomingMovies.value.results);
        }
        _upcomingMovies.add(res);
      });
    });
  }

  void fetchNowPlayingMovies({bool refresh = false}) {
    if (refresh) {
      _fetchNowPlayingMovies.add(Pair(refresh, 1));
      return;
    }
    int currentPage = _nowPlayingMovies.value?.page;
    if (currentPage == _nowPlayingMovies.value.totalPages) {
      return;
    }
    _fetchNowPlayingMovies.add(Pair(false, currentPage + 1));
  }

  void fetchUpcomingMovies({bool refresh = false}) {
    if (refresh) {
      _fetchNowPlayingMovies.add(Pair(refresh, 1));
      return;
    }
    int currentPage = _nowPlayingMovies.value?.page;
    if (currentPage == _nowPlayingMovies.value.totalPages) {
      return;
    }
    _fetchNowPlayingMovies.add(Pair(false, currentPage + 1));
  }

  @override
  void dispose() {
    _nowPlayingMovies?.close();
    _fetchNowPlayingMovies?.close();
    _upcomingMovies?.close();
    _fetchUpcomingMovies?.close();
  }
}
