import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalRepo {
  static const keyAccessToken = "accessToken";

  static final LocalRepo _localRepo = LocalRepo._();

  static LocalRepo get localRepo => _localRepo;
  Completer<SharedPreferences> _pref = Completer();

  LocalRepo._() {
    _pref.complete(SharedPreferences.getInstance());
  }

  Future<bool> saveAccessToken(String token) {
    return _pref.future.then((pref) => pref.setString(keyAccessToken, token));
  }
}
