import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cinema_box/data/repo/model/credit.dart';
import 'package:cinema_box/data/repo/model/response/movie_detail_res.dart';
import 'package:cinema_box/data/repo/model/video.dart';
import 'package:cinema_box/data/repo/remote/remote_repo.dart';
import 'package:cinema_box/ui/app_bloc.dart';
import 'package:cinema_box/ui/custom_widget/custom_app_bar.dart';
import 'package:cinema_box/ui/custom_widget/custom_widget.dart';
import 'package:cinema_box/ui/movie_detail/movie_detail_bloc.dart';
import 'package:cinema_box/ui/youtube_video/youtube_video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
      appBar: CustomAppBar(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: StreamBuilder<MovieDetailRes>(
                      stream: bloc.movieDetail,
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              height: 210,
                              child: Row(
                                children: <Widget>[
                                  _buildPoster(),
                                  SizedBox(width: 10),
                                  if (snapshot.hasData)
                                    Expanded(
                                      child: _buildTitles(snapshot.data),
                                    ),
                                ],
                              ),
                            ),
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
        if (snapshot.hasData && snapshot.data.videos.isYoutubeTrailerExist())
          ..._buildTrailer(context, textTheme, snapshot.data.videos),
        if (snapshot.hasData)
          ..._buildCast(textTheme, snapshot.data.credits?.cast),
      ],
    );
  }

  Widget _buildPoster() {
    return Container(
      width: 115,
      height: 170,
      child: Hero(
        tag: posterHeroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TransitionToImage(
            image: AdvancedNetworkImage(
              "${RemoteRepo.imageBaseUrl}$posterUrl",
            ),
            fit: BoxFit.cover,
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
        SizedBox(height: 30),
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(right: 15),
          child: Icon(FontAwesomeIcons.heart),
        ),
        SizedBox(height: 20),
        Text("上映時間：${data.releaseDate.replaceAll("-", " / ")}"),
        Divider(height: 10),
        Text("${data.title}"),
        SizedBox(height: 2),
        Text("${data.originalTitle}"),
        Divider(height: 10),
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
      Divider(height: 40),
    ];
  }

  List<Widget> _buildTrailer(
      BuildContext context, TextTheme textTheme, Video video) {
    List<String> trailerKeys = video.getYoutubeTrailerKeys();
    if (trailerKeys == null) {
      return [];
    }
    return [
      Text(
        "預告片",
        style: textTheme.title.copyWith(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Container(
        height: 90,
        child: ListView(
          scrollDirection: Axis.horizontal,
          itemExtent: 170,
          cacheExtent: trailerKeys.length * 0.8 * 170,
          children: trailerKeys.map((key) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () {
                    AppBloc bloc = BlocProviderList.of<AppBloc>(context);
                    bloc.appNavKey.currentState.pushNamed(
                      YoutubeVideoPage.routeName,
                      arguments: {YoutubeVideoPage.argVideoKey: key},
                    );
                  },
                  child: AbsorbPointer(
                    child: YoutubePlayer(
                      context: context,
                      videoId: key,
                      autoPlay: false,
                      showVideoProgressIndicator: true,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      Divider(height: 40),
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
          itemExtent: 80,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.black12,
                    backgroundImage: AdvancedNetworkImage(
                      "${RemoteRepo.imageBaseUrl}${casts[index].profilePath}",
                      useDiskCache: true,
                    ),
                  ),
                  SizedBox(height: 5),
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
      Divider(height: 40),
    ];
  }

  Widget _buildReview() {
    return Container(color: Colors.cyan);
  }
}
