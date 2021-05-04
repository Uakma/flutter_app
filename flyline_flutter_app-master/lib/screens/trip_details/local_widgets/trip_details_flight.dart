import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/trip_details/local_widgets/rounded_box.dart';
import 'package:motel/utils/constants.dart';

class TripDetailsFlight extends StatelessWidget {

  TripDetailsFlight({Key key, this.detail}) : super(key: key);

  final FlightRouteObject detail;

  // Widget flightIcon() {
  //   String imageName = ;
  //   return Image.asset(imageName);
  // }

  Future<Image> flightIcon() async {
    String path = 'assets/images/${detail.airline.toLowerCase()}.png';
    return rootBundle.load(path).then((value) {
      return Image.memory(value.buffer.asUint8List());
    }).catchError((_) {
      return Image.network(
        "https://staging.flyline.io/images/airlines/${detail.airline}.png",
        height: 20,
        width: 20,
        fit: BoxFit.cover,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 115,
          child: Image.asset(
            'assets/images/arrow_down_popup.png',
            width: 8,
          ),
        ),
        SizedBox(
          width: 21,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 19),
            child: RoundedBox(
              height: 75,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 17,
                          child: Image.network(
                            "https://staging.flyline.io/images/airlines/${detail.airline}.png",
                            height: 17,
                            width: 17,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 8
                        ),
                        Container(
                          child: Text(
                            '${airlineNames[detail.airline] ?? ''}',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                                color: Color.fromRGBO(142, 150, 159, 1),
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Flight Duration : ',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 14,
                                    color: Color(0xff333333),
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                '${detail.durationString()}',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 14,
                                  color: Color.fromRGBO(142, 150, 159, 1),
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          )
                        ),
                        Container(
                          child: Text(
                            'Flight Number : ${detail.airline.toUpperCase()} ${detail.flightNo}',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: Color.fromRGBO(142, 150, 159, 1),
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        )
      ],
    );
  }
}