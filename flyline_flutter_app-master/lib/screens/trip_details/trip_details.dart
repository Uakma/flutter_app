import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/screens/home/local_widgets/blue_button.dart';
import 'package:motel/screens/introduction/introductionScreen.dart';
import 'package:motel/screens/log_in/log_in.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_board_days.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_booking_button.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_flight.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_layover.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_routes.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_stopover.dart';
import 'package:motel/screens/trip_details/trip_details_route_popup.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/current_trip_data.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/flights_results/meta_book_screen.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_travel_details.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_wrapper.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/screens/trip_details/local_widgets/meta_fare_description.dart';
import 'package:motel/widgets/flight_card_detail_row.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:motel/widgets/web_bottom_widget.dart';
import 'package:motel/widgets/web_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class TripDetailsScreen extends StatefulWidget {
  final List<FlightRouteObject> routes;
  final int ch;
  final int ad;
  final String bookingToken;
  final int typeOfTripSelected;
  final String selectedClassOfService;
  final FlightInformationObject flight;
  final Map<String, dynamic> retailInfo;
  final String depDate;
  final String arrDate;
  final SearchType type;
  final List<StopDetails> stops;


  TripDetailsScreen({
    Key key,
    this.routes,
    this.ch,
    @required this.stops,
    this.bookingToken,
    this.flight,
    this.selectedClassOfService,
    this.typeOfTripSelected,
    this.retailInfo,
    this.depDate,
    this.arrDate,
    this.type,
    this.ad,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TripDetailsScreen>
    with TickerProviderStateMixin {
  bool get isRoundTrip => widget.typeOfTripSelected == 0;

  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 10.0, keepScrollOffset: true);

  String get continueButtonText =>
      widget.type == SearchType.FARE || widget.type == SearchType.EXCLUSIVE
          ? "Continue"
          : "Continue";

  int get departureStopOvers => widget.flight.departures.length - 1;

  int get returnStopOvers => widget.flight.returns.length - 1;

  CheckFlightResponse _checkFlightResponse;
  List<BagItem> handBags;
  List<BagItem> holdBags;

  bool _clickFlightDeparture = false;
  bool loading = true;
  bool isShowingRouteDetail = false;
  bool isWhiteBackground = false;

  final formatDates = intl.DateFormat("dd MMM yyyy");
  final formatTime = intl.DateFormat("hh : mm a");
  final formatAllDay = intl.DateFormat("dd/MM/yyyy");

  AnimationController _transitionController;
  Animation _slidingRouteDetailAnimation;
  int _animationDuration = 1500;

  String departureStopOversText = '';
  String returnStopOversText = '';

  void checkFlight() {
    setState(() {
      loading = true;
    });
    flyLinebloc
        .checkFlights(
            widget.bookingToken, 0, widget.ch, flyLinebloc.numberOfPassengers)
        .then((response) {
      setState(() {
        loading = false;
        _checkFlightResponse = response;
      });

      if (!response.flightsChecked) {
        flyLinebloc.checkFlights(
            widget.bookingToken, 0, widget.ch, flyLinebloc.numberOfPassengers);
      }
      setState(() {
        loading = false;
      });
    });
  }

  void addPassenger() async {
    if (flyLinebloc.numberOfPassengers < 7 && !loading) {
      flyLinebloc.setAdults(flyLinebloc.numberOfPassengers + 1);
      checkFlight();
    }
  }

  void removePassenger() async {
    if (!loading) {
      flyLinebloc.setAdults(flyLinebloc.numberOfPassengers - 1);
      checkFlight();
    }
  }

  @override
  void initState() {
    
    // for (int i = 0; i < widget.routes.length; i++) {
    //   FlightRouteObject route = widget.routes[i];
    //   print('Route detail index: $i');
    //   print('From: ${route.flyFrom}');
    //   print('To: ${route.flyTo}');
    //   print('Airflight: ${route.airline}');
    // }
    // for (int i = 0; i < widget.stops.length; i++) {
    //   StopDetails detail = widget.stops[i];
    //   print('Stop detail index: $i');
    //   print('Stop to: ${detail.to}');
    //   print('Stop Duration: ${detail.duration}');
    // }

    _transitionController = AnimationController(
        duration: Duration(milliseconds: _animationDuration), vsync: this);
    _slidingRouteDetailAnimation =
        Tween<Offset>(begin: Offset(0, 2), end: Offset(0, 0)).animate(
      CurvedAnimation(
          parent: _transitionController,
          curve: Interval(0.33, 0.66, curve: Curves.fastOutSlowIn)),
    );

    switch (widget.type) {
      case SearchType.FARE:
        getFareInit();
        super.initState();
        break;
      case SearchType.EXCLUSIVE:
        getExclusiveInit();
        super.initState();
        break;
      case SearchType.META:
        getMetaInit();
        super.initState();
        break;
    }

    departureStopOversText = (departureStopOvers > 0
        ? (departureStopOvers > 1
            ? "$departureStopOvers Stopovers"
            : "$departureStopOvers Stopover")
        : "Direct");

    returnStopOversText = (returnStopOvers > 0
        ? (returnStopOvers > 1
            ? "$returnStopOvers Stopovers"
            : "$returnStopOvers Stopover")
        : "Direct");
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: buildMobileContent(),
      desktop: buildWebContent(),
    );
    
  }

  Widget buildWebContent() {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            WebHeaderWidget(
              leftButton: GestureDetector(
                child: SvgImageWidget.asset(
                  'assets/svg/arrow_back.svg',
                  width: 11.h,
                  height: 22.h
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              rightButton: BlueButtonWidget(
                width: 132.w,
                height: 43.h,
                text: 'Sign in',
                onPressed: () {
                  showDialog(
                    context: context, 
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: (MediaQuery.of(context).size.width - 477.w) / 2,
                          vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                        ),
                        child: IntroductionScreen(
                          onTapSignIn: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context, 
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (MediaQuery.of(context).size.width - 557.w) / 2,
                                    vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                                  ),
                                  child: LoginScreen(),
                                )
                              )
                            );
                          },
                          onTapSignUp: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context, 
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (MediaQuery.of(context).size.width - 557.w) / 2,
                                    vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                                  ),
                                  child: SignUpScreen(),
                                )
                              )
                            );
                          }
                        ),
                      )
                    )
                  );
                },
              ),
            ),
            Expanded(
              child: buildWebBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWebBody() {
    final String typeOfTrip = isRoundTrip ? 'Round-trip' : 'One-way';
    String flightTitle = widget.flight.cityFrom;
    if (widget.flight.flyFrom != null) {
      flightTitle += ' ${widget.flight.flyFrom}';
    }
    if (isRoundTrip) {
      flightTitle += ' - '  + widget.flight.cityTo;
      if (widget.flight.flyTo != null) {
        flightTitle += ' ${widget.flight.flyTo}';
      }
    }

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 460.w,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 38.w, bottom: 5.h),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            typeOfTrip + ' | ' + widget.ad.toString() + ' Adult',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14.h,
                              color: Color.fromRGBO(187, 196, 220, 1),
                              fontWeight: FontWeight.w300
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Trip Price',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14.h,
                              color: Color.fromRGBO(187, 196, 220, 1),
                              fontWeight: FontWeight.w300
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ]
                    ),
                  ),
                  Container(
                    height: 39.h,
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              flightTitle,
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 24.h,
                                color: Color.fromRGBO(14, 49, 120, 1),
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ),
                        ),
                        Container(
                          width: 127.w,
                          child: Text(
                            '${Provider.of<SettingsBloc>(context).selectedCurrency.sign}' + widget.flight.price.toStringAsFixed(2),
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 24.h,
                              color: Color.fromRGBO(64, 206, 83, 1),
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    margin: EdgeInsets.only(top: 7.h, bottom: 10.h),
                    color: Color.fromRGBO(237, 238, 246, 1)
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
                    height: 105.h,
                    child: buildTopColorBoxes(),
                  ),
                  Container(
                    padding: EdgeInsets.all(22.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Color.fromRGBO(237, 238, 246, 1),
                      ),
                      borderRadius: BorderRadius.circular(20.w)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TripDetailsTravelDetails(
                          dateText: "Departure",
                          date: intl.DateFormat('${intl.DateFormat.MONTH}, ${intl.DateFormat.DAY}').format(DateTime.parse(widget.depDate)),
                          flights: widget.flight.departures,
                          duration: widget.flight.durationDeparture,
                          stopOvers: departureStopOversText,
                          classOfService: widget.selectedClassOfService,
                          flight: widget.flight,
                          onPressDetail: () {
                            showDialog(
                              context: context, 
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (MediaQuery.of(context).size.width - 600.w) / 2,
                                    vertical: 0,
                                  ),
                                  child: Transform.scale(
                                    child: TripDetailRoutePopup(
                                      arrDate: widget.arrDate,
                                      depDate: widget.depDate,
                                      flight: widget.flight,
                                      isRoundTrip: isRoundTrip,
                                      stops: widget.stops,
                                    ),
                                    scale: 0.8,
                                  ),
                                )
                              )
                            );
                          },
                        ),
                        if (isRoundTrip)
                          Container(
                            margin: EdgeInsets.only(top: 25.h, bottom: 5.h, left: 32.w, right: 32.w),
                            child: buildOnboardDays(),
                          ),
                        if (isRoundTrip)
                          TripDetailsTravelDetails(
                            dateText: "Return",
                            date: intl.DateFormat('${intl.DateFormat.MONTH}, ${intl.DateFormat.DAY}').format(DateTime.parse(widget.arrDate)),
                            flights: widget.flight.returns,
                            duration: widget.flight.durationReturn,
                            stopOvers: returnStopOversText,
                            classOfService: widget.selectedClassOfService,
                            flight: widget.flight,
                            onPressDetail: () {
                              showDialog(
                              context: context, 
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (MediaQuery.of(context).size.width - 600.w) / 2,
                                    vertical: 0,
                                  ),
                                  child: Transform.scale(
                                    child: TripDetailRoutePopup(
                                      arrDate: widget.arrDate,
                                      depDate: widget.depDate,
                                      flight: widget.flight,
                                      isRoundTrip: isRoundTrip,
                                      stops: widget.stops,
                                    ),
                                    scale: 0.8,
                                  ),
                                )
                              )
                            );
                            }
                          ),
                      ],
                    ),
                  ),
                  TripDetailsBookingButton(onPressed: getContinueAction, title: 'Continue to Book'),
                ],
              ),
            ),
            WebBottomWidget()
          ],
        )
      ),
    );
  }

  Widget buildMobileContent() {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: getAppBarUI(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isWhiteBackground ? Colors.white : Colors.transparent,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 15,
            ),
            isShowingRouteDetail 
              ? Container(
                height: 1,
                color: Color.fromRGBO(247, 249, 252, 1),
              )
              : Container(),
            Expanded(
                child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: flightDetail(),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SlideTransition(
                      child: TripDetailsRoutes(
                        arrDate: widget.arrDate,
                        depDate: widget.depDate,
                        flight: widget.flight,
                        isRoundTrip: isRoundTrip,
                        stops: widget.stops,
                      ),
                      position: _slidingRouteDetailAnimation 
                    ),
                  )
                ],
              )
            ),
            Container(
              height: 90.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0, right: 20.0, left: 20.0),
                child: Row(
                  children: <Widget>[
                    if (!loading || widget.type != SearchType.EXCLUSIVE)
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Total ",
                                    style: TextStyle(
                                      color: Color(0xff333333),
                                      fontFamily: 'Gilroy',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.type == SearchType.EXCLUSIVE
                                        ? "  \$ " +
                                            (_checkFlightResponse.total)
                                                ?.toStringAsFixed(2)
                                        : "  \$ " +
                                            widget.flight.price
                                                ?.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Color(0xff40CE53),
                                      fontFamily: 'Gilroy',
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (loading && widget.type == SearchType.EXCLUSIVE)
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Color(0xFFBBC4DC),
                          highlightColor: Color(0xFFBBC4DC),
                          enabled: true,
                          child: Row(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Total",
                                      style: TextStyle(
                                        color: Color(0xff333333),
                                        fontFamily: 'Gilroy',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " Loading ",
                                      style: TextStyle(
                                        color: Color(0xff40CE53),
                                        fontFamily: 'Gilroy',
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.only(left: 40.0, right: 40.0),
                          width: 199,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff40CE53),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          child: Center(
                            child: Text(
                              continueButtonText,
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xffffffff),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        onTap: getContinueAction,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget differentAirport(String errorText) {
    if (widget.flight.returns.isEmpty)
      return Container();

    if (widget.flight.departures.first.flyFrom != widget.flight.returns.last.flyTo && widget.flight.departures.first.cityFrom != widget.flight.returns.last.cityTo) {
      return  Container(
        color: Color.fromRGBO(247, 249, 252, 1),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    color: HexColor("#FFE4E4"),
                    onPressed: () => null,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            color: HexColor("#FE8930"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Different Origin Airport",
                            style: TextStyle(
                              fontSize: 14,
                              color: HexColor("#FE8930"),
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (widget.flight.departures.first.flyFrom != widget.flight.returns.last.flyTo) {
      return  Container(
        color: Color.fromRGBO(247, 249, 252, 1),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    color: HexColor("#FFE4E4"),
                    onPressed: () => null,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            color: HexColor("#FE8930"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Different Origin Airport",
                            style: TextStyle(
                              fontSize: 14,
                              color: HexColor("#FE8930"),
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if(widget.flight.departures.first.cityFrom != widget.flight.returns.last.cityTo) {
      return  Container(
        color: Color.fromRGBO(247, 249, 252, 1),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    color: HexColor("#FFE4E4"),
                    onPressed: () => null,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            color: HexColor("#FE8930"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Extended Layover",
                            style: TextStyle(
                              fontSize: 14,
                              color: HexColor("#FE8930"),
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget extedneLayover() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 24, right: 24),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Warning:",
                style: TextStyle(
                  color: Color(0xff8e969f),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                      text:
                          'This trip has a different arrival airport The Departing airport on the first leg of your flight.',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.6,
                      )),
                ],
              ),
            ),
            Container(
              height: 40,
            ),
            RichText(
              text: TextSpan(
                text: "Warning:",
                style: TextStyle(
                  color: Color(0xff8e969f),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                      text: 'This trip has a layover longer than 6 hours',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff8e969f),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.6,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopBoxWidget(Color backgroundColor, Color textColor, String text) {
    return ScreenTypeLayout(
      mobile: FlatButton(
                padding: EdgeInsets.only(left: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                color: backgroundColor,
                onPressed: () => null,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color: textColor,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          color: textColor
                        ),
                      )
                    ],
                  ),
                ),
              ),
      desktop: FlatButton(
                padding: EdgeInsets.only(left: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.h)),
                ),
                color: backgroundColor,
                onPressed: () => null,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h, horizontal: 10.w
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color: textColor,
                        size: 16.h,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 12.h,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          color: textColor
                        ),
                      )
                    ],
                  ),
                ),
              ),
    );
  }

  Widget buildTopColorBoxes() {
    return ScreenTypeLayout(
      mobile: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: buildTopBoxWidget(
                  Color.fromRGBO(0, 174, 239, 0.1), 
                  Color.fromRGBO(0, 174, 239, 1), 
                  'Price Confirmed'
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: buildTopBoxWidget(
                      Color.fromRGBO(64, 206, 83, 0.1),
                      Color.fromRGBO(64, 206, 83, 1),
                      'Free cancellation within the next 24 hours!'
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      desktop: Column(
        children: [
          Expanded(
            flex: 1,
            child: buildTopBoxWidget(
              Color.fromRGBO(0, 174, 239, 0.1), 
              Color.fromRGBO(0, 174, 239, 1), 
              'Price Confirmed'
            ),
          ),
          Container(height: 8.h),
          Expanded(
            flex: 1,
            child: buildTopBoxWidget(
              Color.fromRGBO(64, 206, 83, 0.1),
              Color.fromRGBO(64, 206, 83, 1),
              'Free cancellation within the next 24 hours!'
            ),
          ),
        ],
      ),
    );
  }

  Widget flightDetail() {
    return SingleChildScrollView(
      child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20.0, bottom: 25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    _clickFlightDeparture = !_clickFlightDeparture;
                  });
                },
                child: Column(
                  children: <Widget>[
                    differentAirport(""),
                    Container(
                      color: Color.fromRGBO(247, 249, 252, 1),
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: buildTopColorBoxes(),
                    ), // Checked notification
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TripDetailsTravelDetails(
                            dateText: "Departure",
                            date: intl.DateFormat('${intl.DateFormat.MONTH}, ${intl.DateFormat.DAY}').format(DateTime.parse(widget.depDate)),
                            flights: widget.flight.departures,
                            duration: widget.flight.durationDeparture,
                            stopOvers: departureStopOversText,
                            classOfService: widget.selectedClassOfService,
                            flight: widget.flight,
                            onPressDetail: () {
                              _transitionController.forward();
                              Future.delayed(Duration(milliseconds: _animationDuration), () {
                                setState(() {
                                  isShowingRouteDetail = true;
                                });
                              });
                              Future.delayed(Duration(milliseconds: _animationDuration ~/ 2), () {
                                setState(() {
                                  isWhiteBackground = true;
                                });
                              });
                            },
                          ),
                          if (isRoundTrip)
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0,
                                  left: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                            ),
                          if (isRoundTrip)
                            TripDetailsTravelDetails(
                              dateText: "Return",
                              date: intl.DateFormat('${intl.DateFormat.MONTH}, ${intl.DateFormat.DAY}').format(DateTime.parse(widget.arrDate)),
                              flights: widget.flight.returns,
                              duration: widget.flight.durationReturn,
                              stopOvers: returnStopOversText,
                              classOfService: widget.selectedClassOfService,
                              flight: widget.flight,
                              onPressDetail: () {
                              _transitionController.forward();
                              Future.delayed(Duration(milliseconds: _animationDuration), () {
                                setState(() {
                                  isShowingRouteDetail = true;
                                });
                              });
                              Future.delayed(Duration(milliseconds: _animationDuration ~/ 2), () {
                                setState(() {
                                  isWhiteBackground = true;
                                });
                              });
                            }
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.getTheme().dividerColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                  left: 20.0,
                  top: 20,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              "Passengers:  ",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xffBBC4DC),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              StreamBuilder(
                                  stream: flyLinebloc.outAdults,
                                  builder: (context, snapshot) {
                                    return snapshot.data != null &&
                                            snapshot.data > 1
                                        ? GestureDetector(
                                            child: Container(
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Gilroy',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              removePassenger();
                                            },
                                          )
                                        : Container();
                                  }),
                              StreamBuilder(
                                  stream: flyLinebloc.outAdults,
                                  builder: (context, snapshot) {
                                    return Container(
                                      child: Text(
                                        snapshot.data != null &&
                                                snapshot.data > 1
                                            ? '${snapshot.data.toString()} Adults '
                                            : '${snapshot.data.toString()} Adult ',
                                        style: TextStyle(
                                          color: Color(0xff333333),
                                          fontFamily: 'Gilroy',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    );
                                  }),
                              if (widget.type == SearchType.EXCLUSIVE)
                                GestureDetector(
                                  child: Container(
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        color: Color(0xff00aeef),
                                        fontFamily: 'Gilroy',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    addPassenger();
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Trip Price :",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xffBBC4DC),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              if (!loading ||
                                  widget.type != SearchType.EXCLUSIVE)
                                Container(
                                  height: 30,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xffE5F7FE),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.type == SearchType.EXCLUSIVE
                                          ? "  \$ ${_checkFlightResponse?.total}"
                                          : '\$ ${widget.flight.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xff00aeef),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              if (loading &&
                                  widget.type == SearchType.EXCLUSIVE)
                                Shimmer.fromColors(
                                  baseColor: Color(0xFFBBC4DC),
                                  highlightColor: Color(0xFFBBC4DC),
                                  enabled: true,
                                  child: Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffE5F7FE),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.type == SearchType.META)
          Padding(
            padding: const EdgeInsets.only(
              top: 24.0,
              left: 46.0,
              right: 46.0,
            ),
            child: MetaFareDescription(),
          ),


//        (widget.stops.length > 0
//            ? Column(
//          children: widget.stops
//              .map(
//                (e) => Helper.durationLabelHideShow(e.duration) ? extedneLayover() : Container() ,
//          )
//              .toList(),
//        )
//            : Container()),
      ],
    )
    );
  }

  

  Widget buildOnboardDays() {
    if (isRoundTrip) {
      return TripDetailsOnBoardDays(flight: widget.flight,);
    } else {
      return Container();
    }
  }

  

  Widget getAppBarUI() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey),
      title: Text(
        "Trip Details",
        style: TextStyle(
          fontFamily: 'Gilroy',
          color: Color(0xff0E3178),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
      ),
      actions: [
        isShowingRouteDetail 
          ? Container(
          alignment: Alignment.centerRight,
          width: 65,
          height: 35,
          child: InkWell(
            onTap: () {
              _transitionController.reverse();
              setState(() {
                isShowingRouteDetail = false;
              });
              Future.delayed(Duration(milliseconds: _animationDuration ~/ 2), () {
                setState(() {
                  isWhiteBackground = false;
                });
              });
            },
            child: Container(
              height: 35,
              width: 65,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: SvgPicture.asset(
                "assets/svg/home/cancel_grey.svg",
                width: 15,
                height: 15,
              ),
            ),
          ),
        )
        : Container()
      ],
      leading: Container(
        height: 40.0,
        width: 40.0,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/back-arrow.png',
              scale: 28,
            )
          ),
        ),
      ),
    );
  }

  Function() getContinueAction() {
    print(widget.type);
    print("Select Type");
    switch (widget.type) {
      case SearchType.FARE:
        getFareAction();
        return null;
      case SearchType.EXCLUSIVE:
        getExclusiveAction();
        return null;
      case SearchType.META:
        getMetaAction();
        return null;
    }
    return null;
  }

  void getFareAction() {
    flyLinebloc.setCurrentTripData(CurrentTripData(
        flightResponse: null,
        flight: widget.flight,
        totalPrice: widget.flight.price,
        typeOfTripSelected: this.widget.typeOfTripSelected,
        selectedClassOfService: this.widget.selectedClassOfService,
        payment: null));
    print("pushing object");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsWrapper(
            routes: widget.routes,
            ch: widget.ch,
            bookingToken: widget.bookingToken,
            flight: widget.flight,
            selectedClassOfService: widget.selectedClassOfService,
            typeOfTripSelected: widget.typeOfTripSelected,
            retailInfo: widget.retailInfo,
            depDate: widget.depDate,
            arrDate: widget.arrDate,
            type: widget.type,
            ad: widget.ad),
      ),
    );
  }

  void getExclusiveAction() {
    flyLinebloc.setCurrentTripData(CurrentTripData(
        flightResponse: _checkFlightResponse,
        flight: widget.flight,
        totalPrice: _checkFlightResponse.total,
        typeOfTripSelected: this.widget.typeOfTripSelected,
        selectedClassOfService: this.widget.selectedClassOfService,
        payment: null));
    if (_checkFlightResponse != null && !loading)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetailsWrapper(
              routes: widget.routes,
              ch: widget.ch,
              bookingToken: widget.bookingToken,
              flight: widget.flight,
              selectedClassOfService: widget.selectedClassOfService,
              typeOfTripSelected: widget.typeOfTripSelected,
              retailInfo: widget.retailInfo,
              depDate: widget.depDate,
              arrDate: widget.arrDate,
              type: widget.type,
              ad: widget.ad),
        ),
      );
  }

  Future<void> getMetaAction() async {
    if (kIsWeb) {
      final String url = 'https://api.flyline.io' + widget.flight.deepLink;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MetaBookScreen(
            url: widget.flight.deepLink,
            retailInfo: widget.flight.raw,
          ),
        ),
      );
    }
  }

  void getFareInit() {}

  void getExclusiveInit() {
    checkFlight();
  }

  void getMetaInit() {}
}
