import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {

  RoundedBox({Key key, this.child, this.width, this.height, this.padding}) : super(key: key);

  final Widget child;
  final double width;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 249, 252, 1),
        borderRadius: BorderRadius.circular(15)  
      ),
      width: width ?? 279,
      height: height ?? 50,
      padding: padding ?? EdgeInsets.all(0),
      child: child,
    );
  }
}