import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/screens/wallet/create_account.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/models/airline.dart';
import 'package:motel/models/booked_flight.dart';
import 'package:motel/models/locations.dart';
import 'package:motel/models/traveler_info.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/utils/app_utils.dart';
import 'package:motel/widgets/list_loading.dart';
import 'package:motel/widgets/svg_image_widget.dart';

import 'local_widgets/add_prefered_airlines.dart';
import 'local_widgets/add_prefered_airport_city.dart';
import 'local_widgets/add_cabin_clas.dart';
import 'local_widgets/add_prefered_flight.dart';

class TravelPreferences extends StatefulWidget {
  @override
  _TravelPreferencesState createState() => _TravelPreferencesState();
}

class _TravelPreferencesState extends State<TravelPreferences>
    with TickerProviderStateMixin {
  Future<List<BookedFlight>> pastFlights;

  List<AirlineSelect> _selectedAirlines = List<AirlineSelect>();
  List<FlightSelect> _selectedFlights = [];
  String _selectedCabin = "";
  List<LocationObject> _selectedAirport = [];
  TravelerInfo _travelerInfo;
  bool loading = false;

  @override
  void initState() {
    pastFlights = flyLinebloc.pastFlightSummary();
    _getTravellerInfo();
    super.initState();
  }

  void _getTravellerInfo() async {
    setState(() {
      loading = true;
    });
    _travelerInfo = await flyLinebloc.travelerInfo();
    _selectedAirport.addAll(_travelerInfo.preferredAirports ?? []);
    List<AirlineSelect> airlineSelected = [];
    _travelerInfo.preferredAirlines.forEach((element) async {
      String name = AppUtils.getAirlineByCode(context, element);
      AirlineSelect airlineSelect = AirlineSelect(
          airlineName: name.replaceAll(" ", "_").toLowerCase(),
          airlineDescription: name,
          airlinePictureUrl:"assets/images/preferred_airline_logos/$element.png");
      airlineSelected.add(airlineSelect);
    });
    _selectedAirlines.addAll(airlineSelected);
    _selectedCabin =
        AppUtils.capitalize(Cabin.getKey(_travelerInfo.cabinPreference));

    _selectedFlights.add(
        AppUtils.createDurationFlight(_travelerInfo.durationPricePreference));
    if(_travelerInfo.carrierPreference!=null)
    _selectedFlights
        .add(AppUtils.createCarrier(_travelerInfo.carrierPreference));
    if (_travelerInfo.directFlightPreference) {
      _selectedFlights.add(AppUtils.createDirectFlight());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateAirlines(List<AirlineSelect> airlines) async {
    List<String> airlineCodes = [];
    for (AirlineSelect airlineSelect in airlines) {
      String code =
      AppUtils.getAirlineCode(context, airlineSelect.airlineDescription);
      if (code.isNotEmpty) {
        airlineCodes.add(code);
      }
    }
    flyLinebloc.updateAirlines(airlineCodes);
  }

  void _updateFlightPreference(List<FlightSelect> flights) {
    FlightSelect flightSelect = flights.firstWhere(
            (element) => element.flightName == "direct_flight",
        orElse: () => null);
    flyLinebloc.updateDirectFlightPreference(flightSelect != null);

    FlightSelect flight = flights.firstWhere(
            (element) =>
        element.flightName == "cheapest_flights" ||
            element.flightName == "shortest_flight",
        orElse: () => null);
    if (flight != null) {
      flyLinebloc.updateDurationPricePreference(flight.flightName);
    }

    FlightSelect carrierFlight = flights.firstWhere(
            (element) =>
        element.flightName == "single_carrier" ||
            element.flightName == "multi_carrier",
        orElse: () => null);
    if (carrierFlight != null) {
      flyLinebloc.updateCarrierPreference(carrierFlight.flightName);
    }
  }

  void _awaitSelectedAirlineFromAirlineScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddPreferredAirline(
                  selectedAirlines: _selectedAirlines,
                )));
    setState(() {
      _selectedAirlines = result ?? [];
      _updateAirlines(_selectedAirlines);
    });
  }

  void _awaitSelectedFlightFromFlightScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddPreferredFlight(
                  selectedFlights: _selectedFlights,
                )));
    setState(() {
      _selectedFlights = result ?? [];
      _updateFlightPreference(_selectedFlights);
    });
  }

  void _awaitSelectedCabinFromCabinScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddCabinClass(
                  selectedCabin: _selectedCabin,
                )));
    setState(() {
      _selectedCabin = result ?? "";
      flyLinebloc.updateCabinType(_selectedCabin);
    });
  }

  void _awaitSelectedAirportFromAirportScreen(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddPreferredAirport()));
    if (result != null) {
      setState(() {
        _selectedAirport.add(result);
        flyLinebloc.updatePreferredAirPorts(_selectedAirport);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isGustLogin == true  ? NoDataCreateAccountPage(
      title: "Personalize your FlyLine",
      description:
      "Create your free FlyLine account and personalize your travel experience by saving preferred airports and airlines",
    ) : loading
        ? ListLoading()
        : StreamBuilder(
        stream: flyLinebloc.outAccount,
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 36.0, top: 32.0, bottom: 11.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Airline Preferences",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 17,
                              color: Color(0xff333333),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 17.0, left: 18),
                        child:
                        Divider(height: 1.5, color: Color(0xffe7e9f0)),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 20, bottom: 10, right: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      _selectedAirlines[index]
                                          .airlinePictureUrl,
                                      height: 26,
                                      width: 26,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _selectedAirlines[index]
                                          .airlineDescription,
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
                                Row(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                          width: 80,
                                          child: FlatButton(
                                            padding:
                                            const EdgeInsets.all(0),
                                            splashColor: Colors.transparent,
                                            onPressed: () {
                                              setState(() {
                                                _selectedAirlines.remove(
                                                    "Alaska Airlines");
                                                _selectedAirlines
                                                    .removeWhere((element) =>
                                                element
                                                    .airlineName ==
                                                    _selectedAirlines[
                                                    index]
                                                        .airlineName);
                                                _updateAirlines(
                                                    _selectedAirlines);
                                              });
                                            },
                                            child: Align(
                                              alignment:
                                              Alignment.centerRight,
                                              child: Text(
                                                "Remove Airline",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Colors.red,
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: _selectedAirlines.length,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        padding: EdgeInsets.only(right: 0),
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: ListTile(
                          contentPadding:
                          EdgeInsets.only(left: 20, right: 0),
                          title: new Text(
                            "Add Airline Preferances",
                            style: TextStyle(
                              color: Color(0xffBBC4DC),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          trailing: SvgImageWidget.asset(
                            'assets/svg/navigation/forward-arrow.svg',
                            height: 14,
                            width: 14,
                          ),
                          onTap: () {
                            _awaitSelectedAirlineFromAirlineScreen(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 36.0, top: 32.0, bottom: 11.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Preferred Airports or Markets",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 17,
                              color: Color(0xff333333),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18, top: 0.0, bottom: 17.0),
                        child:
                        Divider(height: 1.5, color: Color(0xffe7e9f0)),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 20, bottom: 10, right: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      _selectedAirport[index].name,
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
                                Row(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                          width: 80,
                                          child: FlatButton(
                                            padding:
                                            const EdgeInsets.all(0),
                                            splashColor: Colors.transparent,
                                            onPressed: () {
                                              setState(() {
                                                _selectedAirport.removeWhere(
                                                        (element) =>
                                                    element.name ==
                                                        _selectedAirport[
                                                        index]
                                                            .name);
                                                flyLinebloc
                                                    .updatePreferredAirPorts(
                                                    _selectedAirport);
                                              });
                                            },
                                            child: Align(
                                              alignment:
                                              Alignment.centerRight,
                                              child: Text(
                                                "Remove",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Colors.red,
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: _selectedAirport.length,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: ListTile(
                          contentPadding:
                          EdgeInsets.only(left: 20, right: 0),
                          title: new Text(
                            "Add Preferred Airports or Markets",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xffBBC4DC),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          trailing: SvgImageWidget.asset(
                            'assets/svg/navigation/forward-arrow.svg',
                            height: 14,
                            width: 14,
                          ),
                          onTap: () =>
                              _awaitSelectedAirportFromAirportScreen(
                                  context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 36.0, top: 32.0, bottom: 11.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Cabin Class Preferance",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 17,
                              color: Color(0xff333333),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18, top: 0.0, bottom: 17.0),
                        child:
                        Divider(height: 1.5, color: Color(0xffe7e9f0)),
                      ),
                      if (_selectedCabin != null &&
                          _selectedCabin != "") ...[
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, bottom: 10, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  if(_selectedCabin.isNotEmpty ||
                                      _selectedCabin != null)
                                    Image.asset(
                                      "assets/images/preferences_icons/seat.png",
                                      height: 26,
                                      width: 26,
                                    ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    _selectedCabin,
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
                              Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                        width: 80,
                                        child: FlatButton(
                                          padding: const EdgeInsets.all(0),
                                          splashColor: Colors.transparent,
                                          onPressed: () {
                                            setState(() {
                                              _selectedCabin = "";
                                              flyLinebloc.updateCabinType(
                                                  _selectedCabin);
                                            });
                                          },
                                          child: Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: Text(
                                              "Remove Cabin",
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                color: Colors.red,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: ListTile(
                            contentPadding:
                            EdgeInsets.only(left: 20, right: 0),
                            title: new Text(
                              "Add Cabin Class Preferance",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xffBBC4DC),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            trailing: SvgImageWidget.asset(
                              'assets/svg/navigation/forward-arrow.svg',
                              height: 14,
                              width: 14,
                            ),
                            onTap: () =>
                                _awaitSelectedCabinFromCabinScreen(
                                    context)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class BuildSelectedAirlineList extends StatefulWidget {
  @override
  _BuildSelectedAirlineListState createState() =>
      _BuildSelectedAirlineListState();
}

class _BuildSelectedAirlineListState extends State<BuildSelectedAirlineList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PillSlider extends StatefulWidget {
  const PillSlider({Key key}) : super(key: key);

  @override
  _PillSliderState createState() => _PillSliderState();
}

class _PillSliderState extends State<PillSlider> with TickerProviderStateMixin {
  AnimationController _squeezeAnimationCtrl;
  Animation<double> _squeezeAnimation;

  @override
  void initState() {
    _squeezeAnimationCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _squeezeAnimation =
        Tween<double>(begin: 80, end: 0).animate(CurvedAnimation(
          parent: _squeezeAnimationCtrl,
          curve: Curves.ease,
        ));

    super.initState();
  }

  @override
  void dispose() {
    _squeezeAnimationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _squeezeAnimation,
      builder: (context, child) =>
          SizedBox(
            height: 20,
            width: _squeezeAnimation.value,
            child: Container(
              color: Colors.white,
              child: FlatButton(
                padding: const EdgeInsets.all(0),
                splashColor: Colors.transparent,
                onPressed: () {
                  _squeezeAnimationCtrl.forward();
                  Future.delayed(const Duration(milliseconds: 3000), () {
                    if (mounted) {
                      _squeezeAnimationCtrl.reverse();
                    }
                  });
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 5,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
