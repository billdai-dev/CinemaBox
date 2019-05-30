import 'package:cinema_box/data/repo/model/local/local_repo.dart';
import 'package:cinema_box/data/repo/model/response/access_token_res.dart';
import 'package:cinema_box/data/repo/model/response/account_state_res.dart';
import 'package:cinema_box/data/repo/model/response/create_session_id_res.dart';
import 'package:cinema_box/data/repo/model/response/movie_detail_res.dart';
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
    _localRepo.loadAccessToken().then((token) async {
      _remoteRepo.accessTokenCache.complete(token);
      await _localRepo.loadAccountId().then((accountId) {
        _remoteRepo.accountIdCache.complete(accountId);
      });
      await _localRepo.loadSessionId().then((sessionId) {
        _remoteRepo.sessionIdCache.complete(sessionId);
      });
    });
  }

  Future<bool> isUserLoggedIn() async {
    String accessToken = await loadAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    String accountId = await loadSessionId();
    if (accountId == null || accountId.isEmpty) {
      return false;
    }
    String sessionId = await loadSessionId();
    if (sessionId == null || sessionId.isEmpty) {
      return false;
    }
    return true;
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
  Future<bool> saveAccountId(String accountId) {
    return _localRepo.saveAccountId(accountId);
  }

  @override
  Future<String> loadAccountId() {
    return _localRepo.loadAccountId();
  }

  @override
  Future<bool> saveSessionId(String sessionId) {
    return _localRepo.saveSessionId(sessionId);
  }

  @override
  Future<String> loadSessionId() {
    return _localRepo.loadSessionId();
  }

  @override
  Future<RequestTokenRes> createRequestToken({String apiKey}) {
    return _remoteRepo.createRequestToken(apiKey: apiKey);
  }

  @override
  Future<AccessTokenRes> createAccessToken(String requestToken) async {
    AccessTokenRes response = await _remoteRepo.createAccessToken(requestToken);
    await _localRepo.saveAccessToken(response.accessToken);
    await _localRepo.saveAccountId(response.accountId);
    await createSessionId(response.accessToken);
    return response;
  }

  @override
  Future<CreateSessionIdRes> createSessionId(String accessToken) async {
    CreateSessionIdRes response =
        await _remoteRepo.createSessionId(accessToken);
    await _localRepo.saveSessionId(response.sessionId);
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

  @override
  Future<MovieDetailRes> getMovieDetail(int movieId,
      {List<String> appendToResponse, bool isChinese = true}) {
    return _remoteRepo.getMovieDetail(movieId,
        appendToResponse: appendToResponse, isChinese: isChinese);
  }

  @override
  Future<AccountStateRes> getAccountState(int movieId) {
    return _remoteRepo.getAccountState(movieId);
  }

  @override
  Future<MoviePosterInfoListRes> getFavoriteMovies(int page) {
    return _remoteRepo.getFavoriteMovies(page);
  }

  @override
  Future<bool> markAsFavorite(int movieId, bool isFavorite) {
    return _remoteRepo.markAsFavorite(movieId, isFavorite);
  }
}
