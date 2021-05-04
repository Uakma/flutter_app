import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/models/book_request.dart' as BookRequest;
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/screens/home/local_widgets/blue_button.dart';
import 'package:motel/screens/introduction/introductionScreen.dart';
import 'package:motel/screens/log_in/log_in.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_booking_button.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/models/current_trip_data.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/screens/booking_process/baggage_details.dart';
import 'package:motel/screens/booking_process/confirm_booking.dart';
import 'package:motel/screens/booking_process/payment_details.dart';
import 'package:motel/screens/booking_process/personal_details.dart';
import 'package:motel/screens/trip_details/local_widgets/trip_details_price_footer.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/loading_screen.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:motel/widgets/web_bottom_widget.dart';
import 'package:motel/widgets/web_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TripDetailsWrapper extends StatefulWidget {

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

  const TripDetailsWrapper({
    Key key,
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
  _TripDetailsWrapperState createState() => _TripDetailsWrapperState();
}

class _TripDetailsWrapperState extends State<TripDetailsWrapper>
    with SingleTickerProviderStateMixin {

  PageController _controller = PageController(initialPage: 0);

  AnimationController _animationController;
  Animation<double> _animation;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int get numberOfPassengers => flyLinebloc.numberOfPassengers;


  final List<String> pageTitles = [
    "Personal Details",
    "Baggage & Extras",
    "Payment Information",
    "Review and Book",
  ];

  void _showSnackBar(message, context) {
    final snackBar =
    SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _bookFlight() async {
    createBookRequest().passengers.forEach((element) {print("PERSON " + element.jsonSerialize.toString());});
    print("BOOK REQUEST " + createBookRequest().toString());
    flyLinebloc.book(createBookRequest());
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  double webBodyHeight(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return (400 * flyLinebloc.numberOfPassengers).toDouble();
      case 1:
        return 700;
      case 2:
      case 3:
        return 400;
    }
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
      // key: _scaffoldKey,
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
            child: Container(
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
                                      pageTitles[(_animation.value * 4).round()],
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
                            height: 6.h,
                            margin: EdgeInsets.only(top: 11.h, bottom: 13.h),
                            child: LinearProgressIndicator(
                              value: _animation.value + 0.25,
                              backgroundColor: Color.fromRGBO(231, 233, 240, 1),
                            ),
                          ),
                          Container(
                            height: 500,
                            child: buildWebBody(),
                          ),
                          TripDetailsBookingButton(
                            title: _animation.value == 0.75 ? 'Next' : 'Continue to Book', 
                            onPressed: () {
                            if (_controller.page == 0.0) {
                              if (flyLinebloc.getCurrentTripData.travelersInfo != null) {
                                for (int index = 0; index < this.numberOfPassengers; index++) {
                                  if(flyLinebloc.getCurrentTripData.travelersInfo[index].firstName.isEmpty){
                                    _showSnackBar("Enter Traveler First Name", context);
                                  } else if (flyLinebloc.getCurrentTripData.travelersInfo[index].lastName.isEmpty) {
                                    _showSnackBar("Enter Traveler Last Last", context);
                                  } else if (flyLinebloc.getCurrentTripData.travelersInfo[index].dob.isEmpty) {
                                    _showSnackBar("Enter Traveler Date of Birth", context);
                                  } else if (flyLinebloc.getCurrentTripData.travelersInfo[index].dob.isEmpty) {
                                    _showSnackBar("Enter Traveler Gender", context);
                                  } else {
                                  _animationController
                                      .animateTo(_animation.value + 0.25)
                                      .then((value) {
                                        _controller.nextPage(
                                          duration: Duration(milliseconds: 200),
                                          curve: ElasticInCurve(),
                                        );
                                      }).then((_) => setState(() {}));
                                  }
                                }
                              }
                            } else if (_controller.page == 2.0) {
                              if (SortOptions.paymentInfo.nameOfCard == null) {
                                _showSnackBar("Enter Name on Card", context);
                              } else if (SortOptions.paymentInfo.creditCart == null) {
                                _showSnackBar("Enter Credit Card Number", context);
                              } else if (SortOptions.paymentInfo.expDate == null) {
                                _showSnackBar("Enter Exp Date (MM/YY)", context);
                              } else if (SortOptions.paymentInfo.cvv == null) {
                                _showSnackBar("Enter Cart CVV", context);
                              } else {
                                _animationController
                                  .animateTo(_animation.value + 0.25)
                                  .then((value) {
                                    _controller.nextPage(
                                      duration: Duration(milliseconds: 200),
                                      curve: ElasticInCurve(),
                                    );
                                  }).then((_) => setState(() {}));
                              }
                            } else if (_controller.page == 3.0) {
                              _bookFlight();
                            } else {
                              _animationController
                                .animateTo(_animation.value + 0.25)
                                .then((value) {
                                  _controller.nextPage(
                                    duration: Duration(milliseconds: 200),
                                    curve: ElasticInCurve(),
                                  );
                                }).then((_) => setState(() {}));
                            }
                          },),
                        ],
                      ),
                    ),
                    WebBottomWidget()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildWebBody() {
    return PageView(
      controller: _controller,
      children: <Widget>[
        PersonalDetailsScreen(),
        BaggageDetailsScreen(
          type: widget.flight.source ?? FlightType.KIWI,
          onEnd: () => _animationController
            .animateTo(_animation.value + 0.25)
            .then((value) => _controller
            .nextPage(
              duration: Duration(milliseconds: 200),
              curve: ElasticInCurve(),
            )
            .then((_) => setState(() {}))),
        ),
        PaymentDetailsScreen(
          controller: _controller,
        ),
        ConfirmBookingScreen(
          routes: widget.routes,
          ch: widget.ch,
          bookingToken: widget.bookingToken,
          typeOfTripSelected: widget.typeOfTripSelected,
          selectedClassOfService: widget.selectedClassOfService,
          flight: widget.flight,
          retailInfo: widget.retailInfo,
          depDate: widget.depDate,
          arrDate: widget.arrDate,
          type: widget.type,
          ad: widget.ad
        ),
      ],
    );
  }

  Widget buildMobileContent() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF7F9FC),
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, AppBar().preferredSize.height + 40),
        child: AppBar(
          title: Text(
            pageTitles[(_animation.value * 4).round()],
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
            onTap: () {
              if ((_animation.value * 4).round() == 0)
                Navigator.of(context).pop();
              _animationController
                  .animateTo(_animation.value - 0.25)
                  .then((value) => _controller
                      .previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: ElasticInCurve(),
                      )
                      .then((value) => setState(() {})));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/back-arrow.png',
                scale: 28,
              ),
            ),
          ),
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
                              '${(_animation.value * 4 + 1).toStringAsFixed(0)} of 4 ',
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
                  value: _animation.value + 0.25,
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
              children: <Widget>[
                PersonalDetailsScreen(),
                BaggageDetailsScreen(
                  type: widget.flight.source ?? FlightType.KIWI,
                  onEnd: () => _animationController
                      .animateTo(_animation.value + 0.25)
                      .then((value) => _controller
                          .nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: ElasticInCurve(),
                          )
                          .then((_) => setState(() {}))),
                ),
                PaymentDetailsScreen(
                  controller: _controller,
                ),
                ConfirmBookingScreen(
                    routes: widget.routes,
                    ch: widget.ch,
                    bookingToken: widget.bookingToken,
                    typeOfTripSelected: widget.typeOfTripSelected,
                    selectedClassOfService: widget.selectedClassOfService,
                    flight: widget.flight,
                    retailInfo: widget.retailInfo,
                    depDate: widget.depDate,
                    arrDate: widget.arrDate,
                    type: widget.type,
                    ad: widget.ad),
              ],
            ),
          ),
          if (_animation.value != 0.75 && _animation.value != 0.25)
            StreamBuilder<CurrentTripData>(
              stream: flyLinebloc.outCurrentTripData,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return TripDetailsPriceFooter(
                    total: snapshot.data.totalPrice +
                        snapshot.data.travelersInfo
                            .map((e) =>
                                (e?.handBag?.price?.amount ?? 0.00) +
                                (e?.holdBag?.price?.amount ?? 0.00) +
                                ((e?.autoChecking ?? false)
                                    ? (flyLinebloc.account.isPremium)
                                        ? 0.00
                                        : 5.00
                                    : 0))
                            .toList()
                            .reduce((value, element) => value + element),
                    onTap: () {
                      if (_controller.page == 0.0) {
                          if (flyLinebloc.getCurrentTripData.travelersInfo != null) {
                            for (int index = 0; index < this.numberOfPassengers; index++) {
                              if(flyLinebloc.getCurrentTripData.travelersInfo[index].firstName.isEmpty){
                                _showSnackBar("Enter Traveler First Name", context);
                              } else if (flyLinebloc.getCurrentTripData.travelersInfo[index].lastName.isEmpty) {
                                _showSnackBar("Enter Traveler Last Last", context);
                              } else if (flyLinebloc.getCurrentTripData.travelersInfo[index].dob.isEmpty) {
                                _showSnackBar("Enter Traveler Date of Birth", context);
                              } else if (flyLinebloc.getCurrentTripData.travelersInfo[index].dob.isEmpty) {
                                _showSnackBar("Enter Traveler Gender", context);
                              } else {
                              _animationController
                                  .animateTo(_animation.value + 0.25)
                                  .then((value) {
                                _controller.nextPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: ElasticInCurve(),
                                );
                              }).then((_) => setState(() {}));
                             }
                            }
                          }
                      } else if (_controller.page == 2.0) {
                        if (SortOptions.paymentInfo.nameOfCard == null){
                          _showSnackBar("Enter Name on Card", context);
                        } else if (SortOptions.paymentInfo.creditCart == null){
                          _showSnackBar("Enter Credit Card Number", context);
                        } else if (SortOptions.paymentInfo.expDate == null){
                          _showSnackBar("Enter Exp Date (MM/YY)", context);
                        } else if (SortOptions.paymentInfo.cvv == null){
                          _showSnackBar("Enter Cart CVV", context);
                        } else {
                          _animationController
                              .animateTo(_animation.value + 0.25)
                              .then((value) {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: ElasticInCurve(),
                            );
                          }).then((_) => setState(() {}));
                        }
                      } else {
                        _animationController
                            .animateTo(_animation.value + 0.25)
                            .then((value) {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: ElasticInCurve(),
                          );
                        }).then((_) => setState(() {}));
                      }
                    },
                  );
                return Container();
              },
            ),
        ],
      ),
    );
  }
}
