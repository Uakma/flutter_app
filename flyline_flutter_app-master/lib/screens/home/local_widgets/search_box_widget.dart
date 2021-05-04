import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/models/recent_flight_search.dart';
import 'package:motel/providers/search_provider.dart';
import 'package:motel/screens/flights_results/search_results_screen.dart';
import 'package:motel/screens/home/local_widgets/search_box_skeleton.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class RecentSearchBoxWidget extends StatefulWidget {
  const RecentSearchBoxWidget({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  _RecentSearchBoxWidgetState createState() => _RecentSearchBoxWidgetState();
}

class _RecentSearchBoxWidgetState extends State<RecentSearchBoxWidget> {
  @override
  Widget build(BuildContext context) {
    final currency =
        Provider.of<SettingsBloc>(context, listen: true).selectedCurrency;
      List<String> sortValues = [SortOptions.soonest];

    final _dateFormatter = DateFormat('${DateFormat.MONTH}, ${DateFormat.DAY}');
    return StreamBuilder<List<RecentFlightSearch>>(
      stream: flyLinebloc.recentFlightSearches,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (widget.index + 1 > snapshot.data.length ||
              snapshot.data.length == 0) return Container();
          final RecentFlightSearch data = snapshot.data[widget.index];
          return GestureDetector(
            onTap: () {
              try {
                flyLinebloc.loadingOverlay.show(context);
                flyLinebloc
                    .searchFlight(
                      data.placeFrom.type + ":" + data.placeFrom.code,
                      data.placeTo.type + ":" + data.placeTo.code,
                      data.departureDate,
                      data.departureDate,
                      data.destinationType,
                      data.returnDate,
                      data.returnDate,
                      data.adults,
                      data.infants,
                      data.children,
                      data.seatType,
                      "USD",
                      "20",
                      "20",
                    )
                    .then((_) => setState(() {
                          flyLinebloc.loadingOverlay.hide();
                        }));
              } catch (e) {
                setState(() {
                  flyLinebloc.loadingOverlay.hide();
                });
              }

              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (BuildContext context) => SearchSelector(
              //     flyingFrom: data.placeFrom.code,
              //     flyingTo: data.placeTo.code,
              //     departureDate: data.departureDate,
              //     arrivalDate: data.returnDate,
              //     isRoundTrip: data.isRoundTrip,
              //   ),
              // ));

              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return SearchResults(
                    type: SearchType.META,
                    flyingFrom: data.placeFrom.code,
                    flyingTo: data.placeTo.code,
                    depDate:
                      DateFormat('yyyy-MM-dd hh:mm:ss').format(data.departureDate),
                    arrDate: data.isRoundTrip
                      ? DateFormat('yyyy-MM-dd hh:mm:ss').format(data.returnDate)
                      : null,
                    isRoundTrip: data.isRoundTrip,
                    // flightsStream: Rx.combineLatest3<
                    //         List<FlightInformationObject>,
                    //         List<FlightInformationObject>,
                    //         List<FlightInformationObject>,
                    //         List<FlightInformationObject>>(
                    //           flyLinebloc.flightsMetaItems(
                    //             currency, sortValues, data.isRoundTrip),
                    //           flyLinebloc.flightsExclusiveItems(
                    //             currency, sortValues, data.isRoundTrip),
                    //           flyLinebloc.flightsFareItems(
                    //             currency, sortValues, data.isRoundTrip),
                    //           (a, b, c) => a + b + c,
                    //         ).asBroadcastStream()
                    );
                },
              ),);
              context.read<SearchProvider>().setFlightsStream(Rx.combineLatest3<
                            List<FlightInformationObject>,
                            List<FlightInformationObject>,
                            List<FlightInformationObject>,
                            List<FlightInformationObject>>(
                              flyLinebloc.flightsMetaItems(
                                currency, sortValues, data.isRoundTrip),
                              flyLinebloc.flightsExclusiveItems(
                                currency, sortValues, data.isRoundTrip),
                              flyLinebloc.flightsFareItems(
                                currency, sortValues, data.isRoundTrip),
                              (a, b, c) => a + b + c,
                            ).asBroadcastStream());
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 37,
                      width: 37,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: SvgImageWidget.asset(
                          "assets/svg/home/recent_search.svg",
                          height: 26,
                          width: 26,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                'Recent Flight Search',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 12,
                                  color: Color(0xFF44CF57),
                                  fontWeight: FontWeight.w600,
                                ),
                                softWrap: true,
                                maxLines: 1,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                '${data.placeFrom.code}  to ${data.placeTo.code}',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 18,
                                  color: Color(0xFF0E3178),
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                '${_dateFormatter.format(data.departureDate)}' +
                                    (data.isRoundTrip
                                        ? '  - ${_dateFormatter.format(data.returnDate)}   Round Trip'
                                        : ''),
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 12,
                                  color: Color.fromRGBO(142, 150, 159, 1),
                                  fontWeight: FontWeight.w500,
                                ),
                                softWrap: true,
                                maxLines: 5,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SvgImageWidget.asset(
                      "assets/svg/home/right.svg",
                      // color: Colors.amber,
                      height: 12,
                      width: 12,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SearchBoxSkeleton();
      },
    );
  }
}
