import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/screens/home/local_widgets/web_bottom_button.dart';

class WebBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(247, 249, 252, 1),
      height: 49.h,
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
            ),
            WebBottomButtonWidget(
              text: 'How FlyLine Works', 
              onPressed: () {}
            ),
            WebBottomButtonWidget(
              text: 'Support', 
              onPressed: () {}
            ),
            WebBottomButtonWidget(
              text: 'Currency (USD)', 
              onPressed: () {}
            ),
            Spacer(),
            WebBottomButtonWidget(
              text: 'Privacy Policy', 
              onPressed: () {}
            ),
            WebBottomButtonWidget(
              text: 'Terms of Use', 
              onPressed: () {}
            ),
            SizedBox(
              width: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}