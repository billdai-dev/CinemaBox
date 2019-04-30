import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/app_repo.dart';

class LoginBloc extends BlocBase {
  final AppRepo _repo;
  String _requestToken;

  LoginBloc({repo}) : _repo = repo ?? AppRepo.repo;

  Future<String> generateRequestToken() {
    return _repo.createRequestToken().then((requestTokenRes) {
      _requestToken = requestTokenRes.requestToken;
      return _requestToken;
    });
  }

  Future<bool> generateAccessToken() {
    return _repo.createAccessToken(_requestToken).then((_) => true);
  }

  @override
  void dispose() {}
}
