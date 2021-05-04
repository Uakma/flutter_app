import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/screens/auto_pilot/auto_pilot_confirmed.dart';
import 'package:motel/screens/auto_pilot/trip_date_preferences.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/screens/home/local_widgets/blue_button.dart';
import 'package:motel/screens/introduction/introductionScreen.dart';
import 'package:motel/screens/log_in/log_in.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/widgets/round_secondary_button.dart';
import 'package:motel/models/price_data.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:motel/widgets/web_bottom_widget.dart';
import 'package:motel/widgets/web_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../confirm_reservation.dart';
import '../flight_preferences.dart';
import '../pricing_preferences.dart';
import '../time_preferences.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class ReservationsDetailsWrapper extends StatefulWidget {
  static bool checkedPriceData = false;
  ReservationsDetailsWrapper({
    Key key
  }) : super(key: key);

  @override
  _ReservationsDetailsWrapperState createState() =>
      _ReservationsDetailsWrapperState();
}

class _ReservationsDetailsWrapperState extends State<ReservationsDetailsWrapper>
    with SingleTickerProviderStateMixin {
  PageController _controller = PageController(initialPage: 0);

  AnimationController _animationController;
  Animation<double> _animation;

  List<String> _pageTitles = [
    "Select Trip Dates",
    "Pricing Preferences",
    "Flight Preferences",
    "Time Preferences",
    "Confirm Reservation",
  ];

  int _currentPage = 0;
  @override
  void initState() {
    super.initState();

    ReservationsDetailsWrapper.checkedPriceData = false;

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    // Default Values
    flyLinebloc.setProbability(60);
    flyLinebloc.setMaxPrice(550);
    flyLinebloc.getPriceData(flyLinebloc.departureLocation.code, flyLinebloc.arrivalLocation.code, "", flyLinebloc.outAdults.value.toString(), flyLinebloc.outChildren.value.toString());
  }

  double webBodyHeight() {
    if (_animation.value < 0.25) {
      return 350;
    } else if (_animation.value < 0.5) {
      return 532;
    } else {
      return 516;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: ScreenTypeLayout(
        mobile:  buildMobileContent(),
        desktop: buildWebContent(),
      ),
    );
  }

  Widget buildMobileContent() {
    return Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        appBar: PreferredSize(
          preferredSize:
              Size(double.infinity, AppBar().preferredSize.height + 40),
          child: AppBar(
            title: Text(
              _pageTitles[(_animation.value * _pageTitles.length).round()],
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff0e3178),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: _back,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/back-arrow.png',
                  scale: 28,
                ),
              ),
            ),
            actions: [
              _currentPage == 0?
              Container(
                alignment: Alignment.centerRight,
                height: AppBar().preferredSize.height + 10,
                margin: EdgeInsets.only(right: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      setState(() {
                        ReservationsDetailsWrapper.checkedPriceData = !ReservationsDetailsWrapper.checkedPriceData;
                      });
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        child: Center(
                            child: Image.asset(
                              ReservationsDetailsWrapper.checkedPriceData?'assets/images/chart-button.png':'assets/images/chart-button-disabled.png',
                              scale: 2,
                            )
                        )
                    ),
                  ),
                ),
              ): Container(),
            ],
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 1.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${_currentPage + 1} of ${_pageTitles.length}  ',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff0e3178),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          TextSpan(
                            text: "Steps",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff8e969f),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  LinearProgressIndicator(
                    value: _animation.value + (1 / _pageTitles.length),
                    backgroundColor: Color.fromRGBO(231, 233, 240, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (page) => _currentPage = page,
                children: <Widget>[
                  TripDatePreferences(),
                  PricingPreferences(),
                  FlightPreferences(),
                  TimePreferences(),
                  ConfirmReservation(),
                ],
              ),
            ),



            Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Color.fromRGBO(
                        247, 249, 252, 1),),
                  ),
                  color: Colors.white
              ),
              child: FlatButton(
                onPressed: () {
                  if ( _currentPage >= _pageTitles.length - 1 ){
                    _confirm();
                  }
                  else{
                    _next();
                  }
                },
                splashColor: Colors.transparent,
                color: Color.fromRGBO(0, 174, 239, 1),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                ),
                padding: EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
                child: Text(
                  _currentPage >= _pageTitles.length - 1
                      ? 'Confirm Reservation'
                      : 'Next',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
            // SizedBox(height: 16),

          ],
        ),
      );
  }

  Widget buildWebContent() {
    _pageTitles = [
      "Set Max Price Preference",
      "Set Flight Preferences",
      "Set Time Preferences",
      "Confirm Reservation",
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: webBodyHeight(),
                      width: 460.w,
                      child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 38.w, bottom: 5.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Step ',
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(187, 196, 220, 1),
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        )
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '${(_animation.value * 4 + 1).toStringAsFixed(0)} of 4',
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(14, 49, 120, 1),
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        )
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                )
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Autopilot Probability',
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
                                      _pageTitles[(_animation.value * 4).round()],
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
                                  child: StreamBuilder(
                                    stream: flyLinebloc.outProbability,
                                    builder: (context, snapshot) {
                                      String valueString = '0%';
                                      var hexColor = "#FE8930";
                                      if (snapshot.hasData) {
                                        valueString = snapshot.data.toInt().toString() + "%";
                                        if (snapshot.data <= 33.33) {
                                          hexColor = "#FF001E";
                                        } else
                                        if (snapshot.data >= 33.33 && snapshot.data <= 66.66) {
                                          hexColor = "#FE8930";
                                        } else if (snapshot.data >= 66.66) {
                                          hexColor = "#44CF57";
                                        }
                                      }
                                      return Text(
                                        valueString,
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontSize: 24.h,
                                          color: HexColor(hexColor),
                                          fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.right,
                                      );
                                    },
                                  ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 6.h,
                          margin: EdgeInsets.only(top: 11.h, bottom: 26.h),
                          child: LinearProgressIndicator(
                            value: _animation.value + (1 / _pageTitles.length),
                            backgroundColor: Color.fromRGBO(231, 233, 240, 1),
                          ),
                        ),
                        Expanded(
                          child: PageView(
                            controller: _controller,
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (page) => _currentPage = page,
                            children: <Widget>[
                              PricingPreferences(),
                              FlightPreferences(),
                              TimePreferences(),
                              ConfirmReservation(),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.w, bottom: 16.w),
                          width: MediaQuery.of(context).size.width,
                          child: FlatButton(
                            onPressed: () {
                              if ( _currentPage >= _pageTitles.length - 1 ){
                                _confirm();
                              }
                              else{
                                _next();
                              }
                            },
                            splashColor: Colors.transparent,
                            color: Color.fromRGBO(64, 206, 83, 1),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.w),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
                            child: Text(
                              _currentPage >= _pageTitles.length - 1
                                  ? 'Confirm Reservation'
                                  : 'Next',
                              style: TextStyle(
                                  fontSize: 18.w,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        // SizedBox(height: 16),

                      ],
                    ),
                    ),
                    WebBottomWidget()
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }

  Future<bool> _back() async {
    // if ((_animation.value * _pageTitles.length).round() == 0)

    // if initial screen then pop to previous screen
    if (_currentPage <= 0) Navigator.of(context).pop();

    await _controller.previousPage(
      duration: Duration(milliseconds: 200),
      curve: ElasticInCurve(),
    );
    await _animationController
        .animateTo(_animation.value - (1 / _pageTitles.length));

    setState(() {});
    return Future.value(_currentPage < 0);
  }

  void _next() async {
// _animationController
    //     .animateTo(_animation.value + (1 / _pageTitles.length))
    //     .then((_) => _controller
    //         .nextPage(
    //           duration: Duration(milliseconds: 200),
    //           curve: ElasticInCurve(),
    //         )
    //         .then((_) => setState(() {})));

    // if (_controller.page >= _pageTitles.length - 1) return;

    if (_controller.page == 0 && flyLinebloc.departureDate == null) {
      return;
    }

    await _controller.nextPage(
      duration: Duration(milliseconds: 200),
      curve: ElasticInCurve(),
    );
    await _animationController
        .animateTo(_animation.value + 1 / _pageTitles.length);
    setState(() {});
  }

  void _confirm() {
    flyLinebloc
        .createAutopilot(
      flyLinebloc.departureLocation,
      flyLinebloc.arrivalLocation,
      flyLinebloc.departureDate,
      flyLinebloc.returnDate,
      flyLinebloc.outAdults.value,
      flyLinebloc.outChildren.value,
      flyLinebloc.outMaxPrice.value,
      flyLinebloc.preferredAirlines,
      flyLinebloc.departureStartTime,
      flyLinebloc.departureEndTime,
      flyLinebloc.returnStartTime,
      flyLinebloc.returnEndTime,
      false,
      false,
      flyLinebloc.flightPreferences,
    )
        .then((value) {
      if (value['success'] == true) {
        flyLinebloc.setDepartureLocation(null);
        flyLinebloc.setArrivalLocation(null);
        flyLinebloc.setDepartureDate(null);
        flyLinebloc.setReturnDate(null);
        flyLinebloc.setPreferredAirlines(null);
        flyLinebloc.setDepartureStartTime(null);
        flyLinebloc.setDepartureEndTime(null);
        flyLinebloc.setReturnStartTime(null);
        flyLinebloc.setReturnEndTime(null);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ConfirmedScreen()),
        );
      } else {
        if (value['message'] != null) {
          _showErrorMsg(value['message']);
        } else {
          _showErrorMsg('Unknown error');
        }
      }
    }).catchError((e) => print(e));
  }

  void _showErrorMsg(String msg) {
    Flushbar(
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blueAccent,
      ),
      messageText: Text(
        msg,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
      duration: Duration(seconds: 3),
      isDismissible: true,
    )..show(context);
  }
}
