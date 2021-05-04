import 'package:flutter/material.dart';

class AppBarDateDepArr extends StatelessWidget {
  const AppBarDateDepArr({
    @required this.depDate,
    this.arrDate,
  });

  final String depDate;
  final String arrDate;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: depDate,
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Color(0xff333333),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          if (arrDate != null)
            TextSpan(
              text: ' - $arrDate',
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff333333),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
        ],
      ),
    );
  }
}
