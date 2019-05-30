import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalRepoContract {
  Future<bool> saveAccessToken(String token);

  Future<String> loadAccessToken();

  Future<bool> saveAccountId(String accountId);

  Future<String> loadAccountId();

  Future<bool> saveSessionId(String sessionId);

  Future<String> loadSessionId();
}

class LocalRepo implements LocalRepoContract {
  static const _keyAccessToken = "accessToken";
  static const _keyAccountId = "accountId";
  static const _keySessionId = "sessionId";

  static final LocalRepo _localRepo = LocalRepo._();

  static LocalRepo get localRepo => _localRepo;

  final Completer<SharedPreferences> _pref = Completer();

  LocalRepo._() {
    _pref.complete(SharedPreferences.getInstance());
  }

  Future<bool> saveAccessToken(String token) {
    return _pref.future.then((pref) => pref.setString(_keyAccessToken, token));
  }

  Future<String> loadAccessToken() {
    return _pref.future.then((pref) => pref.getString(_keyAccessToken));
  }

  @override
  Future<bool> saveAccountId(String accountId) {
    return _pref.future
        .then((pref) => pref.setString(_keyAccountId, accountId));
  }

  @override
  Future<String> loadAccountId() {
    return _pref.future.then((pref) => pref.getString(_keyAccountId));
  }

  @override
  Future<bool> saveSessionId(String sessionId) {
    return _pref.future
        .then((pref) => pref.setString(_keySessionId, sessionId));
  }

  @override
  Future<String> loadSessionId() {
    return _pref.future.then((pref) => pref.getString(_keySessionId));
  }
}
