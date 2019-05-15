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
    });
  }

  @override
  void dispose() {
    _movieDetail?.close();
    _fetchMovieDetail?.close();
  }
}
