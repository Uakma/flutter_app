import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/screens/log_in/widgets/log_in_widget.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
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
            body: Center(
              child: buildWebBody()
            ),
          ),
      ),
    );
  }

  Widget buildWebBody() {
    return Container(
      width: 557.w,
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
        child: LoginWidget(),
      )
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
          child: Stack(
            children: <Widget>[
              BackGroundDesign(),
              LoginWidget()
            ],
          ),
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
            child: Stack(),
          )
        ],
      ),
    );
  }
}
