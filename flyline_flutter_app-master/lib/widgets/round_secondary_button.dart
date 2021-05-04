

import 'package:flutter/material.dart';

class RoundSecondaryButton extends StatelessWidget {
  final Function onTap;
  final String text;

  const RoundSecondaryButton({Key key, this.onTap, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 48,
      child: FlatButton(
        onPressed: onTap,
        splashColor: Colors.transparent,
        color: const Color.fromRGBO(0, 174, 239, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          '$text',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
      ),
    );
  }
}