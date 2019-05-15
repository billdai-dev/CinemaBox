import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  static const double _kToolbarHeight = 56.0;

  @override
  final Size preferredSize;

  CustomAppBar() : preferredSize = Size.fromHeight(_kToolbarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
