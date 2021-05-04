import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/models/locations.dart';
import 'package:motel/models/price_data.dart';
import 'package:motel/screens/date_picker/local_widgets/flutter_calendar_carousel.dart';
import 'package:motel/screens/home/local_widgets/blue_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DatePickerScreen extends StatefulWidget {
  final DateTime startingDate;
  final bool shouldChooseMultipleDates;
  DateTime departure;
  final int showMonth;
  DateTime arrival;
  final int adults;
  final int children;
  bool selected;
  final LocationObject departurePlace;
  final LocationObject arrivalPlace;
  Function(DateResult) didSelectDate;

  DatePickerScreen({
    Key key,
    this.startingDate,
    this.shouldChooseMultipleDates = false,
    this.departurePlace,
    this.arrivalPlace,
    this.departure,
    this.arrival,
    this.adults,
    this.children,
    this.showMonth = 0,
    this.selected = false,
    this.didSelectDate,
  }) : super(key: key);

  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  List<DateTime> selectedDates = List();

  bool _isDirty = false;

  bool _checkedPriceData = false;

  bool _priceDataShow = false;
  double _randomV;
  DateTime oneWayTripDateSelected, _today, _currDateTime = DateTime.now();
  Future<Map<DateTime, PriceLevel>> _roundPriceDataFuture, _priceDataFuture;
  var _rnd = Random();

  bool shouldRefresh = false;


  List<DateTime> generateMonths() {
    List<DateTime> dtList = [];
    int currMonth = DateTime.now().month;
    int currYear = DateTime.now().year;

    for (int i = currMonth; i <= (currMonth + 12); i++) {
      if (i > 12) {
        dtList.add(DateTime(currYear + 1, (i - 12), 1));
      } else {
        dtList.add(DateTime(currYear, (i), 1));
      }
    }
    return dtList;
  }

  @override
  void initState() {
    _today = DateTime(_currDateTime.year, _currDateTime.month,
        _currDateTime.day); //remove time from date
    _priceDataFuture = PriceDataRepository().fetchPriceDataList(
        widget.departurePlace?.code,
        widget.arrivalPlace?.code,
        _today,
        _today.add(Duration(days: 300)),
        widget.adults,
        widget.children);

    _roundPriceDataFuture = PriceDataRepository().fetchRoundTripPriceData(
        widget.departurePlace?.code,
        widget.arrivalPlace?.code,
        _today,
        _today.add(Duration(days: 300)),
        _today.add(Duration(days: 1)),
        _today.add(Duration(days: 301)),
        widget.adults,
        widget.children);
    _randomV = _rnd.nextDouble();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> monthsToShow = generateMonths();
  
    Widget getAppBarUI() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: AppBar().preferredSize.height + 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        Navigator.pop(context,
                            DateResult(DateTime.now(), DateTime.now()));
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          child: Center(
                              child: Image.asset(
                            'assets/images/back-arrow.png',
                            scale: 28,
                          ))
                          // Image.asset("assets/images/left.png"),
                          ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: AppBar().preferredSize.height + 10,
                  alignment: Alignment.center,
                  child: ScreenTypeLayout(
                    mobile: Text(
                      "Trip Dates",
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontSize: 20,
                          color: Color.fromRGBO(14, 49, 120, 1),
                          fontWeight: FontWeight.bold),
                    ),
                    desktop: Text(
                      "Trip Dates",
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontSize: ScreenUtil().setSp(30),
                          color: Color.fromRGBO(14, 49, 120, 1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // SizedBox(height: 30,),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  height: AppBar().preferredSize.height + 10,
                  child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        setState(() {
                          _checkedPriceData = !_checkedPriceData;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: Image.asset(
                              _checkedPriceData?'assets/images/chart-button.png':'assets/images/chart-button-disabled.png',
                              scale: 2,
                            )
                          )
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _renderCalDateWithColor(
        {DateTime day, int R, int G, int B, double colorOpacity = 1}) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color.fromRGBO(R, G, B, colorOpacity)),
        child: Center(
          child: Text(
            "${day.day}",
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      );
    }

    bool _fallsBetweenRange(
        DateTime currDate, DateTime departure, DateTime arrival) {
      //All possible criteria for dates that fall between departure and return dates
      if ((currDate.day > departure.day &&
              currDate.day < arrival.day &&
              currDate.month == departure.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day > departure.day &&
              currDate.day < arrival.day &&
              currDate.month == departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day > departure.day &&
              currDate.day == arrival.day &&
              currDate.month == departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day > departure.day &&
              currDate.day > arrival.day &&
              currDate.month == departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day < departure.day &&
              currDate.day < arrival.day &&
              currDate.month > departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day == departure.day &&
              currDate.day < arrival.day &&
              currDate.month > departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day > departure.day &&
              currDate.day < arrival.day &&
              currDate.month > departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day > departure.day &&
              currDate.day == arrival.day &&
              currDate.month > departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day > departure.day &&
              currDate.day > arrival.day &&
              currDate.month > departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day < departure.day &&
              currDate.day < arrival.day &&
              currDate.month > departure.month &&
              currDate.month == arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day == departure.day &&
              currDate.day < arrival.day &&
              currDate.month > departure.month &&
              currDate.month == arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day > departure.day &&
              currDate.day < arrival.day &&
              currDate.month > departure.month &&
              currDate.month == arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day < departure.day &&
              currDate.day == arrival.day &&
              currDate.month > departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year) ||
          (currDate.day == departure.day &&
              currDate.day < arrival.day &&
              currDate.month > departure.month &&
              currDate.month < arrival.month &&
              currDate.year >= departure.year &&
              currDate.year <= arrival.year)) {
        return true;
      } else
        return false;
    }

    Color _estimateColor(DateTime _date) {
      int _days = _date.difference(_today).inDays;

      if (_days >= 1 && _days <= 30) {
        if (_randomV < 0.4) {
          return Color.fromRGBO(68, 207, 87, 1);
        }
        if (_randomV < 0.6) {
          return Color.fromRGBO(254, 137, 48, 1);
        }
        return Color.fromRGBO(255, 0, 30, 1);
      }

      if (_days >= 30 && _days <= 60) {
        if (_randomV < 0.3) {
          return Color.fromRGBO(68, 207, 87, 1);
        }
        if (_randomV < 0.7) {
          return Color.fromRGBO(254, 137, 48, 1);
        }
        return Color.fromRGBO(255, 0, 30, 1);
      }

      if (_days > 60) {
        if (_randomV < 0.5) {
          return Color.fromRGBO(68, 207, 87, 1);
        }
        if (_randomV < 0.8) {
          return Color.fromRGBO(254, 137, 48, 1);
        }
        return Color.fromRGBO(255, 0, 30, 1);
      }
      return Color.fromRGBO(0, 0, 0, 1);
    }

    double bottomHeight = 245;
    if ( _checkedPriceData == false ){
      bottomHeight = 97;
    }

    return new Scaffold(
      backgroundColor: Colors.white,
//      appBar:PreferredSizeWidget(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          children: <Widget>[
            getAppBarUI(),

            Container(
              height: MediaQuery.of(context).size.height - //Screen Height
                  (AppBar().preferredSize.height + bottomHeight) - //AppBar Height
                  MediaQuery.of(context).padding.top, //StatusBar Height
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Stack(children: <Widget>[
                if (_priceDataShow) ...[
                  //if trip type is one way
                  if (!widget.shouldChooseMultipleDates) ...[
                    //departure && arrival places cannot be empty
                    if (widget.departurePlace != null &&
                        widget.arrivalPlace != null) ...[
                      FutureBuilder(
                          future: _priceDataFuture,
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<DateTime, PriceLevel>>
                                  snapshot) {
                            if (snapshot.data != null && snapshot.hasData) {
                              return ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      margin: EdgeInsets.all(0),
                                      height: 440,
                                      child: CalendarCarousel(
                                        minSelectedDate: DateTime.now(),
                                        monthToShow: monthsToShow[index],
                                        chooseMultiple:
                                            widget.shouldChooseMultipleDates,
                                        headerTextStyle: TextStyle(
                                            fontFamily: 'Gilroy',
                                            color:
                                                Color.fromRGBO(58, 63, 92, 1),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 1.4),
                                        weekdayTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(58, 63, 92, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        inactiveDaysTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFFBBC4DC),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        inactiveWeekendTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFFBBC4DC),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        daysTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(58, 63, 92, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        weekendTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(58, 63, 92, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        selectedDayTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xffffffff),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        onDayPressed: (selectedDate, _) {
                                          if (widget
                                              .shouldChooseMultipleDates) {
                                            selectedDates.add(selectedDate);
                                            widget.arrival ??= DateTime.now();

                                            if (selectedDates.length == 0 ||
                                                selectedDates.length < 2) {
                                              _isDirty = true;
                                              setState(() {
                                                widget.selected = true;
                                                widget.departure =
                                                    selectedDates[0];
                                                widget.arrival = null;
                                              });
                                            } else if (selectedDates.length ==
                                                2) {
                                              _isDirty = false;
                                              DateTime dep = selectedDates[0]
                                                      .isBefore(
                                                          selectedDates[1])
                                                  ? selectedDates[0]
                                                  : selectedDates[1];
                                              DateTime ret = selectedDates[0]
                                                      .isAfter(selectedDates[1])
                                                  ? selectedDates[0]
                                                  : selectedDates[1];
                                              setState(() {
                                                widget.departure = dep;
                                                widget.arrival = ret;
                                              });
                                            } else {
                                              _isDirty = true;
                                              DateTime toAssign =
                                                  selectedDates.last;
                                              selectedDates.clear();
                                              selectedDates.add(toAssign);

                                              setState(() {
                                                widget.selected = true;
                                                widget.departure = null;
                                                widget.arrival = null;
                                                widget.departure =
                                                    selectedDates[0];
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              oneWayTripDateSelected =
                                                  selectedDate;
                                            });
                                          }
                                        },
                                        customDayBuilder: (
                                          bool isSelectable,
                                          int index,
                                          bool isSelectedDay,
                                          bool isToday,
                                          bool isPrevMonthDay,
                                          TextStyle textStyle,
                                          bool isNextMonthDay,
                                          bool isThisMonthDay,
                                          DateTime day,
                                        ) {
                                          if (day.compareTo(
                                                  oneWayTripDateSelected) ==
                                              0) {
                                            return _renderCalDateWithColor(
                                                day: day,
                                                R: 28,
                                                G: 175,
                                                B: 236,
                                                colorOpacity: 1);
                                          }

                                          //apply price data colors for oneway trips
                                          if (snapshot.data[day] != null) {
                                            if (snapshot.data[day] ==
                                                    PriceLevel.low &&
                                                !isSelectedDay) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 68,
                                                  G: 207,
                                                  B: 87,
                                                  colorOpacity:
                                                      isToday ? .3 : 1);
                                            }

                                            if (snapshot.data[day] ==
                                                    PriceLevel.mid &&
                                                !isSelectedDay) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 254,
                                                  G: 137,
                                                  B: 48,
                                                  colorOpacity:
                                                      isToday ? .3 : 1);
                                            }

                                            if (snapshot.data[day] ==
                                                    PriceLevel.high &&
                                                !isSelectedDay) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 255,
                                                  G: 0,
                                                  B: 30,
                                                  colorOpacity:
                                                      isToday ? .3 : 1);
                                            }
                                          }

                                          if (snapshot.data[day] == null) {
                                            if (_estimateColor(day) ==
                                                Color.fromRGBO(0, 0, 0, 1)) {
                                              return null;
                                            }
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: _estimateColor(day)),
                                              child: Center(
                                                child: Text(
                                                  "${day.day}",
                                                  style: TextStyle(
                                                    fontFamily: 'Gilroy',
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
      
                                          if (isSelectable &&
                                              oneWayTripDateSelected != null &&
                                              day.compareTo(
                                                      oneWayTripDateSelected) !=
                                                  0) {
                                            return Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Color.fromRGBO(
                                                          247, 249, 252, 1))),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '${day.day}',
                                                    semanticsLabel:
                                                        day.day.toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      color: Color.fromRGBO(
                                                          58, 63, 92, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          return null;
                                        },
                                      ),
                                    );
                                  });
                            }
                            return Container(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }),
                    ]
                  ] else ...[
                    //if trip type is two way
                    //departure && arrival places cannot be empty
                    if (widget.departurePlace != null &&
                        widget.arrivalPlace != null) ...[
                      //"Return Future for Two way trip prices"
                      FutureBuilder(
                          future: _roundPriceDataFuture,
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<DateTime, PriceLevel>>
                                  snapshot) {
                              print('check 345');
                            if (snapshot.data != null && snapshot.hasData) {
                              print('check 678');
                              return ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      margin: EdgeInsets.all(0),
                                      height: 440,
                                      child: CalendarCarousel(
                                        minSelectedDate: DateTime.now(),
                                        monthToShow: monthsToShow[index],
                                        chooseMultiple:
                                            widget.shouldChooseMultipleDates,
                                        headerMargin: EdgeInsets.only(left: 15, right: 15, top: 16, bottom: 16),
                                        headerTextStyle: TextStyle(
                                            fontFamily: 'Gilroy',
                                            color: Color.fromRGBO(14, 49, 120, 1),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 1.4),
                                        weekdayTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(58, 63, 92, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        inactiveDaysTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFFBBC4DC),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        inactiveWeekendTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xFFBBC4DC),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        daysTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(58, 63, 92, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        weekendTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(58, 63, 92, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        selectedDayTextStyle: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xffffffff),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        onDayPressed: (selectedDate, _) {
                                          if (widget
                                              .shouldChooseMultipleDates) {
                                            selectedDates.add(selectedDate);
                                            widget.arrival ??= DateTime.now();

                                            if (selectedDates.length == 0 ||
                                                selectedDates.length < 2) {
                                              _isDirty = true;
                                              setState(() {
                                                widget.selected = true;
                                                widget.departure =
                                                    selectedDates[0];
                                                widget.arrival = null;
                                              });
                                            } else if (selectedDates.length ==
                                                2) {
                                              _isDirty = false;
                                              DateTime dep = selectedDates[0]
                                                      .isBefore(
                                                          selectedDates[1])
                                                  ? selectedDates[0]
                                                  : selectedDates[1];
                                              DateTime ret = selectedDates[0]
                                                      .isAfter(selectedDates[1])
                                                  ? selectedDates[0]
                                                  : selectedDates[1];
                                              setState(() {
                                                widget.departure = dep;
                                                widget.arrival = ret;
                                              });
                                            } else {
                                              _isDirty = true;
                                              DateTime toAssign =
                                                  selectedDates.last;
                                              selectedDates.clear();
                                              selectedDates.add(toAssign);

                                              setState(() {
                                                widget.selected = true;
                                                widget.departure = null;
                                                widget.arrival = null;
                                                widget.departure =
                                                    selectedDates[0];
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              oneWayTripDateSelected =
                                                  selectedDate;
                                            });
                                          }
                                        },
                                        customDayBuilder: (
                                          bool isSelectable,
                                          int index,
                                          bool isSelectedDay,
                                          bool isToday,
                                          bool isPrevMonthDay,
                                          TextStyle textStyle,
                                          bool isNextMonthDay,
                                          bool isThisMonthDay,
                                          DateTime day,
                                        ) {
                                          if (day.compareTo(widget.departure) ==
                                              0) {
                                            return _renderCalDateWithColor(
                                                day: day,
                                                R: 28,
                                                G: 175,
                                                B: 236,
                                                colorOpacity: 1);
                                          }
                                          if (widget.departure != null &&
                                              widget.arrival != null) {
                                            if (day.isAfter(widget.departure) &&
                                                day.isBefore(widget.arrival)) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 28,
                                                  G: 175,
                                                  B: 236,
                                                  colorOpacity: .3);
                                            }
                                          }

                                          //apply price data colors for two way trips
                                          if (snapshot.data[day] != null) {
                                            //Green color
                                            if (snapshot.data[day] ==
                                                    PriceLevel.low &&
                                                !isSelectedDay) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 68,
                                                  G: 207,
                                                  B: 87,
                                                  colorOpacity: isToday &&
                                                          _fallsBetweenRange(
                                                              day,
                                                              widget.departure,
                                                              widget.arrival)
                                                      ? .3
                                                      : 1);
                                            }

                                            //Yellow color
                                            if (snapshot.data[day] ==
                                                    PriceLevel.mid &&
                                                !isSelectedDay) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 254,
                                                  G: 137,
                                                  B: 48,
                                                  colorOpacity:
                                                      isToday ? .3 : 1);
                                            }

                                            //Red color
                                            if (snapshot.data[day] ==
                                                    PriceLevel.high &&
                                                !isSelectedDay) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 255,
                                                  G: 0,
                                                  B: 30,
                                                  colorOpacity:
                                                      isToday ? .3 : 1);
                                            }
                                          }

                                          // Estimate color if not found in data
                                          if (snapshot.data[day] == null) {
                                            if (_estimateColor(day) ==
                                                Color.fromRGBO(0, 0, 0, 1)) {
                                              return null;
                                            }
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: _estimateColor(day)),
                                              child: Center(
                                                child: Text(
                                                  "${day.day}",
                                                  style: TextStyle(
                                                    fontFamily: 'Gilroy',
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                          // Fix multiple month day selection bug for round trip
                                          if (widget.selected &&
                                              isSelectable &&
                                              widget.arrival != null &&
                                              (day.day > widget.arrival.day ||
                                                  day.day <
                                                      widget.arrival.day) &&
                                              day.month >
                                                  widget.arrival.month &&
                                              day.year >= widget.arrival.year) {
                                            return Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Color.fromRGBO(
                                                          247, 249, 252, 1))),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '${day.day}',
                                                    semanticsLabel:
                                                        day.day.toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      color: Color.fromRGBO(
                                                          58, 63, 92, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          if (_isDirty) {
                                            return null;
                                          }

                                          if (widget.selected) {
                                            //if It is the start date
                                            if (day.day ==
                                                    widget.departure.day &&
                                                day.month ==
                                                    widget.departure.month &&
                                                day.year ==
                                                    widget.departure.year) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 28,
                                                  G: 175,
                                                  B: 236,
                                                  colorOpacity: 1);
                                            }

                                            //if It is falls between range
                                            if (_fallsBetweenRange(
                                                day,
                                                widget.departure,
                                                widget.arrival)) {
                                              print("dayss");
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 28,
                                                  G: 175,
                                                  B: 236,
                                                  colorOpacity: .3);
                                            }

                                            if (!_isDirty &&
                                                day.day == widget.arrival.day &&
                                                day.month ==
                                                    widget.arrival.month &&
                                                day.year ==
                                                    widget.arrival.year) {
                                              return _renderCalDateWithColor(
                                                  day: day,
                                                  R: 28,
                                                  G: 175,
                                                  B: 236,
                                                  colorOpacity: 1);
                                            }
                                            return null;
                                          }

                                          return null;
                                        },
                                      ),
                                    );
                                  });
                            }
                            print("Printing no snapshot");
                            // print(snapshot.data);
                            return Container(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }),
                    ] else ...[
                      Container(
                        child: Center(
                          child: Text(
                              "Departure and arrival places are required."),
                        ),
                      ),
                    ]
                  ],
                ] else ...[
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        margin: EdgeInsets.all(0),
                        height: 440,
                        child: CalendarCarousel(
                          resetDate: shouldRefresh ? oneWayTripDateSelected : null,
                          minSelectedDate: DateTime.now(),
                          monthToShow: monthsToShow[index],
                          chooseMultiple: widget.shouldChooseMultipleDates,
                          headerMargin: EdgeInsets.only(left: 15, right: 15, top: 16, bottom: 16),
                          headerTextStyle: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color.fromRGBO(14, 49, 120, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.4),
                          weekdayTextStyle: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color.fromRGBO(58, 63, 92, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                          inactiveDaysTextStyle: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xFFBBC4DC),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                          inactiveWeekendTextStyle: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xFFBBC4DC),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                          daysTextStyle: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color.fromRGBO(58, 63, 92, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                          weekendTextStyle: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color.fromRGBO(58, 63, 92, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                          selectedDayTextStyle: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xffffffff),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                          onDayPressed: (selectedDate, _) {
                            if (widget.shouldChooseMultipleDates) {
                              selectedDates.add(selectedDate);
                              widget.arrival ??= DateTime.now();

                              if (selectedDates.length == 0 ||
                                  selectedDates.length < 2) {
                                _isDirty = true;
                                setState(() {
                                  widget.selected = true;
                                  widget.departure = selectedDates[0];
                                  widget.arrival = null;
                                });
                              } else if (selectedDates.length == 2) {
                                _isDirty = false;
                                DateTime dep =
                                    selectedDates[0].isBefore(selectedDates[1])
                                        ? selectedDates[0]
                                        : selectedDates[1];
                                DateTime ret =
                                    selectedDates[0].isAfter(selectedDates[1])
                                        ? selectedDates[0]
                                        : selectedDates[1];
                                setState(() {
                                  widget.departure = dep;
                                  widget.arrival = ret;
                                });
                              } else {
                                _isDirty = true;
                                DateTime toAssign = selectedDates.last;
                                selectedDates.clear();
                                selectedDates.add(toAssign);

                                setState(() {
                                  widget.selected = true;
                                  widget.departure = null;
                                  widget.arrival = null;
                                  widget.departure = selectedDates[0];
                                });
                              }
                            } else {
                              if (selectedDate.month != oneWayTripDateSelected?.month) {
                                setState(() {
                                  oneWayTripDateSelected = selectedDate;
                                  shouldRefresh = true;
                                });
                              } else {
                                setState(() {
                                  oneWayTripDateSelected = selectedDate;
                                  shouldRefresh = false;
                                });
                              }
                            }
                          },
                          customDayBuilder: (
                            bool isSelectable,
                            int index,
                            bool isSelectedDay,
                            bool isToday,
                            bool isPrevMonthDay,
                            TextStyle textStyle,
                            bool isNextMonthDay,
                            bool isThisMonthDay,
                            DateTime day,
                          ) {
                            if (!widget.shouldChooseMultipleDates) {
                              return null;
                            }

                            if (widget.selected &&
                                isSelectable &&
                                widget.arrival != null &&
                                (day.day > widget.arrival.day ||
                                    day.day < widget.arrival.day) &&
                                day.month > widget.arrival.month &&
                                day.year >= widget.arrival.year) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(247, 249, 252, 1))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('${day.day}',
                                        semanticsLabel: day.day.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color.fromRGBO(58, 63, 92, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        )),
                                  ],
                                ),
                              );
                            }

                            if (_isDirty) {
                              return null;
                            }

                            if (widget.selected) {
                              //if It is the start date
                              if (day.day == widget.departure.day &&
                                  day.month == widget.departure.month &&
                                  day.year == widget.departure.year) {
                                return _renderCalDateWithColor(
                                    day: day,
                                    R: 28,
                                    G: 175,
                                    B: 236,
                                    colorOpacity: 1);
                              }

                              if (_fallsBetweenRange(
                                  day, widget.departure, widget.arrival)) {
                                return _renderCalDateWithColor(
                                    day: day,
                                    R: 28,
                                    G: 175,
                                    B: 236,
                                    colorOpacity: .3);
                              }

                              if (!_isDirty &&
                                  day.day == widget.arrival.day &&
                                  day.month == widget.arrival.month &&
                                  day.year == widget.arrival.year) {
                                return _renderCalDateWithColor(
                                    day: day,
                                    R: 28,
                                    G: 175,
                                    B: 236,
                                    colorOpacity: 1);
                              }
                              return null;
                            }

                            return null;
                          },
                        ),
                      );
                    }, // ListView builder end
                    shrinkWrap: true, //ListView builder property
                    itemCount: monthsToShow.length, //ListView builder property
                  ), //ListView end
                ],


              ]),
            ),

            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      height: _checkedPriceData==false?0:null,
                      padding: EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.16),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: Offset(0, 0), // changes position of shadow
                          )
                        ],
                      ),

                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: ScreenTypeLayout(
                                        mobile: Text(
                                          'Flight Price Data',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        desktop: Text(
                                          'Flight Price Data',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(24),
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Transform.scale(
                                            scale: 0.7,
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              child: CupertinoSwitch(
                                                trackColor: Colors.red,
                                                activeColor: Color(0xff40CE53),
                                                value: _priceDataShow,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _priceDataShow = value;
                                                  });
                                                },
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  _priceDataShow = !_priceDataShow;
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                    )

                                  ],
                                )
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 2.0, bottom: 4.0),
                              child: ScreenTypeLayout(
                                mobile: Text(
                                  'Use our flight price data to find the cheapest dates to fly',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy',
                                    color: Color.fromRGBO(142, 150, 159, 1),
                                  ),
                                ),
                                desktop: Text(
                                  'Use our flight price data to find the cheapest dates to fly',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(18),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy',
                                    color: Color.fromRGBO(142, 150, 159, 1),
                                  ),
                                ),
                              )
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  247, 249, 252, 1),
                                              width: 1),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5)),
                                      padding:
                                      const EdgeInsets.fromLTRB(2, 0, 10, 0),
                                      margin: EdgeInsets.symmetric(horizontal: 0),
                                      child: Row(
                                        children: <Widget>[
                                          ScreenTypeLayout(
                                            mobile: Card(
                                              color: Color.fromRGBO(68, 207, 87, 1),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(6)),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            desktop: Card(
                                              color: Color.fromRGBO(68, 207, 87, 1),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(3)),
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                              ),
                                            ),
                                          ),
                                          ScreenTypeLayout(
                                            mobile: Text(
                                              'Cheapest',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(142, 150, 159, 1),
                                              ),
                                            ),
                                            desktop: Text(
                                              'Cheapest',
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(18),
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(142, 150, 159, 1),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      247, 249, 252, 1),
                                                  width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5)),
                                          padding:
                                          const EdgeInsets.fromLTRB(2, 0, 10, 0),
                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                          child: Row(
                                            children: <Widget>[
                                              ScreenTypeLayout(
                                                mobile: Card(
                                                  color:
                                                  Color.fromRGBO(254, 137, 48, 1),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(6)),
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                                desktop: Card(
                                                  color:
                                                  Color.fromRGBO(254, 137, 48, 1),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(3)),
                                                  child: Container(
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                ),
                                              ),
                                              ScreenTypeLayout(
                                                mobile: Text(
                                                  'Average',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(142, 150, 159, 1),
                                                  ),
                                                ),
                                                desktop: Text(
                                                  'Average',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil().setSp(18),
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(142, 150, 159, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      247, 249, 252, 1),
                                                  width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5)),
                                          padding:
                                          const EdgeInsets.fromLTRB(2, 0, 10, 0),
                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                          child: Row(
                                            children: <Widget>[
                                              ScreenTypeLayout(
                                                mobile: Card(
                                                  color: Color.fromRGBO(255, 0, 0, 1),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(6)),
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                                desktop: Card(
                                                  color: Color.fromRGBO(255, 0, 0, 1),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(3)),
                                                  child: Container(
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                ),
                                              ),
                                              ScreenTypeLayout(
                                                mobile: Text(
                                                  'Expensive',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(142, 150, 159, 1),
                                                  ),
                                                ),
                                                desktop: Text(
                                                  'Expensive',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil().setSp(18),
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(142, 150, 159, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  )

                                ],
                              ),
                            ),


                          ]
                      )
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xff00AEEF),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          DateResult selectedDateResult;
                          if (widget.shouldChooseMultipleDates) {
                            if (widget.arrival != null) {
                              selectedDateResult = DateResult(widget.departure, widget.arrival);
                            } else {
                              selectedDateResult = DateResult(widget.departure, null);
                            }
                          } else {
                            selectedDateResult = DateResult(oneWayTripDateSelected, null);
                          }
                          if (widget.didSelectDate != null) {
                            widget.didSelectDate(selectedDateResult);
                            Navigator.of(context).pop();
                          } else {
                            Navigator.pop(context,
                                selectedDateResult);
                          }
                        },
                        child: Text(
                          'Select Trip Dates',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                          ),
                        )
                      )
                    )
                    // FlatButton(
                      // onPressed: () {
                      //   if (widget.shouldChooseMultipleDates) {
                      //     Navigator.pop(context,
                      //         DateResult(widget.departure, widget.arrival));
                      //   } else {
                      //     Navigator.pop(context,
                      //         DateResult(oneWayTripDateSelected, null));
                      //   }
                      // },
                    //   splashColor: Colors.transparent,
                    //   color: Colors.blue,//Color.fromRGBO(0, 174, 239, 1),
                    //   shape: new RoundedRectangleBorder(
                    //     borderRadius: new BorderRadius.circular(50.0),
                    //   ),
                    //   padding: EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
                    //   child: Text(
                    //     'Select Trip Dates',
                      //   style: TextStyle(
                      //       fontSize: 18,
                      //       fontFamily: 'Gilroy',
                      //       fontWeight: FontWeight.w700,
                      //       color: Colors.white),
                      // ),

                    // ),
                  // ),

                ],

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateResult {
  final DateTime _departureDate;
  final DateTime _returnDate;

  DateResult(this._departureDate, this._returnDate);

  get departureDate => _departureDate;

  get returnDate => _returnDate;
}
