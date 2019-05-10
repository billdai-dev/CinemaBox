import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/ui/login/login_bloc.dart';
import 'package:cinema_box/ui/login/login_web_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isLoginSuccess = await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim1, anim2) {
                    return BlocProvider(
                        bloc: LoginBloc(), child: LoginWebViewPage());
                  },
                  transitionsBuilder: (context, anim1, anim2, child) {
                    return child;
                  },
                ),
              ) ??
              false;
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(isLoginSuccess ? "Login Success!" : "Login failed!"),
          ));
        },
        child: Icon(Icons.vpn_key),
      ),
    );
  }
}
