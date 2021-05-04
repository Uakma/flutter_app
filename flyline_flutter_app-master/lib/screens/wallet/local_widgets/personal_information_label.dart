import 'package:flutter/material.dart';

class PersonalInformationLabel extends StatelessWidget {
  const PersonalInformationLabel({
    Key key,
    @required this.label,
  })  : assert(label != null),
        super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 32.0, bottom: 11.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 17,
                color: Color(0xff333333),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 17.0, left: 18, right: 0),
          child: Divider(height: 1.5,thickness: .5, color: Color.fromRGBO(231, 233 ,240, 1)),
        ),
      ],
    );
  }
}
