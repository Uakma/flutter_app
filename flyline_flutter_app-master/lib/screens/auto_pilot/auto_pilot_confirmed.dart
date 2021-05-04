import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/widgets/svg_image_widget.dart';


/// Author: Ali Dali
/// Last Updated: 28-07-2020

class ConfirmedScreen extends StatefulWidget {
  @override
  _ConfirmedScreenState createState() => _ConfirmedScreenState();
}

class _ConfirmedScreenState extends State<ConfirmedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.introColor,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              Container(
                child: Center(
                  child:  Image.asset(
                    'assets/images/on_boarding_mocs/illustration_four.png', width: 375, height: 375,),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Your reservation has been placed',
                        style: TextStyle(
                          fontFamily: "Gilroy",
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: HexColor("#0E3178"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Text(
                  'Congrats! You have placed an autopilot reservation we will send you an email and push notification if a flight meets your preferences.',
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    fontSize: 18,
                    height: 1.8,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(142, 150, 159, 1),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 175,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: HexColor("#00AEEF"),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.SearchScreen,
                            (Route<dynamic> route) => false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 16,
                            color: HexColor("#ffffff"),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 175,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: HexColor("#00AEEF"),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, Routes.HELP,
                            (Route<dynamic> route) => false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'More Info',
                          style: TextStyle(
                            fontSize: 16,
                            color: HexColor("#ffffff"),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class Routes {
  static const String SearchScreen = "/home/logged_home";
  static const String SPLASH = "/";
  static const String HELP = "/home/help";
}
