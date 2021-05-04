import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'tag.dart';


class TimePreferences extends StatelessWidget {
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
                    'Set Time Preferences',
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
              'Tap the tags below to add take-off and landing \ntimes for your reservation',
              style: TextStyle(
                color: Color(0xff8e969f),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                height: 1.7,
              ),
            ),
            SizedBox(height: 25),
            Text(
              '${flyLinebloc.departureLocation.name} ${flyLinebloc.departureLocation.subdivisionName} ${flyLinebloc.departureLocation.countryCode} - ${flyLinebloc.arrivalLocation.name} ${flyLinebloc.arrivalLocation.subdivisionName} ${flyLinebloc.arrivalLocation.countryCode}',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildTimeTags(true),
            SizedBox(height: 25),
            Text(
              '${flyLinebloc.arrivalLocation.name} ${flyLinebloc.arrivalLocation.subdivisionName} ${flyLinebloc.arrivalLocation.countryCode} - ${flyLinebloc.departureLocation.name} ${flyLinebloc.departureLocation.subdivisionName} ${flyLinebloc.departureLocation.countryCode}',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildTimeTags(false),
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
              '${flyLinebloc.departureLocation.name} ${flyLinebloc.departureLocation.subdivisionName} ${flyLinebloc.departureLocation.countryCode} - ${flyLinebloc.arrivalLocation.name} ${flyLinebloc.arrivalLocation.subdivisionName} ${flyLinebloc.arrivalLocation.countryCode}',
              style: TextStyle(
                color: Color.fromRGBO(58, 63, 92, 1),
                fontSize: 14.w,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildTimeTags(true),
            SizedBox(height: 48.w),
            Text(
              '${flyLinebloc.arrivalLocation.name} ${flyLinebloc.arrivalLocation.subdivisionName} ${flyLinebloc.arrivalLocation.countryCode} - ${flyLinebloc.departureLocation.name} ${flyLinebloc.departureLocation.subdivisionName} ${flyLinebloc.departureLocation.countryCode}',
              style: TextStyle(
                color: Color.fromRGBO(58, 63, 92, 1),
                fontSize: 14.w,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            _buildTimeTags(false),
          ],
        ),
      );
  }

  Widget _buildTimeTags(bool departure) {
    List<String> timePreferences = ['Morning', 'Afternoon', 'Evening'];

    List<String> selectedStartTime = (departure
            ? flyLinebloc.departureStartTime
            : flyLinebloc.returnStartTime) ??
        [];
    List<Widget> startTimeTags = [];
    startTimeTags.add(
      ScreenTypeLayout(
        mobile: Text(
          'Take-off',
          style: TextStyle(
            color: Color(0xffbbc4dc),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        desktop: Text(
          'Take-off',
          style: TextStyle(
            color: Color.fromRGBO(58, 63, 92, 1),
            fontSize: 12.w,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
    startTimeTags.add(SizedBox(width: 12));

    for (String timePreference in timePreferences) {
      bool selected = false;
      if (selectedStartTime.contains(timePreference)) {
        selected = true;
      }

      startTimeTags.add(
        Expanded(
            child:
                Tag(timePreference, selected: selected, onSelected: (selected) {
          if (selected) {
            _addStartTime(timePreference, departure);
          } else {
            _removeStartTime(timePreference, departure);
          }
        })),
      );
    }

    List<String> selectedEndTime = (departure
            ? flyLinebloc.departureEndTime
            : flyLinebloc.returnEndTime) ??
        [];
    List<Widget> endTimeTags = [];
    endTimeTags.add(
      ScreenTypeLayout(
        mobile: Text(
          'Landing',
          style: TextStyle(
            color: Color(0xffbbc4dc),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        desktop: Text(
          'Landing',
          style: TextStyle(
            color: Color.fromRGBO(58, 63, 92, 1),
            fontSize: 12.w,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
    endTimeTags.add(SizedBox(width: 12));

    for (String timePreference in timePreferences) {
      bool selected = false;
      if (selectedEndTime.contains(timePreference)) {
        selected = true;
      }

      endTimeTags.add(
        Expanded(
            child:
                Tag(timePreference, selected: selected, onSelected: (selected) {
          if (selected) {
            _addEndTime(timePreference, departure);
          } else {
            _removeEndTime(timePreference, departure);
          }
        })),
      );
    }

    return Column(
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: startTimeTags,
        ),
        Flex(
          direction: Axis.horizontal,
          children: endTimeTags,
        )
      ],
    );
  }

  void _addStartTime(String timePreference, bool departure) {
    List<String> startTime = (departure
            ? flyLinebloc.departureStartTime
            : flyLinebloc.returnStartTime) ??
        [];
    startTime.add(timePreference);
    departure
        ? flyLinebloc.setDepartureStartTime(startTime)
        : flyLinebloc.setReturnStartTime(startTime);
  }

  void _removeStartTime(String timePreference, bool departure) {
    List<String> startTime = (departure
            ? flyLinebloc.departureStartTime
            : flyLinebloc.returnStartTime) ??
        [];
    startTime.remove(timePreference);
    departure
        ? flyLinebloc.setDepartureStartTime(startTime)
        : flyLinebloc.setReturnStartTime(startTime);
  }

  void _addEndTime(String timePreference, bool departure) {
    List<String> endTime = (departure
            ? flyLinebloc.departureEndTime
            : flyLinebloc.returnEndTime) ??
        [];
    endTime.add(timePreference);
    departure
        ? flyLinebloc.setDepartureEndTime(endTime)
        : flyLinebloc.setReturnEndTime(endTime);
  }

  void _removeEndTime(String timePreference, bool departure) {
    List<String> endTime = (departure
            ? flyLinebloc.departureEndTime
            : flyLinebloc.returnEndTime) ??
        [];
    endTime.remove(timePreference);
    departure
        ? flyLinebloc.setDepartureEndTime(endTime)
        : flyLinebloc.setReturnEndTime(endTime);
  }
}
