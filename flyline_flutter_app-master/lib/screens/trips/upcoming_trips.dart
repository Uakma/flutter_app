import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/booked_flight.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/screens/trips/local_widgets/upcoming_trip_card.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/screens/wallet/create_account.dart';
import 'package:motel/widgets/list_loading.dart';
import 'package:motel/widgets/no_data_page.dart';

class UpcomingTrips extends StatelessWidget {
  final upcomingFlights = flyLinebloc.upcomingFlightSummary();
  @override
  Widget build(BuildContext context) {
    return isGustLogin  ?  NoDataCreateAccountPage(
      title: "Manage your travel",
      description: "Create your free FlyLine account to manage your upcoming and completed trips.",
        imageShow: "assets/images/on_boarding_mocs/manage_trip_guest_image.png"
    ) : FutureBuilder(
      future: upcomingFlights,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done || isGustLogin == true)
          return StreamBuilder<List<BookedFlight>>(
              stream: flyLinebloc.upcomingFlights,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0)
                    return NoDataPage(
                      title: "Oops, no upcoming trips",
                      description: "Once you've booked a trip, it will display here. You can change, cancel, or check-in to your flight all from the FlyLine.",
                      imageShow: "assets/images/on_boarding_mocs/upcoming_trips.png",
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

                      if (!(flight.data.roundtrip ?? false))
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: UpcomingTripCard(flight: flight),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Divider(),
                            ),
                          ],
                        );
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: UpcomingTripCard(flight: flight),
                                ),
                                UpcomingTripCard(
                                  flight: flight,
                                  isReturn: true,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Divider(
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return ListLoading();
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
      },
    );
  }
}
