import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/model/response/movie_poster_info_list_res.dart';
import 'package:cinema_box/data/repo/remote/remote_repo.dart';
import 'package:cinema_box/ui/custom_widget/custom_app_bar.dart';
import 'package:cinema_box/ui/custom_widget/custom_widget.dart';
import 'package:cinema_box/ui/favorite/favorite_movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class FavoriteMoviePage extends StatefulWidget {
  static const String routeName = "/favoriteMovie";

  @override
  _FavoriteMoviePageState createState() => _FavoriteMoviePageState();
}

class _FavoriteMoviePageState extends State<FavoriteMoviePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: DefaultTabController(
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
      ),
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
        FavoriteMovieBloc bloc = BlocProvider.of<FavoriteMovieBloc>(context);
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
    FavoriteMovieBloc bloc = BlocProvider.of<FavoriteMovieBloc>(context);
    return RefreshIndicator(
      onRefresh: () {
        bloc.fetchFavoriteMovies(refresh: true);
        isRefreshing = Completer();
        return isRefreshing.future.then((_) {
          scrollController.animateTo(0,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        });
      },
      child: StreamBuilder<MoviePosterInfoListRes>(
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

          return ListView.separated(
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
              return Container(
                height: 210,
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: "FavoriteMovie_${movie.id}",
                      child: TransitionToImage(
                        width: 115,
                        height: 170,
                        borderRadius: BorderRadius.circular(5),
                        fit: BoxFit.cover,
                        placeholder: Container(color: Colors.black12),
                        image: AdvancedNetworkImage(
                            "${RemoteRepo.imageBaseUrl}${movie.posterPath}"),
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
                              icon: Icon(Icons.favorite),
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
              );
            },
            separatorBuilder: (context, index) => Divider(height: 0),
          );
        },
      ),
    );
  }
}

enum _MoviePoserType { inTheater, upcoming }
