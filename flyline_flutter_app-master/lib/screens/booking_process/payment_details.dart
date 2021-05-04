import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/models/book_request.dart' as BookRequest;
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/current_trip_data.dart';
import 'package:motel/models/traveler_info.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final PageController controller;
  PaymentDetailsScreen({Key key, this.controller}) : super(key: key);

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}


class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {

  TextEditingController promoCodeController;
  TextEditingController nameOnCardController;
  TextEditingController creditController;
  TextEditingController expDateController;
  TextEditingController ccvController;
  TextEditingController emailAddressController;
  TextEditingController phoneNumberController;


  TravelerInfo _travelerInfo;

  CheckFlightResponse get flightResponse =>
      flyLinebloc.getCurrentTripData.flightResponse;

  @override
  void initState() {
    this.getAccountInfo();
    super.initState();

    widget.controller.addListener(() {
      if (widget.controller.page == 3.0) {
        print("object");
        CurrentTripData currentTripData = flyLinebloc.getCurrentTripData;
        currentTripData.payment = this.getPayment();
        flyLinebloc.setCurrentTripData(currentTripData);
      }
    });
  }

  @override
  void dispose() {
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
//      emailAddressController.text = prefs.getString('email');
//      phoneNumberController.text = prefs.getString('phone_number');
      emailAddressController.text = flyLinebloc.account.email;
      phoneNumberController.text = flyLinebloc.account.phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        new Expanded(
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        getCheckoutUI(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getCheckoutUI() {
    return ScreenTypeLayout(
      mobile: getMobileCheckoutUI(),
      desktop: getWebCheckoutUI(),
    );
  }

  Widget getMobileCheckoutUI() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          // margin: const EdgeInsets.only(top: 8, bottom: 8),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 30.0, left: 16.0, bottom: 20.0),
          child: new Text(
            "Payment Information",
            style: TextStyle(
              color: Color(0xff3333333),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 10),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
//            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: promoCodeController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {

              },
              onTap: () {

              },
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff333333),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: "Promo Code",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Gilroy",
                      color: Color(0xFFBBC4DC))),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(
            top: 0,
            bottom: 10,
            left: 16,
            right: 16,
          ),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
//            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: nameOnCardController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {
                  SortOptions.paymentInfo.nameOfCard = txt;
              },
              onTap: () {

              },
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff333333),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name on Card",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Gilroy",
                      color: Color(0xFFBBC4DC))),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 10),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
//            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: creditController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {
                SortOptions.paymentInfo.creditCart = txt;
              },
              onTap: () {},
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff333333),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: "Credit Card Number",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Gilroy",
                      color: Color(0xFFBBC4DC))),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 0,
                  bottom: 10,
                  left: 16,
                  right: 8,
                ),
                decoration: new BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
//                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: expDateController,
                    textAlign: TextAlign.start,
                    onChanged: (String txt) {
                      SortOptions.paymentInfo.expDate = txt;
                    },
                    // onTap: () {
                    //   DatePicker.showDatePicker(
                    //     context,
                    //     showTitleActions: true,
                    //     minTime: DateTime(
                    //       DateTime.now().year,
                    //       DateTime.now().month,
                    //     ),
                    //     maxTime: DateTime(
                    //       DateTime.now().year + 6,
                    //       DateTime.now().month,
                    //     ),
                    //     onConfirm: (date) {
                    //       expDateController.text =
                    //           Helper.getDateViaDate(date, 'MM/yy');
                    //     },
                    //     currentTime: DateTime.now(),
                    //     locale: LocaleType.en,
                    //   );
                    // },
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    cursorColor: AppTheme.getTheme().primaryColor,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: "Exp Date (MM/YY)",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Gilroy",
                            color: Color(0xFFBBC4DC))),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 0,
                  bottom: 10,
                  left: 8,
                  right: 16,
                ),
                decoration: new BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
//                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: ccvController,
                    textAlign: TextAlign.start,
                    onChanged: (String txt) {
                      SortOptions.paymentInfo.cvv = txt;
                    },
                    onTap: () {

                    },
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    cursorColor: AppTheme.getTheme().primaryColor,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: "CCV",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Gilroy",
                            color: Color(0xFFBBC4DC))),
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // margin: const EdgeInsets.only(top: 8, bottom: 8),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 30.0, left: 16.0, bottom: 20.0),
          child: new Text(
            "Contact Details",
            style: TextStyle(
              color: Color(0xff3333333),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 10),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
//            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: emailAddressController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff333333),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email Address",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Gilroy",
                      color: Color(0xFFBBC4DC))),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(
            top: 0,
            left: 16,
            right: 16,
          ),
          decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
//            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: phoneNumberController,
              textAlign: TextAlign.start,
              onChanged: (String txt) {},
              onTap: () {},
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff333333),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppTheme.getTheme().primaryColor,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: "Phone Number",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Gilroy",
                      color: Color(0xFFBBC4DC))),
            ),
          ),
        ),
      ],
    );
  }

  Widget getWebCheckoutUI() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(
          width: 2,
          color: Color.fromRGBO(237, 238, 246, 1)
        ),
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 30.w, left: 45.w, bottom: 20.h),
            child: new Text(
              "Payment Information",
              style: TextStyle(
                color: Color.fromRGBO(58, 63, 92, 1),
                fontSize: 16.w,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 45.w, right: 45.w, top: 0, bottom: 16.h),
            decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                color: Color.fromRGBO(237, 238, 246, 1)
              )
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
  //            padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: promoCodeController,
                textAlign: TextAlign.start,
                onChanged: (String txt) {

                },
                onTap: () {

                },
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff333333),
                  fontSize: 16.w,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: AppTheme.getTheme().primaryColor,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Promo Code",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Gilroy",
                        color: Color(0xFFBBC4DC))),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              top: 0,
              bottom: 16.h,
              left: 45.w,
              right: 45.w,
            ),
            decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                color: Color.fromRGBO(237, 238, 246, 1)
              )
            ),
            child: Container(
  //            padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: nameOnCardController,
                textAlign: TextAlign.start,
                onChanged: (String txt) {
                    SortOptions.paymentInfo.nameOfCard = txt;
                },
                onTap: () {

                },
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff333333),
                  fontSize: 16.w,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: AppTheme.getTheme().primaryColor,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name on Card",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Gilroy",
                        color: Color(0xFFBBC4DC))),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin:
                EdgeInsets.only(left: 45.w, right: 45.w, top: 0, bottom: 16.h),
            decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                color: Color.fromRGBO(237, 238, 246, 1)
              )
            ),
            child: Container(
  //            padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: creditController,
                textAlign: TextAlign.start,
                onChanged: (String txt) {
                  SortOptions.paymentInfo.creditCart = txt;
                },
                onTap: () {},
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff333333),
                  fontSize: 16.w,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: AppTheme.getTheme().primaryColor,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Credit Card Number",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Gilroy",
                        color: Color(0xFFBBC4DC))),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    bottom: 16.h,
                    left: 45.w,
                    right: 22.w,
                  ),
                  decoration: new BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(237, 238, 246, 1)
                    )
                  ),
                  child: Container(
  //                  padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: expDateController,
                      textAlign: TextAlign.start,
                      onChanged: (String txt) {
                        SortOptions.paymentInfo.expDate = txt;
                      },
                      // onTap: () {
                      //   DatePicker.showDatePicker(
                      //     context,
                      //     showTitleActions: true,
                      //     minTime: DateTime(
                      //       DateTime.now().year,
                      //       DateTime.now().month,
                      //     ),
                      //     maxTime: DateTime(
                      //       DateTime.now().year + 6,
                      //       DateTime.now().month,
                      //     ),
                      //     onConfirm: (date) {
                      //       expDateController.text =
                      //           Helper.getDateViaDate(date, 'MM/yy');
                      //     },
                      //     currentTime: DateTime.now(),
                      //     locale: LocaleType.en,
                      //   );
                      // },
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff333333),
                        fontSize: 16.w,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: AppTheme.getTheme().primaryColor,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "Exp Date (MM/YY)",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Gilroy",
                              color: Color(0xFFBBC4DC))),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    bottom: 16.h,
                    left: 0,
                    right: 45.w,
                  ),
                  decoration: new BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(237, 238, 246, 1)
                    )
                  ),
                  child: Container(
  //                  padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: ccvController,
                      textAlign: TextAlign.start,
                      onChanged: (String txt) {
                        SortOptions.paymentInfo.cvv = txt;
                      },
                      onTap: () {

                      },
                      style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.w600),
                      cursorColor: AppTheme.getTheme().primaryColor,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "CCV",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Gilroy",
                              color: Color(0xFFBBC4DC))),
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // margin: const EdgeInsets.only(top: 8, bottom: 8),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 35.h, left: 45.w, bottom: 32.h),
            child: new Text(
              "Contact Details",
              style: TextStyle(
                color: Color.fromRGBO(58, 63, 92, 1),
                fontSize: 16.w,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin:
                EdgeInsets.only(left: 45.w, right: 45.w, top: 0, bottom: 16.h),
            decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                color: Color.fromRGBO(237, 238, 246, 1)
              )
            ),
            child: Container(
  //            padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: emailAddressController,
                textAlign: TextAlign.start,
                onChanged: (String txt) {},
                onTap: () {},
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff333333),
                  fontSize: 16.w,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: AppTheme.getTheme().primaryColor,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email Address",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Gilroy",
                        color: Color(0xFFBBC4DC))),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              top: 0,
              left: 45.w,
              right: 45.w,
              bottom: 24.h
            ),
            decoration: new BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                color: Color.fromRGBO(237, 238, 246, 1)
              )
            ),
            child: Container(
  //            padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: phoneNumberController,
                textAlign: TextAlign.start,
                onChanged: (String txt) {},
                onTap: () {},
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff333333),
                  fontSize: 16.w,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: AppTheme.getTheme().primaryColor,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Gilroy",
                        color: Color(0xFFBBC4DC))),
              ),
            ),
          ),
        ],
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
          DateFormat('dd/MM/yyyy').parse(p.passportExpiration),
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
        this.getPayment(),
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
