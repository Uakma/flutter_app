import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/screens/home/home.dart';
import 'package:motel/screens/terms_and_privacy/privacy_policy.dart';
import 'package:motel/screens/terms_and_privacy/terms_of_use.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/main.dart';
import 'package:motel/screens/log_in/log_in.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/appTheme.dart';

class IntroductionScreen extends StatefulWidget {

  IntroductionScreen({this.onTapSignIn, this.onTapSignUp});

  final Function onTapSignIn;
  final Function onTapSignUp;

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int _numPages = 4;
  bool authenticationChecked = false;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: 8.0,
        width: isActive ? 20.0 : 10.0,
        decoration: BoxDecoration(
            color: isActive ?  Color(0xff00AEEF) : Color(0xff00AEEF),
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  Widget _overLayers() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Color(0xff00AEEF),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    child: Text(
                      ' Login ',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w700,
                          color: Color(0xffffffff)),
                    ),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Color(0xff00AEEF),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    child: Text(
                      '   Get Started   ',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w700,
                          color: Color(0xffffffff)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
//        Expanded(
//          flex: 1,
//          child: Container(
//            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 55),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                _currentPage != _numPages - 1
//                    ? InkWell(
//                        onTap: () {
//                          _pageController.animateToPage(5,
//                              duration: Duration(milliseconds: 500),
//                              curve: Curves.ease);
//                        },
//                        child: Text(
//                          'Skip',
//                          style: TextStyle(
//                              fontFamily: "Gilroy",
//                              color: Color.fromRGBO(142, 150, 159, 1),
//                              fontSize: 16,
//                              fontWeight: FontWeight.w500),
//                        ),
//                      )
//                    : Container(
//                        width: 38,
//                      ),
////                Row(
////                  children: _buildPageIndicator(),
////                ),
////                _currentPage != _numPages - 1
////                    ? InkWell(
////                        onTap: () {
////                          _pageController.nextPage(
////                            duration: Duration(milliseconds: 500),
////                            curve: Curves.ease,
////                          );
////                        },
////                        child: Text(
////                          'Next',
////                          style: TextStyle(
////                              fontFamily: "Gilroy",
////                              color: Color.fromRGBO(142, 150, 159, 1),
////                              fontSize: 16,
////                              fontWeight: FontWeight.w500),
////                        ),
////                      )
////                    : Container(
////                        width: 38,
////                      ),
//              ],
//            ),
//          ),
//        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Text(
                    'FlyLine - Terms of use | Privacy policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Gilroy",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(142, 150, 159, 1),),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  var isLogin = false;

  void _checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("token_data");
    if (data != null) {
      if (data.isEmpty) {
        isLogin = true;
        setState(() {
          authenticationChecked = true;
        });
      } else {
        flyLinebloc.token = data;
        isLogin = false;
        setState(() {});
        flyLinebloc.loginResponse.stream.listen((data) => onLogginResult(data));
      }
    } else {
      isLogin = true;
      setState(() {
        authenticationChecked = true;
      });
    }
  }

  @override
  void initState() {
    _checkIsLogin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    }
    return Container(
      child: ScreenTypeLayout(
          mobile: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: buildMobileBody()
          ),
          desktop: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Center(
              child: buildWebBody()
            )
          ),
      ),
    );
  }

  Widget buildWebBody() {
    return Container(
        width: 557.h,
        height: 640.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Color.fromRGBO(247, 249, 252, 1),
            width: 2
          )
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 10.h),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  padding: EdgeInsets.all(12.w),
                  child: GestureDetector(
                    child: SvgImageWidget.asset(
                      'assets/svg/home/cancel_grey.svg',
                      width: 24.w,
                      height: 24.w
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildTitle(),
                  buildDesciption(),
                  buildLoginButton(),
                  buildSignUpButton(),
                  SizedBox(
                    height: 48.h,
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomWidget(),
              ),
            ],
          ),
        )
      );
  }

  Widget buildMobileBody() {
    return authenticationChecked ? 
          InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          buildIntroImage(),
                          SizedBox(
                            width: double.infinity,
                            // height: double.infinity,
                            child: buildTitle(),
                          ),
                          SizedBox(
                            width: double.infinity,
                            // height: double.infinity,
                            child: buildDesciption(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                buildLoginButton(),
                                buildSignUpButton(),
                                buildGuestButton(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 32, right: 32, bottom: 8, top: 16),
                            child: Container(
                              height: 50,
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(1.0)),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(1.0)),
                                  highlightColor: Colors.transparent,
                                  onTap: () {

                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                  isGustLogin = true;
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [


                                      Center(
                                        child: Text(
                                          "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Gilroy',
                                              fontSize: 16,
                                              color: Color.fromRGBO(14, 49, 120, 1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomWidget(),
              ),
            ],
          ),
        ) : 
        Container();
  }

  Widget buildBottomWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: kIsWeb ? 36.h : 40.0),
      child: InkWell(onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginScreen()));
      },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "FlyLine - ",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(142, 150, 159, 1),
                fontSize: kIsWeb ? ScreenUtil().setSp(16) : 16,
                fontFamily: "Gilroy",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => UseTermsPage(),
                  transitionsBuilder: (c, anim, a2, child) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 1.0),
                      end: Offset(0.0, 0.0)).animate(anim),
                      child: child,
                    ),
                    transitionDuration: Duration(milliseconds: 300),
                ));
              },
              child: Text(
                "Terms of Use",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HexColor("#0E3178"),
                  fontSize: kIsWeb ? ScreenUtil().setSp(16) : 16,
                  fontFamily: "Gilroy",
                ),
              ),
            ),
            Text(
              " | ",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(142, 150, 159, 1),
                fontSize: kIsWeb ? ScreenUtil().setSp(16) : 16,
                fontFamily: "Gilroy",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => PrivacyPolicyPage(),
                  transitionsBuilder: (c, anim, a2, child) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 1.0),
                      end: Offset(0.0, 0.0)).animate(anim),
                      child: child,
                    ),
                    transitionDuration: Duration(milliseconds: 300),
                ));
              },
              child: Text(
                "Privacy Policy",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HexColor("#0E3178"),
                  fontSize: kIsWeb ? ScreenUtil().setSp(16) : 16,
                  fontFamily: "Gilroy",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIntroImage() {
    return Padding(
                              padding: const EdgeInsets.only(top: 60.0, bottom: 0),
                              child: Image.asset('assets/images/on_boarding_mocs/illustration_one.png', width: 400, height: 400,
                              ));
  }

  Widget buildTitle() {
    return ScreenTypeLayout(
      mobile: Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                              child: Center(
                                child: Text(
                                  "Travel on autopilot",
                                  textAlign: TextAlign.start,
                                  style: new TextStyle(
                                    color: HexColor("#0E3178"),
                                    fontFamily: "Gilroy",
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
      desktop: Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                              child: Center(
                                child: Text(
                                  "Travel on autopilot",
                                  textAlign: TextAlign.start,
                                  style: new TextStyle(
                                    color: HexColor("#0E3178"),
                                    fontFamily: "Gilroy",
                                    fontSize: 36.w,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
    );
  }

  Widget buildDesciption() {
    return ScreenTypeLayout(
      mobile: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 0, left: 40.0, right: 40.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Flyline is the easiest way to search, \nbook, and manage flights.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(142, 150, 159, 1),
                                      fontSize: 16,
                                      height: 1.5,
                                      fontFamily: "Gilroy",
                                    ),
                                  ),
                                ],
                              ),
                            ),
      desktop: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 0, left: 40.0, right: 40.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Flyline is the easiest way to search, \nbook, and manage flights.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(142, 150, 159, 1),
                                      fontSize: 12.w,
                                      height: 1.5,
                                      fontFamily: "Gilroy",
                                    ),
                                  ),
                                ],
                              ),
                            )
    );
  }

  Widget buildButton(Color backgroundColor, Function onPressed, Widget icon, String title) {
    return Container(
                              height: kIsWeb ? 62.h : 50,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kIsWeb ? 60.w : 27.0)),
                                // boxShadow: <BoxShadow>[
                                //   BoxShadow(
                                //     color: AppTheme.getTheme().dividerColor,
                                //     blurRadius: 8,
                                //     offset: Offset(4, 4),
                                //   ),
                                // ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(1.0)),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(1.0)),
                                  highlightColor: Colors.transparent,
                                  onTap: onPressed,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: kIsWeb ? 27.w : 20),
                                          child: icon),
                                      Spacer(),
                                      Center(
                                        child: Text(
                                          title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Gilroy',
                                              fontSize: kIsWeb ? 20.w : 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: kIsWeb ? 27.w : 20),
                                          child: Container(
                                            width: kIsWeb ? 30.w : 25,
                                          )
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                ),
                              ),
                            );
  }

  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0, right: 0, bottom: 8, top: 30
      ),
      child: buildButton(
        HexColor("#00AEEF"),
        kIsWeb 
          ? widget.onTapSignIn
          : () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        SvgImageWidget.asset(
          'assets/svg/email_icon.svg',
          width: kIsWeb ? 40.w : 35,
        ),
        'Sign In'
      ),
    );
  }

  Widget buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0, right: 0, bottom: 8, top: 4
      ),
      child: buildButton(
        HexColor("#0E3178"),
        kIsWeb 
          ? widget.onTapSignUp
          : () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
        SvgImageWidget.asset(
          'assets/svg/email_one.svg',
          width: kIsWeb ? 40.w : 35,
        ),
        'Sign Up With Email'
      ),
    );
  }

  Widget buildGuestButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0, right: 0, bottom: 8, top: 4),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: HexColor("#0E3178"),
          borderRadius: BorderRadius.all(Radius.circular(27.0)),
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: AppTheme.getTheme().dividerColor,
          //     blurRadius: 8,
          //     offset: Offset(4, 4),
          //   ),
          // ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(1.0)
          ),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              isGustLogin = true;
            },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SvgImageWidget.asset(
                  'assets/svg/email_two.svg',
                  width: 35,
                )
              ),
              Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Continue As Guest",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Gilroy',
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 25,
                )
              ),
              Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onLogginResult(String data) {
    if (this.mounted)
      // ignore: missing_return
      setState(() {
        Future.delayed(const Duration(milliseconds: 500), () {
          authenticationChecked = true;
        });
        if (data != null) {
          if (data.isNotEmpty) {
            isLogin = false;
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.SearchScreen, (Route<dynamic> route) => false);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      });
  }


}
