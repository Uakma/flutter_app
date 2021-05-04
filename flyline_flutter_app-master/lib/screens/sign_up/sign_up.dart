import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/screens/terms_and_privacy/privacy_policy.dart';
import 'package:motel/screens/terms_and_privacy/terms_of_use.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/screens/introduction/introductionScreen.dart';
import 'package:motel/screens/home/home.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/locations.dart';

bool isGustLogin = false;
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final activationCodeController = TextEditingController();

  bool isLoggingIn = false;
  bool isCalledOnce = false;
  var emailpressed = false; // This is the press variable
  var passwordpressed = false;
  var airportpressed = false;
  var isLogginClicked = false;

  bool isIntroModeOn = true;
  LocationObject selectedDeparture;
  LocationObject departure;
  AnimationController _transitionController;

  @override
  void initState() {
    super.initState();
    // passwordController.text = "Mgoblue123";
    //emailController.text = "zach@joinflyline.com";
    flyLinebloc.loginResponse.stream.listen((data) => onLogginResult(data));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenTypeLayout(
          mobile: Scaffold(
            backgroundColor: AppTheme.introColor,
            resizeToAvoidBottomInset: false,
            body: buildMobileBody(),
          ),
          desktop: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: buildWebBody(),
          ),
        ),
    );
  }

  Widget buildWebBody() {
    return Center(
      child: Container(
        width: 324,
        height: 384,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Color.fromRGBO(247, 249, 252, 1),
            width: 2
          )
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
          child: buildSignUpWidget(),
        )
      ),
    );
  }

  Widget buildMobileBody() {
    return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(children: <Widget>[
            BackGroundDesign(),
            buildSignUpWidget(),
          ]),
        );
  }

  Widget buildSignUpWidget() {
    return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: appBar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: kIsWeb ? 16 : 32),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: kIsWeb ? 12 : 24,
                                ),
                                SizedBox(
                                  width: kIsWeb ? 8 : 16,
                                ),
                                SizedBox(
                                  width: kIsWeb ? 12 : 24,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kIsWeb ? 12 : 24, 
                            right: kIsWeb ? 12 : 24),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: kIsWeb ? 4 : 8, 
                                right: kIsWeb ? 4 : 8),
                              child: Container(
                                height: kIsWeb ? 36 : 54,
                                decoration: BoxDecoration(
                                  color: AppTheme.getTheme().backgroundColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(kIsWeb ? 8 : 15)),
                                  // border: Border.all(
                                  //   color: HexColor("#757575").withOpacity(0.6),
                                  // ),
                                  // boxShadow: <BoxShadow>[
                                  //   BoxShadow(
                                  //     color: AppTheme.getTheme().dividerColor,
                                  //     blurRadius: 8,
                                  //     offset: Offset(4, 4),
                                  //   ),
                                  // ],
                                ),
                                child: Center(
                                  child: TextField(
                                    maxLines: 1,
                                    onChanged: (String txt) {
                                      setState(() {
                                        if (txt == "")
                                          emailpressed = false;
                                        else
                                          emailpressed =
                                              true; // update the state of the class to show color change
                                        isLogginClicked = false;
                                      });
                                    },
                                    controller: emailController,
                                    autofocus: true,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xff3A3F5C),
                                      fontSize: kIsWeb ? 10 : 15,
                                      fontWeight: FontWeight.w500,
                                      // color: AppTheme.dark_grey,
                                    ),
                                    cursorColor:
                                        AppTheme.getTheme().primaryColor,
                                    decoration: InputDecoration(
                                      fillColor:
                                          Color.fromRGBO(247, 249, 252, 1),
                                      filled: true,
                                      hintText: 'Enter your email',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Gilroy",
                                        color: Color(0xFFBBC4DC),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: kIsWeb ? 10 : 20, 
                                          horizontal:kIsWeb ? 8 :  15),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(kIsWeb ? 8 : 15),
                                          borderSide: BorderSide.none),
                                      labelStyle: const TextStyle(
                                        fontSize: kIsWeb ? 10 : 15.0,
                                        color: Color(0xFFcb1725),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(kIsWeb ? 8 : 15.0),
                                          ),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 0.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(kIsWeb ? 8 : 15.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: HexColor("#0e3178"),
                                              width: 1.0),
                                        ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: kIsWeb ? 12 : 24, 
                              right: kIsWeb ? 12 : 24, 
                              top: kIsWeb ? 8 : 16, 
                              bottom: 0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: kIsWeb ? 4 : 8, 
                                right: kIsWeb ? 4 : 8),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: kIsWeb ? 34 : 68,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 0,
                                          bottom: kIsWeb ? 11 : 22),
                                      child: SizedBox(
                                        height: double.infinity,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.getTheme()
                                                .backgroundColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(kIsWeb ? 8 : 15)),
                                            // boxShadow: <BoxShadow>[
                                            //   BoxShadow(
                                            //     color: AppTheme.getTheme().dividerColor,
                                            //     blurRadius: 8,
                                            //     offset: Offset(4, 4),
                                            //   ),
                                            // ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: kIsWeb ? 36 : 54,
                                    margin: EdgeInsets.symmetric(
                                        vertical: kIsWeb ? 3 : 5, horizontal: 0),
                                    child: TextField(
                                      obscureText: true,
                                      maxLines: 1,
                                      controller: passwordController,
                                      keyboardType: TextInputType.text,
                                      onChanged: (String txt) {
                                        setState(() {
                                          if (txt == "")
                                            passwordpressed = false;
                                          else
                                            passwordpressed =
                                                true; // update the state of the class to show color change
                                          isLogginClicked = false;
                                        });
                                      },
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        color: Color(0xff3A3F5C),
                                        fontSize: kIsWeb ? 10 : 15,
                                        fontWeight: FontWeight.w500,
                                        // color: AppTheme.dark_grey,
                                      ),
                                      cursorColor:
                                          AppTheme.getTheme().primaryColor,
                                      decoration: InputDecoration(
                                        fillColor:
                                            Color.fromRGBO(247, 249, 252, 1),
                                        filled: true,
                                        hintText: 'Enter your password',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Gilroy",
                                          color: Color(0xFFBBC4DC),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: kIsWeb ? 10 : 20, 
                                            horizontal: 8),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(kIsWeb ? 8 : 15),
                                            borderSide: BorderSide.none),
                                        labelStyle: const TextStyle(
                                          fontSize: kIsWeb ? 10 : 15.0,
                                          color: Color(0xFFcb1725),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(kIsWeb ? 8 : 15.0),
                                          ),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 0.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(kIsWeb ? 8 : 15.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: HexColor("#0e3178"),
                                              width: 1.0),
                                        ),
                                        errorBorder: isLogginClicked
                                            ? OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(kIsWeb ? 8 : 15.0),
                                                ),
                                                borderSide: BorderSide(
                                                    color: HexColor("#ff6784"),
                                                    width: 1.0),
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: kIsWeb ? 17 : 34, 
                              right: kIsWeb ? 17 : 34, 
                              bottom: kIsWeb ? 4 : 8, 
                              top: 16),
                          child: isLoggingIn
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: kIsWeb ? 20 : 40.0,
                                      right: kIsWeb ? 20 : 40.0,
                                      top: kIsWeb ? 15 : 30.0,
                                      bottom: kIsWeb ? 15 : 30.0),
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              const Color(0xFF00AFF5)),
                                      strokeWidth: 3.0),
                                  height: kIsWeb ? 20 : 40.0,
                                  width: kIsWeb ? 20 : 40.0,
                                )
                              : Container(
                                  height: kIsWeb ? 30 : 50,
                                  decoration: BoxDecoration(
                                    color: HexColor("#00AEEF"),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(27.0)),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1.0)),
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(1.0)),
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        String result = await flyLinebloc
                                            .trySignup(
                                                email: emailController.text
                                                    .toString(),
                                                password:
                                                    passwordController
                                                        .text
                                                        .toString(),
                                                activationCode:
                                                    activationCodeController
                                                        .text);
                                        if (result != "") {
                                          isGustLogin = false;
                                          Navigator.push(
                                            context,
//                                        MaterialPageRoute(
//                                            builder: (context) => HomeScreen()),
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                          );
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          "Continue",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Gilroy',
                                              fontSize: kIsWeb ? 12 : 18,
                                              color: Colors.white),
                                        ),
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
            );
  }

  Widget appBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ScreenTypeLayout(
          mobile: SizedBox(
            height: AppBar().preferredSize.height,
            child: Padding(
              padding: EdgeInsets.only(top: 16, left: 16),
              child: Container(
                width: AppBar().preferredSize.height - 16,
                height: AppBar().preferredSize.height - 16,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppBar().preferredSize.height - 16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IntroductionScreen()));
                      // Navigator.pop(context);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/back-arrow.png',
                          scale: 28,
                        )),
                  ),
                ),
              ),
            ),
          ),
          desktop: Container(),
        ),
        SizedBox(
          width: double.infinity,
          // height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
              top: kIsWeb ? 20 : 40, 
              bottom: kIsWeb ? 5 : 10,
              left: kIsWeb ? 20 : 40.0),
            child: Text(
              "Sign up with email",
              textAlign: TextAlign.start,
              style: new TextStyle(
                color: HexColor("#0E3178"),
                fontFamily: "Gilroy",
                fontSize: kIsWeb ? 20 : 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          // height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
              top: kIsWeb ? 5 : 10, 
              bottom: kIsWeb ? 5 : 10,
              left: kIsWeb ? 20 : 40.0),
            child: Column(
              children: [
                Row(children: [
                  Text(
                    "By continuing, you agree to our",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(142, 150, 159, 1),
                      fontSize: kIsWeb ? 10 : 16,
                      fontFamily: "Gilroy",
                    ),
                  ),
                  InkWell(onTap: (){
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
                      " Terms of Service",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: HexColor("#0E3178"),
                        fontFamily: "Gilroy",
                        fontSize: kIsWeb ? 10 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],),
                Container(height: kIsWeb ? 5 : 10,),
                Row(children: [
                  Text(
                    "and",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(142, 150, 159, 1),
                      fontSize: kIsWeb ? 10 : 16,
                      fontFamily: "Gilroy",
                    ),
                  ),
                  InkWell(onTap: (){
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
                      " Privacy Policy",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: HexColor("#0E3178"),
                        fontFamily: "Gilroy",
                        fontSize: kIsWeb ? 10 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],),
              ],
            ),
          ),
        )
      ],
    );
  }

  void changeIntroMode(bool showIntro) {
    if (isIntroModeOn == showIntro) return;

    // hiding any open keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    showIntro
        ? _transitionController.reverse()
        : _transitionController.forward();
    setState(() {
      isIntroModeOn = showIntro;
    });
  }

  onLogginResult(String data) async {
    if (data != null) {
      if (data != "") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        _initTokenData(data);
      } else {
        //isLoggingIn = false;
        setState(() {});
        if (passwordController.text != "") {
          showErrorMsg();
        }
      }
    } else {
      isLoggingIn = false;
      setState(() {});
      if (passwordController.text != "") {
        showErrorMsg();
      }
    }
    setState(() {});
  }

  void showErrorMsg() {
    Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blueAccent,
        ),
        messageText: Text("Credentials are incorrect.",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 14.0)),
        duration: Duration(seconds: 3),
        isDismissible: true)
      ..show(context);
  }

  void _initTokenData(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token_data", data);
  }
}

class BackGroundDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
              ],
            ),
          )
        ],
      ),
    );
  }
}
