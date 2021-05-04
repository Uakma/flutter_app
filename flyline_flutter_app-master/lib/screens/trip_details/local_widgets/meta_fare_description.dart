import 'package:flutter/material.dart';

class MetaFareDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Color(0xff8e969f),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text:
                  'Meta Fares are flights we source from our suppliers. We will always display the cheapest flights when you search on FlyLine.',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color.fromRGBO(142, 150, 159, 1),
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                )
            ),
          ],
        ),
      ),
    );
  }
}
