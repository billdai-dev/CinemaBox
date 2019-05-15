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

  MovieDetailBloc({AppRepo repo}) : _repo = repo ?? AppRepo.repo {
    _fetchMovieDetail.listen((movieId) {
      _repo.getMovieDetail(
        movieId,
        appendToResponse: ["credits", "release_dates", "videos"],
      ).then((res) {
        if (!_movieDetail.isClosed) {
          _movieDetail.add(res);
        }
      });
    });
  }

  @override
  void dispose() {
    _movieDetail?.close();
    _fetchMovieDetail?.close();
  }
}
