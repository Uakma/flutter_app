import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/widgets/svg_image_widget.dart';

class IntroTextBoxWidget extends StatelessWidget {
  final String _title, _message, _icon;

  const IntroTextBoxWidget(
    this._title,
    this._message,
    this._icon, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              height: 37,
              width: 37,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: SvgImageWidget.asset(_icon)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // to wrap text widget
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        _title,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          color: Color(0xFF0E3178),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      _message,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        height: 1.6,
                        color: Color.fromRGBO(142, 150, 159, 1),
                      ),
                      softWrap: true,
                      maxLines: 5,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            SvgImageWidget.asset(
              "assets/svg/home/right.svg",
              // color: Colors.amber,
              height: 12,
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
