import 'package:cinema_box/util/certification_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Rating extends StatelessWidget {
  final int total;
  final double rating;
  final double iconSize;

  Rating(this.rating, {this.total = 5, this.iconSize = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 1; i < total + 1; i++)
          if (i > rating)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: const Color.fromARGB(255, 209, 209, 214),
                size: iconSize,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                rating.toInt() != rating
                    ? FontAwesomeIcons.starHalfAlt
                    : FontAwesomeIcons.solidStar,
                color: Colors.yellow,
                size: iconSize,
              ),
            ),
      ],
    );
  }
}

class CertificationTag extends StatelessWidget {
  final CertificationConverter _converter = CertificationConverter([]);

  @override
  Widget build(BuildContext context) {
    String certification = _converter.getTwCertification();
    Color color = _converter.getCertificationColor(certification);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: color,
      ),
      child: Text(
        certification,
        style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
      ),
    );
  }
}
