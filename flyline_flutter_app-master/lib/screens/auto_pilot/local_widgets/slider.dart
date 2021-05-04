import 'package:flutter/material.dart';
import 'package:motel/theme/appTheme.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class SliderCircle extends StatelessWidget {
  final double position;
  final double width;
  final GestureDragUpdateCallback callback;

  SliderCircle({this.position, this.callback, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: callback,
      child: Container(
        margin: EdgeInsets.only(left: position),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: HexColor('#00aeef'), width: 2)),
        height: width,
        width: width,
      ),
    );
  }
}
