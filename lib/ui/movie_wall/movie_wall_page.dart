import 'dart:async';
import 'dart:math';

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
    with
        AutomaticKeepAliveClientMixin<InTheaterMovie>,
        SingleTickerProviderStateMixin {
  PageController _pageController;
  Completer<bool> isRefreshing;
  ValueNotifier<double> currentPageOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.645);
    _pageController.addListener(() {
      currentPageOffset.value = _pageController.page;
    });
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          double height = constraints.maxHeight;
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                height: height,
                child: StreamBuilder<MoviePosterInfoListRes>(
                  stream: bloc.nowPlayingMovies,
                  builder: (context, snapshot) {
                    if (isRefreshing != null && !isRefreshing.isCompleted) {
                      isRefreshing.complete(true);
                    }
                    MoviePosterInfoListRes data = snapshot.data;
                    int itemCount;
                    if (!snapshot.hasData) {
                      itemCount = 1;
                    } else {
                      itemCount = data.page != data.totalPages
                          ? data.results.length + 1
                          : data.results.length;
                    }

                    return PageView.builder(
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
                      itemBuilder: (context, pageIndex) {
                        if (!snapshot.hasData ||
                            pageIndex >= data.results.length) {
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return ValueListenableBuilder<double>(
                          valueListenable: currentPageOffset,
                          builder: (context, currentPageOffset, child) {
                            double scaleFactor;
                            if (pageIndex == currentPageOffset.floor()) {
                              scaleFactor = max(0.93,
                                  1 - (0.1 * (currentPageOffset - pageIndex)));
                            } else if (pageIndex == currentPageOffset.ceil()) {
                              scaleFactor = max(0.93,
                                  1 - (0.1 * (pageIndex - currentPageOffset)));
                            } else {
                              scaleFactor = 0.93;
                            }
                            return Transform.scale(
                              scale: scaleFactor,
                              child: child,
                            );
                          },
                          child: MoviePoster.inTheater(data.results[pageIndex]),
                        );
                      },
                      itemCount: itemCount,
                    );
                  },
                ),
              ),
            ],
          );
        },
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
  ValueNotifier<double> currentPageOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.645);
    _pageController.addListener(() {
      currentPageOffset.value = _pageController.page;
    });
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                child: StreamBuilder<MoviePosterInfoListRes>(
                  stream: bloc.upcomingMovies,
                  builder: (context, snapshot) {
                    if (isRefreshing != null && !isRefreshing.isCompleted) {
                      isRefreshing.complete(true);
                    }
                    MoviePosterInfoListRes data = snapshot.data;
                    int itemCount;
                    if (!snapshot.hasData) {
                      itemCount = 1;
                    } else {
                      itemCount = data.page != data.totalPages
                          ? data.results.length + 1
                          : data.results.length;
                    }

                    return PageView.builder(
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
                      itemBuilder: (context, pageIndex) {
                        if (!snapshot.hasData ||
                            pageIndex >= data.results.length) {
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return ValueListenableBuilder<double>(
                          valueListenable: currentPageOffset,
                          builder: (context, currentPageOffset, child) {
                            double scaleFactor;
                            if (pageIndex == currentPageOffset.floor()) {
                              scaleFactor = max(0.93,
                                  1 - (0.1 * (currentPageOffset - pageIndex)));
                            } else if (pageIndex == currentPageOffset.ceil()) {
                              scaleFactor = max(0.93,
                                  1 - (0.1 * (pageIndex - currentPageOffset)));
                            } else {
                              scaleFactor = 0.93;
                            }
                            return Transform.scale(
                              scale: scaleFactor,
                              child: child,
                            );
                          },
                          child: MoviePoster.upcoming(data.results[pageIndex]),
                        );
                      },
                      itemCount: itemCount,
                    );
                  },
                ),
              ),
            ],
          );
        },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
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
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Card(
                margin: EdgeInsets.zero,
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
                        fit: BoxFit.cover,
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
          SizedBox(height: 30),
          Column(
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
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

enum _MoviePoserType { inTheater, upcoming }
