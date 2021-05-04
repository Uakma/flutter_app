import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripDetailsBookingButton extends StatelessWidget {

  TripDetailsBookingButton({this.onPressed, this.title});

  final Function onPressed;
  final String title;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              alignment: Alignment.center,
              height: 53.w,
              margin: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.w),
                color: Color.fromRGBO(64, 206, 83, 1)
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 18.w,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }
}