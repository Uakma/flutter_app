import 'package:flutter/material.dart';
import 'package:motel/widgets/flight_card_detail_row.dart';

class TripDetailsLayover extends StatelessWidget {

  TripDetailsLayover({Key key, this.stopDetail}) : super(key: key);

  final StopDetails stopDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 29,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 42, bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      'Layover : ${stopDetail.city} (${stopDetail.to}) : Duration : ${stopDetail.durationString()}',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 14,
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}