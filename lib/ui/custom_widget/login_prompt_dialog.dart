import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/ui/app_bloc.dart';
import 'package:cinema_box/ui/login/login_web_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPromptDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProviderList.of<AppBloc>(context);
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth * 1;
      return Container(
        width: width,
        height: width * (3 / 4),
        child: AlertDialog(
          title: Text("您尚未登入，是否登入？"),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("稍後"),
            ),
            FlatButton.icon(
              onPressed: () async {
                bool loginSuccess = await appBloc.appNavKey.currentState
                    .pushNamed<dynamic>(LoginWebViewPage.routeName);
                loginSuccess ??= false;
                Navigator.pop(context, loginSuccess);
              },
              icon: Icon(FontAwesomeIcons.signInAlt),
              label: Text("登入"),
            ),
          ],
        ),
      );
    });
  }
}
