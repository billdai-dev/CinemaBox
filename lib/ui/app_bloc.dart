import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/app_repo.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends BlocBase {
  final AppRepo _repo;

  final BehaviorSubject<bool> isLoggedIn = BehaviorSubject();

  GlobalKey<NavigatorState> appNavKey;

  AppBloc({AppRepo repo}) : _repo = repo ?? AppRepo.repo {
    _repo.isUserLoggedIn().then((isLoggedIn) {
      this.isLoggedIn.add(isLoggedIn);
    });
  }

  @override
  void dispose() {
    isLoggedIn.close();
  }
}
