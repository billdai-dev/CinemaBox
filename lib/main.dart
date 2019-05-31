import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/ui/app_bloc.dart';
import 'package:cinema_box/ui/favorite/favorite_movie_bloc.dart';
import 'package:cinema_box/ui/favorite/favorite_movie_page.dart';
import 'package:cinema_box/ui/login/login_web_view.dart';
import 'package:cinema_box/ui/movie_detail/movie_detail_page.dart';
import 'package:cinema_box/ui/movie_wall/movie_wall_bloc.dart';
import 'package:cinema_box/ui/movie_wall/movie_wall_page.dart';
import 'package:cinema_box/ui/youtube_video/youtube_video_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(
      BlocProviderList(
        listBloc: [
          Bloc(AppBloc()),
          Bloc(FavoriteMovieBloc()),
        ],
        child: MyApp(),
      ),
    );

Route<dynamic> _generateRoute(RouteSettings routeSetting, {Widget child}) {
  String routeName = routeSetting.name;
  String lastRoute = routeName.substring(routeSetting.name.lastIndexOf("/"));
  return MaterialPageRoute(
    builder: (context) {
      switch (lastRoute) {
        case MovieDetailPage.routeName:
          return MovieDetailPage();
        case YoutubeVideoPage.routeName:
          return YoutubeVideoPage();
        case FavoriteMoviePage.routeName:
          return FavoriteMoviePage();
        case LoginWebViewPage.routeName:
          return LoginWebViewPage();
        default:
          if (child != null &&
              (routeName == "/" || routeSetting.isInitialRoute)) {
            return child;
          }
          return Container(
            alignment: Alignment.center,
            child: Text("Page not found"),
          );
      }
    },
    settings: routeSetting,
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = BlocProviderList.of<AppBloc>(context);
    bloc.appNavKey = _navigatorKey;

    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      onGenerateRoute: (routeSetting) => _generateRoute(routeSetting),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return Container(
              alignment: Alignment.center,
              child: Text("Page not found"),
            );
          },
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<GlobalKey<NavigatorState>, Widget> navKeyPageMapping;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    navKeyPageMapping = {
      GlobalKey(debugLabel: "MovieWall"): BlocProvider(
        bloc: MovieWallBloc(),
        child: MovieWallPage(),
      ),
      GlobalKey(debugLabel: "Search"): Container(),
      GlobalKey(debugLabel: "MyFavorite"): FavoriteMoviePage(),
      GlobalKey(debugLabel: "Profile"): Container(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navKeyPageMapping.keys
          .toList()[tabIndex]
          .currentState
          .maybePop(),
      child: Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 4,
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          selectedItemColor: const Color.fromARGB(255, 194, 54, 66),
          unselectedItemColor: const Color.fromARGB(255, 170, 170, 170),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: _buildBottomBarItems(),
          currentIndex: tabIndex,
          onTap: (index) => setState(() => tabIndex = index),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            for (var i = 0; i < 4; i++)
              _buildBottomBarTab(navKeyPageMapping.keys.toList()[i], i,
                  tabIndex, navKeyPageMapping.values.toList()[i]),
          ],
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.film),
        title: Text("電影牆"),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.search),
        title: Text("搜尋"),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.heart),
        title: Text("我的最愛"),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.userCircle),
        title: Text("個人資料"),
      ),
    ];
  }

  Widget _buildBottomBarTab(GlobalKey<NavigatorState> navigatorKey, int index,
      int curIndex, Widget child) {
    return Visibility(
      maintainState: true,
      maintainAnimation: true,
      visible: index == curIndex,
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (routeSetting) =>
            _generateRoute(routeSetting, child: child),
        observers: [HeroController()],
      ),
    );
  }
}
