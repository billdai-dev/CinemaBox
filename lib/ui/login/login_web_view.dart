import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/ui/app_bloc.dart';
import 'package:cinema_box/ui/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class LoginWebViewPage extends StatefulWidget {
  static const String routeName = "/loginWebView";

  @override
  _LoginWebViewPageState createState() => _LoginWebViewPageState();
}

class _LoginWebViewPageState extends State<LoginWebViewPage> {
  static const String authUrl =
      "https://www.themoviedb.org/auth/access?request_token=";

  bool isBrowserOpened = false;
  bool isUserLoggingIn = false;
  InAppBrowser browser;
  LoginBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = LoginBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.generateRequestToken().then((token) async {
      await browser?.open(url: "$authUrl$token", options: {
        "clearCache": true,
        "toolbarTop": false,
        "hideUrlBar": true,
      });
      setState(() => isBrowserOpened = true);
    });
    browser ??= _MyInAppBrowser(
      context,
      onUserLogin: () {
        setState(() => isUserLoggingIn = true);
        bloc.generateAccessToken().then((isSuccess) {
          AppBloc appBloc = BlocProviderList.of<AppBloc>(context);
          appBloc.isLoggedIn.add(isSuccess == true);
          Navigator.pop(context, isSuccess);
        });
      },
    );
  }

  @override
  void dispose() {
    if (browser.isOpened()) {
      browser?.close();
    }
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            if (isUserLoggingIn)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("正在為您登入中"),
              ),
          ],
        ),
      ),
    );
  }
}

class _MyInAppBrowser extends InAppBrowser {
  final BuildContext _context;
  final VoidCallback _onUserLogin;
  bool isUserLoggedIn = false;

  _MyInAppBrowser(this._context, {VoidCallback onUserLogin})
      : _onUserLogin = onUserLogin;

  @override
  void onLoadStart(String url) {
    if (url.contains("/auth/access/approve")) {
      isUserLoggedIn = true;
      close().then((_) => _onUserLogin());
    }
  }

  @override
  void onExit() {
    if (isUserLoggedIn) {
      return;
    }
    Navigator.pop(_context, false);
  }
}
