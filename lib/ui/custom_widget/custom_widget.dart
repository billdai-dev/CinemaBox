import 'package:cinema_box/util/certification_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Rating extends StatelessWidget {
  static const int _total = 5;
  static const Color _unscoredColor = const Color.fromARGB(255, 209, 209, 214);

  final int highest;
  final double rating;
  final double iconSize;

  Rating(this.rating, {this.highest = 5, this.iconSize = 16});

  @override
  Widget build(BuildContext context) {
    double ratio = rating / highest;
    double newRating =
        double.parse((_total * ratio).toStringAsPrecision(2)); //Ex: 3.7
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 1; i < _total + 1; i++)
          if (i > newRating)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                newRating.toInt() != newRating && i - 1 == newRating.toInt()
                    ? FontAwesomeIcons.starHalfAlt
                    : FontAwesomeIcons.solidStar,
                color:
                    newRating.toInt() != newRating && i - 1 == newRating.toInt()
                        ? Colors.yellow
                        : _unscoredColor,
                size: iconSize,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                FontAwesomeIcons.solidStar,
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
