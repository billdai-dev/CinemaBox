import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_box/data/repo/model/credit.dart';
import 'package:cinema_box/data/repo/model/response/movie_detail_res.dart';
import 'package:cinema_box/data/repo/model/video.dart';
import 'package:cinema_box/data/repo/remote/remote_repo.dart';
import 'package:cinema_box/ui/app_bloc.dart';
import 'package:cinema_box/ui/custom_widget/custom_app_bar.dart';
import 'package:cinema_box/ui/custom_widget/custom_widget.dart';
import 'package:cinema_box/ui/custom_widget/login_prompt_dialog.dart';
import 'package:cinema_box/ui/favorite/favorite_movie_bloc.dart';
import 'package:cinema_box/ui/movie_detail/movie_detail_bloc.dart';
import 'package:cinema_box/ui/youtube_video/youtube_video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  MovieDetailBloc bloc;
  String posterHeroTag;
  int movieId;
  String posterUrl;
  ValueNotifier<int> segmentedControlIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    bloc = MovieDetailBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    posterHeroTag = args[MovieDetailPage.posterHeroTagParam] ?? "";
    movieId = args[MovieDetailPage.movieIdParam] ?? 0;
    posterUrl = args[MovieDetailPage.posterUrlParam] ?? "";

    bloc.fetchMovieDetail.add(movieId);
  }

  @override
  void dispose() {
    bloc.dispose();
    segmentedControlIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

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
          child: CachedNetworkImage(
            imageUrl: "${RemoteRepo.imageBaseUrl}$posterUrl",
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
          child: StreamBuilder<bool>(
            stream: bloc.isFavorite,
            builder: (context, snapshot) {
              bool isFavorite = snapshot.data;
              return IconButton(
                icon: Icon(
                  isFavorite ?? false ? Icons.favorite : Icons.favorite_border,
                ),
                color: isFavorite == null ? Colors.black54 : Colors.redAccent,
                onPressed: () async {
                  AppBloc appBloc = BlocProviderList.of<AppBloc>(context);
                  if (!appBloc.isLoggedIn.value ?? false) {
                    bool isLoginSuccess = await showDialog(
                      context: context,
                      builder: (context) {
                        return LoginPromptDialog();
                      },
                    );
                    if (isLoginSuccess) {
                      await bloc.getFavoriteState();
                    }
                    return;
                  }
                  FavoriteMovieBloc favoriteBloc =
                      BlocProviderList.of<FavoriteMovieBloc>(context);

                  favoriteBloc
                      .setAsFavorite(data.id, !isFavorite)
                      .then((isSuccess) {
                    if (isSuccess) {
                      bloc.isFavorite.add(!isFavorite);
                    } else {
                      throw AssertionError("Set as favorite failed");
                    }
                  }).catchError(
                    (error) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("收藏失敗，請稍後重試"),
                        ),
                      );
                      bloc.isFavorite.add(isFavorite);
                    },
                  );
                },
              );
            },
          ),
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
                    backgroundImage: CachedNetworkImageProvider(
                      "${RemoteRepo.imageBaseUrl}${casts[index].profilePath}",
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
