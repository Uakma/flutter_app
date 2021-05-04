import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:motel/widgets/airline_logo.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TripDetailsDestinationDetailsRow extends StatelessWidget {
  const TripDetailsDestinationDetailsRow({
    Key key,
    @required this.localTime,
    @required this.city,
    this.logos,
    @required this.flight,
  }) : super(key: key);

  final DateTime localTime;
  final String city;
  final String flight;
  final List<AirlineLogo> logos;

  @override
  Widget build(BuildContext context) {
    final formatTime = DateFormat("hh : mm a");
    return ScreenTypeLayout(
        mobile: Row(
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 3,
                color: Color(0xff3A3F5C),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: "${formatTime.format(localTime)}  - ",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextSpan(
                    text: "$flight($city)",
                    style: TextStyle(
                      color: Color(0xffBBC4DC),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          if (logos != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: logos,
            ),
        ],
      ),
      desktop: Row(
        children: <Widget>[
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(
                width: 2,
                color: Color(0xff3A3F5C),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.w),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 12.w,
                ),
                children: [
                  TextSpan(
                    text: "${formatTime.format(localTime)}  - ",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff333333),
                      fontSize: 12.w,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextSpan(
                    text: "$flight($city)",
                    style: TextStyle(
                      color: Color(0xffBBC4DC),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          if (logos != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: logos,
            ),
        ],
      ),
    );
  }
}
