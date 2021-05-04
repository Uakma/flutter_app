import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/models/flight_information.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TripDetailsOnBoardDays extends StatelessWidget {

  TripDetailsOnBoardDays({this.flight});

  final FlightInformationObject flight;

  @override
  Widget build(BuildContext context) {
    final FlightRouteObject dest = flight.departures.last;
      final DateTime comingDate = flight.departures.last.utcArrival;
      final DateTime leavingDate = flight.returns.first.utcArrival;
      final int days = leavingDate.difference(comingDate).inDays;
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 1,
              color: Color.fromRGBO(142, 150, 159, 0.5),
            ),
          ),
          Container(
            child: ScreenTypeLayout(
              mobile: Text(
                '    $days Nights in ${dest.cityTo}   ',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 14,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  fontWeight: FontWeight.w700
                ),
              ),
              desktop: Text(
                '    $days Nights in ${dest.cityTo}   ',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 10.h,
                    color: Color.fromRGBO(142, 150, 159, 1),
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 1,
              color: Color.fromRGBO(142, 150, 159, 0.5),
            ),
          )
        ],
      );
  }
}