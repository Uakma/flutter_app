import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/screens/home/home.dart';
import 'package:motel/widgets/svg_image_widget.dart';



class BugPage extends StatefulWidget {

  @override
  _BugPageState createState() => _BugPageState();
}

class _BugPageState extends State<BugPage> {
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
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen()));

                },
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                  child: Text(
                    'Home',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Gilroy",
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.white,
                onPressed: () {

                },
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  child: Text(
                    'Support',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Gilroy",
                        fontWeight: FontWeight.bold),
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
        backgroundColor: Color(0xfff7f9fc),
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
        body:  Stack(
          children: <Widget>[
            Stack(
                children: <Widget>[
                  Column(
                    // Base
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff00AEEF),
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
                        // Positioned(
                        //   bottom: 350,
                        //   left: 110,
                        //   child: SvgImageWidget.asset(
                        //       'assets/svg/on_boarding/clound.svg'),
                        // ),
                        // Positioned(
                        //   bottom: 300,
                        //   right: -35,
                        //   child: SvgImageWidget.asset(
                        //       'assets/svg/on_boarding/clound.svg'),
                        // ),
                        // Positioned(
                        //   bottom: 200,
                        //   left: 100,
                        //   child: SvgImageWidget.asset(
                        //       'assets/svg/on_boarding/clound.svg'),
                        // ),
                        // Positioned(
                        //   bottom: -90,
                        //   right: -40,
                        //   child: SvgImageWidget.asset(
                        //       'assets/svg/on_boarding/line_two.svg'),
                        // ),
                        // Positioned(
                        //   bottom: -100,
                        //   left: 0,
                        //   child: SvgImageWidget.asset(
                        //       'assets/svg/on_boarding/line_one.svg'),
                        // ),
                        Positioned(
                          top: -250,
                          left: -60,
                          width: 600,
                          child: SvgImageWidget.asset(
                            'assets/svg/on_boarding/on_boarding_three_white.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),]),

            ///
            // Positioned(
            //   // Top Circles
            //   top: 0,
            //   right: 0,
            //   bottom: 0,
            //   left: 0,
            //   child: Stack(
            //     children: <Widget>[
            //       // Positioned(
            //       //   child: SvgImageWidget.asset(
            //       //       'assets/svg/on_boarding/on_boarding_three_circle_one.svg'),
            //       //   top: -150,
            //       //   left: -150,
            //       // ),
            //       Positioned(
            //         child: SvgImageWidget.asset(
            //             'assets/svg/on_boarding/on_boarding_one_circle_two.svg'),
            //         top: 50,
            //         left: 130,
            //       ),
            //     ],
            //   ),
            // ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin:
                    EdgeInsets.fromLTRB(0, 140, 0, 80),
                    child: Center(
                      child: SvgImageWidget.asset(
                          'assets/svg/on_boarding/plane_illustration.svg'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 0, horizontal: 50),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Oops, looks like\n you found a bug',
                            style: TextStyle(
                              fontFamily: "Gilroy",
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 0, horizontal: 50),
                    child: Text(
                      'It seems like you found a bug, this has been reported to our team, and we will fix it shortly, in the meantime go back and try again or reach out to support team (hello@flyline.io) for further help.',
                      style: TextStyle(
                        fontFamily: "Gilroy",
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
        )



    );
  }
}
