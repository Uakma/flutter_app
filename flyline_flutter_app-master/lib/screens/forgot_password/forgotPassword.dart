import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../theme/appTheme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailTextController = new TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey();
  var response;
  int statusCode;
  bool textTappted = false;

  Future<dynamic> forgotPasswordApiCall() async {
    String url =
        'https://joinflyline.com/api/password_reset/'; // here i am checking with my own api
    response = await http.post(url, body: {"email": emailTextController.text});
    statusCode = response.statusCode;

    //this is output i got

//         I/flutter (11222): response body is  Instance of 'Response'.body
// I/flutter (11222):
// I/flutter (11222): {"balance":null,"email":null,"response_desc":"User id found"}
    // return json_decode(response.body);

    print("response body is  " + '$response.body');
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        // backgroundColor: AppTheme.getTheme().backgroundColor,
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              BackGroundDesign(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: appBar(),
                  ),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 30, left: 40.0, right: 49.5),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          Text(
                                            "Enter your email, we'll send instructions to reset",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(142, 150, 159, 1),
                                              fontSize: 16,
                                              fontFamily: "Gilroy",
                                            ),
                                          ),
                                        ],),
                                        Container(height: 10,),
                                        Row(children: [
                                          Text(
                                            "your password",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(142, 150, 159, 1),
                                              fontSize: 16,
                                              fontFamily: "Gilroy",
                                            ),
                                          ),
                                        ],),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24, bottom: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.getTheme().backgroundColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Container(
                                    height: 50,
                                    child: Center(
                                      child: TextFormField(
                                        controller: emailTextController,
                                        maxLines: 1,
                                        onChanged: (String txt) {},
                                        onTap: () {
                                          setState(() {
                                            textTappted = true;
                                          });
                                        },
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xff333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
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
                                              vertical: 15, horizontal: 15),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          labelStyle: const TextStyle(
                                            fontSize: 15.0,
                                            color: Color(0xFFcb1725),
                                          ),
                                        ),
                                        // ignore: missing_return
                                        validator: (value) {
                                          if (value.length == 0) {
                                            return "Email must not be null";
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 32, right: 32, bottom: 8, top: 16),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(27)),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24.0)),
                                    highlightColor: Colors.transparent,
                                    // ignore: missing_return
                                    onTap: () async {
                                      if (formKey.currentState.validate()) {
                                        await forgotPasswordApiCall();
                                        if (statusCode == 200) {
//                                      Navigator.pop(context);
                                          return Alert(
                                            context: context,
                                            title:
                                                "Please check your email, we have sent you instructions to reset your password",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "OKAY",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                width: 120,
                                              ),
                                            ],
                                          ).show();
                                        } else if (response.statusCode == 500) {
                                          return Alert(
                                            context: context,
                                            title:
                                                "something went wrong, try again later",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "OKAY",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                width: 120,
                                              ),
                                            ],
                                          ).show();
                                        } else {
                                          return Alert(
                                            context: context,
                                            title: "Email doesn't exist ",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "OKAY",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                width: 120,
                                              ),
                                            ],
                                          ).show();
                                        }
                                      }
                                    },

                                    child: Center(
                                      child: Text(
                                        "Send Link",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Gilroy',
                                            fontSize: 18,
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
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: AppBar().preferredSize.height,
          child: Padding(
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Container(
              width: AppBar().preferredSize.height - 16,
              height: AppBar().preferredSize.height - 16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
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
        Padding(
          padding: const EdgeInsets.only(top: 40,left:40.0,right: 49.5),
          child: Text(
            "Forgot Password?",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontFamily: "Gilroy",
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: HexColor("#0E3178"),
            ),
          ),
        ),
      ],
    );
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
