import 'package:flutter/material.dart';

class LabelValue extends StatelessWidget {
  const LabelValue({
    Key key,
    @required this.label,
    this.value,
    this.labelStyle = const TextStyle(
      fontFamily: 'Gilroy',
      color: Color(0xffBBC4DC),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    this.valueStyle = const TextStyle(
      fontFamily: 'Gilroy',
      color: Color(0xff333333),
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    this.valueWidget,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  })  : assert(value == null ? valueWidget != null ? true : false : true),
        super(key: key);

  final String label;
  final String value;
  final Widget valueWidget;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          Text(
            label,
            style: labelStyle,
          ),
          if (value != null)
            Text(
              value,
              style: valueStyle,
            ),
          if (value == null) valueWidget
        ],
      ),
    );
  }
}
