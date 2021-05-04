import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motel/models/booked_flight.dart';
import 'package:motel/screens/trips/local_widgets/upcoming_trip_detail.dart';

class UpcomingTripCard extends StatefulWidget {
  const UpcomingTripCard({
    Key key,
    @required this.flight,
    this.isReturn = false,
  }) : super(key: key);

  final BookedFlight flight;
  final bool isReturn;



  @override
  _UpcomingTripCardState createState() => _UpcomingTripCardState();
}

class _UpcomingTripCardState extends State<UpcomingTripCard> {
  bool _show = false;
  double _opacity = 0;

  var provider = "";

  Color get getTypeColor => widget.flight.provider == "duffel"
      ? Color.fromRGBO(14, 49, 120, 1)
      : widget.flight.provider == "Kiwi"
      ? Color.fromRGBO(0, 174, 239, 1)
      : Color.fromRGBO(68, 207, 87, 1);

  @override
  Widget build(BuildContext context) {

    if (widget.flight.provider == "duffel") {
        provider = "FlyLine Fare";
    } else if (widget.flight.provider == "Kiwi") {
      provider = "FlyLine Exclusive";
    }

    final dateFormatter = DateFormat("MMM dd");
    return InkWell(
      onTap: () => setState(() => _show = !_show),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 9),
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              padding: EdgeInsets.only(
                left: 24,
                top: 20,
                bottom: 12,
                right: 11,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          !widget.isReturn
                              ? 'Departure from ${widget.flight.data.cityFrom} - ${dateFormatter.format(widget.flight.data.localDeparture)}th'
                              : 'Return from ${widget.flight.data.cityTo} - ${dateFormatter.format(widget.flight.data.returnDeparture)}th',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xffBBC4DC),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 0),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                          decoration: BoxDecoration(
                              color: getTypeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            provider,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: getTypeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      !widget.isReturn
                          ? 'To ${widget.flight.data.cityTo}'
                          : 'To ${widget.flight.data.cityFrom}',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff0E3178),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tap to View More Info',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xff44CF57),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Confirmation Number : ${widget.flight.confirmationNumber}',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xffBBC4DC),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${widget.flight.data.passengers.length} ${widget.flight.data.passengers.length > 1 ? 'Passengers' : 'Passenger'}',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xffBBC4DC),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              margin: EdgeInsets.only(top: _show ? 10 : 0),
              padding: EdgeInsets.only(
                left: 24,
                top: 15,
                bottom: 8,
                right: 11,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              duration: Duration(milliseconds: 500),
              height: _show
                  ? widget.flight.data.passengers.length > 1
                      ? (220 +
                          ((widget.flight.flights
                                  .where((element) =>
                                      element.isReturn == widget.isReturn)
                                  .length) *
                              110.0))
                      : (190 +
                          ((widget.flight.flights
                                  .where((element) =>
                                      element.isReturn == widget.isReturn)
                                  .length) *
                              110.0))
                  : 0,
              onEnd: () => setState(() {
                _opacity = 1;
              }),
              child: UpcomingTripDetail(
                flight: widget.flight,
                isReturn: widget.isReturn,
                opacity: _opacity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
