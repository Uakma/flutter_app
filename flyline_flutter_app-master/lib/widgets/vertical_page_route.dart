import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerticalPageRoute extends MaterialPageRoute {
  VerticalPageRoute({@required this.secondWidget})
      : super(builder: (BuildContext context) => secondWidget);

  final Widget secondWidget;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0)).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: secondWidget,
      ),
    );
  }
}