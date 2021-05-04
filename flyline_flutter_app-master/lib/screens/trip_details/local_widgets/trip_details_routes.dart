import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_board_days.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_flight.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_layover.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_stopover.dart';
import 'package:motel/widgets/flight_card_detail_row.dart';


class TripDetailsRoutes extends StatelessWidget {

  TripDetailsRoutes({
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
    return routesDetail();
  }

  Widget routesDetail() {
    final String depDateString = intl.DateFormat('EEEE, MMM dd').format(DateTime.parse(depDate));
    final String arrDateString = isRoundTrip ? intl.DateFormat('EEEE, MMM dd').format(DateTime.parse(depDate)) : null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 29),
              height: 60,
              child: Text(
                'Departure $depDateString',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 14,
                  color: Color.fromRGBO(51, 51, 51, 1),
                  fontWeight: FontWeight.w700
                ),
                textAlign: TextAlign.left,
              )
            ),
            Column(
              children: populateRoutes(flight.departures),
            ),
            !isRoundTrip && flight.departures.length == 1
              ? Container(
                height: 250,
                color: Colors.white
              )
              : Container( ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: TripDetailsOnBoardDays(flight: flight,)
            ),
            isRoundTrip 
              ? Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 29),
                height: 50,
                child: Text(
                  'Return $arrDateString',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                )
              )
              : Container(),
            isRoundTrip 
              ? Column(
                children: populateRoutes(flight.returns),
              )
              : Container(),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> populateRoutes(List<FlightRouteObject> routes) {
    List<Widget> widgets = <Widget>[];
    int routeIndex = 0;
    bool shouldCheckDepatureRoute = false;
    for (int i = routeIndex; i < routes.length; i++) {
      final FlightRouteObject route = routes[i];
        if (i == 0 || shouldCheckDepatureRoute) {
          widgets.add(
            Container(
              height: 50,
              child: TripDetailsStopover(
                datetime: route.localDeparture,
                city: route.cityFrom,
                code: route.flyFrom,
              ),
            )
          );
          widgets.add(
            Container(
              height: 115,
              child: TripDetailsFlight(detail: route),
            )
          );
          widgets.add(
            Container(
              height: 50,
              child: TripDetailsStopover(
                datetime: route.localArrival,
                city: route.cityTo,
                code: route.flyTo,
              ),
            )
          );
          shouldCheckDepatureRoute = false;
        } else {
          widgets.add(
            Container(
              height: 115,
              child: TripDetailsFlight(detail: route),
            )
          );
          widgets.add(
            Container(
              height: 50,
              child: TripDetailsStopover(
                datetime: route.localArrival,
                city: route.cityTo,
                code: route.flyTo,
              ),
            )
          );
        }
      for (int j = 0; j < stops.length; j++) {
        final StopDetails stop = stops[j];
        if (route.flyTo == stop.to) {
          widgets.add(
            Container(
              height: 115,
              child: TripDetailsLayover(stopDetail: stop),
            )
          );
          shouldCheckDepatureRoute = true;

          break;
        }
      }
      if (routeIndex < routes.length - 1) 
        routeIndex++;
    }
    return widgets;
  }
} 