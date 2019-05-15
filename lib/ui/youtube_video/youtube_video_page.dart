import 'package:cinema_box/ui/custom_widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPage extends StatefulWidget {
  static const String routeName = "/youtubeVideo";
  static const String argVideoKey = "videoKey";

  @override
  _YoutubeVideoPageState createState() => _YoutubeVideoPageState();
}

class _YoutubeVideoPageState extends State<YoutubeVideoPage> {
  YoutubePlayerController controller;
  String youtubeKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map args = ModalRoute.of(context).settings.arguments;
    youtubeKey = args[YoutubeVideoPage.argVideoKey];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: InAppWebView(
        initialUrl: "https://www.youtube.com/watch?v=$youtubeKey",
      ),
    );
  }
}
