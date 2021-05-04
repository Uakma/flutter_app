import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_board_days.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_travel_details.dart';
import 'package:motel/screens/trip_details/trip_details_route_popup.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/helper/helper.dart';
import 'package:motel/models/book_request.dart' as BookRequest;
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/current_trip_data.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/home/home.dart';
import 'package:motel/screens/booking_process/booking_complete.dart';
import 'package:motel/screens/flights_results/local_widgets/flight_info_card.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/flight_card_detail_row.dart';
import 'package:motel/widgets/loading_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final List<FlightRouteObject> routes;
  final int ch;
  final String bookingToken;
  final int typeOfTripSelected;
  final String selectedClassOfService;
  final FlightInformationObject flight;
  final Map<String, dynamic> retailInfo;
  final String depDate;
  final String arrDate;
  final SearchType type;
  final int ad;

  ConfirmBookingScreen({
    Key key,
    int numberofpass,
    this.routes,
    this.ch,
    this.bookingToken,
    this.typeOfTripSelected,
    this.selectedClassOfService,
    this.flight,
    this.retailInfo,
    this.depDate,
    this.arrDate,
    this.type,
    this.ad,
  }) : super(key: key);

  @override
  _ConfirmBookingScreenState createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen>
    with TickerProviderStateMixin {
  double priceOnPassenger = 0;
  double priceOnBaggage = 0;
  double tripTotal = 0;
  bool _clickedBookFlight = false;

  TextEditingController promoCodeController;
  TextEditingController nameOnCardController;
  TextEditingController creditController;
  TextEditingController expDateController;
  TextEditingController ccvController;
  TextEditingController emailAddressController;
  TextEditingController phoneNumberController;

  CheckFlightResponse get flightResponse =>
      flyLinebloc.getCurrentTripData.flightResponse;

  bool loading = false;

  int get departureStopOvers => widget.flight.departures.length - 1;

  int get returnStopOvers => widget.flight.returns.length - 1;

  bool get isRoundTrip => widget.typeOfTripSelected == 0;

  List<StopDetails> stops;

  @override
  void initState() {
    this.getAccountInfo();
    super.initState();

    flyLinebloc.bookingProgressSubject.listen((loading) {
      if (loading) {


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoadingScreen(
              message: "Confirming Reservation",
            ),
          ),
        );

//        showDialog(
//          context: context,
//          builder: (_) => Material(
//            type: MaterialType.transparency,
//            child: LoadingScreen(
//              message: "Confirming your Reservation",
//            ),
//          ),
//        );
      } else {
        Navigator.pop(context);
      }
    });


    flyLinebloc.bookFlight.stream.listen((Map onData) {
      print("BOOK FLIGHT STREAM LISTEN DATA: " + onData.toString());
      
      if (onData != null && _clickedBookFlight) {
        if (onData['status'] == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BookingCompletePage()),
            (route) => ModalRoute.of(context).isFirst,
          );
        } else {
          Alert(
            context: context,
            title:
                "There seemed to be an error when booking your flight, try again or contact FlyLine support, hello@flyline.io",
            buttons: [
              DialogButton(

                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Gilroy', fontWeight: FontWeight.w600,),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ),
                  );
                },
                width: 120,
              ),
            ],
          ).show();
        }
      }
    });
  }

  @override
  void dispose() {
    _clickedBookFlight = false;
    super.dispose();
  }

  void getAccountInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      promoCodeController = TextEditingController();
      nameOnCardController = TextEditingController();
      creditController = TextEditingController();
      expDateController = TextEditingController();
      ccvController = TextEditingController();
      emailAddressController = TextEditingController();
      phoneNumberController = TextEditingController();

      emailAddressController.text = prefs.getString('email');
      phoneNumberController.text = prefs.getString('phone_number');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenTypeLayout(
        mobile: buildMobileContent(),
        desktop: buildWebContent(),
      ),
    );
  }

  Widget buildMobileContent() {
    return Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                padding: EdgeInsets.only(left: 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                color: Color.fromRGBO(64, 206, 83, 0.1),
                                onPressed: () {},
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.check,
                                        color: Color.fromRGBO(64, 206, 83, 1),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Free cancellation within the next 24 hours!',
                                        style: TextStyle(
                                          color: Color.fromRGBO(64, 206, 83, 1),
                                          fontSize: 14,
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
                      ),
                      FlightInfoCard(
                        flight: widget.flight,
                        type: widget.flight.kind == null
                            ? SearchType.EXCLUSIVE
                            : (widget.flight.kind == "tripadvisor" ||
                                    widget.flight.kind == "skyscanner" ||
                                    widget.flight.kind == "kayak")
                                ? SearchType.META
                                : SearchType.FARE,
                        typeOfTripSelected: widget.typeOfTripSelected,
                        ad: widget.ad,
                        children: widget.ch,
                        depDate: widget.depDate,
                        arrDate: widget.arrDate,
                        selectedClassOfService: widget.selectedClassOfService,
                        reviewPage: true,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Passenger(s)",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xff0e3178),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Passenger ${index + 1} :",
                                            style: TextStyle(
                                              fontFamily: 'Gilroy',
                                              color: Color(0xffBBC4DC),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          Text(
                                            flyLinebloc
                                                    .getCurrentTripData
                                                    .travelersInfo[index]
                                                    .firstName +
                                                " " +
                                                flyLinebloc
                                                    .getCurrentTripData
                                                    .travelersInfo[index]
                                                    .lastName,
                                            style: TextStyle(
                                              fontFamily: 'Gilroy',
                                              color: Color(0xff3333333),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 15),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    0, 174, 239, .1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Text(
                                              flyLinebloc.getCurrentTripData
                                                  .selectedClassOfService,
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                color: Color.fromRGBO(
                                                    0, 174, 239, 1),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: flyLinebloc
                                      .getCurrentTripData.travelersInfo.length,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Trip Total : ",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xff0e3178),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  StreamBuilder<CurrentTripData>(
                                    stream: flyLinebloc.outCurrentTripData,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          " \$" +
                                              (snapshot.data.totalPrice +
                                                      snapshot
                                                          .data.travelersInfo
                                                          .map((e) =>
                                                              (e?.handBag?.price?.amount ?? 0.00) +
                                                              (e?.holdBag?.price
                                                                      ?.amount ??
                                                                  0.00) +
                                                              ((e?.autoChecking ??
                                                                      false)
                                                                  ? (flyLinebloc
                                                                          .account
                                                                          .isPremium)
                                                                      ? 0.00
                                                                      : 5.00
                                                                  : 0))
                                                          .toList()
                                                          .reduce((value,
                                                                  element) =>
                                                              value + element))
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            color:
                                                Color.fromRGBO(64, 206, 83, 1),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Trip Price :",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xffBBC4DC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(0, 174, 239, .1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Text(
                                        '\$${flyLinebloc.getCurrentTripData.totalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Baggage :",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xffBBC4DC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(0, 174, 239, .1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Text(
                                        '\$${flyLinebloc.getCurrentTripData.travelersInfo.first?.holdBag?.price?.amount?.toStringAsFixed(2) ?? '0.00'}',
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Auto Check-In :",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xffBBC4DC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(0, 174, 239, .1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Text(
                                        "Free",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Booking Fee :",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xffBBC4DC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(0, 174, 239, .1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        // ignore: unrelated_type_equality_checks
                                        child: (widget.flight.kind == null)
                                            ? Text(
                                                "\$10.00",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Color.fromRGBO(
                                                      0, 174, 239, 1),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              )
                                            : Text(
                                                "\$5.00",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Color.fromRGBO(
                                                      0, 174, 239, 1),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              height: 90,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () => _bookFlight(),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      color: Color.fromRGBO(64, 206, 83, 1),
                      child: Text(
                        "Confirm Booking",
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
        ],
      );
  }

  Widget buildWebContent() {
    String departureStopOversText = (departureStopOvers > 0
        ? (departureStopOvers > 1
            ? "$departureStopOvers Stopovers"
            : "$departureStopOvers Stopover")
        : "Direct");

    String returnStopOversText = (returnStopOvers > 0
        ? (returnStopOvers > 1
            ? "$returnStopOvers Stopovers"
            : "$returnStopOvers Stopover")
        : "Direct");

    stops = [
                ...List.from(widget.flight.departures)
                  ..remove(widget.flight.departures.last)
              ]
                  .map(
                    (e) => StopDetails(
                  to: e.flyTo,
                  duration: e.duration,
                  city: e.cityTo
                ),
              )
                  .toList();

    return Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10.h),
                        margin: EdgeInsets.symmetric(
                            vertical: 28.h),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                padding: EdgeInsets.only(left: 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                color: Color.fromRGBO(64, 206, 83, 0.1),
                                onPressed: () {},
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.check,
                                        color: Color.fromRGBO(64, 206, 83, 1),
                                        size: 16.h,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Free cancellation within the next 24 hours!',
                                        style: TextStyle(
                                          color: Color.fromRGBO(64, 206, 83, 1),
                                          fontSize: 12.w,
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
                              date: DateFormat('${DateFormat.MONTH}, ${DateFormat.DAY}').format(DateTime.parse(widget.depDate)),
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
                                          stops: stops,
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
                                child: TripDetailsOnBoardDays(flight: widget.flight),
                              ),
                            if (isRoundTrip)
                              TripDetailsTravelDetails(
                                dateText: "Return",
                                date: DateFormat('${DateFormat.MONTH}, ${DateFormat.DAY}').format(DateTime.parse(widget.arrDate)),
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
                                          stops: stops,
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
                      Container(
                        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        child: Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.w),
                              border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(237, 238, 246, 1),
                              )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Passenger(s)",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color.fromRGBO(14, 49, 120, 1),
                                        fontSize: 18.w,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Passenger ${index + 1} :",
                                            style: TextStyle(
                                              fontFamily: 'Gilroy',
                                              color: Color.fromRGBO(177, 177, 177, 1),
                                              fontSize: 14.w,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          Text(
                                            flyLinebloc
                                                    .getCurrentTripData
                                                    .travelersInfo[index]
                                                    .firstName +
                                                " " +
                                                flyLinebloc
                                                    .getCurrentTripData
                                                    .travelersInfo[index]
                                                    .lastName,
                                            style: TextStyle(
                                              fontFamily: 'Gilroy',
                                              color: Color.fromRGBO(58, 63, 92, 1),
                                              fontSize: 14.w,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 15),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    0, 174, 239, .1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Text(
                                              flyLinebloc.getCurrentTripData
                                                  .selectedClassOfService,
                                              style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                color: Color.fromRGBO(
                                                    0, 174, 239, 1),
                                                fontSize: 14.w,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: flyLinebloc
                                      .getCurrentTripData.travelersInfo.length,
                                ),
                              ],
                            ),
                          ),
                      ),
                      Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.w),
                              border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(237, 238, 246, 1),
                              )
                            ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Trip Total : ",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color.fromRGBO(14, 49, 120, 1),
                                      fontSize: 18.w,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  StreamBuilder<CurrentTripData>(
                                    stream: flyLinebloc.outCurrentTripData,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          " \$" +
                                              (snapshot.data.totalPrice +
                                                      snapshot
                                                          .data.travelersInfo
                                                          .map((e) =>
                                                              (e?.handBag?.price?.amount ?? 0.00) +
                                                              (e?.holdBag?.price
                                                                      ?.amount ??
                                                                  0.00) +
                                                              ((e?.autoChecking ??
                                                                      false)
                                                                  ? (flyLinebloc
                                                                          .account
                                                                          .isPremium)
                                                                      ? 0.00
                                                                      : 5.00
                                                                  : 0))
                                                          .toList()
                                                          .reduce((value,
                                                                  element) =>
                                                              value + element))
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            color:
                                                Color.fromRGBO(64, 206, 83, 1),
                                            fontSize: 18.w,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Trip Price :",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color.fromRGBO(177, 177, 177, 1),
                                        fontSize: 14.w,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(0, 174, 239, .1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Text(
                                        '\$${flyLinebloc.getCurrentTripData.totalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 14.w,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Baggage :",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color.fromRGBO(177, 177, 177, 1),
                                        fontSize: 14.w,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(0, 174, 239, .1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Text(
                                        '\$${flyLinebloc.getCurrentTripData.travelersInfo.first?.holdBag?.price?.amount?.toStringAsFixed(2) ?? '0.00'}',
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 14.w,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Auto Check-In :",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color.fromRGBO(177, 177, 177, 1),
                                        fontSize: 14.w,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(0, 174, 239, .1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Text(
                                        "Free",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(0, 174, 239, 1),
                                          fontSize: 14.w,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Booking Fee :",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color.fromRGBO(177, 177, 177, 1),
                                        fontSize: 14.w,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(0, 174, 239, .1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        // ignore: unrelated_type_equality_checks
                                        child: (widget.flight.kind == null)
                                            ? Text(
                                                "\$10.00",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Color.fromRGBO(
                                                      0, 174, 239, 1),
                                                  fontSize: 14.w,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              )
                                            : Text(
                                                "\$5.00",
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  color: Color.fromRGBO(
                                                      0, 174, 239, 1),
                                                  fontSize: 14.w,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void _bookFlight() async {
    setState(() {
      _clickedBookFlight = true;
    });
    createBookRequest().passengers.forEach((element) {print("PERSON " + element.jsonSerialize.toString());});
    print("BOOK REQUEST " + createBookRequest().toString());
    flyLinebloc.book(createBookRequest());
  }

  Widget pageIndicator() {
    return new Container(
        // width: 375,
        height: 4,
        decoration: BoxDecoration(color: Color(0xff0e3178)));
  }

  Widget getCheckoutUI() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          // margin: const EdgeInsets.only(top: 8, bottom: 8),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            left: 16.0,
          ),
          child: new Text(
            "Payment Info",
            style: TextStyle(
              fontFamily: 'AvenirNext',
              color: Color(0xff3a3f5c),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: promoCodeController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Promo Code",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: nameOnCardController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Name on Card",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: creditController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Credit Card Number",
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 8,
                ),
                decoration: new BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: expDateController,
                    textAlign: TextAlign.start,
                    onChanged: (String txt) {},
                    onTap: () {},
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    cursorColor: AppTheme.getTheme().primaryColor,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "Exp Date",
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 8,
                  right: 16,
                ),
                decoration: new BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: ccvController,
                    textAlign: TextAlign.start,
                    onChanged: (String txt) {},
                    onTap: () {},
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    cursorColor: AppTheme.getTheme().primaryColor,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "CCV",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: emailAddressController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Email Address",
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: phoneNumberController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Phone Number",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getTripDetails() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xF6F6F6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 16.0, top: 20),
                          width: MediaQuery.of(context).size.width / 2,
                          child: new Text(
                            "Trip Summary",
                            style: TextStyle(
                              fontFamily: 'AvenirNext',
                              color: Color(0xff3a3f5c),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.getTheme().backgroundColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: new Text(
                                      "Passengers:  ",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xff8e969f),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          flyLinebloc.numberOfPassengers
                                                  .toString() +
                                              ' Adult',
                                          style: TextStyle(
                                            fontFamily: 'AvenirNext',
                                            color: Color(0xff3a3f5c),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                          child: Container(
                                            child: Text(
                                              "  + Add More",
                                              style: TextStyle(
                                                fontFamily: 'AvenirNext',
                                                color: Color(0xff00aeef),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                          onTap: () => {}
                                          //getAddAnotherPassenger(),
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Container(
                                    child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Trip Price:",
                                        style: TextStyle(
                                          fontFamily: 'AvenirNext',
                                          color: Color(0xff8e969f),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        // Container(),
                                        Container(
                                          height: 30,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xffE5F7FE),
                                          ),
                                          child: Center(
                                            child: Text(
                                              Helper.cost(
                                                  flightResponse.total,
                                                  flightResponse
                                                      .conversion.amount,
                                                  flightResponse.total),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: 'AvenirNext',
                                                color: Color(0xff00aeef),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                          //child: Text("\$ " + widget.flight.price.toString()),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: new Text(
                                        "Bagage:",
                                        style: TextStyle(
                                          fontFamily: 'AvenirNext',
                                          color: Color(0xff8e969f),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffE5F7FE),
                                    ),
                                    child: Center(
                                      child: Text(
                                        Helper.formatNumber(priceOnBaggage),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'AvenirNext',
                                          color: Color(0xff00aeef),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Container(
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
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top / 2),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Review and Book",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff0e3178),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "4 of 4 ",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff0e3178),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            )),
                        TextSpan(
                            text: "Steps",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff8e969f),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            )),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BookRequest.BookRequest createBookRequest() {
    BookRequest.Baggage baggage =
        BookRequest.Baggage(List<BookRequest.BaggageItem>());

    List<BookRequest.Passenger> passengers = List();

    Map<String, List<int>> carryOnPassengers = Map();
    List<BagItem> carryOns = List();

    Map<String, List<int>> checkedBagagePassengers = Map();
    List<BagItem> checkedBagages = List();

    flyLinebloc.getCurrentTripData.travelersInfo.forEach((p) {
      BookRequest.Passenger passenger = BookRequest.Passenger(
          DateFormat("MM/dd/yyyy").parse(p.dob),
          p.passportId,
          p.ageCategory,
          p.passportExpiration.isNotEmpty ? DateFormat("dd/MM/yyyy").parse(p.passportExpiration) : null,
          p.firstName,
          "US",
          p.lastName,
          p.title);

      passengers.add(passenger);

      if (p.handBag != null &&
          p.handBag.conditions.passengerGroups.indexOf(p.ageCategory) != -1) {
        if (carryOnPassengers.containsKey(p.handBag.uuid)) {
          carryOnPassengers.update(p.handBag.uuid, (List<int> val) {
            val.add(passengers.length - 1);
            return val;
          });
        } else {
          carryOns.add(p.handBag);
          carryOnPassengers.addAll({
            p.handBag.uuid: [passengers.length - 1]
          });
        }
      }

      if (p.holdBag != null &&
          p.holdBag.conditions.passengerGroups.indexOf(p.ageCategory) != -1) {
        if (checkedBagagePassengers.containsKey(p.holdBag.uuid)) {
          checkedBagagePassengers.update(p.holdBag.uuid, (List<int> val) {
            val.add(passengers.length - 1);
            return val;
          });
        } else {
          checkedBagages.add(p.holdBag);
          checkedBagagePassengers.addAll({
            p.holdBag.uuid: [passengers.length - 1]
          });
        }
      }
    });

    carryOns.forEach((item) {
      BookRequest.Combination combination = BookRequest.Combination(item);

      baggage.add(new BookRequest.BaggageItem(
          combination, carryOnPassengers[item.uuid]));
    });

    checkedBagages.forEach((item) {
      BookRequest.Combination combination = BookRequest.Combination(item);

      baggage.add(new BookRequest.BaggageItem(
          combination, checkedBagagePassengers[item.uuid]));
    });

    BookRequest.BookRequest bookRequest = BookRequest.BookRequest(
        baggage,
        BookRequest.BookRequest.DEFAULT_CURRENCY,
        BookRequest.BookRequest.DEFAULT_LANG,
        BookRequest.BookRequest.DEFAULT_LOCALE,
        flyLinebloc.getCurrentTripData.payment,
        passengers,
        flyLinebloc.getCurrentTripData.flight.raw,
        flyLinebloc.getCurrentTripData.flight.bookingToken,
        flyLinebloc.getCurrentTripData.flight.source ?? FlightType.KIWI);

    return bookRequest;
  }

  BookRequest.Payment getPayment() => BookRequest.Payment(
      creditController.text,
      ccvController.text,
      emailAddressController.text,
      expDateController.text,
      nameOnCardController.text,
      phoneNumberController.text,
      promoCodeController.text);
}
