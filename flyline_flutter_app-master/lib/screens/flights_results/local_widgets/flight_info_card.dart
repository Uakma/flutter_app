import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/trip_details/trip_details.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/airline_logo.dart';
import 'package:motel/widgets/flight_card_detail_row.dart';
import 'package:motel/widgets/flight_card_header.dart';

class FlightInfoCard extends StatelessWidget {
  const FlightInfoCard({
    Key key,
    @required this.flight,
    @required this.type,
    @required this.typeOfTripSelected,
    @required this.ad,
    @required this.children,
    @required this.depDate,
    @required this.arrDate,
    @required this.selectedClassOfService,
    this.reviewPage = false,
  }) : super(key: key);

  final int ad;
  final int children;
  final String depDate;
  final String arrDate;
  final String selectedClassOfService;
  final int typeOfTripSelected;
  final SearchType type;
  final FlightInformationObject flight;
  final bool reviewPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 16),
        padding: EdgeInsets.only(left: 16.0, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // if (type == SearchType.EXCLUSIVE)
            //   FutureBuilder(
            //       future: flyLinebloc.checkFlights(flight.bookingToken, 0, 0,
            //           flyLinebloc.numberOfPassengers),
            //       builder: (context, snapshot) {
            //         if(snapshot.hasData && snapshot.data !=null){
            //           if (snapshot.connectionState == ConnectionState.done)
            //             return FlightCardHeader(
            //               type: type,
            //               price: snapshot.data.total,
            //               reviewPage: reviewPage,
            //               logos: flight.airlines
            //                   .map(
            //                     (e) => AirlineLogo(airline: e),
            //               )
            //                   .toList(),
            //             );
            //         }

            //         return FlightCardHeader(
            //           type: type,
            //           price: null,
            //           reviewPage: reviewPage,
            //           logos: flight.airlines
            //               .map(
            //                 (e) => AirlineLogo(airline: e),
            //           )
            //               .toList(),
            //         );
            //       }),
            // if (type != SearchType.EXCLUSIVE)
              FlightCardHeader(
                type: type,
                price: flight.price,
                reviewPage: reviewPage,
                logos: flight.airlines
                    .map(
                      (e) => AirlineLogo(airline: e),
                    )
                    .toList(),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: FlightCardDetailRow(
                from: flight.departures.first.flyFrom,
                to: flight.departures.last.flyTo,
                duration: flight.durationDeparture,
                localDeparture: flight.departures.first.localDeparture,
                localArrival: flight.departures.last.localArrival,
                colorLocation: Color(0xffBBC4DC),
                stops: [
                  ...List.from(flight.departures)
                    ..remove(flight.departures.last)
                ]
                    .map(
                      (e) => StopDetails(
                        to: e.flyTo,
                        duration: e.duration,
                        city: e.cityTo
                      ),
                    )
                    .toList(),
              ),
            ),
            if (typeOfTripSelected == 0)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: FlightCardDetailRow(
                  from: flight.returns.first.flyFrom,
                  to: flight.returns.last.flyTo,
                  duration: flight.durationReturn,
                  localDeparture: flight.returns.first.localDeparture,
                  localArrival: flight.returns.last.localArrival,
                  colorLocation: flight.departures.first.flyFrom == flight.returns.last.flyTo ? Color(0xffBBC4DC) : Color(0xffFE8930),
                  stops: [
                    ...List.from(flight.returns)..remove(flight.returns.last)
                  ]
                      .map(
                        (e) => StopDetails(
                          to: e.flyTo,
                          duration: e.duration,
                          city: e.cityTo
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(
              ch: children,
              depDate: depDate,
              arrDate: arrDate,
              selectedClassOfService: selectedClassOfService,
              routes: flight.routes,
              typeOfTripSelected: typeOfTripSelected,
              flight: flight,
              bookingToken: flight.bookingToken,
              retailInfo: flight.raw,
              type: type,
              ad: ad,
              stops: [
                ...List.from(flight.departures)
                  ..remove(flight.departures.last)
              ]
                  .map(
                    (e) => StopDetails(
                  to: e.flyTo,
                  duration: e.duration,
                  city: e.cityTo
                ),
              )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
