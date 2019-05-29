import 'package:cinema_box/ui/custom_widget/custom_app_bar.dart';
import 'package:cinema_box/ui/custom_widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class FavoriteMoviePage extends StatefulWidget {
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
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      itemBuilder: (context, index) {
        return Container(
          height: 210,
          child: Row(
            children: <Widget>[
              Hero(
                tag: "FavoriteMovie_id",
                child: TransitionToImage(
                  width: 115,
                  height: 170,
                  borderRadius: BorderRadius.circular(5),
                  fit: BoxFit.cover,
                  placeholder: Container(color: Colors.black12),
                  image: AdvancedNetworkImage(
                      "http://en.es-static.us/upl/2018/12/comet-wirtanen-Jack-Fusco-dec-2018-Anza-Borrego-desert-CA-e1544613895713.jpg"),
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
                    Text("上映時間："),
                    Divider(height: 5),
                    Text("電影名"),
                    Text("英文電影名"),
                    if (widget._posterType == _MoviePoserType.inTheater)
                      Divider(height: 5),
                    if (widget._posterType == _MoviePoserType.inTheater)
                      Row(
                        children: <Widget>[
                          Rating(3.5),
                          SizedBox(width: 4),
                          Text(
                            "${(3.5 / 2).toStringAsPrecision(2)}",
                            //style: textTheme.body1.copyWith(color: Colors.grey),
                          ),
                          SizedBox(width: 2),
                          Text(
                            "(1000})",
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
      itemCount: 10,
    );
  }
}

enum _MoviePoserType { inTheater, upcoming }
