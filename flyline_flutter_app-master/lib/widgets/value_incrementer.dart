import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ValueIncrementer extends StatelessWidget {
  const ValueIncrementer({
    Key key,
    @required this.stream,
    @required this.setter,
    this.maxValue = 7,
  }) : super(key: key);

  final ValueStream stream;
  final Function(int) setter;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.only(right: 5),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setter((max(stream.value - 1, 0)));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 249, 252, 1),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                "-",
                style: TextStyle(
                  color: Color(0xFF0e3178),
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Gilroy',
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
          GestureDetector(
            onTap: () {
              setter(min(maxValue, stream.value + 1));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 249, 252, 1),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                "+",
                style: TextStyle(color: Color(0xFF0e3178)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WebValueIncrementer extends StatelessWidget {
  const WebValueIncrementer({
    Key key,
    @required this.stream,
    @required this.setter,
    this.maxValue = 7,
    this.title = ''
  }) : super(key: key);

  final ValueStream stream;
  final Function(int) setter;
  final int maxValue;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      margin: const EdgeInsets.only(right: 3),
      height: 26,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Color.fromRGBO(0, 174, 239, 0.1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 10,
                color: Color.fromRGBO(0, 174, 239, 1),
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setter((max(stream.value - 1, 0)));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                "-",
                style: TextStyle(
                  color: Color.fromRGBO(0, 174, 239, 1),
                  fontSize: 8
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Gilroy',
                    color: Color.fromRGBO(0, 174, 239, 1),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }),
          GestureDetector(
            onTap: () {
              setter(min(maxValue, stream.value + 1));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                "+",
                style: TextStyle(
                  color: Color.fromRGBO(0, 174, 239, 1),
                  fontSize: 8
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

