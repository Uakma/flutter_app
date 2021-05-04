import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WebBottomButtonWidget extends StatelessWidget {

  WebBottomButtonWidget({
    Key key,
    this.text = '',
    this.onPressed
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: FlatButton(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 12.w,
            color: Color.fromRGBO(51, 51, 51, 0.5),
            fontWeight: FontWeight.bold
          )
        ),
        onPressed: onPressed,
      ),
    );
  }
}