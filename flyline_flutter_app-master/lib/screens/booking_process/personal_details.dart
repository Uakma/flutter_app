import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motel/theme/appTheme.dart';
import 'package:motel/helper/helper.dart';
import 'package:motel/models/traveler_info.dart';
import 'package:motel/models/traveler_information.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PersonalDetailsScreen extends StatefulWidget {
  PersonalDetailsScreen({
    Key key,
  }) : super(key: key);

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> with TickerProviderStateMixin {
  double tripTotal = 0;
  double priceOnPassenger = 0;

  List<TextEditingController> firstNameControllers;
  List<TextEditingController> lastNameControllers;
  List<TextEditingController> dobControllers;
  List<TextEditingController> genderControllers;
  List<TextEditingController> passportIdControllers;
  List<TextEditingController> passportExpirationControllers;

  ScrollController scrollController = ScrollController(initialScrollOffset: 300.0, keepScrollOffset: true);

  static var genders = [
    "Male",
    "Female",
  ];
  static var genderValues = ["0", "1"];

  var selectedGender = genders[0];
  var selectedGenderValue = genderValues[0];

  final formatDates = intl.DateFormat("dd MMM yyyy");
  final formatTime = intl.DateFormat("hh : mm a");
  final formatAllDay = intl.DateFormat("dd/MM/yyyy");
  int get numberOfPassengers => flyLinebloc.numberOfPassengers;

  @override
  void initState() {
    super.initState();
    firstNameControllers = List.generate(numberOfPassengers, (index) => TextEditingController());
    lastNameControllers = List.generate(numberOfPassengers, (index) => TextEditingController());
    dobControllers = List.generate(numberOfPassengers, (index) => TextEditingController());
    genderControllers = List.generate(numberOfPassengers, (index) => TextEditingController());
    passportIdControllers = List.generate(numberOfPassengers, (index) => TextEditingController());
    passportExpirationControllers = List.generate(numberOfPassengers, (index) => TextEditingController());

    firstNameControllers.first.text = flyLinebloc.account.firstName;
    lastNameControllers.first.text = flyLinebloc.account.lastName;
    dobControllers.first.text = TravelerInfo.getDobString(flyLinebloc.account.dob);
    genderControllers.first.text = TravelerInfo.getGenderString(flyLinebloc.account.gender);

    List<TravelerInformation> passengersInformation = List();
    for (int index = 0; index < this.numberOfPassengers; index++) {
      TravelerInformation travelerInformation = TravelerInformation(
        title: genderControllers.first.text == "Male" ? "mr" : "ms",
        firstName: firstNameControllers[index].text,
        lastName: lastNameControllers[index].text,
        dob: dobControllers[index].text,
        gender: genderControllers[index].text,
        passportId: passportIdControllers[index].text,
        passportExpiration: passportExpirationControllers[index].text,
      );
      passengersInformation.add(travelerInformation);
    }
    if (flyLinebloc.getCurrentTripData.travelersInfo == null)
      flyLinebloc.getCurrentTripData.travelersInfo = passengersInformation;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ScreenTypeLayout(
        mobile: buildMobileContent(),
        desktop: buildWebContent(),
      ),
    );
  }

  Widget buildMobileContent() {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Use all first and last names as they appear on your passport.',
                    style: TextStyle(
                      color: Color.fromRGBO(142, 150, 159, 1),
                      fontSize: 11,
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: List.generate(
              numberOfPassengers,
              (index) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        right: 20,
                        left: 20,
                        top: 14,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              (numberOfPassengers <= 1
                                  ? "Traveler Information"
                                  : "Traveler Information (Passenger ${index + 1})"),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff333333),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: TextField(
                          controller: firstNameControllers[index],
                          textAlign: TextAlign.start,
                          onChanged: (String txt) {
                            TravelerInformation travelerInformation = TravelerInformation(
                              title: genderControllers.first.text == "Male" ? "mr" : "ms",
                              firstName: firstNameControllers[index].text,
                              lastName: lastNameControllers[index].text,
                              dob: dobControllers[index].text,
                              gender: genderControllers[index].text,
                              passportId: passportIdControllers[index].text,
                              passportExpiration: passportExpirationControllers[index].text,
                            );
                            flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                          },
                          onTap: () {},
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xff333333),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                          cursorColor: AppTheme.getTheme().primaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "First Name",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Gilroy",
                              color: Color(0xFFBBC4DC),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Container(
                          child: TextField(
                            controller: lastNameControllers[index],
                            textAlign: TextAlign.start,
                            onChanged: (String txt) {
                              TravelerInformation travelerInformation = TravelerInformation(
                                title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                firstName: firstNameControllers[index].text,
                                lastName: lastNameControllers[index].text,
                                dob: dobControllers[index].text,
                                gender: genderControllers[index].text,
                                passportId: passportIdControllers[index].text,
                                passportExpiration: passportExpirationControllers[index].text,
                              );
                              flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                            },
                            onTap: () {},
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff333333),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                            cursorColor: AppTheme.getTheme().primaryColor,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Gilroy",
                                color: Color(0xFFBBC4DC),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Container(
                              child: TextField(
                                controller: dobControllers[index],
                                textAlign: TextAlign.start,
                                onChanged: (String txt) {
                                  TravelerInformation travelerInformation = TravelerInformation(
                                    title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                    firstName: firstNameControllers[index].text,
                                    lastName: lastNameControllers[index].text,
                                    dob: dobControllers[index].text,
                                    gender: genderControllers[index].text,
                                    passportId: passportIdControllers[index].text,
                                    passportExpiration: passportExpirationControllers[index].text,
                                  );
                                  flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                                },
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xff333333),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                                cursorColor: AppTheme.getTheme().primaryColor,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "DOB : MM/DD/YYYY",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Gilroy",
                                    color: Color(0xFFBBC4DC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 200,
                                child: CupertinoPicker(
                                  onSelectedItemChanged: (value) {
                                    setState(() {
                                      selectedGender = genders[value];
                                      selectedGenderValue = value.toString();
                                      genderControllers[index].text = genders[value];
                                    });
                                  },
                                  children: <Widget>[
                                    Text('Male'),
                                    Text('Female'),
                                  ],
                                  itemExtent: 32,
                                ),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: IgnorePointer(
                                child: TextFormField(
                                  maxLines: 1,
                                  controller: genderControllers[index],
                                  keyboardType: TextInputType.text,
                                  cursorColor: AppTheme.getTheme().primaryColor,
                                  decoration: InputDecoration(
                                    hintText: "Gender",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10, bottom: 8),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16.0),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 16, bottom: 20),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Only required on international flights",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xFF3333333),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Container(
                              child: TextField(
                                controller: passportIdControllers[index],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xff333333),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (String txt) {
                                  TravelerInformation travelerInformation = TravelerInformation(
                                    title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                    firstName: firstNameControllers[index].text,
                                    lastName: lastNameControllers[index].text,
                                    dob: dobControllers[index].text,
                                    gender: genderControllers[index].text,
                                    passportId: passportIdControllers[index].text,
                                    passportExpiration: passportExpirationControllers[index].text,
                                  );
                                  flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                                },
                                cursorColor: AppTheme.getTheme().primaryColor,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Passport ID",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Gilroy",
                                    color: Color(0xFFBBC4DC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Container(
                              child: TextField(
                                controller: passportExpirationControllers[index],
                                textAlign: TextAlign.start,
                                onChanged: (String txt) {
                                  TravelerInformation travelerInformation = TravelerInformation(
                                    title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                    firstName: firstNameControllers[index].text,
                                    lastName: lastNameControllers[index].text,
                                    dob: dobControllers[index].text,
                                    gender: genderControllers[index].text,
                                    passportId: passportIdControllers[index].text,
                                    passportExpiration: passportExpirationControllers[index].text,
                                  );
                                  flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                                },
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xff333333),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                cursorColor: AppTheme.getTheme().primaryColor,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Exp DD/MM/YYYY",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Gilroy",
                                    color: Color(0xFFBBC4DC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
  }

  Widget buildWebContent() {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 13.h),
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              border: Border.all(
                width: 1,
                color: Color.fromRGBO(237, 238, 246, 1)
              )
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.info_outline, 
                  color: Colors.orange,
                  size: 15.h,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Use all first and last names as they appear on your passport.',
                    style: TextStyle(
                      color: Color.fromRGBO(142, 150, 159, 1),
                      fontSize: 12.w,
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: List.generate(
              numberOfPassengers,
              (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    border: Border.all(
                      width: 2,
                      color: Color.fromRGBO(237, 238, 246, 1)
                    )
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          right: 20,
                          left: 20,
                          top: 14,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                (numberOfPassengers <= 1
                                    ? "Traveler Information"
                                    : "Traveler Information (Passenger ${index + 1})"),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color.fromRGBO(58, 63, 92, 1),
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.w),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(237, 238, 246, 1)
                          )
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: TextField(
                            controller: firstNameControllers[index],
                            textAlign: TextAlign.start,
                            onChanged: (String txt) {
                              TravelerInformation travelerInformation = TravelerInformation(
                                title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                firstName: firstNameControllers[index].text,
                                lastName: lastNameControllers[index].text,
                                dob: dobControllers[index].text,
                                gender: genderControllers[index].text,
                                passportId: passportIdControllers[index].text,
                                passportExpiration: passportExpirationControllers[index].text,
                              );
                              flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                            },
                            onTap: () {},
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff333333),
                              fontSize: 16.w,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                            cursorColor: AppTheme.getTheme().primaryColor,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "First Name",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Gilroy",
                                color: Color(0xFFBBC4DC),
                                fontSize: 16.w
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.w),
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(237, 238, 246, 1)
                            )
                          ),
                          child: Container(
                            child: TextField(
                              controller: lastNameControllers[index],
                              textAlign: TextAlign.start,
                              onChanged: (String txt) {
                                TravelerInformation travelerInformation = TravelerInformation(
                                  title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                  firstName: firstNameControllers[index].text,
                                  lastName: lastNameControllers[index].text,
                                  dob: dobControllers[index].text,
                                  gender: genderControllers[index].text,
                                  passportId: passportIdControllers[index].text,
                                  passportExpiration: passportExpirationControllers[index].text,
                                );
                                flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                              },
                              onTap: () {},
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff333333),
                                fontSize: 16.w,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                              cursorColor: AppTheme.getTheme().primaryColor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Last Name",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Gilroy",
                                  color: Color(0xFFBBC4DC),
                                  fontSize: 16.w
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.w),
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(237, 238, 246, 1)
                                )
                              ),
                              child: Container(
                                child: TextField(
                                  controller: dobControllers[index],
                                  textAlign: TextAlign.start,
                                  onChanged: (String txt) {
                                    TravelerInformation travelerInformation = TravelerInformation(
                                      title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                      firstName: firstNameControllers[index].text,
                                      lastName: lastNameControllers[index].text,
                                      dob: dobControllers[index].text,
                                      gender: genderControllers[index].text,
                                      passportId: passportIdControllers[index].text,
                                      passportExpiration: passportExpirationControllers[index].text,
                                    );
                                    flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                                  },
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff333333),
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  cursorColor: AppTheme.getTheme().primaryColor,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "DOB : MM/DD/YYYY",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC),
                                      fontSize: 16.w
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  height: 200,
                                  child: CupertinoPicker(
                                    onSelectedItemChanged: (value) {
                                      setState(() {
                                        selectedGender = genders[value];
                                        selectedGenderValue = value.toString();
                                        genderControllers[index].text = genders[value];
                                      });
                                    },
                                    children: <Widget>[
                                      Text('Male'),
                                      Text('Female'),
                                    ],
                                    itemExtent: 32,
                                  ),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15.w)),
                                  border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(237, 238, 246, 1)
                                  )
                                ),
                                child: IgnorePointer(
                                  child: TextFormField(
                                    maxLines: 1,
                                    controller: genderControllers[index],
                                    keyboardType: TextInputType.text,
                                    cursorColor: AppTheme.getTheme().primaryColor,
                                    decoration: InputDecoration(
                                      hintText: "Gender",
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Gilroy",
                                        color: Color(0xFFBBC4DC),
                                        fontSize: 16.w
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xff333333),
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10, bottom: 8),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 16.0),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 16),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Passport Info",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xFF3333333),
                            fontSize: 16.w,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 4, bottom: 20),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          "(Only required for international flight)",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color.fromRGBO(142, 150, 159, 1),
                            fontSize: 12.w,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.w),
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(237, 238, 246, 1)
                                )
                              ),
                              child: Container(
                                child: TextField(
                                  controller: passportIdControllers[index],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff333333),
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onChanged: (String txt) {
                                    TravelerInformation travelerInformation = TravelerInformation(
                                      title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                      firstName: firstNameControllers[index].text,
                                      lastName: lastNameControllers[index].text,
                                      dob: dobControllers[index].text,
                                      gender: genderControllers[index].text,
                                      passportId: passportIdControllers[index].text,
                                      passportExpiration: passportExpirationControllers[index].text,
                                    );
                                    flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                                  },
                                  cursorColor: AppTheme.getTheme().primaryColor,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Passport ID",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC),
                                      fontSize: 16.w
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.w),
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(237, 238, 246, 1)
                                )
                              ),
                              child: Container(
                                child: TextField(
                                  controller: passportExpirationControllers[index],
                                  textAlign: TextAlign.start,
                                  onChanged: (String txt) {
                                    TravelerInformation travelerInformation = TravelerInformation(
                                      title: genderControllers.first.text == "Male" ? "mr" : "ms",
                                      firstName: firstNameControllers[index].text,
                                      lastName: lastNameControllers[index].text,
                                      dob: dobControllers[index].text,
                                      gender: genderControllers[index].text,
                                      passportId: passportIdControllers[index].text,
                                      passportExpiration: passportExpirationControllers[index].text,
                                    );
                                    flyLinebloc.getCurrentTripData.travelersInfo[index] = travelerInformation;
                                  },
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff333333),
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  cursorColor: AppTheme.getTheme().primaryColor,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Exp DD/MM/YYYY",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Color(0xFFBBC4DC),
                                      fontSize: 16.w
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(height: 31.h,)
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
  }
}
