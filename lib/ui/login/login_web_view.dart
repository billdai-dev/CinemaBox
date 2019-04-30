import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/ui/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebViewPage extends StatefulWidget {
  @override
  _LoginWebViewPageState createState() => _LoginWebViewPageState();
}

class _LoginWebViewPageState extends State<LoginWebViewPage> {
  static const String _authUrl =
      "https://www.themoviedb.org/auth/access?request_token=";

  Completer<WebViewController> webViewController = Completer();
  Completer<String> requestToken = Completer();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LoginBloc bloc = BlocProvider.of<LoginBloc>(context);
    requestToken.complete(bloc.generateRequestToken());
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc bloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      body: WebView(
        navigationDelegate: (navRequest) {
          String nextUrl = navRequest.url;
          if (nextUrl.contains("/auth/access/approve")) {
            bloc.generateAccessToken().then((isSuccess) {
              Navigator.of(context).pop(isSuccess);
            });
            /*Navigator.of(context).pop(true);
            return NavigationDecision.prevent;*/
          }
          return NavigationDecision.navigate;
        },
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          webViewController.complete(controller);
          requestToken.future.then((token) {
            controller.loadUrl("$_authUrl$requestToken");
          });
        },
      ),
    );
  }
}
