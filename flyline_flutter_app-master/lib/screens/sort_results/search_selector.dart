import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/providers/search_provider.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/auto_pilot/local_widgets/time_filters.dart';
import 'package:motel/widgets/app_bar_close_icon.dart';
import 'package:motel/screens/sort_results/local_widgets/category_tile_widget.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:provider/provider.dart';

import 'package:rxdart/rxdart.dart';

class SearchSelector extends StatefulWidget {
  const SearchSelector({
    Key key,
    @required this.flyingFrom,
    @required this.flyingTo,
    @required this.departureDate,
    // this.arrivalDate,
    @required this.isRoundTrip,
    // this.onUpdateFilter
  }) : super(key: key);

  final String flyingFrom;
  final String flyingTo;
  final DateTime departureDate;
  // final DateTime arrivalDate;
  final bool isRoundTrip;
  // final Function onUpdateFilter;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SearchSelector> {
  // final dateFormatter = DateFormat("MMM dd");

  bool _setPriceAlerts = false;
  List<String> _sortValues = [];
  bool showMetaCard = true;
  bool showFareCard = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        Provider.of<SettingsBloc>(context, listen: true).selectedCurrency;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        left: 8,
                        right: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppBarCloseIcon(),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text(
                              'Sort & Filter Flights',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(14, 49, 120, 1)
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 174, 239, 0.1),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Turn on price drop notifications",
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color.fromRGBO(0, 174, 239, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )),
                      Transform.scale(
                        scale: .6,
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: CupertinoSwitch(
                            trackColor: Colors.red,
                            activeColor: Color(0xff40CE53),
                            value: _setPriceAlerts,
                            onChanged: (bool value) {
                              setState(() {
                                _setPriceAlerts = value;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _setPriceAlerts = !_setPriceAlerts;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Filter Flights',
                          style: TextStyle(
                            color: Color.fromRGBO(14, 49, 120, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Filter the results by tapping on the tags below. After \nselecting your tags, sort by your preferred fare type.",
                          style: TextStyle(
                            fontFamily: "Gilroy",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(142, 150, 159, 1),
                            height: 1.6,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Wrap(
                          runSpacing: -10,
                          spacing: 5,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () {
                                if (_sortValues.contains(SortOptions.soonest)) {
                                  setState(() {
                                    _sortValues.remove(SortOptions.soonest);
                                  });
                                } else {
                                  setState(() {
                                    if (_sortValues
                                        .contains(SortOptions.cheapest)) {
                                      _sortValues.remove(SortOptions.cheapest);
                                    }

                                    if (_sortValues
                                        .contains(SortOptions.quickest)) {
                                      _sortValues.remove(SortOptions.quickest);
                                    }

                                    _sortValues.add(SortOptions.soonest);
                                  });
                                }

                                // showModalBottomSheet(
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.vertical(
                                //           top: Radius.circular(20.0)),
                                //     ),

                                //     context: context,
                                //     builder: (context) => TimeFilters(
                                //       cityFrom: widget.flyingFrom,
                                //       cityTo: widget.flyingTo,
                                //       isRoundTrip: widget.isRoundTrip,
                                //       sortValues: _sortValues,
                                //       onConfrim:
                                //           (List<String> sortOptions) {
                                //         setState(() {
                                //           _sortValues = sortOptions;
                                //         });
                                //         _sortValues.forEach((element) {
                                //           print(element + "\n");
                                //         });
                                //       },
                                //     ));
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              constraints: BoxConstraints(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              child: Text("+ Soonest",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: _sortValues
                                            .contains(SortOptions.soonest)
                                        ? Colors.white
                                        : Color.fromRGBO(0, 174, 239, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  )),
                              fillColor: Color.fromRGBO(
                                  0,
                                  174,
                                  239,
                                  _sortValues.contains(SortOptions.soonest)
                                      ? 1
                                      : .1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (_sortValues
                                    .contains(SortOptions.quickest)) {
                                  setState(() {
                                    _sortValues.remove(SortOptions.quickest);
                                  });
                                } else {
                                  setState(() {
                                    if (_sortValues
                                        .contains(SortOptions.cheapest)) {
                                      _sortValues.remove(SortOptions.cheapest);
                                    }

                                    if (_sortValues
                                        .contains(SortOptions.soonest)) {
                                      _sortValues.remove(SortOptions.soonest);
                                    }

                                    _sortValues.add(SortOptions.quickest);
                                  });
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              constraints: BoxConstraints(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              child: Text("+ Quickest (Duration)",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: _sortValues
                                            .contains(SortOptions.quickest)
                                        ? Colors.white
                                        : Color.fromRGBO(0, 174, 239, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  )),
                              fillColor: Color.fromRGBO(
                                  0,
                                  174,
                                  239,
                                  _sortValues.contains(SortOptions.quickest)
                                      ? 1
                                      : .1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                //  if (_sortValues
                                //     .contains(SortOptions.soonest)) {
                                //   setState(() {
                                //     _sortValues.remove(SortOptions.soonest);
                                //   });
                                // } else {
                                //   setState(() {
                                //     if (_sortValues
                                //         .contains(SortOptions.cheapest)) {
                                //       _sortValues.remove(SortOptions.cheapest);
                                //     }

                                //     if (_sortValues
                                //         .contains(SortOptions.quickest)) {
                                //       _sortValues.remove(SortOptions.quickest);
                                //     }

                                //     _sortValues.add(SortOptions.soonest);
                                //   });
                                // }

                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.0)),
                                    ),
                                    context: context,
                                    builder: (context) => TimeFilters(
                                          cityFrom: widget.flyingFrom,
                                          cityTo: widget.flyingTo,
                                          isRoundTrip: widget.isRoundTrip,
                                          sortValues: _sortValues,
                                          onConfrim:
                                              (List<String> sortOptions) {
                                            setState(() {
                                              _sortValues = sortOptions;
                                            });
                                            _sortValues.forEach((element) {
                                              print(element + "\n");
                                            });
                                          },
                                        ));
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              constraints: BoxConstraints(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              child: Text("+ Take-off / Landing Time(s)",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: _sortValues
                                            .contains(SortOptions.soonest)
                                        ? Colors.white
                                        : Color.fromRGBO(0, 174, 239, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  )),
                              fillColor: Color.fromRGBO(
                                  0,
                                  174,
                                  239,
                                  _sortValues.contains(SortOptions.soonest)
                                      ? 1
                                      : .1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (_sortValues
                                    .contains(SortOptions.directFlights)) {
                                  setState(() {
                                    _sortValues
                                        .remove(SortOptions.directFlights);
                                  });
                                } else {
                                  setState(() {
                                    _sortValues.add(SortOptions.directFlights);
                                  });
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              constraints: BoxConstraints(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              child: Text("+ Direct Flights",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: _sortValues
                                            .contains(SortOptions.directFlights)
                                        ? Colors.white
                                        : Color.fromRGBO(0, 174, 239, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  )),
                              fillColor: Color.fromRGBO(
                                  0,
                                  174,
                                  239,
                                  _sortValues
                                          .contains(SortOptions.directFlights)
                                      ? 1
                                      : .1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (_sortValues
                                    .contains(SortOptions.singlecarier)) {
                                  setState(() {
                                    _sortValues
                                        .remove(SortOptions.singlecarier);
                                  });
                                } else {
                                  setState(() {
                                    _sortValues.add(SortOptions.singlecarier);
                                  });
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              constraints: BoxConstraints(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              child: Text("+ Single Carrier Flight",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: _sortValues
                                            .contains(SortOptions.singlecarier)
                                        ? Colors.white
                                        : Color.fromRGBO(0, 174, 239, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  )),
                              fillColor: Color.fromRGBO(
                                  0,
                                  174,
                                  239,
                                  _sortValues.contains(SortOptions.singlecarier)
                                      ? 1
                                      : .1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (_sortValues
                                    .contains(SortOptions.legacyFlagCarriers)) {
                                  setState(() {
                                    _sortValues
                                        .remove(SortOptions.legacyFlagCarriers);
                                  });
                                } else {
                                  setState(() {
                                    if (_sortValues.contains(
                                        SortOptions.lowCostCarriers)) {
                                      _sortValues
                                          .remove(SortOptions.lowCostCarriers);
                                    }

                                    if (_sortValues.contains(
                                        SortOptions.ultraLowCostCarriers)) {
                                      _sortValues.remove(
                                          SortOptions.ultraLowCostCarriers);
                                    }
                                    _sortValues
                                        .add(SortOptions.legacyFlagCarriers);
                                  });
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              constraints: BoxConstraints(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              child: Text("+ Legacy Carriers / Flag Carriers",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: _sortValues.contains(
                                            SortOptions.legacyFlagCarriers)
                                        ? Colors.white
                                        : Color.fromRGBO(0, 174, 239, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  )),
                              fillColor: Color.fromRGBO(
                                  0,
                                  174,
                                  239,
                                  _sortValues.contains(
                                          SortOptions.legacyFlagCarriers)
                                      ? 1
                                      : .1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (_sortValues
                                    .contains(SortOptions.lowCostCarriers)) {
                                  setState(() {
                                    _sortValues
                                        .remove(SortOptions.lowCostCarriers);
                                  });
                                } else {
                                  setState(() {
                                    if (_sortValues.contains(
                                        SortOptions.legacyFlagCarriers)) {
                                      _sortValues.remove(
                                          SortOptions.legacyFlagCarriers);
                                    }

                                    if (_sortValues.contains(
                                        SortOptions.ultraLowCostCarriers)) {
                                      _sortValues.remove(
                                          SortOptions.ultraLowCostCarriers);
                                    }

                                    _sortValues
                                        .add(SortOptions.lowCostCarriers);
                                  });
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              constraints: BoxConstraints(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              child: Text("+ Low Cost Carriers",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: _sortValues.contains(
                                            SortOptions.lowCostCarriers)
                                        ? Colors.white
                                        : Color.fromRGBO(0, 174, 239, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  )),
                              fillColor: Color.fromRGBO(
                                  0,
                                  174,
                                  239,
                                  _sortValues
                                          .contains(SortOptions.lowCostCarriers)
                                      ? 1
                                      : .1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (_sortValues.contains(
                                    SortOptions.ultraLowCostCarriers)) {
                                  setState(() {
                                    _sortValues.remove(
                                        SortOptions.ultraLowCostCarriers);
                                  });
                                } else {
                                  setState(() {
                                    if (_sortValues.contains(
                                        SortOptions.lowCostCarriers)) {
                                      _sortValues
                                          .remove(SortOptions.lowCostCarriers);
                                    }

                                    if (_sortValues.contains(
                                        SortOptions.legacyFlagCarriers)) {
                                      _sortValues.remove(
                                          SortOptions.legacyFlagCarriers);
                                    }

                                    _sortValues
                                        .add(SortOptions.ultraLowCostCarriers);
                                  });
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              constraints: BoxConstraints(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              child: Text("+ Ultra Low Cost Carriers",
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: _sortValues.contains(
                                            SortOptions.ultraLowCostCarriers)
                                        ? Colors.white
                                        : Color.fromRGBO(0, 174, 239, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  )),
                              fillColor: Color.fromRGBO(
                                  0,
                                  174,
                                  239,
                                  _sortValues.contains(
                                          SortOptions.ultraLowCostCarriers)
                                      ? 1
                                      : .1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  // child: Divider(height: 30),
                  child: Container()
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
                      color: Colors.white,
                    ),
                    child: ListView(
                    physics: ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 90),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                        child: Text(
                          'Sort by Fare Type',
                          style: TextStyle(
                            color: Color.fromRGBO(14, 49, 120, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Divider(height: 1, ),
                      ),
                      StreamBuilder<List<FlightInformationObject>>(
                          stream: flyLinebloc.flightsFareItems(
                              currency, _sortValues, widget.isRoundTrip),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data.isNotEmpty) {
                              return CategoryTileWidget(
                                title: 'FlyLine Fares',
                                description:
                                    'FlyLine Fares(Direct Bookings) are sourced directly from more than 250 airlines.',
                                minimumPrice: StreamBuilder<
                                    List<FlightInformationObject>>(
                                  stream: flyLinebloc.flightsFareItems(currency,
                                      _sortValues, widget.isRoundTrip),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data.isNotEmpty) {
                                      double _minVal = 0;
                                      _minVal = snapshot.data
                                          .reduce((value, element) =>
                                              value.price < element.price
                                                  ? value
                                                  : element)
                                          .price;

                                      return Text(
                                        "${currency.sign} " +
                                            _minVal.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontFamily: "Gilroy",
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                        ),
                                      );
                                    }

                                    return Text(
                                      "",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Color.fromRGBO(0, 174, 239, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                    );
                                  },
                                ),
                                maximumPrice: StreamBuilder<
                                    List<FlightInformationObject>>(
                                  stream: flyLinebloc.flightsFareItems(currency,
                                      _sortValues, widget.isRoundTrip),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data.isNotEmpty) {
                                      double _minVal = 0;
                                      _minVal = snapshot.data
                                          .reduce((value, element) =>
                                              value.price > element.price
                                                  ? value
                                                  : element)
                                          .price;
                                      return Text(
                                        " - ${currency.sign} " +
                                            _minVal.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontFamily: "Gilroy",
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                        ),
                                      );
                                    }
                                    return Text(
                                      "",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Color.fromRGBO(0, 174, 239, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                    );
                                  },
                                ),
                                departureDate: widget.departureDate,
                                color: Color.fromRGBO(14, 49, 120, 1),
                                onSelectAction: () {
                                  // widget.onUpdateFilter(
                                  //   flyLinebloc.flightsFareItems(
                                  //     currency,
                                  //     _sortValues,
                                  //     widget.isRoundTrip),
                                  // );
                                  context.read<SearchProvider>().setFlightsStream(flyLinebloc.flightsFareItems(
                                      currency,
                                      _sortValues,
                                      widget.isRoundTrip));
                                  Navigator.of(context).pop();
                                },
                                // routeToPush: SearchResults(
                                //   flyingFrom: widget.flyingFrom,
                                //   flyingTo: widget.flyingTo,
                                //   type: SearchType.FARE,
                                //   depDate: dateFormatter
                                //       .format(widget.departureDate),
                                //   arrDate: widget.isRoundTrip
                                //       ? dateFormatter.format(widget.arrivalDate)
                                //       : null,
                                //   isRoundTrip: widget.isRoundTrip,
                                //   // flightsStream: flyLinebloc.flightsFareItems(
                                //   //     currency,
                                //   //     _sortValues,
                                //   //     widget.isRoundTrip),
                                // ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Divider(height: 1, ),
                      ),
                      CategoryTileWidget(
                        title: 'FlyLine Exclusives',
                        description:
                            'Our exclusive AutoLink fares are discounted up to 60% by combining one-way tickets.',
                        minimumPrice:
                            StreamBuilder<List<FlightInformationObject>>(
                          stream: flyLinebloc.flightsExclusiveItems(
                              currency, _sortValues, widget.isRoundTrip),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data.isNotEmpty) {
                              double _minVal = 0;
                              _minVal = snapshot.data
                                  .reduce((value, element) =>
                                      value.price < element.price
                                          ? value
                                          : element)
                                  .price;
                              return Text(
                                "${currency.sign} " +
                                    _minVal.toStringAsFixed(2),
                                style: TextStyle(
                                  fontFamily: "Gilroy",
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              );
                            }
                            return Text(
                              "",
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Color.fromRGBO(0, 174, 239, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            );
                          },
                        ),
                        maximumPrice:
                            StreamBuilder<List<FlightInformationObject>>(
                          stream: flyLinebloc.flightsExclusiveItems(
                              currency, _sortValues, widget.isRoundTrip),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data.isNotEmpty) {
                              double _minVal = 0;
                              _minVal = snapshot.data
                                  .reduce((value, element) =>
                                      value.price > element.price
                                          ? value
                                          : element)
                                  .price;
                              return Text(
                                " - ${currency.sign} " +
                                    _minVal.toStringAsFixed(2),
                                style: TextStyle(
                                  fontFamily: "Gilroy",
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              );
                            }
                            return Text(
                              "",
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Color.fromRGBO(0, 174, 239, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            );
                          },
                        ),
                        departureDate: widget.departureDate,
                        color: Color.fromRGBO(14, 49, 120, 1),
                        onSelectAction: () {
                                  // widget.onUpdateFilter(
                                  //   flyLinebloc.flightsExclusiveItems(
                                  //     currency, _sortValues, widget.isRoundTrip
                                  //   )
                                  // );
                                  context.read<SearchProvider>().setFlightsStream(flyLinebloc.flightsExclusiveItems(
                                      currency, _sortValues, widget.isRoundTrip
                                    ));
                                  Navigator.of(context).pop();
                                },
                        // routeToPush: SearchResults(
                        //   flyingFrom: widget.flyingFrom,
                        //   flyingTo: widget.flyingTo,
                        //   type: SearchType.EXCLUSIVE,
                        //   depDate: dateFormatter.format(widget.departureDate),
                        //   arrDate: widget.isRoundTrip
                        //       ? dateFormatter.format(widget.arrivalDate)
                        //       : null,
                        //   isRoundTrip: widget.isRoundTrip,
                        //   // flightsStream: flyLinebloc.flightsExclusiveItems(
                        //   //     currency, _sortValues, widget.isRoundTrip),
                        // ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Divider(height: 1, ),
                      ),
                      StreamBuilder<List<FlightInformationObject>>(
                          stream: flyLinebloc.flightsMetaItems(
                              currency, _sortValues, widget.isRoundTrip),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data.isNotEmpty) {
                              return CategoryTileWidget(
                                title: 'Meta Fares',
                                description:
                                    'Meta Fares include results from metasearch services like Kayak and TripAdvisor.',
                                minimumPrice: StreamBuilder<
                                        List<FlightInformationObject>>(
                                    stream: flyLinebloc.flightsMetaItems(
                                        currency,
                                        _sortValues,
                                        widget.isRoundTrip),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null &&
                                          snapshot.data.isNotEmpty) {
                                        double _minVal = 0;
                                        _minVal = snapshot.data
                                            .reduce((value, element) =>
                                                value.price < element.price
                                                    ? value
                                                    : element)
                                            .price;
                                        return Text(
                                          "${currency.sign} " +
                                              _minVal.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontFamily: "Gilroy",
                                            color:
                                                Color.fromRGBO(0, 174, 239, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            height: 1.5,
                                          ),
                                        );
                                      }
                                      return Text(
                                        "",
                                        style: TextStyle(
                                          fontFamily: "Gilroy",
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                        ),
                                      );
                                    }),
                                maximumPrice: StreamBuilder<
                                    List<FlightInformationObject>>(
                                  stream: flyLinebloc.flightsMetaItems(currency,
                                      _sortValues, widget.isRoundTrip),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data.isNotEmpty) {
                                      double _minVal = 0;
                                      _minVal = snapshot.data
                                          .reduce((value, element) =>
                                              value.price > element.price
                                                  ? value
                                                  : element)
                                          .price;
                                      return Text(
                                        " - ${currency.sign} " +
                                            _minVal.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontFamily: "Gilroy",
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                        ),
                                      );
                                    }
                                    return Text(
                                      "",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Color.fromRGBO(0, 174, 239, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                    );
                                  },
                                ),
                                departureDate: widget.departureDate,
                                color: Color.fromRGBO(14, 49, 120, 1),
                                onSelectAction: () {
                                  // widget.onUpdateFilter(
                                  //   flyLinebloc.flightsMetaItems(
                                  //     currency,
                                  //     _sortValues,
                                  //     widget.isRoundTrip
                                  //   )
                                  // );
                                  context.read<SearchProvider>().setFlightsStream(flyLinebloc.flightsMetaItems(
                                      currency,
                                      _sortValues,
                                      widget.isRoundTrip
                                    ));
                                  Navigator.of(context).pop();
                                },
                                // routeToPush: SearchResults(
                                //   type: SearchType.META,
                                //   flyingFrom: widget.flyingFrom,
                                //   flyingTo: widget.flyingTo,
                                //   depDate: dateFormatter
                                //       .format(widget.departureDate),
                                //   arrDate: widget.isRoundTrip
                                //       ? dateFormatter.format(widget.arrivalDate)
                                //       : null,
                                //   isRoundTrip: widget.isRoundTrip,
                                //   // flightsStream: flyLinebloc.flightsMetaItems(
                                //   //     currency,
                                //   //     _sortValues,
                                //   //     widget.isRoundTrip),
                                // ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ),
                  ),
                ),
                SizedBox(height: 16)
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 90,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          // widget.onUpdateFilter(Rx.combineLatest3<
                          //   List<FlightInformationObject>,
                          //   List<FlightInformationObject>,
                          //   List<FlightInformationObject>,
                          //   List<FlightInformationObject>>(
                          //     flyLinebloc.flightsMetaItems(
                          //       currency, _sortValues, widget.isRoundTrip
                          //     ),
                          //     flyLinebloc.flightsExclusiveItems(
                          //       currency, _sortValues, widget.isRoundTrip
                          //     ),
                          //     flyLinebloc.flightsFareItems(
                          //       currency, _sortValues, widget.isRoundTrip
                          //     ),
                          //     (a, b, c) => a + b + c,
                          //   ).asBroadcastStream()
                          // );
                          context.read<SearchProvider>().setFlightsStream(Rx.combineLatest3<
                            List<FlightInformationObject>,
                            List<FlightInformationObject>,
                            List<FlightInformationObject>,
                            List<FlightInformationObject>>(
                              flyLinebloc.flightsMetaItems(
                                currency, _sortValues, widget.isRoundTrip
                              ),
                              flyLinebloc.flightsExclusiveItems(
                                currency, _sortValues, widget.isRoundTrip
                              ),
                              flyLinebloc.flightsFareItems(
                                currency, _sortValues, widget.isRoundTrip
                              ),
                              (a, b, c) => a + b + c,
                            ).asBroadcastStream());
                          Navigator.of(context).pop();
                        },
                        //     Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (BuildContext context) {
                        //     return SearchResults(
                        //       type: SearchType.META,
                        //       flyingFrom: widget.flyingFrom,
                        //       flyingTo: widget.flyingTo,
                        //       depDate:
                        //           dateFormatter.format(widget.departureDate),
                        //       arrDate: widget.isRoundTrip
                        //           ? dateFormatter.format(widget.arrivalDate)
                        //           : null,
                        //       isRoundTrip: widget.isRoundTrip,
                        //       flightsStream: Rx.combineLatest3<
                        //           List<FlightInformationObject>,
                        //           List<FlightInformationObject>,
                        //           List<FlightInformationObject>,
                        //           List<FlightInformationObject>>(
                        //         flyLinebloc.flightsMetaItems(
                        //             currency, _sortValues, widget.isRoundTrip),
                        //         flyLinebloc.flightsExclusiveItems(
                        //             currency, _sortValues, widget.isRoundTrip),
                        //         flyLinebloc.flightsFareItems(
                        //             currency, _sortValues, widget.isRoundTrip),
                        //         (a, b, c) => a + b + c,
                        //       ).asBroadcastStream(),
                        //     );
                        //   },
                        // )),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        color: Color.fromRGBO(0, 174, 239, 1),
                        child: Text(
                          "Update Results",
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xffffffff),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // getAppBarWithBackButton(context),
          ],
        ),
      ),
    );
  }
}
