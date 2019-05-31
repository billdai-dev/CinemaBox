import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_box/data/repo/model/response/movie_poster_info_list_res.dart';
import 'package:cinema_box/data/repo/remote/remote_repo.dart';
import 'package:cinema_box/ui/app_bloc.dart';
import 'package:cinema_box/ui/custom_widget/custom_app_bar.dart';
import 'package:cinema_box/ui/custom_widget/custom_widget.dart';
import 'package:cinema_box/ui/custom_widget/login_prompt_dialog.dart';
import 'package:cinema_box/ui/favorite/favorite_movie_bloc.dart';
import 'package:cinema_box/ui/movie_detail/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoriteMoviePage extends StatefulWidget {
  static const String routeName = "/favoriteMovie";

  @override
  _FavoriteMoviePageState createState() => _FavoriteMoviePageState();
}

class _FavoriteMoviePageState extends State<FavoriteMoviePage> {
  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProviderList.of<AppBloc>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: StreamBuilder<bool>(
          stream: appBloc.isLoggedIn,
          builder: (context, snapshot) {
            bool isUserLoggedIn = snapshot.data ?? false;
            if (!isUserLoggedIn) {
              return Center(
                child: OutlineButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => LoginPromptDialog(),
                    );
                  },
                  icon: Icon(FontAwesomeIcons.signInAlt),
                  label: Text("登入"),
                ),
              );
            }
            return DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    indicatorColor: Colors.red,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorWeight: 1,
                    tabs: [
                      Tab(text: "上映中"),
                      Tab(text: "即將上映"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _FavoriteMovieList(_MoviePoserType.inTheater),
                        _FavoriteMovieList(_MoviePoserType.upcoming),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _FavoriteMovieList extends StatefulWidget {
  final _MoviePoserType _posterType;

  _FavoriteMovieList(this._posterType);

  @override
  _FavoriteMovieListState createState() => _FavoriteMovieListState();
}

class _FavoriteMovieListState extends State<_FavoriteMovieList> {
  static const double itemExtent = 210;
  static const double loadMoreExtent = 100;
  static const double loadMoreThreshold = itemExtent * 2 + loadMoreExtent;
  Completer<bool> isRefreshing;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent - loadMoreThreshold) {
        FavoriteMovieBloc bloc =
            BlocProviderList.of<FavoriteMovieBloc>(context);
        bloc.fetchFavoriteMovies();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteMovieBloc bloc = BlocProviderList.of<FavoriteMovieBloc>(context);

    return StreamBuilder<MoviePosterInfoListRes>(
      stream: bloc.favoriteMovies,
      builder: (context, snapshot) {
        if (isRefreshing != null && !isRefreshing.isCompleted) {
          isRefreshing.complete(true);
        }
        MoviePosterInfoListRes data = snapshot.data;
        if (data == null) {
          return Center(child: CircularProgressIndicator());
        }

        List<MoviePosterInfo> movies = [];
        for (var movie in data.results) {
          DateTime now = DateTime.now();
          if (widget._posterType == _MoviePoserType.inTheater) {
            if (now.isAfter(DateTime.parse(movie.releaseDate))) {
              movies.add(movie);
            }
          } else {
            if (now.isBefore(DateTime.parse(movie.releaseDate))) {
              movies.add(movie);
            }
          }
        }
        int itemCount =
            data.page != data.totalPages ? movies.length + 1 : movies.length;

        return RefreshIndicator(
          onRefresh: () {
            bloc.fetchFavoriteMovies(refresh: true);
            isRefreshing = Completer();
            return isRefreshing.future.then((_) {
              scrollController.animateTo(0,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            });
          },
          child: ListView.separated(
            key: PageStorageKey(widget._posterType),
            controller: scrollController,
            physics:
                ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: itemCount,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            itemBuilder: (context, index) {
              if (movies == null || index >= movies.length) {
                return Container(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              MoviePosterInfo movie = movies[index];
              return GestureDetector(
                key: ValueKey("${widget._posterType.toString()}${movie.id}"),
                onTap: () {
                  int movieId = movies[index].id;
                  Navigator.of(context).pushNamed(
                    MovieDetailPage.routeName,
                    arguments: {
                      MovieDetailPage.movieIdParam: movieId,
                      MovieDetailPage.posterHeroTagParam:
                          "FavoriteMovie_$movieId",
                      MovieDetailPage.posterUrlParam: movie.posterPath,
                    },
                  );
                },
                child: Container(
                  height: 210,
                  child: Row(
                    children: <Widget>[
                      Hero(
                        tag: "FavoriteMovie_${movie.id}",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            width: 115,
                            height: 170,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${RemoteRepo.imageBaseUrl}${movie.posterPath}",
                            placeholder: (context, url) {
                              return Container(width: 115, height: 170);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.favorite,
                                    color: Colors.redAccent),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "上映時間：${movie.releaseDate.replaceAll("-", " / ")}",
                            ),
                            Divider(height: 5),
                            Text(movie.title),
                            Text(movie.originalTitle),
                            if (widget._posterType == _MoviePoserType.inTheater)
                              Divider(height: 5),
                            if (widget._posterType == _MoviePoserType.inTheater)
                              Row(
                                children: <Widget>[
                                  Rating(movie.voteAverage / 2),
                                  SizedBox(width: 4),
                                  Text(
                                    "${(movie.voteAverage / 2).toStringAsPrecision(2)}",
                                    //style: textTheme.body1.copyWith(color: Colors.grey),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    "(${movie.voteCount})",
                                    //style: textTheme.body1.copyWith(color: Colors.grey),
                                  ),
                                  Spacer(),
                                  //CertificationTag(),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(height: 0),
          ),
        );
      },
    );
  }
}

enum _MoviePoserType { inTheater, upcoming }
