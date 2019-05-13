import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalRepoContract {
  Future<bool> saveAccessToken(String token);

  Future<String> loadAccessToken();
}

class LocalRepo {
  static const _keyAccessToken = "accessToken";

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
}
