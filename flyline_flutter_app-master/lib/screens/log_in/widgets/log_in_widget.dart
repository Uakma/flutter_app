import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/screens/auto_pilot/auto_pilot_confirmed.dart';
import 'package:motel/screens/forgot_password/forgotPassword.dart';
import 'package:motel/screens/introduction/introductionScreen.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/screens/terms_and_privacy/privacy_policy.dart';
import 'package:motel/screens/terms_and_privacy/terms_of_use.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginWidgetState();
  }
}

class _LoginWidgetState extends State<LoginWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoggingIn = false;
  bool isCalledOnce = false;
  var emailpressed = false; // This is the press variable
  var passwordpressed = false;
  var isLogginClicked = false;
  
  @override
  void initState() {
    super.initState();

    flyLinebloc.loginResponse.stream.listen((data) => onLogginResult(data));
  }

  onLogginResult(String data) async {
    if (data != null) {
      if (data != "") {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.SearchScreen, (Route<dynamic> route) => false);
        isGustLogin = false;
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

  @override
  Widget build(BuildContext context) {
    return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
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
                                  SizedBox(width: kIsWeb ? 12 : 24),
                                  SizedBox(width: kIsWeb ? 8 : 16),
                                  SizedBox(width: kIsWeb ? 12 : 24)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: kIsWeb ? 36 : 54,
                            margin: EdgeInsets.symmetric(
                                horizontal: kIsWeb ? 16 : 32, vertical: 0),
                            child: TextField(
                              onChanged: (String txt) {
                                setState(() {
                                  if (txt == "")
                                    emailpressed = false;
                                  else
                                    emailpressed = true;
                                  isLogginClicked = false;
                                });
                              },
                              maxLines: 1,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: AppTheme.getTheme().primaryColor,
                              autofocus: true,
                              inputFormatters: [
                                BlacklistingTextInputFormatter(' '),
                              ],
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Color(0xff333333),
                                fontSize: kIsWeb ? 10 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                fillColor: Color.fromRGBO(247, 249, 252, 1),
                                filled: true,
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Gilroy",
                                  color: Color(0xFFBBC4DC),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: kIsWeb ? 8 : 20, horizontal: kIsWeb ? 8 : 15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(kIsWeb ? 8 : 15),
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
                                      color: Colors.transparent, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(kIsWeb ? 8 : 15.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: HexColor("#0e3178"), width: 1.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: kIsWeb ? 36 : 54,
                            margin: EdgeInsets.symmetric(
                                horizontal: kIsWeb ? 16 : 32, vertical: kIsWeb ? 8 : 16),
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
                                color: Color(0xff333333),
                                fontSize: kIsWeb ? 10 : 16,
                                fontWeight: FontWeight.w500,
                                // color: AppTheme.dark_grey,
                              ),
                              decoration: InputDecoration(
                                fillColor: Color.fromRGBO(247, 249, 252, 1),
                                filled: true,
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Gilroy",
                                  color: Color(0xFFBBC4DC),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: kIsWeb ? 10 : 20, horizontal: kIsWeb ? 8 : 15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none),
                                labelStyle: const TextStyle(
                                  fontSize: kIsWeb ? 8 : 15.0,
                                  color: Color(0xFFcb1725),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(kIsWeb ? 8 : 15.0),
                                  ),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(kIsWeb ? 8 : 15.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: HexColor("#0e3178"), width: 1.0),
                                ),
                                errorBorder: isLogginClicked
                                    ? OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
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
                          Padding(
                            padding: const EdgeInsets.only(
                                top: kIsWeb ? 6 : 8, 
                                right: kIsWeb ? 8 : 16, 
                                bottom: kIsWeb ? 6 : 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordScreen()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: kIsWeb ? 25 : 50.0),
                                    child: Text(
                                      "Forgot Password?",
                                      style: new TextStyle(
                                        color: HexColor("#0E3178"),
                                        fontFamily: "Gilroy",
                                        fontSize: kIsWeb ? 10 : 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: kIsWeb ? 16 : 32, 
                                right: kIsWeb ? 16 : 32, 
                                bottom: kIsWeb ? 4 : 8, 
                                top: kIsWeb ? 8 : 16),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(kIsWeb ? 14 : 27.0)),
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
                                        onTap: () {
                                          setState(() {
                                            isLogginClicked =
                                                true; // update the state of the class to show color change
                                          });
                                          isCalledOnce = true;
                                          flyLinebloc.tryLogin(
                                              emailController.text,
                                              passwordController.text);
//                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => route == null);
//                                           Navigator.pushAndRemoveUntil(context, Routes.SearchScreen, (Route<dynamic> route) => false);
                                          // Navigator.pushReplacementNamed(context, Routes.TabScreen);
                                        },
                                        child: Center(
                                          child: Text(
                                            "Continue",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
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
                        child: SvgImageWidget.asset(
                          'assets/svg/navigation/back-arrow.svg',
                          height: 10,
                          width: 10,
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
              top: kIsWeb ? 20 : 40.0, 
              bottom: kIsWeb ? 5 : 10, 
              left: kIsWeb ? 20 : 40.0),
            child: Text(
              "Log in",
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
                bottom: 0, 
                left: kIsWeb ? 20 : 40.0, 
                right: kIsWeb ? 20 : 40.0),
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
        ),
      ],
    );
  }
}