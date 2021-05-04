import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/screens/home/home.dart';
import 'package:motel/screens/app_settings/help_center.dart';
import 'package:motel/widgets/svg_image_widget.dart';

import '../../theme/appTheme.dart';

class BookingCompletePage extends StatefulWidget {
  @override
  _BookingCompletePageState createState() => _BookingCompletePageState();
}

class _BookingCompletePageState extends State<BookingCompletePage> {
  Widget _overLayers() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(60, 40, 50, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: HexColor("#00AEEF"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen())
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Text(
                    'Home',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor("#ffffff"),
                        fontFamily: "Gilroy",
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: HexColor("#00AEEF"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpCenterScreen())
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    'More Info',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor("#ffffff"),
                        fontFamily: "Gilroy",
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.introColor,
        // backgroundColor: Color(0xfff7f9fc),
        // body: Center(
        //   child: SingleChildScrollView(
        //     child: Padding(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Image.asset('assets/images/booking.png'),
        //           const SizedBox(height: 20),
        //           new Text(
        //             "Your Trip has been successfully booked!",
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               fontFamily: 'Gilroy',
        //               color: Color(0xff8e969f),
        //               fontSize: 18,
        //               fontWeight: FontWeight.w500,
        //               fontStyle: FontStyle.normal,
        //             ),
        //           ),
        //           const SizedBox(height: 20),
        //           SizedBox(
        //             width: double.infinity,
        //             child: FlatButton(
        //               child: new Text(
        //                 "Back to Home",
        //                 style: TextStyle(
        //                   fontFamily: 'Gilroy',
        //                   color: Color(0xffffffff),
        //                   fontSize: 16,
        //                   fontWeight: FontWeight.w700,
        //                   fontStyle: FontStyle.normal,
        //                 ),
        //               ),
        //               onPressed: () {
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => HomeScreen()));
        //               },
        //               color: Color(0xff24aaf1),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(40),
        //               ),
        //               padding: const EdgeInsets.symmetric(
        //                   vertical: 20, horizontal: 15),
        //             ),
        //           ),
        //         ],
        //       ),
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: 30,
        //         vertical: 15,
        //       ),
        //     ),
        //   ),
        // ),
        body: Stack(
          children: <Widget>[
            Stack(children: <Widget>[
              Column(
                // Base
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor('#ffffff'),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                // bottom clouds and lines
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Stack(
                  children: <Widget>[
                  ],
                ),
              ),
            ]),


             Positioned(
               // Top Circles
               top: 0,
               right: 0,
               bottom: 0,
               left: 0,
               child: Stack(
                children: <Widget>[
                 ],
               ),
             ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 100, 0, 10),
                    child: Center(
                      child: Image.asset(
                          'assets/images/on_boarding_mocs/illustration_one.png', width: 350, height: 350,),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Your reservation \nhas been confirmed',
                            style: TextStyle(
                              fontFamily: "Gilroy",
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#0E3178"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                    child: Text(
                      'Congrats! You’re ready to fly. Remember: You can change your seat, make updates and cancellations, check upgrades, and more all from the trips tab.',
                      style: TextStyle(
                        fontFamily: "Gilroy",
                        fontSize: 18,
                        height: 1.8,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(142, 150, 159, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _overLayers()
                ],
              ),
            )
          ],
        ));
  }
}
