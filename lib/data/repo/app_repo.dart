import 'package:cinema_box/data/repo/model/local/local_repo.dart';
import 'package:cinema_box/data/repo/model/response/access_token_res.dart';
import 'package:cinema_box/data/repo/model/response/request_token_res.dart';
import 'package:cinema_box/data/repo/remote/remote_repo.dart';

import 'model/response/movie_poster_info_list_res.dart';

class AppRepo implements LocalRepoContract, RemoteRepoContract {
  static final AppRepo _repo = AppRepo._();

  static AppRepo get repo => _repo;

  RemoteRepo _remoteRepo;
  LocalRepo _localRepo;

  AppRepo._() {
    _remoteRepo = RemoteRepo.remoteRepo;
    _localRepo = LocalRepo.localRepo;
    _localRepo.loadAccessToken().then((token) {
      _remoteRepo.accessTokenCache.complete(token);
    });
  }

  @override
  Future<bool> saveAccessToken(String token) {
    return _localRepo.saveAccessToken(token);
  }

  @override
  Future<String> loadAccessToken() {
    return _localRepo.loadAccessToken();
  }

  @override
  Future<RequestTokenRes> createRequestToken({String apiKey}) {
    return _remoteRepo.createRequestToken(apiKey: apiKey);
  }

  @override
  Future<AccessTokenRes> createAccessToken(String requestToken) async {
    AccessTokenRes response = await _remoteRepo.createAccessToken(requestToken);
    String accessToken = response.accessToken;
    await _localRepo.saveAccessToken(accessToken);
    return response;
  }

  @override
  Future<MoviePosterInfoListRes> getNowPlayingMovies(int page) {
    return _remoteRepo.getNowPlayingMovies(page);
  }

  @override
  Future<MoviePosterInfoListRes> getUpcomingMovies(int page) {
    return _remoteRepo.getUpcomingMovies(page);
  }
}
