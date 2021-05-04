import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_booking_button.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_routes.dart';
import 'package:motel/widgets/flight_card_detail_row.dart';
import 'package:motel/widgets/svg_image_widget.dart';

class TripDetailRoutePopup extends StatelessWidget {

  TripDetailRoutePopup({
    this.depDate,
    this.arrDate,
    this.isRoundTrip,
    this.flight,
    this.stops
  });

  final String depDate;
  final String arrDate;
  final bool isRoundTrip;
  final FlightInformationObject flight;
  final List<StopDetails> stops;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 600,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
          ),
          child: Column(
            children: [
              Container(
                height: 68.w,
                child: Row(
                  children: [
                    Container(
                      width: 100,                  
                    ),
                    Expanded(
                      child: Text(
                        'Trip Details',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 20,
                          color: Color.fromRGBO(14, 49, 120, 1),
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 100,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40.w,
                          width: 40.w,
                          child: Center(
                            child: SvgImageWidget.asset(
                              "assets/svg/home/cancel_grey.svg",
                              width: 20.w,
                              height: 20.w,
                            ),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(229, 229, 229, 1)
              ),
              Expanded(
                child: TripDetailsRoutes(arrDate: arrDate,
                  depDate: depDate,
                  flight: flight,
                  isRoundTrip: isRoundTrip,
                  stops: stops,
                )
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(229, 229, 229, 1)
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: TripDetailsBookingButton(onPressed: () {}, title: 'Continue to Book',),
              )
            ],
          ),
        ),
      ),
    );
  }
}