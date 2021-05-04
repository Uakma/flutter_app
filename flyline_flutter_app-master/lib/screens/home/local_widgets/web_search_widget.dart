import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/helper/helper.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/providers/search_provider.dart';
import 'package:motel/screens/trip_details/trip_details.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/widgets/airline_logo.dart';
import 'package:motel/widgets/flight_card_airline_logos.dart';
import 'package:motel/widgets/flight_card_detail_row.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

class WebSearchWidget extends StatefulWidget {

  WebSearchWidget({
    Key key,
    this.depDate,
    this.retDate,
    this.room,
    this.children,
    this.adults,
    this.selectedClassOfService,
    this.typeOfTripSelected
  }) : super(key: key);

  final String depDate;
  final String retDate;
  final int room;
  final int children;
  final int adults;
  final String selectedClassOfService;
  final int typeOfTripSelected;

  @override
  State<StatefulWidget> createState() {
    return _WebSearchWidgetState();
  }
}

class _WebSearchWidgetState extends State<WebSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (_, SearchProvider provider, Widget child) {
        if (provider.isSearching) 
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                height: provider.isRoundTrip? 141 : 98,
                child: WebSearchSkeleton(isRoundTrip: provider.isRoundTrip),
              );
            },
          );
        return StreamBuilder<List<FlightInformationObject>>(
          stream: provider.flightsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    if (index != snapshot.data.length) {
                      var flight = snapshot.data[index];
                      if (flight == null) {
                        return null;
                      }
                      return Container(
                        height: provider.isRoundTrip ? 141 : 98,
                        child: WebSearchResultItem(
                          flight: flight,
                          isRoundTrip: provider.isRoundTrip,
                          depDate: widget.depDate,
                          retDate: widget.retDate,
                          children: widget.children,
                          adults: widget.adults,
                          room: widget.room,
                          selectedClassOfService: widget.selectedClassOfService,
                          typeOfTripSelected: widget.typeOfTripSelected,
                        ),
                      );
                    }
                  },
                );
              }
              return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    height: provider.isRoundTrip? 141 : 98,
                    child: WebSearchSkeleton(isRoundTrip: provider.isRoundTrip,),
                  );
                },
              );
            }
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  height: provider.isRoundTrip? 141 : 98,
                  child: WebSearchSkeleton(isRoundTrip: provider.isRoundTrip),
                );
              },
            );
          },
        );
      },
    );
  }
}

class WebSearchSkeleton extends StatelessWidget {

  WebSearchSkeleton({this.isRoundTrip});

  final bool isRoundTrip;

  @override
  Widget build(BuildContext context) {
    return buildWebResultSkeleton();
  }

  Widget buildWebResultSkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.w),
      padding: EdgeInsets.symmetric(vertical: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(
          color: Color.fromRGBO(237, 238, 246, 1),
          width: 1
        ),
        color: Colors.white
      ),
      child: Row(
        children: [
          SizedBox(
            width: 25.w,
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: buildShimmer(),
                  ),
                ),
                isRoundTrip 
                  ? Container(
                      height: 1,
                      width: 45.w,
                      color: Color.fromRGBO(235, 235, 235, 1),
                    )
                  : Container(),
                isRoundTrip 
                  ? Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: buildShimmer(),
                      ),
                    )
                  : Container(),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: buildDetailSkeleton(),
          ),
          Expanded(
            flex: 5,
            child: buildDetailSkeleton(),
          ),
          Expanded(
            flex: 6,
            child: buildDetailSkeleton(),
          ),
          Container(
            width: 1,
            color: Color.fromRGBO(237, 238, 246, 1),
          ),
          Container(
            width: 180.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 72.w,
                    height: isRoundTrip ? 28.w : 26.w,
                    child: buildShimmer(),
                  ),
                isRoundTrip ? Container() : Container(height: 2),
                Container(
                  width: 111.w,
                  height: isRoundTrip ? 28.w : 26.w,
                  margin: EdgeInsets.symmetric(vertical: isRoundTrip ? 8 : 0),
                  child: buildShimmer(),
                ),
                Container(
                    width: 72.w,
                    height: isRoundTrip ? 28.w : 0,
                    child: Container(),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildShimmer() {
    return SkeletonAnimation(  
      child: Container(  
        decoration: BoxDecoration(  
          borderRadius: BorderRadius.circular(10.0),  
          color: Colors.grey[300]
        ),  
      ),  
    );
  }

  Widget buildDetailSkeleton() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 2, top: 2, left: 10, right: 10),
                  child: buildShimmer(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 2, top: 2, left: 10, right: 30),
                  child: buildShimmer(),
                ),
              )
            ],
          ),
        ),
        isRoundTrip 
          ? Container(
              height: 8.w,
            )
          : Container(),
        isRoundTrip 
          ? Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2, top: 2, left: 10, right: 10),
                      child: buildShimmer(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2, top: 2, left: 10, right: 30),
                      child: buildShimmer(),
                    ),
                  )
                ],
              ),
            )
          : Container()
      ],
    );
  }
}

class WebSearchResultItem extends StatelessWidget {

  WebSearchResultItem({
    this.flight,
    this.isRoundTrip,
    this.depDate,
    this.retDate,
    this.children,
    this.adults,
    this.room,
    this.selectedClassOfService,
    this.typeOfTripSelected
  });

  final FlightInformationObject flight;
  final bool isRoundTrip;
  final String depDate;
  final String retDate;
  final int room;
  final int adults;
  final int children;
  final String selectedClassOfService;
  final int typeOfTripSelected;

  SearchType get type {
    return flight.kind == null
      ? SearchType.EXCLUSIVE
      : (flight.kind == "tripadvisor" || 
        flight.kind == "skyscanner" ||
        flight.kind == "kayak")
          ? SearchType.META
          : SearchType.FARE;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => TripDetailsScreen(
              ch: children,
              depDate: depDate,
              arrDate: retDate,
              selectedClassOfService: selectedClassOfService,
              routes: flight.routes,
              typeOfTripSelected: typeOfTripSelected,
              flight: flight,
              bookingToken: flight.bookingToken,
              retailInfo: flight.raw,
              type: type,
              ad: adults,
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
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.w),
        padding: EdgeInsets.symmetric(vertical: isRoundTrip ? 24.w : 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(
            color: Color.fromRGBO(237, 238, 246, 1),
            width: 1
          ),
          color: Colors.white
        ),
        child: Row(
          children: [
            SizedBox(
              width: 25.w,
            ),
            Expanded(
              flex: 4,
              child: buildIconsWidget(),
            ),
            Expanded(
              flex: 7,
              child: buildTimeWidget(),
            ),
            Expanded(
              flex: 5,
              child: buildDurationWidget(),
            ),
            Expanded(
              flex: 6,
              child: buildStopsWidget(),
            ),
            Container(
              width: 1,
              color: Color.fromRGBO(237, 238, 246, 1),
            ),
            Container(
              width: 180.w,
              padding: EdgeInsets.symmetric(vertical: isRoundTrip ? 12 : 0),
              child: WebSearchPriceWidget(
                price: flight.price,
                type: type,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildIconsWidget() {
    final List<dynamic> departureAirlines = flight.departures.map((e) => e.airline).toList();
    final List<String> returnAirlines = flight.returns.map((e) => e.airline).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: FlightCardAirlineLogos(
              logos: departureAirlines.map((e) => AirlineLogo(airline: e)).toList(),
            )
          )
        ),
        isRoundTrip 
          ? Container(
              width: 45.w,
              color: Color.fromRGBO(235, 235, 235, 1),
              height: 1,
            )
          : Container(),
        isRoundTrip
          ? Expanded(
              flex: 1,
              child: Container(
                child: FlightCardAirlineLogos(
                  logos: returnAirlines.map((e) => AirlineLogo(airline: e)).toList(),
                )
              )
            )
          : Container(),
      ],
    );
  }

  Widget buildTimeWidget() {
    print('flight.departures: ${flight.departures}');
    print('flight.returns: ${flight.returns}');
    final List<dynamic> departureAirlines = flight.departures.map((e) => e.airline).toList();
    final List<String> returnAirlines = flight.returns.map((e) => e.airline).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRoundTrip ? Container() : Container(height: 16),
        Expanded(
          flex: 1,
          child: Container(
            child: WebSearchTimeWidget(
              departureDate: flight.departures.first.localDeparture,
              arrivalDate: flight.departures.last.localArrival,
              airlines: departureAirlines,
            )
          ),
        ),
        isRoundTrip ? Container(height: 10.w,) : Container(),
        isRoundTrip 
          ? Expanded(
              flex: 1,
              child: Container(
                child: WebSearchTimeWidget(
                  departureDate: flight.returns.first.localDeparture,
                  arrivalDate: flight.returns.last.localArrival,
                  airlines: returnAirlines,
                )
              ),
            )
          : Container(),
      ],
    );
  }

  Widget buildDurationWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRoundTrip ? Container() : Container(height: 16),
        Expanded(
          flex: 1,
          child: Container(
            child: WebSearchDurationWidget(
              duration: Duration(seconds: flight.durationDepartureInSeconds),
              from: flight.flyFrom ?? '',
              to: flight.flyTo ?? ''
            )
          )
        ),
        isRoundTrip ? Container(height: 10.w,) : Container(),
        isRoundTrip 
          ? Expanded(
              flex: 1,
              child: Container(
                child: WebSearchDurationWidget(
                  duration: Duration(seconds: flight.durationReturnInSeconds),
                  from: flight.flyTo ?? '',
                  to: flight.flyFrom ?? ''
                )
              )
            )
          : Container()
      ],
    );
  }

  Widget buildStopsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRoundTrip ? Container() : Container(height: 16),
        Expanded(
          flex: 1,
          child: Container(
            child: WebSearchStopoverWidget(
              stops: [
                    ...List.from(flight.departures)..remove(flight.departures.last)
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
        ),
        isRoundTrip ? Container(height: 10.w,) : Container(),
        isRoundTrip
          ? Expanded(
              flex: 1,
              child: Container(
                child: WebSearchStopoverWidget(
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
            )
          : Container()
      ],
    );
  }
}

class WebSearchPriceWidget extends StatelessWidget {

  WebSearchPriceWidget({this.price, this.type});

  final num price;
  final SearchType type;

  Color get getTypeColor => type == SearchType.FARE
      ? Color.fromRGBO(14, 49, 120, 1)
      : type == SearchType.EXCLUSIVE
          ? Color.fromRGBO(0, 174, 239, 1)
          : Color.fromRGBO(68, 207, 87, 1);

  String get getTypeName => type == SearchType.FARE
      ? "FlyLine Fare"
      : type == SearchType.EXCLUSIVE ? "FlyLine Exclusive" : "Meta Fare";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Text(
              "${Provider.of<SettingsBloc>(context).selectedCurrency.sign} " + price.toStringAsFixed(2),
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 26.w,
                color: Color.fromRGBO(68, 207, 87, 1),
                fontWeight: FontWeight.bold
              ),
            )
          )
        ),
        Container(
          width: 111.w,
          height: 28.w,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: getTypeColor.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(40.w))
            ),
            child: Text(
              getTypeName,
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: getTypeColor,
                fontSize: 10.w,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Show Details',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 8.w,
                  color: Color.fromRGBO(51, 51, 51, 1),
                  fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class WebSearchTimeWidget extends StatelessWidget {

  WebSearchTimeWidget({
    this.departureDate,
    this.arrivalDate,
    this.airlines
  });

  final DateTime departureDate;
  final DateTime arrivalDate;
  final List<String> airlines;

  final DateFormat formatTime = DateFormat("hh:mma");

  @override
  Widget build(BuildContext context) {
    List<String> airlineNameList = <String>[];
    for (String airline in airlines) {
      if (airlineNames[airline] != null) {
        airlineNameList.add(airlineNames[airline]);
      } else {
        airlineNameList.add(airline);
      }
    }
    return WebSearchItemDetail(
      mainText: formatTime.format(departureDate) + ' - ' + formatTime.format(arrivalDate),
      subText: 'Airline(s): ' + airlineNameList.reduce((value, element) => 
        value + ', ' + element),
    );
  }
}

class WebSearchDurationWidget extends StatelessWidget {

  WebSearchDurationWidget({this.duration, this.from, this.to});

  final Duration duration;
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return WebSearchItemDetail(
      mainText: Helper.duration(duration).toString(),
      subText: from + ' - ' + to,
    );
  }
}

class WebSearchStopoverWidget extends StatelessWidget {

  WebSearchStopoverWidget({this.stops});

  final List<StopDetails> stops;

  String get stopsLabel => (stops.length > 0
      ? (stops.length > 1
          ? "${stops.length} Stopovers"
          : "${stops.length} Stopover ")
      : "Non-Stop");

  String get stopsDetail {
    if (stops.length == 0) {
      return 'Direct';
    } else {
      int totalStopTime = 0;
      List<String> stopCodes = <String>[];
      for (StopDetails stop in stops) {
        totalStopTime += stop.duration.inMinutes;
        stopCodes.add(stop.to);
      }
      String codes = stopCodes.reduce((value, element) => value + ' ' + element);
      return '${Helper.duration(Duration(minutes: totalStopTime)).toString()} $codes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebSearchItemDetail(
      mainText: stopsLabel,
      subText: stopsDetail,
    );
  }
}

class WebSearchItemDetail extends StatelessWidget {

  WebSearchItemDetail({this.mainText, this.subText});

  final String mainText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 4.w,
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text(
              mainText,
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 16.w,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Container(
          height: 4.w,
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text(
              subText,
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 10.w,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(187, 196, 220, 1)
              ),
              textAlign: TextAlign.left,
            )
          )
        )
      ],
    );
  }
}