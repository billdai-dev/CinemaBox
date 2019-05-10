import 'dart:async';

import 'package:cinema_box/data/repo/model/response/access_token_res.dart';
import 'package:cinema_box/data/repo/model/response/request_token_res.dart';
import 'package:dio/dio.dart';

import '../app_repo.dart';

class RemoteRepo {
  static final RemoteRepo _remoteRepo = RemoteRepo._();

  static RemoteRepo get remoteRepo => _remoteRepo;

  final Completer<String> _accessTokenCache = Completer();

  Dio _dioV3;
  Dio _dioV4;

  String _apiKeyV3 = "60ec67cdfd3973f8430814b7217fa490";
  String _apiAccessToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MGVjNjdjZGZkMzk3M2Y4NDMwODE0YjcyMTdmYTQ5MCIsInN1YiI6IjVjYjU5NDg3YzNhMzY4NmFlYjgxNWM3OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.D8SYlMu04VCxhDi1N3aN0I8betW_4SLRMTxr4aopYQs";
  //String _accessToken;
  String _sessionId;

  RemoteRepo._() {
    _initDio();
    _accessTokenCache.complete(AppRepo.repo.loadAccessToken());
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
      _accessTokenCache.complete(res.accessToken);
      return res;
    });
  }

  /*Future<CreateSessionRes> createSession(String accessToken) {
    return _dioV3.post(
      "/authentication/session/convert/4",
      data: {"access_token": accessToken},
    ).then((response) {
      CreateSessionRes res = CreateSessionRes.fromJson(response.data);
      _sessionId = res.sessionId;
      return res;
    });
  }*/

  void _initDio() {
    BaseOptions baseOptions =
        BaseOptions(connectTimeout: 6000, receiveTimeout: 6000);
    /*_dioV3 = Dio(baseOptions.merge(baseUrl: "https://api.themoviedb.org/3"))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options) async {
        if (_apiKeyV3 == null) {
          return options;
        }
        var apiKey = options.queryParameters["api_key"];
        if (apiKey == null) {
          options.queryParameters["api_key"] = _apiKeyV3;
        }
        return options;
      }));*/

    _dioV4 = Dio(baseOptions.merge(baseUrl: "https://api.themoviedb.org/4"))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options) async {
        String tokenCache = await _accessTokenCache.future;
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
