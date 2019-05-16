import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_box/data/repo/model/response/movie_poster_info_list_res.dart';
import 'package:cinema_box/data/repo/remote/remote_repo.dart';
import 'package:cinema_box/ui/custom_widget/custom_app_bar.dart';
import 'package:cinema_box/ui/custom_widget/custom_widget.dart';
import 'package:cinema_box/ui/movie_detail/movie_detail_page.dart';
import 'package:cinema_box/ui/movie_wall/movie_wall_bloc.dart';
import 'package:flutter/material.dart';

class MovieWallPage extends StatefulWidget {
  static const String routeName = "/movieWall";

  @override
  _MovieWallPageState createState() => _MovieWallPageState();
}

class _MovieWallPageState extends State<MovieWallPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: MovieWallBloc(),
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TabBar(
                controller: _tabController,
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
                  controller: _tabController,
                  children: <Widget>[
                    InTheaterMovie(),
                    UpcomingMovie(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InTheaterMovie extends StatefulWidget {
  @override
  _InTheaterMovieState createState() => _InTheaterMovieState();
}

class _InTheaterMovieState extends State<InTheaterMovie>
    with AutomaticKeepAliveClientMixin<InTheaterMovie> {
  PageController _pageController;
  Completer<bool> isRefreshing;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    MovieWallBloc bloc = BlocProvider.of<MovieWallBloc>(context);
    return RefreshIndicator(
      onRefresh: () {
        bloc.fetchNowPlayingMovies(refresh: true);
        isRefreshing = Completer();
        return isRefreshing.future.then((_) {
          _pageController.animateTo(0,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        });
      },
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 618,
            child: StreamBuilder<MoviePosterInfoListRes>(
              stream: bloc.nowPlayingMovies,
              builder: (context, snapshot) {
                if (isRefreshing != null && !isRefreshing.isCompleted) {
                  isRefreshing.complete(true);
                }
                List<Widget> movies = snapshot.hasData
                    ? snapshot.data.results
                        .map((movie) => MoviePoster.inTheater(movie))
                        .toList()
                    : [];
                return PageView(
                  controller: _pageController,
                  onPageChanged: (currentPage) {
                    int dataSize = bloc.nowPlayingMoviesLength;
                    if (dataSize == 0) {
                      return;
                    }
                    if (currentPage >= dataSize - 3) {
                      bloc.fetchNowPlayingMovies();
                    }
                  },
                  children: <Widget>[
                    ...movies,
                    if (snapshot.hasData &&
                        snapshot.data.page != snapshot.data.totalPages)
                      Container(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class UpcomingMovie extends StatefulWidget {
  @override
  _UpcomingMovieState createState() => _UpcomingMovieState();
}

class _UpcomingMovieState extends State<UpcomingMovie>
    with AutomaticKeepAliveClientMixin<UpcomingMovie> {
  PageController _pageController;
  Completer<bool> isRefreshing;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    MovieWallBloc bloc = BlocProvider.of<MovieWallBloc>(context);
    return RefreshIndicator(
      onRefresh: () {
        bloc.fetchUpcomingMovies(refresh: true);
        isRefreshing = Completer();
        return isRefreshing.future.then((_) {
          _pageController.animateTo(0,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        });
      },
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 618,
            child: StreamBuilder<MoviePosterInfoListRes>(
              stream: bloc.upcomingMovies,
              builder: (context, snapshot) {
                if (isRefreshing != null && !isRefreshing.isCompleted) {
                  isRefreshing.complete(true);
                }
                List<Widget> movies = snapshot.hasData
                    ? snapshot.data.results
                        .map((movie) => MoviePoster.upcoming(movie))
                        .toList()
                    : [];

                return PageView(
                  physics: BouncingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (currentPage) {
                    int dataSize = bloc.upcomingMoviesLength;
                    if (dataSize == 0) {
                      return;
                    }
                    if (currentPage >= dataSize - 3) {
                      bloc.fetchUpcomingMovies();
                    }
                  },
                  children: <Widget>[
                    ...movies,
                    if (snapshot.hasData &&
                        snapshot.data.page != snapshot.data.totalPages)
                      Container(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MoviePoster extends StatefulWidget {
  final _MoviePoserType _poserType;
  final MoviePosterInfo _movie;

  MoviePoster.inTheater(this._movie) : _poserType = _MoviePoserType.inTheater;

  MoviePoster.upcoming(this._movie) : _poserType = _MoviePoserType.upcoming;

  @override
  _MoviePosterState createState() => _MoviePosterState();
}

class _MoviePosterState extends State<MoviePoster>
    with AutomaticKeepAliveClientMixin<MoviePoster> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 30),
              child: InkWell(
                onTap: () {
                  int movieId = widget._movie.id;
                  Navigator.of(context).pushNamed(
                    MovieDetailPage.routeName,
                    arguments: {
                      MovieDetailPage.movieIdParam: movieId,
                      MovieDetailPage.posterHeroTagParam: "$movieId",
                      MovieDetailPage.posterUrlParam: widget._movie.posterPath,
                    },
                  );
                },
                child: Card(
                  color: Colors.black12,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 10,
                  child: Hero(
                    tag: "${widget._movie.id}",
                    child: CachedNetworkImage(
                      imageUrl:
                          "${RemoteRepo.imageBaseUrl}${widget._movie.posterPath}",
                      imageBuilder: (context, imageProvider) {
                        return Image(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        );
                      },
                      placeholder: (context, url) {
                        return Container(color: Colors.black12);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "上映時間：${widget._movie.releaseDate.replaceAll("-", " / ")}",
                  style: textTheme.body2.copyWith(color: Colors.grey),
                ),
                Divider(height: 10),
                Text(
                  "${widget._movie.title}",
                  style: textTheme.title.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: 2),
                Text(
                  "${widget._movie.originalTitle}",
                  style: textTheme.body2.copyWith(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                if (widget._poserType == _MoviePoserType.inTheater)
                  Divider(height: 10),
                if (widget._poserType == _MoviePoserType.inTheater)
                  Row(
                    children: <Widget>[
                      Rating(widget._movie.voteAverage / 2),
                      SizedBox(width: 4),
                      Text(
                        "${(widget._movie.voteAverage / 2).toStringAsPrecision(2)}",
                        style: textTheme.body1.copyWith(color: Colors.grey),
                      ),
                      SizedBox(width: 2),
                      Text(
                        "(${widget._movie.voteCount})",
                        style: textTheme.body1.copyWith(color: Colors.grey),
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
  }

  @override
  bool get wantKeepAlive => false;
}

enum _MoviePoserType { inTheater, upcoming }
