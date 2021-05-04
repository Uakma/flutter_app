import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AirlineLogo extends StatelessWidget {
  const AirlineLogo({
    Key key,
    @required this.airline,
  }) : super(key: key);

  final String airline;
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: buildMobileContent(),
      desktop: buildWebContent(),
    );
  }

  Widget buildMobileContent() {
    return Container(
      padding: EdgeInsets.only(
        right: 10,
      ),
      child: Image.network(
        "https://staging.flyline.io/images/airlines/$airline.png",
        height: 20,
        width: 20,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildWebContent() {
    return Container(
      padding: EdgeInsets.only(
        right: 10.w,
      ),
      child: Image.network(
        "https://staging.flyline.io/images/airlines/$airline.png",
        height: 30.w,
        width: 30.w,
        fit: BoxFit.cover,
      ),
    );
  }
}
