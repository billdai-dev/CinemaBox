import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/app_repo.dart';
import 'package:cinema_box/data/repo/model/response/now_playing_movie_list_res.dart';
import 'package:rxdart/rxdart.dart';

class MovieWallBloc extends BlocBase {
  final AppRepo _repo;

  final BehaviorSubject<NowPlayingMovieListRes> _nowPlayingMovies =
      BehaviorSubject();

  Stream<NowPlayingMovieListRes> get nowPlayingMovies =>
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
