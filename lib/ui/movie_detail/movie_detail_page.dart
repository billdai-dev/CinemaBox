import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_box/data/repo/model/credit.dart';
import 'package:cinema_box/data/repo/model/response/movie_detail_res.dart';
import 'package:cinema_box/data/repo/model/video.dart';
import 'package:cinema_box/data/repo/remote/remote_repo.dart';
import 'package:cinema_box/ui/custom_widget/custom_widget.dart';
import 'package:cinema_box/ui/movie_detail/movie_detail_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieDetailPage extends StatefulWidget {
  static const String routeName = "/movieDetail";
  static const String posterHeroTagParam = "posterHeroTag";
  static const String movieIdParam = "movieId";
  static const String posterUrlParam = "posterUrl";

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  String posterHeroTag;
  int movieId;
  String posterUrl;
  ValueNotifier<int> segmentedControlIndex = ValueNotifier(0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MovieDetailBloc bloc = BlocProvider.of<MovieDetailBloc>(context);
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    posterHeroTag = args[MovieDetailPage.posterHeroTagParam] ?? "";
    movieId = args[MovieDetailPage.movieIdParam] ?? 0;
    posterUrl = args[MovieDetailPage.posterUrlParam] ?? "";
    bloc.fetchMovieDetail.add(movieId);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    MovieDetailBloc bloc = BlocProvider.of<MovieDetailBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        title: Text("Cinema Box"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesomeIcons.filter,
                color: Colors.red,
              ),
              onPressed: () {}),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(180, 0, 0, 0),
                Colors.black,
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: StreamBuilder<MovieDetailRes>(
                      stream: bloc.movieDetail,
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Container(
                              height: 200,
                              child: Row(
                                children: <Widget>[
                                  _buildPoster(),
                                  SizedBox(width: 8),
                                  if (snapshot.hasData)
                                    Expanded(
                                      child: _buildTitles(snapshot.data),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildSegmentedControl(),
                            SizedBox(height: 20),
                            ValueListenableBuilder(
                              valueListenable: segmentedControlIndex,
                              builder: (context, index, child) {
                                return IndexedStack(
                                  index: index,
                                  children: <Widget>[
                                    _buildMovieDetail(textTheme, snapshot),
                                    _buildReview(),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: bloc.movieDetail,
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox.shrink();
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildMovieDetail(
      TextTheme textTheme, AsyncSnapshot<MovieDetailRes> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (snapshot.hasData)
          ..._buildOverview(textTheme, snapshot.data.overview),
        Divider(height: 32),
        if (!true) ..._buildTrailer(textTheme, snapshot.data.videos),
        if (snapshot.hasData)
          ..._buildCast(textTheme, snapshot.data.credits?.cast),
      ],
    );
  }

  Widget _buildPoster() {
    return Container(
      child: Hero(
        tag: posterHeroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: "${RemoteRepo.imageBaseUrl}$posterUrl",
            imageBuilder: (context, imageProvider) {
              return Image(
                image: imageProvider,
                fit: BoxFit.contain,
              );
            },
            placeholder: (context, url) {
              return Container(color: Colors.black12);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitles(MovieDetailRes data) {
    String rating = (data.voteAverage / 2).toStringAsPrecision(2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 8),
        Align(
          alignment: Alignment(0.8, 0),
          child: Icon(FontAwesomeIcons.heart),
        ),
        SizedBox(height: 28),
        Text("上映時間：${data.releaseDate.replaceAll("-", " / ")}"),
        Divider(height: 16),
        Text("${data.title}"),
        SizedBox(height: 2),
        Text("${data.originalTitle}"),
        Divider(height: 16),
        Row(
          children: <Widget>[
            Rating(double.parse(rating), iconSize: 12),
            SizedBox(width: 4),
            Text(rating),
            SizedBox(width: 2),
            Text("(${data.voteCount})"),
            Spacer(),
            CertificationTag(data.releaseDataInfo),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentedControl() {
    return ValueListenableBuilder(
      valueListenable: segmentedControlIndex,
      builder: (context, index, child) {
        return CupertinoSegmentedControl(
          children: const {
            0: Text("電影資訊"),
            1: Text("電影評論"),
          },
          onValueChanged: (index) => segmentedControlIndex.value = index,
          groupValue: index,
          unselectedColor: Colors.white,
          selectedColor: Colors.red,
          borderColor: Colors.red,
        );
      },
    );
  }

  List<Widget> _buildOverview(TextTheme textTheme, String overview) {
    return [
      Text(
        "關於",
        style: textTheme.title.copyWith(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Text(overview),
    ];
  }

  List<Widget> _buildTrailer(TextTheme textTheme, Video video) {
    return [
      Text(
        "預告片",
        style: textTheme.title.copyWith(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Row(
        children: <Widget>[],
      ),
    ];
  }

  List<Widget> _buildCast(TextTheme textTheme, List<Cast> casts) {
    return [
      Text(
        "演員卡司",
        style: textTheme.title.copyWith(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16),
      Container(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: casts.length,
          itemExtent: 100,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.black12,
                    backgroundImage: CachedNetworkImageProvider(
                      "${RemoteRepo.imageBaseUrl}${casts[index].profilePath}",
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    casts[index].name,
                    textAlign: TextAlign.center,
                    style: textTheme.caption.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildReview() {
    return Container(color: Colors.cyan);
  }
}
