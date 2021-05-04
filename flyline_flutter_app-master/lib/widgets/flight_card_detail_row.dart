import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motel/helper/helper.dart';

class FlightCardDetailRow extends StatelessWidget {

  const FlightCardDetailRow({
    Key key,
    @required this.from,
    @required this.to,
    @required this.localDeparture,
    @required this.localArrival,
    @required this.duration,
    @required this.stops,
    @required this.colorLocation,
  }) : super(key: key);

  final String from;
  final String to;
  final String duration;
  final DateTime localDeparture;
  final DateTime localArrival;
  final Color colorLocation;
  final List<StopDetails> stops;

  String get stopsLabel => (stops.length > 0
      ? (stops.length > 1
          ? "${stops.length} Stopovers"
          : "${stops.length} Stopover ")
      : "Non-Stop");


  @override
  Widget build(BuildContext context) {
    final DateFormat formatTime = DateFormat("hh : mm a");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$from - ",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xffBBC4DC),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextSpan(
                      text: to,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: colorLocation,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 10,
                top: 8.0,
              ),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: formatTime.format(localDeparture) + " - ",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff333333),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextSpan(
                    text: formatTime.format(localArrival) + " ",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff333333),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Travel time",
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xffBBC4DC),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                duration,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff333333),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                stopsLabel,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xffBBC4DC),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            (stops.length > 0
                ? Row(
                    children: stops
                        .map(
                          (e) => RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: e.to + '  ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff333333),
                                  ),
                                ),
                                if (stops.length == 1)
                                  TextSpan(
                                    text: Helper.duration(e.duration),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                      color: Helper.getColor(e.duration),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Text(
                    "Direct",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  )),
          ],
        ),
      ],
    );
  }
}

class StopDetails {
  final String to;
  final Duration duration;
  final String city;

  StopDetails({
    @required this.to,
    @required this.duration,
    @required this.city,
  });

  String durationString() {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    // final int seconds = duration.inSeconds.remainder(60);
    String result = '';
    if (hours > 0) {
      result += '${hours}h';
    }
    if (minutes > 0) {
      result += result.isEmpty ? '${minutes}m' : ' ${minutes}m';
    }
    return result;
  }
}
