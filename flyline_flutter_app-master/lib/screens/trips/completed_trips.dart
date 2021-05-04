import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/booked_flight.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/screens/wallet/create_account.dart';
import 'package:motel/utils/date_utils.dart';
import 'package:motel/widgets/airline_logo.dart';
import 'package:motel/widgets/flight_card_detail_row.dart';
import 'package:motel/widgets/flight_card_header.dart';
import 'package:motel/widgets/no_data_page.dart';

class CompletedTrips extends StatelessWidget {
  final pastFlights = flyLinebloc.pastFlightSummary();

  @override
  Widget build(BuildContext context) {
    return isGustLogin  ?  NoDataCreateAccountPage(
      title: "Track your Trips",
      description: "Create your free FlyLine account to manage your upcoming trips",
      imageShow: "assets/svg/on_boarding/trips_image.svg",
    ) : FutureBuilder(
        future: pastFlights,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return StreamBuilder<List<BookedFlight>>(
                stream: flyLinebloc.pastFlights,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0 )
                    /*  return NoDataCreateAccountPage(
                          title: "Create your free FlyLine Account",
                          description: "To manage upcoming and previous trips create your free flyline account",
                      );*/
                     return NoDataPage(
                        title: "Oops, no completed trips",
                        description:
                            "Once you've completed an upcoming trip, it will display here. You'll be able to see a complete history of all your flights on FlyLine.",
                       imageShow: "assets/images/on_boarding_mocs/completed_trips.png",
                      );
                    final listOfFlights = snapshot.data;
                    return ListView.builder(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      scrollDirection: Axis.vertical,
                      itemCount: listOfFlights.length,
                      itemBuilder: (context, index) {
                        var flight = listOfFlights[index];

                        if (flight == null) return null;

                        List<Flight> departures = List();
                        List<String> departureStopOverCity = List();
                        List<Flight> returns = List();
                        List<String> returnStopOverCity = List();
                        // one way
                        if (!(flight.data.roundtrip ?? false)) {
                          for (Flight route in flight.flights) {
                            departures.add(route);
                            if (route.cityTo != flight.data.cityTo) {
                              departureStopOverCity.add(route.cityTo);
                            } else {
                              break;
                            }
                          } // round trip
                        } else {
                          for (Flight route in flight.flights) {
                            departures.add(route);
                            if (route.cityTo != flight.data.cityTo) {
                              departureStopOverCity.add(route.cityTo);
                            } else {
                              break;
                            }
                          }

                          for (Flight route in flight.flights.reversed) {
                            returns.add(route);

                            if (route.cityFrom != flight.data.cityTo) {
                              returnStopOverCity.add(route.cityTo);
                            } else {
                              break;
                            }
                          }
                        }

                        return Container(
                          margin: EdgeInsets.only(
                              left: 9, right: 9, top: 14, bottom: 0),
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FlightCardHeader(
                                type: SearchType.EXCLUSIVE,
                                price: flight.data.price,
                                logos: departures.toSet().toList().map(
                                  (e) {
                                    return AirlineLogo(
                                        airline: e.data.airline.code);
                                  },
                                ).toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 11.0),
                                child: FlightCardDetailRow(
                                  from: departures[0].data.flyFrom,
                                  to: departures[departures.length - 1]
                                      .data
                                      .flyTo,
                                  duration: DateUtils.secs2hm(
                                    Duration(
                                            seconds: flight.data.duration.total)
                                        .inSeconds,
                                  ),
                                  localDeparture:
                                      departures[0].data.localDeparture,
                                  localArrival:
                                      departures[departures.length - 1]
                                          .data
                                          .localArrival,
                                  stops: departures
                                      .map(
                                        (e) => StopDetails(
                                          to: e.data.flyTo,
                                          duration: e.data.localDeparture
                                              .difference(e.data.localArrival),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              if (flight.data.roundtrip ?? false)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 11.0,
                                  ),
                                  child: FlightCardDetailRow(
                                    from: returns[returns.length - 1]
                                        .data
                                        .flyFrom,
                                    to: departures[0].data.flyFrom,
                                    duration: DateUtils.secs2hm(
                                      Duration(
                                              seconds: flight
                                                  .data.duration.durationReturn)
                                          .inSeconds,
                                    ),
                                    localDeparture: returns[returns.length - 1]
                                        .data
                                        .localDeparture,
                                    localArrival: returns[0].data.localArrival,
                                    stops: returns
                                        .map(
                                          (e) => StopDetails(
                                            to: e.data.flyTo,
                                            duration: e.data.localDeparture
                                                .difference(
                                                    e.data.localArrival),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return Center(
                    child: CupertinoTheme(
                      data: CupertinoTheme.of(context).copyWith(
                          primaryColor: Colors.white,
                          brightness: Brightness.dark),
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
                  );
                });
          return Center(
            child: CupertinoTheme(
              data: CupertinoTheme.of(context).copyWith(
                primaryColor: Colors.white,
                brightness: Brightness.light,
              ),
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            ),
          );
        });
  }
}
