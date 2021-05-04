import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motel/models/booked_flight.dart';
import 'package:motel/screens/trips/local_widgets/label_value.dart';
import 'package:motel/widgets/airline_logo.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:motel/models/boardingpass_url.dart';

class UpcomingTripDetail extends StatefulWidget {
  const UpcomingTripDetail({
    Key key,
    @required this.flight,
    this.isReturn = false,
    this.opacity,
  }) : super(key: key);

  final BookedFlight flight;
  final bool isReturn;
  final double opacity;

  @override
  _UpcomingTripDetailState createState() => _UpcomingTripDetailState();
}

class _UpcomingTripDetailState extends State<UpcomingTripDetail> {
  int _current = 0;
  BoardingPassAirlineUrl boardingPassUrl = BoardingPassAirlineUrl();

  List<Flight> get filteredFlights => widget.flight.flights
      .where((element) => element.isReturn == widget.isReturn)
      .toList();

  int get numberOfFlights => filteredFlights.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 140 + (numberOfFlights * 110.0),
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: false,
              height: double.infinity,
              enableInfiniteScroll: widget.flight.data.passengers.length > 1,
              onPageChanged: updateScrollIndicator,
            ),
            items: widget.flight.data.passengers
                .map(
                  (passenger) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    'Passenger : ',
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  passenger.name,
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff333333),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    'Trip Status : ',
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  'On-Time',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    color: Color(0xff44CF57),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 52 + (numberOfFlights * 110.0),
                              width: 10,
                              padding: EdgeInsets.only(top: 36.0),
                              margin: EdgeInsets.only(left: 8),
                              child: CustomPaint(
                                painter: DashedLinePainter(
                                  stops: numberOfFlights,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlightDestinationDetailRow(
                                    flight: filteredFlights.first,
                                    flightDestinationDetail:
                                        FlightDestinationDetail(
                                      city: filteredFlights.first.data.cityFrom,
                                      cityCode: filteredFlights
                                          .first.data.cityCodeFrom,
                                      localTime: filteredFlights
                                          .first.data.localDeparture,
                                    ),
                                  ),
                                  ...List.generate(
                                          numberOfFlights - 1, (index) => index)
                                      .map(
                                    (e) => Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 120,
                                            right: 30,
                                          ),
                                          child: Divider(),
                                        ),
                                        FlightDestinationDetailRow(
                                          flight: filteredFlights[e + 1],
                                          flightDestinationDetail:
                                              FlightDestinationDetail(
                                            city: filteredFlights[e + 1]
                                                .data
                                                .cityFrom,
                                            cityCode: filteredFlights[e + 1]
                                                .data
                                                .cityCodeFrom,
                                            localTime: filteredFlights[e + 1]
                                                .data
                                                .localDeparture,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FlightDestinationDetail(
                                        city: filteredFlights.last.data.cityTo,
                                        cityCode: filteredFlights
                                            .last.data.cityCodeTo,
                                        localTime: filteredFlights
                                            .last.data.localArrival,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: 180,
                                                  child: RawMaterialButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                WebviewScaffold(
                                                                  enableAppScheme:
                                                                      true,
                                                                  url: boardingPassUrl
                                                                          .airlineJsonData[
                                                                      filteredFlights
                                                                          .first
                                                                          .data
                                                                          .airline
                                                                          .code],
                                                                  appBar:
                                                                      AppBar(
                                                                    backgroundColor:
                                                                    Colors.white,
                                                                    elevation:
                                                                        0.0,
                                                                    centerTitle:
                                                                        true,
                                                                    iconTheme: IconThemeData(
                                                                        color: Colors
                                                                            .grey),
                                                                    title: Text(
                                                                      "Mange Booking",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Gilroy',
                                                                        color: Color(
                                                                            0xff0E3178),
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  withZoom:
                                                                      true,
                                                                  withLocalStorage:
                                                                      true,
                                                                  withJavascript:
                                                                      true,
                                                                )),
                                                      );
                                                    },
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10,
                                                    ),
                                                    elevation: 0,
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    hoverElevation: 0,
                                                    highlightElevation: 0,
                                                    focusElevation: 0,
                                                    child: Text(
                                                      "Manage Booking",
                                                      style: TextStyle(
                                                        fontFamily: 'Gilroy',
                                                        color: Color.fromRGBO(
                                                            0, 174, 239, 1),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                    ),
                                                    fillColor: Color.fromRGBO(
                                                        0, 174, 239, .1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: RawMaterialButton(
                                                    onPressed: () {},
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10,
                                                    ),
                                                    elevation: 0,
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    hoverElevation: 0,
                                                    highlightElevation: 0,
                                                    focusElevation: 0,
                                                    child: Text(
                                                        "Change or Cancel",
                                                        style: TextStyle(
                                                          fontFamily: 'Gilroy',
                                                          color: Color.fromRGBO(
                                                              0, 174, 239, 1),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        )),
                                                    fillColor: Color.fromRGBO(
                                                        0, 174, 239, .1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        if (widget.flight.data.passengers.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.flight.data.passengers.map((passenger) {
              int index = widget.flight.data.passengers.indexOf(passenger);
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _current == index ? 32.0 : 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 174, 239, 1)
                      : Color.fromRGBO(0, 174, 239, .5),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  void updateScrollIndicator(int page, CarouselPageChangedReason reason) {}
}

class DashedLinePainter extends CustomPainter {
  DashedLinePainter({
    this.stops = 1,
  });

  final num stops;

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 7, dashSpace = 4, startY = 0;
    var paint = Paint()
      ..color = Color(0xFFB1B1B1)
      ..strokeWidth = 1;
    while (startY < size.height - 5) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
    List.generate(stops, (index) => index).forEach((stop) {
      paint.color = Color(0xFFB1B1B1);
      canvas.drawCircle(Offset(0, (startY / stops) * stop), 5, paint);
      paint.color = Colors.white;
      canvas.drawCircle(Offset(0, (startY / stops) * stop), 2, paint);
      paint.color = Color(0xFF0E3178);
    });

    canvas.drawCircle(Offset(0, startY), 5, paint);
    paint.color = Colors.white;
    canvas.drawCircle(Offset(0, startY), 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FlightDestinationDetail extends StatelessWidget {
  const FlightDestinationDetail({
    Key key,
    @required this.city,
    @required this.cityCode,
    @required this.localTime,
  }) : super(key: key);

  final String city;
  final String cityCode;
  final DateTime localTime;

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat.jm();
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$city', //, ${e.data.countryTo.code}',
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Color(0xffBBC4DC),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '$cityCode',
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff0E3178),
                fontSize: 26,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          Text(
            '${dateFormatter.format(localTime).toLowerCase()}',
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Color(0xff707070),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class FlightDestinationDetailRow extends StatelessWidget {
  const FlightDestinationDetailRow({
    Key key,
    @required this.flight,
    @required this.flightDestinationDetail,
  }) : super(key: key);

  final Flight flight;
  final FlightDestinationDetail flightDestinationDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        flightDestinationDetail,
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LabelValue(
                    label: 'Airline',
                    valueWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            flight.data.airline.airlineName,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff333333),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        AirlineLogo(
                          airline: flight.data.airline.code,
                        ),
                      ],
                    ),
                  ),
                  LabelValue(
                    label: 'Class of Service',
                    value: 'Basic',
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  LabelValue(
                    label: 'Flight Number',
                    value: flight.data.flightNo,
                  ),
                  LabelValue(
                    label: 'Seat Number',
                    value: 'Not Available',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
