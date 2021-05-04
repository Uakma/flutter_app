import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/svg_image_widget.dart';


class AutoPilotProbability extends StatelessWidget {
  final probability;

  const AutoPilotProbability(
    this.probability, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SvgImageWidget.asset('assets/svg/home/probability_illustration.svg'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder(
                    stream: flyLinebloc.outProbability,
                    builder: (_, snapshot) {
                      var value = "Medium";
                      var hexColor = "#FE8930";
                      if ( snapshot != null && snapshot.data != null ) {
                        if (snapshot.data <= 33.33) {
                          value = "Low";
                          hexColor = "#FF001E";
                        } else
                        if (snapshot.data >= 33.33 && snapshot.data <= 66.66) {
                          value = "Medium";
                          hexColor = "#FE8930";
                        } else if (snapshot.data >= 66.66) {
                          value = "High";
                          hexColor = "#44CF57";
                        }
                        value = snapshot.data.toInt().toString() + "%";
                      }

                      return Text(
                        // '40%',
                        '${value ?? probability}',
                        style: TextStyle(
                          color: HexColor(hexColor),
                          fontFamily: 'Gilroy',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Text(
                    'Autopilot Probability',
                    style: TextStyle(
                      color: Color(0xffbbc4dc),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              )
            ],
          ),
          Divider(indent: 20, endIndent: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Text(
              'Select your preferences below, If you see the probability number go to low, change the preferences to improve the chances of you getting the reservation.',
              style: TextStyle(
                color: Color(0xff8e969f),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
