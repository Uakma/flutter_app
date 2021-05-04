import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:motel/screens/trip_details/local_widgets/rounded_box.dart';

class TripDetailsStopover extends StatelessWidget {

  TripDetailsStopover({
    Key key,
    this.datetime,
    this.city,
    this.code
  }) : super(key: key);

  final DateTime datetime;
  final String city;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 3,
              color: Color(0xff3A3F5C),
            ),
          ),
        ),
        SizedBox(
          width: 19,
        ),
        Expanded(
          child: RoundedBox(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  child: Text(
                    DateFormat('h:mm a').format(datetime) + ' ',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                        color: Color(0xff333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    city,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                        color: Color(0xff333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    code,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                        color: Color(0xff333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            ),
          )
        )
      ],
    );
  }
}