import 'package:flutter/material.dart';

class TripDetailsPriceFooter extends StatelessWidget {
  const TripDetailsPriceFooter({
    Key key,
    @required this.onTap,
    @required this.total,
  }) : super(key: key);

  final Function onTap;
  final num total;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Wrap(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Total ",
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontFamily: 'Gilroy',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Text(
                            '  \$${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Color(0xff40CE53),
                              fontFamily: 'Gilroy',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  width: 199,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff40CE53),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xffffffff),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
