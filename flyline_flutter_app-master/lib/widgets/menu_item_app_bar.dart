import 'package:flutter/material.dart';
import 'package:motel/widgets/app_bar_pop_icon.dart';

class MenuItemAppBar extends StatelessWidget {
  const MenuItemAppBar({
    Key key,
    @required this.title,
    this.backgroundColor = Colors.white,
    this.buttonColor,
  }) : super(key: key);

  final String title;
  final Color backgroundColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 8,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppBarPopIcon(
            buttonColor: Color(0xffffffff),
          ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xff0E3178),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 40,
            width: 40,
          )
        ],
      ),
    );
  }
}

Widget getAppBarWithBackButton(context) {
  return Positioned(
    top: 0.0,
    left: 0.0,
    right: 0.0,
    child: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white.withOpacity(0.0),
      elevation: 0.0,
    ),
  );
}
