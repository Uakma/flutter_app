import 'package:flutter/material.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/airline_logo.dart';
import 'package:motel/widgets/flight_card_airline_logos.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FlightCardHeader extends StatelessWidget {
  const FlightCardHeader({
    Key key,
    @required this.type,
    @required this.logos,
    @required this.price,
    this.reviewPage = false,
  }) : super(key: key);

  final SearchType type;
  final List<AirlineLogo> logos;
  final num price;
  final bool reviewPage;

  String get getTypeName => type == SearchType.FARE
      ? "FlyLine Fare"
      : type == SearchType.EXCLUSIVE ? "FlyLine Exclusive" : "Meta Fare";

  Color get getTypeColor => type == SearchType.FARE
      ? Color.fromRGBO(14, 49, 120, 1)
      : type == SearchType.EXCLUSIVE
          ? Color.fromRGBO(0, 174, 239, 1)
          : Color.fromRGBO(68, 207, 87, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if(reviewPage) ...[
                  Text(
                    "Trip Details",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff0e3178),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),

              ] else ...[
                if (price != null)
                  Text(
                    "${Provider.of<SettingsBloc>(context).selectedCurrency.sign} " + price.toStringAsFixed(0),
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff0e3178),
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                if (price == null)
                  Container(
                    height: 20,
                    child: Shimmer.fromColors(
                      baseColor: Color(0xFFBBC4DC),
                      highlightColor: Color(0xFFBBC4DC),
                      child: Text(
                        " Loading ",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xff0e3178),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
              ],
              Container(
                margin: const EdgeInsets.only(left: 20, bottom: 0),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                decoration: BoxDecoration(
                    color: getTypeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text(
                  getTypeName,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: getTypeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
          FlightCardAirlineLogos(logos: logos,),
        ],
      ),
    );
  }
}
