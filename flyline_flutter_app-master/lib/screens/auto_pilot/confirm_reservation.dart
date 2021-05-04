import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'local_widgets/airline_tag.dart';
import 'local_widgets/rounded_card.dart';


class ConfirmReservation extends StatefulWidget {
  @override
  _ConfirmReservationState createState() => _ConfirmReservationState();
}

class _ConfirmReservationState extends State<ConfirmReservation> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: buildMobileContent(),
      desktop: buildWebContent(),
    );
  }

  Widget buildMobileContent() {
    return Column(
      children: <Widget>[
        _totalProbability(),
        _spacer(25),
        Expanded(child: _reservationSummary()),
      ],
    );
  }

  Widget buildWebContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: Color.fromRGBO(237, 238, 246, 1)
        )
      ),
      child: Expanded(child: _reservationSummary()),
    );
  }

  Widget _totalProbability() {


    var value = flyLinebloc.outProbability.value.toInt().toString() + "%";
    var hexColor = "#FE8930";
    if (flyLinebloc.outProbability.value <= 33.33) {
      // value = "Low";
      hexColor = "#FF001E";
    } else if (flyLinebloc.outProbability.value >= 33.33 && flyLinebloc.outProbability.value <= 66.66) {
      // value = "Medium";
      hexColor = "#FE8930";
    } else if (flyLinebloc.outProbability.value >= 66.66) {
      // value = "High";
      hexColor = "#44CF57";
    }

    return RoundedCard(
      padding: const EdgeInsets.all(25),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // direction: Axis.vertical,
              children: <Widget>[
                Text(
                  'Total Probabilty',
                  style: TextStyle(
                    color: Color(0xff0e3178),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                _spacer(),
                Text(
                  'Based on our data, we have calculated\nthe total probability for your reservation.',
                  style: TextStyle(
                    color: Color(0xff8e969f),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),


          Text(
            value,
            style: TextStyle(
              color: HexColor(hexColor),
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reservationSummary() {
    DateFormat dateFormat = DateFormat('E, MMM dd');
    String tripDates = '${dateFormat.format(flyLinebloc.departureDate)}';
    if (flyLinebloc.returnDate != null) {
      tripDates += ' - ${dateFormat.format(flyLinebloc.returnDate)}';
    }

    List<String> airlines = ['AA', 'DL', 'IB', 'WN', 'F9', 'LH', 'VS', 'NK'];
    List<Widget> preferredAirlinesWidgets = [];
    for (String name in airlines) {
      if ((flyLinebloc.preferredAirlines ?? []).contains(name)) {
        preferredAirlinesWidgets.add(AirLineTag(name, clickable: false));
      }
    }

    Widget preferredAirlineWidget = preferredAirlinesWidgets.length == 0
        ? Container()
        : _row(
            'Preferred Airline(s)',
            Flexible(
              child: ScreenTypeLayout(
                mobile: Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 50,
                  child: ListView(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: preferredAirlinesWidgets,
                  ),
                ),
                desktop: Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 50.w,
                  child: ListView(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: preferredAirlinesWidgets,
                  ),
                ),
              ),
            ),
          );

    List<String> flightPreferences = [
      'Direct Flight',
      'Single Carrier',
      'Quickest (Durration)',
      'Economy',
      'Economy Premium',
      'Business Class',
      'First Class'
    ];
    List<String> selectedFlightPreferences = [];
    for (String text in flightPreferences) {
      if ((flyLinebloc.flightPreferences ?? []).contains(text)) {
        selectedFlightPreferences.add(text);
      }
    }

    List<String> timePreferences = ['Morning', 'Afternoon', 'Evening'];
    List<String> departureStartTime = [];
    for (String time in timePreferences) {
      if ((flyLinebloc.departureStartTime ?? []).contains(time)) {
        departureStartTime.add(time);
      }
    }
    List<String> departureEndTime = [];
    for (String time in timePreferences) {
      if ((flyLinebloc.departureEndTime ?? []).contains(time)) {
        departureEndTime.add(time);
      }
    }

    return SingleChildScrollView(
      child: ScreenTypeLayout(
        mobile: buildMobileBody(
          tripDates, 
          selectedFlightPreferences, 
          preferredAirlineWidget, 
          departureEndTime, 
          departureStartTime),
        desktop: buildWebBody(
          tripDates, 
          selectedFlightPreferences, 
          preferredAirlineWidget, 
          departureEndTime, 
          departureStartTime),
      ),
    );
  }

  Widget buildMobileBody(
    String tripDates, 
    List<String> selectedFlightPreferences,
    Widget preferredAirlineWidget,
    List<String> departureEndTime,
    List<String> departureStartTime,
  ) {
    return Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Reservation Summary',
                  style: TextStyle(
                    color: Color(0xff0e3178),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Text(
                  'Edit Reservation',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            _spacer(),
            Text(
              'Below are the details of your autopilot reservation. \nGo back to make any changes.',
              style: TextStyle(
                color: Color(0xff8e969f),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                height: 1.7,
              ),
              textAlign: TextAlign.start,
            ),
            Divider(height: 40),
            _spacer(),
            _row('Departure City or Airport',
                '${flyLinebloc.departureLocation.name} ${flyLinebloc.departureLocation.subdivisionName} ${flyLinebloc.departureLocation.countryCode}'),
            _spacer(25),
            _row('Arrival City or Airport',
                '${flyLinebloc.arrivalLocation.name} ${flyLinebloc.arrivalLocation.subdivisionName} ${flyLinebloc.arrivalLocation.countryCode}'),
            _spacer(25),
            _row('Trip Dates', tripDates),
            _spacer(),
            Divider(height: 40),
            _spacer(),
            _row(
                'Max Price Preference',
                Text(
                  '\$${flyLinebloc.outMaxPrice.value}',
                  style: TextStyle(
                    color: Color.fromRGBO(68, 207, 87, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                )),
            _spacer(),
            selectedFlightPreferences.length == 0
                ? Container()
                : Divider(height: 40),
            preferredAirlineWidget,
            selectedFlightPreferences.length == 0 ? Container() : _spacer(15),
            selectedFlightPreferences.length == 0
                ? Container()
                : _row(
                    'Flight Preferences',
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          selectedFlightPreferences.join(', '),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
            departureEndTime.length == 0 && departureStartTime.length == 0
                ? Container()
                : _spacer(),
            departureEndTime.length == 0 && departureStartTime.length == 0
                ? Container()
                : Divider(height: 30),
            departureEndTime.length == 0 && departureStartTime.length == 0
                ? Container()
                : _row('', ''),
            departureEndTime.length == 0 && departureStartTime.length == 0
                ? Container()
                : _spacer(0),
            departureStartTime.length == 0
                ? Container()
                : _row('Take-Off Time', departureStartTime.join(', ')),
            departureStartTime.length == 0 ? Container() : _spacer(20),
            departureEndTime.length == 0
                ? Container()
                : _row('Landing Time', departureEndTime.join(', ')),
          ],
        ),
      );
  }

  Widget buildWebBody(
    String tripDates, 
    List<String> selectedFlightPreferences,
    Widget preferredAirlineWidget,
    List<String> departureEndTime,
    List<String> departureStartTime,
  ) {
    return Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Reservation Summary',
                  style: TextStyle(
                    color: Color.fromRGBO(58, 63, 92, 1),
                    fontSize: 14.w,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            Divider(height: 40),
            _spacer(),
            _row('Departure City or Airport',
                '${flyLinebloc.departureLocation.name} ${flyLinebloc.departureLocation.subdivisionName} ${flyLinebloc.departureLocation.countryCode}'),
            _spacer(25),
            _row('Arrival City or Airport',
                '${flyLinebloc.arrivalLocation.name} ${flyLinebloc.arrivalLocation.subdivisionName} ${flyLinebloc.arrivalLocation.countryCode}'),
            _spacer(25),
            _row('Trip Dates', tripDates),
            _spacer(),
            Divider(height: 40),
            _spacer(),
            _row(
                'Max Price Preference',
                Text(
                  '\$${flyLinebloc.outMaxPrice.value}',
                  style: TextStyle(
                    color: Color.fromRGBO(68, 207, 87, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.w,
                  ),
                )),
            _spacer(),
            selectedFlightPreferences.length == 0
                ? Container()
                : Divider(height: 40),
            preferredAirlineWidget,
            selectedFlightPreferences.length == 0 ? Container() : _spacer(15),
            selectedFlightPreferences.length == 0
                ? Container()
                : _row(
                    'Flight Preferences',
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          selectedFlightPreferences.join(', '),
                          style: TextStyle(
                            color: Color.fromRGBO(58, 63, 92, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.w
                          ),
                        ),
                      ),
                    ),
                  ),
            departureEndTime.length == 0 && departureStartTime.length == 0
                ? Container()
                : _spacer(),
            departureEndTime.length == 0 && departureStartTime.length == 0
                ? Container()
                : Divider(height: 30),
            departureEndTime.length == 0 && departureStartTime.length == 0
                ? Container()
                : _row('', ''),
            departureEndTime.length == 0 && departureStartTime.length == 0
                ? Container()
                : _spacer(0),
            departureStartTime.length == 0
                ? Container()
                : _row('Take-Off Time', departureStartTime.join(', ')),
            departureStartTime.length == 0 ? Container() : _spacer(20),
            departureEndTime.length == 0
                ? Container()
                : _row('Landing Time', departureEndTime.join(', ')),
          ],
        ),
      );
  }

  Widget _spacer([double height]) {
    return SizedBox(height: height ?? 8);
  }

  Widget _row(String leading, dynamic trailing) {
    return ScreenTypeLayout(
      mobile: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leading,
            style: TextStyle(
              color: Color(0xffbbc4dc),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing is String
              ? Text(
                  trailing,
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontWeight: FontWeight.w700,
                  ),
                )
              : trailing,
        ],
      ),
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leading,
            style: TextStyle(
              color: Color.fromRGBO(58, 63, 92, 1),
              fontSize: 12.w,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing is String
              ? Text(
                  trailing,
                  style: TextStyle(
                    fontSize: 12.w,
                    color: Color.fromRGBO(58, 63, 92, 1),
                    fontWeight: FontWeight.w500,
                  ),
                )
              : trailing,
        ],
      ),
    );
  }
}
