import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/ui/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class LoginWebViewPage extends StatefulWidget {
  @override
  _LoginWebViewPageState createState() => _LoginWebViewPageState();
}

class _LoginWebViewPageState extends State<LoginWebViewPage> {
  static const String authUrl =
      "https://www.themoviedb.org/auth/access?request_token=";

  bool isBrowserOpened = false;
  InAppBrowser browser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LoginBloc bloc = BlocProvider.of<LoginBloc>(context);
    bloc.generateRequestToken().then((token) async {
      await browser?.open(url: "$authUrl$token", options: {
        "clearCache": true,
        "toolbarTop": false,
        "hideUrlBar": true,
      });
      setState(() => isBrowserOpened = true);
    });
    browser ??= _MyInAppBrowser(context, bloc);
  }

  @override
  void dispose() {
    browser?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //LoginBloc bloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: isBrowserOpened ? null : CircularProgressIndicator(),
      ),
    );
  }
}

class _MyInAppBrowser extends InAppBrowser {
  final BuildContext context;
  final LoginBloc bloc;

  _MyInAppBrowser(this.context, this.bloc);

  @override
  void onLoadStart(String url) {
    if (url.contains("/auth/access/approve")) {
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        return bloc.generateAccessToken();
      }).then((isSuccess) async {
        await close();
        Navigator.pop(context, isSuccess);
      });
    }
  }
}
