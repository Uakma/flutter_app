import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/screens/home/local_widgets/blue_button.dart';
import 'package:motel/screens/home/local_widgets/web_bottom_button.dart';
import 'package:motel/screens/introduction/introductionScreen.dart';
import 'package:motel/screens/log_in/log_in.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:motel/widgets/web_bottom_widget.dart';
import 'package:motel/widgets/web_header_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key key,
    this.message = "Loading Search Results",
  }) : super(key: key);

  final String message;

  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: buildMobileContent(context),
      desktop: buildWebContent(context),
    );
  }

  Widget buildWebContent(BuildContext context) {
    return Column(
      children: [
        WebHeaderWidget(
              leftButton: GestureDetector(
                child: SvgImageWidget.asset(
                  'assets/svg/arrow_back.svg',
                  width: 11.h,
                  height: 22.h
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              rightButton: BlueButtonWidget(
                width: 132.w,
                height: 43.h,
                text: 'Sign in',
                onPressed: () {
                  showDialog(
                    context: context, 
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: (MediaQuery.of(context).size.width - 477.w) / 2,
                          vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                        ),
                        child: IntroductionScreen(
                          onTapSignIn: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context, 
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (MediaQuery.of(context).size.width - 557.w) / 2,
                                    vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                                  ),
                                  child: LoginScreen(),
                                )
                              )
                            );
                          },
                          onTapSignUp: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context, 
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (MediaQuery.of(context).size.width - 557.w) / 2,
                                    vertical: (MediaQuery.of(context).size.height - 640.h) / 2,
                                  ),
                                  child: SignUpScreen(),
                                )
                              )
                            );
                          }
                        ),
                      )
                    )
                  );
                },
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Color(0xFFFFFFFF),
                  ),
                  Positioned(
                    // top: screenHeight(context) / 2,
                    // left: screenWidth(context) / 2.2,
                    child: Align(
                      alignment: Alignment(0, -0.1),
                      child: CupertinoTheme(
                        data: CupertinoTheme.of(context).copyWith(
                            primaryColor: Colors.white, brightness: Brightness.dark),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Positioned(
                    // top: screenHeight(context) / 2.2,
                    // left: screenWidth(context) / 4.2,
                    child: Align(
                      alignment: Alignment(0, 0.1),
                      child: Material(
                        color: Color(0xFFFFFFFF),
                        child: new Text(
                          message,
                          style: TextStyle(
                            color: Color(0xFF0E3178),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
            WebBottomWidget()
      ],
    );
  }

  Widget buildMobileContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Color(0xFFFFFFFF),
        ),
        Positioned(
          // top: screenHeight(context) / 2,
          // left: screenWidth(context) / 2.2,
          child: Align(
            alignment: Alignment(0, -0.1),
            child: CupertinoTheme(
              data: CupertinoTheme.of(context).copyWith(
                  primaryColor: Colors.white, brightness: Brightness.dark),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Positioned(
          // top: screenHeight(context) / 2.2,
          // left: screenWidth(context) / 4.2,
          child: Align(
            alignment: Alignment(0, 0.1),
            child: Material(
              color: Color(0xFFFFFFFF),
              child: new Text(
                message,
                style: TextStyle(
                  color: Color(0xFF0E3178),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
