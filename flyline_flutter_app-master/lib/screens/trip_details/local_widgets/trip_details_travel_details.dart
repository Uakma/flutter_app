import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_destination_details_row.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_flight_details_tags.dart';
import 'package:motel/widgets/airline_logo.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TripDetailsTravelDetails extends StatelessWidget {
  const TripDetailsTravelDetails({
    Key key,
    @required this.dateText,
    @required this.date,
    @required this.flights,
    @required this.duration,
    @required this.stopOvers,
    @required this.classOfService,
    @required this.flight,
    this.onPressDetail
  }) : super(key: key);

  final String dateText;
  final String date;
  final List flights;
  final String duration;
  final String stopOvers;
  final String classOfService;
  final FlightInformationObject flight;
  final Function onPressDetail;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 14, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                      children: [
                        TextSpan(text: "$dateText Date :   "),
                        TextSpan(text: date),
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text(
                        'Tap for Details',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xff333333),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      onTap: onPressDetail,
                    ),
                  )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //From
              TripDetailsDestinationDetailsRow(
                logos: flights.toSet().toList().map(
                  (e) {
                    return AirlineLogo(airline: e.airline);
                  },
                ).toList(),
                localTime: flights.first.localDeparture,
                flight: flights.first.flyFrom,
                city: flights.first.cityFrom,
              ),
              //Dots
              Container(
                height: 40.5,
                child: SvgImageWidget.asset(
                  'assets/svg/arrow_down.svg',
                  width: 8,
                ),
              ),
              //To
              TripDetailsDestinationDetailsRow(
                localTime: flights.last.localArrival,
                flight: flights.last.flyTo,
                city: flights.last.cityTo,
              ),
              TripDetailsFlightDetailsTags(
                tags: [
                  duration,
                  stopOvers,
                  classOfService,
                ],
              ),
            ],
          ),
        ],
      ),
      desktop: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 23.w, bottom: 23.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff333333),
                        fontSize: 14.w,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                      children: [
                        TextSpan(text: "$dateText Date :   "),
                        TextSpan(text: date),
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text(
                        'Tap for Details',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xff333333),
                          fontSize: 10.w,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      onTap: onPressDetail,
                    ),
                  )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //From
              TripDetailsDestinationDetailsRow(
                logos: flights.toSet().toList().map(
                  (e) {
                    return AirlineLogo(airline: e.airline);
                  },
                ).toList(),
                localTime: flights.first.localDeparture,
                flight: flights.first.flyFrom,
                city: flights.first.cityFrom,
              ),
              //Dots
              Container(
                height: 27.h,
                child: SvgImageWidget.asset(
                  'assets/svg/arrow_down.svg',
                  width: 8,
                ),
              ),
              //To
              TripDetailsDestinationDetailsRow(
                localTime: flights.last.localArrival,
                flight: flights.last.flyTo,
                city: flights.last.cityTo,
              ),
              TripDetailsFlightDetailsTags(
                tags: [
                  duration,
                  stopOvers,
                  classOfService,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
