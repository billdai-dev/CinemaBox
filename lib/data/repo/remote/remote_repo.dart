import 'dart:async';

import 'package:cinema_box/data/repo/model/response/access_token_res.dart';
import 'package:cinema_box/data/repo/model/response/account_state_res.dart';
import 'package:cinema_box/data/repo/model/response/create_session_id_res.dart';
import 'package:cinema_box/data/repo/model/response/movie_detail_res.dart';
import 'package:cinema_box/data/repo/model/response/movie_poster_info_list_res.dart';
import 'package:cinema_box/data/repo/model/response/request_token_res.dart';
import 'package:dio/dio.dart';

abstract class RemoteRepoContract {
  Future<RequestTokenRes> createRequestToken({String apiKey});

  Future<AccessTokenRes> createAccessToken(String requestToken);

  Future<CreateSessionIdRes> createSessionId(String accessToken);

  Future<MoviePosterInfoListRes> getNowPlayingMovies(int page);

  Future<MoviePosterInfoListRes> getUpcomingMovies(int page);

  Future<MovieDetailRes> getMovieDetail(int movieId,
      {List<String> appendToResponse, bool isChinese = true});

  Future<AccountStateRes> getAccountState(int movieId);

  Future<MoviePosterInfoListRes> getFavoriteMovies(int page);

  Future<bool> markAsFavorite(int movieId, bool isFavorite);
}

class RemoteRepo implements RemoteRepoContract {
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/original";
  static const String _languageCode_tw = "zh-TW";
  static const String _regionCode_tw = "TW";

  static final RemoteRepo _remoteRepo = RemoteRepo._();

  static RemoteRepo get remoteRepo => _remoteRepo;

  final Completer<String> accessTokenCache = Completer();
  final Completer<String> accountIdCache = Completer();
  final Completer<String> sessionIdCache = Completer();

  Dio _dioV3;
  Dio _dioV4;

  String _apiKeyV3 = "60ec67cdfd3973f8430814b7217fa490";
  String _apiAccessToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MGVjNjdjZGZkMzk3M2Y4NDMwODE0YjcyMTdmYTQ5MCIsInN1YiI6IjVjYjU5NDg3YzNhMzY4NmFlYjgxNWM3OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.D8SYlMu04VCxhDi1N3aN0I8betW_4SLRMTxr4aopYQs";

  RemoteRepo._() {
    _initDio();
  }

  Future<RequestTokenRes> createRequestToken({String apiKey}) {
    apiKey ??= _apiAccessToken;
    return _dioV4
        .post("/auth/request_token",
            options: Options(headers: {"Authorization": "Bearer $apiKey"}))
        .then((response) => RequestTokenRes.fromJson(response.data));
  }

  Future<AccessTokenRes> createAccessToken(String requestToken) {
    return _dioV4.post(
      "/auth/access_token",
      options: Options(headers: {"Authorization": "Bearer $_apiAccessToken"}),
      data: {"request_token": requestToken},
    ).then((response) {
      AccessTokenRes res = AccessTokenRes.fromJson(response.data);
      if (!accessTokenCache.isCompleted) {
        accessTokenCache.complete(res.accessToken);
      }
      if (!accountIdCache.isCompleted) {
        accountIdCache.complete(res.accountId);
      }
      return res;
    });
  }

  @override
  Future<CreateSessionIdRes> createSessionId(String accessToken) {
    return _dioV3.post(
      "/authentication/session/convert/4",
      data: {"access_token": accessToken},
    ).then((response) {
      CreateSessionIdRes res = CreateSessionIdRes.fromJson(response.data);
      if (!sessionIdCache.isCompleted) {
        sessionIdCache.complete(res.sessionId);
      }
      return res;
    });
  }

  @override
  Future<MoviePosterInfoListRes> getNowPlayingMovies(int page) {
    return _dioV3.get(
      "/movie/now_playing",
      queryParameters: {
        "language": _languageCode_tw,
        "page": page,
        "region": _regionCode_tw,
      },
    ).then((response) => MoviePosterInfoListRes.fromJson(response.data));
  }

  @override
  Future<MoviePosterInfoListRes> getUpcomingMovies(int page) {
    return _dioV3.get(
      "/movie/upcoming",
      queryParameters: {
        "language": _languageCode_tw,
        "page": page,
        "region": _regionCode_tw,
      },
    ).then((response) => MoviePosterInfoListRes.fromJson(response.data));
  }

  @override
  Future<MovieDetailRes> getMovieDetail(int movieId,
      {List<String> appendToResponse, bool isChinese = true}) {
    Map<String, dynamic> queryParams = {};
    if (isChinese) {
      queryParams.putIfAbsent("language", () => _languageCode_tw);
      queryParams.putIfAbsent("region", () => _regionCode_tw);
    }
    if (appendToResponse != null && appendToResponse.isNotEmpty) {
      queryParams.putIfAbsent(
        "append_to_response",
        () => appendToResponse.join(","),
      );
    }
    return _dioV3
        .get("/movie/$movieId", queryParameters: queryParams)
        .then((response) => MovieDetailRes.fromJson(response.data));
  }

  @override
  Future<AccountStateRes> getAccountState(int movieId) async {
    String sessionId = await sessionIdCache.future;
    return _dioV3.get("/movie/$movieId/account_states", queryParameters: {
      "session_id": sessionId
    }).then((response) => AccountStateRes.fromJson(response.data));
  }

  @override
  Future<MoviePosterInfoListRes> getFavoriteMovies(int page) async {
    String accountId = await accountIdCache.future;
    return _dioV4.get(
      "/account/$accountId/movie/favorites",
      queryParameters: {"page": page, "sort_by": "created_at.desc"},
    ).then((response) => MoviePosterInfoListRes.fromJson(response.data));
  }

  @override
  Future<bool> markAsFavorite(int movieId, bool isFavorite) async {
    String accountId = await accountIdCache.future;
    String sessionId = await sessionIdCache.future;
    return _dioV3.post("/account/$accountId/favorite", queryParameters: {
      "session_id": sessionId
    }, data: {
      "media_type": "movie",
      "media_id": movieId,
      "favorite": isFavorite,
    }).then((response) {
      return response.statusCode >= 200 && response.statusCode < 400;
    });
  }

  void _initDio() {
    BaseOptions baseOptions =
        BaseOptions(connectTimeout: 6000, receiveTimeout: 6000);
    _dioV3 = Dio(baseOptions.merge(baseUrl: "https://api.themoviedb.org/3"))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options) async {
        if (_apiKeyV3 == null) {
          return options;
        }
        var apiKey = options.queryParameters["api_key"];
        if (apiKey == null) {
          options.queryParameters["api_key"] = _apiKeyV3;
        }
        return options;
      }));

    _dioV4 = Dio(baseOptions.merge(baseUrl: "https://api.themoviedb.org/4"))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options) async {
        String tokenCache = await accessTokenCache.future;
        if (tokenCache == null || tokenCache.isEmpty) {
          return options;
        }
        var auth = options.headers["Authorization"];
        if (auth == null) {
          options.headers["Authorization"] = "Bearer $tokenCache";
        }
        return options;
      }));
  }
}
