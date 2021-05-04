import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlueButtonWidget extends StatelessWidget {

  BlueButtonWidget({
    Key key,
    this.width, 
    this.height, 
    this.text = '',
    this.onPressed}) : super(key: key);

  final double width;
  final double height;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: Color(0xff00AEEF),
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Gilroy',
            fontSize: 14.w,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )
      )
    );
  }
}