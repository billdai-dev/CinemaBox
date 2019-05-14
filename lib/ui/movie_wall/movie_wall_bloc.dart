import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/app_repo.dart';
import 'package:cinema_box/data/repo/model/response/movie_poster_info_list_res.dart';
import 'package:rxdart/rxdart.dart';

class MovieWallBloc extends BlocBase {
  final AppRepo _repo;

  final BehaviorSubject<MoviePosterInfoListRes> _nowPlayingMovies =
      BehaviorSubject();

  Stream<MoviePosterInfoListRes> get nowPlayingMovies =>
      _nowPlayingMovies.stream;

  MovieWallBloc({AppRepo repo}) : _repo = repo ?? AppRepo.repo {
    _repo.getNowPlayingMovies(1).then((res) {
      _nowPlayingMovies.add(res);
    });
  }

  @override
  void dispose() {
    _nowPlayingMovies?.close();
  }
}
