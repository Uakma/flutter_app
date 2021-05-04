import 'package:flutter/material.dart';
import 'package:motel/widgets/airline_logo.dart';

class FlightCardAirlineLogos extends StatelessWidget {

  FlightCardAirlineLogos({Key key, this.logos}) : super(key: key);

  final List<AirlineLogo> logos;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if(logos.length <= 2) ...[
          for(var logo in logos) ...[
            logo,
          ]
        ] else ...[
          logos[0],
          logos[1],
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color.fromRGBO(0, 174, 239, .1),
            ),
            child: Text("+${logos.length - 2}",
              style: TextStyle(
                color: Color.fromRGBO(0, 174, 239, 1),
                fontFamily: 'Gilroy',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
          )
        ],
      ],
    );
  }
}