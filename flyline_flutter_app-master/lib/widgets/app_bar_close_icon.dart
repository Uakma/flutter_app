import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/widgets/svg_image_widget.dart';

class AppBarCloseIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: AppBar().preferredSize.height + 10,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 35,
            width: 65,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: SvgImageWidget.asset(
              "assets/svg/home/cancel_grey.svg",
              width: 15,
              height: 15,
            ),
          ),
        ),
      ),
    );
  }
}
