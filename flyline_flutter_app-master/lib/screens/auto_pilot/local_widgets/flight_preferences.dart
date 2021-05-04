import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'airline_tag.dart';
import 'tag.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class FlightPreferences extends StatefulWidget {
  @override
  _FlightPreferencesState createState() => _FlightPreferencesState();
}

class _FlightPreferencesState extends State<FlightPreferences> {
  List<String> flightPreferences = [
    'Direct Flight',
    'Single Carrier',
    'Quickest (Durration)',
    'Economy'
  ];
  bool isAdditionalFlightPrefExpand = false;
  int airlinesPrefShowItemsCounter = 5;

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
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Set Flight Preferences',
                    style: TextStyle(
                      color: Color(0xff0e3178),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Optional',
                  style: TextStyle(
                    color: Color(0xffbbc4dc),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              'Select your preferred airline(s) and additional \npreferences for your autopilot reservation.',
              style: TextStyle(
                color: Color(0xff8e969f),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                height: 1.7,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Select Preferred Airline(s)',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildAirlinesPref(),
            SizedBox(height: 25),
            Text(
              'Additional Flight Preferences',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildFlightTags(),
          ],
        ),
      );
  }

  Widget buildWebContent() {
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select Preferred Airlines',
              style: TextStyle(
                color: Color.fromRGBO(58, 63, 92, 1),
                fontSize: 14.w,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildAirlinesPref(),
            SizedBox(height: 50.w),
            Text(
              'Additional Flight Preferences',
              style: TextStyle(
                color: Color.fromRGBO(58, 63, 92, 1),
                fontSize: 14.w,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildFlightTags(),
          ],
        ),
      );
  }

  Widget _buildAirlinesPref() {
    List<String> airlinesPrefList = [];

    List<String> airlinesDefault = [
      'AA',
      'DL',
      'IB',
      'WN',
      'F9',
      'LH',
      'VS',
      'NK'
    ];

    List<String> airlinesUS = [
      'AA',
      'DL',
      'UA',
      'AS',

      'F9',
      'NK',
      'B6',
      'WN'
    ];

    if ( flyLinebloc.arrivalLocation.countryCode == "UK" && flyLinebloc.departureLocation.countryCode == "US" ) {
      airlinesPrefList.add("BA");
    }
    else if ( flyLinebloc.arrivalLocation.countryCode == "US" || flyLinebloc.departureLocation.countryCode == "US" ){
      airlinesPrefList.addAll(airlinesUS);
    }else{
      airlinesPrefList.addAll(airlinesDefault);
    }



    return ScreenTypeLayout(
      mobile: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        height: 50,
        child: ListView.builder(
          itemBuilder: (context, pos) {
            return AirLineTag(
              airlinesPrefList[pos],
              isLastItemIndex: (pos == airlinesPrefShowItemsCounter),
              lastShowCounter:
                  (airlinesPrefList.length - airlinesPrefShowItemsCounter),
              onExpandList: (isExpand) {
                airlinesPrefShowItemsCounter = airlinesPrefList.length;
                setState(() {});
              },
            );
          },
          itemCount: (airlinesPrefShowItemsCounter == airlinesPrefList.length)
              ? airlinesPrefShowItemsCounter
              : airlinesPrefShowItemsCounter + 1,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
        ),
      ),
      desktop: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        height: 50.w,
        child: ListView.builder(
          itemBuilder: (context, pos) {
            return AirLineTag(
              airlinesPrefList[pos],
              isLastItemIndex: (pos == airlinesPrefShowItemsCounter),
              lastShowCounter:
                  (airlinesPrefList.length - airlinesPrefShowItemsCounter),
              onExpandList: (isExpand) {
                airlinesPrefShowItemsCounter = airlinesPrefList.length;
                setState(() {});
              },
            );
          },
          itemCount: (airlinesPrefShowItemsCounter == airlinesPrefList.length)
              ? airlinesPrefShowItemsCounter
              : airlinesPrefShowItemsCounter + 1,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget _buildFlightTags() {
    List<Widget> flightPreferencesTags = [];
    List<String> selectedFlightPreferences =
        flyLinebloc.flightPreferences ?? [];

    for (String flightPreference in flightPreferences) {
      bool selected = false;
      if (selectedFlightPreferences.contains(flightPreference)) {
        selected = true;
      }

      flightPreferencesTags.add(
        Tag(
          flightPreference,
          selected: selected,
          onSelected: (selected) {
            if (selected) {
              _addFlightPreference(flightPreference);
              setState(() {});
            } else {
              _removeFlightPreference(flightPreference);
            }
          },
        ),
      );
    }

    flightPreferencesTags.add(isAdditionalFlightPrefExpand
        ? SizedBox.shrink()
        : Tag('Additional Preferences', selected: false, onSelected: (val) {
            flightPreferences.add('Economy Premium');
            flightPreferences.add('Business Class');
            flightPreferences.add('First Class');
            isAdditionalFlightPrefExpand = true;

            setState(() {});
          }));
    return Wrap(children: flightPreferencesTags);
  }

  void _addFlightPreference(String flightPreference) {
    List<String> flightPreferences = flyLinebloc.flightPreferences ?? [];
    if (flightPreference == 'Economy' ||
        flightPreference == 'Economy Premium' ||
        flightPreference == 'Business Class' ||
        flightPreference == 'First Class') {
      flightPreferences.remove('Economy');
      flightPreferences.remove('Economy Premium');
      flightPreferences.remove('Business Class');
      flightPreferences.remove('First Class');
    }
    flightPreferences.add(flightPreference);
    flyLinebloc.setFlightPreferences(flightPreferences);
  }

  void _removeFlightPreference(String flightPreference) {
    List<String> flightPreferences = flyLinebloc.flightPreferences ?? [];
    flightPreferences.remove(flightPreference);
    flyLinebloc.setFlightPreferences(flightPreferences);
  }
}
