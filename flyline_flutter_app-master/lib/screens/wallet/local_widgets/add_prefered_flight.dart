import 'package:flutter/material.dart';
import 'package:motel/models/airline.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';

class AddPreferredFlight extends StatefulWidget {
  final List<FlightSelect> selectedFlights;

  const AddPreferredFlight({Key key, this.selectedFlights = const []})
      : super(key: key);
  @override
  _AddPreferredFlightState createState() => _AddPreferredFlightState();
}

class _AddPreferredFlightState extends State<AddPreferredFlight> {
  List<FlightSelect> _buildFlightList = [];
  FlightSelect _flightObj = FlightSelect();

  @override
  void initState() {
    _buildFlightList = widget.selectedFlights ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FC),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: <Widget>[
                  MenuItemAppBar(title: 'Flight Preferences'),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 32.0, bottom: 11.0),
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Select Flight Preferances",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 17,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 17.0),
                    margin: const EdgeInsets.only(left: 18),
                    child: Divider(height: 1.5, color: Color(0xffe7e9f0)),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/preferences_icons/direct.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Direct Flight",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _buildFlightList.singleWhere(
                                          (element) =>
                                              element.flightName ==
                                              'direct_flight',
                                          orElse: () => null) !=
                                      null
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(0, 174, 239, 1),
                                      size: 23,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                    ),
                              onTap: () {
                                if (_buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            'direct_flight',
                                        orElse: () => null) !=
                                    null) {
                                  setState(() {
                                    _buildFlightList.removeWhere((element) =>
                                        element.flightName == 'direct_flight');
                                  });
                                } else {
                                  _flightObj = FlightSelect(
                                      flightName: "direct_flight",
                                      flightDescription: "Direct Flight",
                                      flightPictureUrl:
                                          "assets/images/preferences_icons/direct.png");
                                  setState(() {
                                    _buildFlightList.add(_flightObj);
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/preferences_icons/cheapest.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Cheapest Flights",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _buildFlightList.singleWhere(
                                          (element) =>
                                              element.flightName ==
                                              'cheapest_flights',
                                          orElse: () => null) !=
                                      null
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(0, 174, 239, 1),
                                      size: 23,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                    ),
                              onTap: () {
                                FlightSelect flightSelect =
                                    _buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            "shortest_flight",
                                        orElse: () => null);
                                if (flightSelect != null) {
                                  _buildFlightList.removeWhere((element) =>
                                      element.flightName == 'shortest_flight');
                                }
                                if (_buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            'cheapest_flights',
                                        orElse: () => null) !=
                                    null) {
                                  setState(() {
                                    _buildFlightList.removeWhere((element) =>
                                        element.flightName ==
                                        'cheapest_flights');
                                  });
                                } else {
                                  _flightObj = FlightSelect(
                                      flightName: "cheapest_flights",
                                      flightDescription: "Cheapest Flights",
                                      flightPictureUrl:
                                          "assets/images/preferences_icons/cheapest.png");
                                  setState(() {
                                    _buildFlightList.add(_flightObj);
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/preferences_icons/shortest.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Shortest (Duration) Flights",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _buildFlightList.singleWhere(
                                          (element) =>
                                              element.flightName ==
                                              'shortest_flight',
                                          orElse: () => null) !=
                                      null
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(0, 174, 239, 1),
                                      size: 23,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                    ),
                              onTap: () {
                                FlightSelect flightSelect =
                                    _buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            "cheapest_flights",
                                        orElse: () => null);
                                if (flightSelect != null) {
                                  _buildFlightList.removeWhere((element) =>
                                      element.flightName == 'cheapest_flights');
                                }
                                if (_buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            'shortest_flight',
                                        orElse: () => null) !=
                                    null) {
                                  setState(() {
                                    _buildFlightList.removeWhere((element) =>
                                        element.flightName ==
                                        'shortest_flight');
                                  });
                                } else {
                                  _flightObj = FlightSelect(
                                      flightName: "shortest_flight",
                                      flightDescription:
                                          "Shortest (Duration) Flights",
                                      flightPictureUrl:
                                          "assets/images/preferences_icons/shortest.png");
                                  setState(() {
                                    _buildFlightList.add(_flightObj);
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/preferences_icons/carrier.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Single Carrier",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _buildFlightList.singleWhere(
                                          (element) =>
                                              element.flightName ==
                                              'single_carrier',
                                          orElse: () => null) !=
                                      null
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(0, 174, 239, 1),
                                      size: 23,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                    ),
                              onTap: () {
                                FlightSelect flightSelect =
                                    _buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            "multi_carrier",
                                        orElse: () => null);
                                if (flightSelect != null) {
                                  _buildFlightList.removeWhere((element) =>
                                      element.flightName == 'multi_carrier');
                                }
                                if (_buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            'single_carrier',
                                        orElse: () => null) !=
                                    null) {
                                  setState(() {
                                    _buildFlightList.removeWhere((element) =>
                                        element.flightName == 'single_carrier');
                                  });
                                } else {
                                  _flightObj = FlightSelect(
                                      flightName: "single_carrier",
                                      flightDescription: "Single Carrier",
                                      flightPictureUrl:
                                          "assets/images/preferences_icons/carrier.png");
                                  setState(() {
                                    _buildFlightList.add(_flightObj);
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/preferences_icons/carrier.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Multi-Carrier",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _buildFlightList.singleWhere(
                                          (element) =>
                                              element.flightName ==
                                              'multi_carrier',
                                          orElse: () => null) !=
                                      null
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(0, 174, 239, 1),
                                      size: 23,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                    ),
                              onTap: () {
                                FlightSelect flightSelect =
                                    _buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            "single_carrier",
                                        orElse: () => null);
                                if (flightSelect != null) {
                                  _buildFlightList.removeWhere((element) =>
                                      element.flightName == 'single_carrier');
                                }
                                if (_buildFlightList.singleWhere(
                                        (element) =>
                                            element.flightName ==
                                            'multi_carrier',
                                        orElse: () => null) !=
                                    null) {
                                  setState(() {
                                    _buildFlightList.removeWhere((element) =>
                                        element.flightName == 'multi_carrier');
                                  });
                                } else {
                                  _flightObj = FlightSelect(
                                      flightName: "multi_carrier",
                                      flightDescription: "Multi-Carrier",
                                      flightPictureUrl:
                                          "assets/images/preferences_icons/carrier.png");
                                  setState(() {
                                    _buildFlightList.add(_flightObj);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: -5,
              left: 0,
              right: 0,
              height: 100,
              child: Material(
                color: Colors.white,
                elevation: 10,
                child: Center(
                  child: FlatButton(
                    onPressed: () => Navigator.pop(context, _buildFlightList),
                    splashColor: Colors.transparent,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(0, 174, 239, 1)),
                      child: Text(
                        'Save Selection(s)',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
