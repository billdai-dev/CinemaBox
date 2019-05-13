import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/model/response/now_playing_movie_list_res.dart';
import 'package:cinema_box/data/repo/remote/remote_repo.dart';
import 'package:cinema_box/ui/custom_widget/custom_widget.dart';
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
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.red,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
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

class _InTheaterMovieState extends State<InTheaterMovie> {
  PageController _pageController;

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
    MovieWallBloc bloc = BlocProvider.of<MovieWallBloc>(context);
    return StreamBuilder<NowPlayingMovieListRes>(
      stream: bloc.nowPlayingMovies,
      builder: (context, snapshot) {
        List<Widget> movies = snapshot.hasData
            ? snapshot.data.results
                .map((movie) => MoviePoster.inTheater(movie))
                .toList()
            : [];

        return PageView(
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          children: movies,
        );
      },
    );
  }
}

class UpcomingMovie extends StatefulWidget {
  @override
  _UpcomingMovieState createState() => _UpcomingMovieState();
}

class _UpcomingMovieState extends State<UpcomingMovie> {
  PageController _pageController;

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
    return PageView(
      physics: BouncingScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        //MoviePoster.upcoming(),
        //MoviePoster.upcoming(),
      ],
    );
  }
}

class MoviePoster extends StatefulWidget {
  final _MoviePoserType _poserType;
  final NowPlayingMovie _movie;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 30),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "${RemoteRepo.imageBaseUrl}${widget._movie.posterPath}",
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "上映時間：${widget._movie.releaseDate.replaceAll("-", " / ")}",
                  style: textTheme.body2.copyWith(color: Colors.grey),
                ),
                Divider(height: 16),
                Text(
                  "${widget._movie.title}",
                  style: textTheme.title.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "${widget._movie.originalTitle}",
                  style: textTheme.body2.copyWith(color: Colors.grey),
                ),
                Divider(height: 12),
                if (widget._poserType == _MoviePoserType.inTheater)
                  Row(
                    children: <Widget>[
                      Rating(widget._movie.voteAverage / 2),
                      SizedBox(width: 4),
                      Text(
                        "${(widget._movie.voteAverage / 2).toStringAsPrecision(2)}",
                        style: textTheme.body1.copyWith(color: Colors.grey),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "(${widget._movie.voteCount})",
                        style: textTheme.body1.copyWith(color: Colors.grey),
                      ),
                      Spacer(),
                      //CertificationTag(),
                    ],
                  )
                else
                  Row(
                    children: <Widget>[
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
  bool get wantKeepAlive => true;
}

enum _MoviePoserType { inTheater, upcoming }
