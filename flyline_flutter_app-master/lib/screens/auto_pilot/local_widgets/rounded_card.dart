import 'package:flutter/material.dart';
import 'package:motel/theme/appTheme.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class TitledRoundedCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget content;
  final Color color;
  final Function onTap;
  final Widget action;

  const TitledRoundedCard({
    Key key,
    this.title,
    this.description,
    this.color = Colors.white,
    this.content,
    this.onTap,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title',
                  style: TextStyle(
                    color: HexColor('#0e3178'),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
                action != null ? action : Offstage(),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '$description',
              style: TextStyle(
                fontFamily: "Gilroy",
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xff707070),
                height: 1.5,
              ),
            ),
            SizedBox(height: 8),
            content
          ],
        ),
      ),
    );
  }
}

class RoundedCard extends StatelessWidget {
  final Widget content;
  final Color color;
  final Function onTap;
  final EdgeInsets padding;

  const RoundedCard({
    Key key,
    this.color = Colors.white,
    this.content,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: content),
    );
  }
}
