import 'package:flutter/material.dart';
import 'package:motel/screens/sign_up/sign_up.dart';

class MenuItemTabBar extends StatelessWidget {
  const MenuItemTabBar({
    Key key,
    @required this.tabs,
    this.color,
    this.isTripScreen
  }) : super(key: key);

  final List<String> tabs;
  final Color color;
  final bool isTripScreen;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
//      padding: EdgeInsets.only(bottom: 18.0),
      color: color ?? Color(0xFFF7F9FC),
      child: TabBar(
        physics: NeverScrollableScrollPhysics(),

        indicatorColor: Colors.transparent,
        labelColor: isTripScreen && isGustLogin ? Color.fromRGBO(14, 49, 120, .5) : Color(0xff333333) ,
        unselectedLabelColor: isTripScreen && isGustLogin ? Color.fromRGBO(14, 49, 120, .5) : Color.fromRGBO(14, 49, 120, .5),
        labelStyle: TextStyle(
          fontFamily: 'Gilroy',
          color: Color.fromRGBO(14, 49, 120, 1),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Gilroy',
          color: Color.fromRGBO(14, 49, 120, 1),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
        ),
        labelPadding: EdgeInsets.zero,
        tabs: [
          ...tabs.map(
            (t) => (tabs.length - 1) != tabs.indexOf(t)
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color.fromRGBO(231, 233, 240, 1),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Tab(
                      child: Text(t),
                    ),
                  )
                : Tab(
                    child: Text(t)
                  ),
          ),
        ],
      ),
    );
  }
}
