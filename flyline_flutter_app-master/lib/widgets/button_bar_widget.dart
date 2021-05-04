import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/screens/app_settings/app_settings.dart';
import 'package:motel/screens/home/home.dart';
import 'package:motel/screens/wallet/traveler_details.dart';
import 'package:motel/screens/trips/trip_management.dart';
import 'package:motel/widgets/svg_image_widget.dart';

import '../theme/appTheme.dart';

class BottomBar extends StatelessWidget {
  final Color bottomMenuActiveColor = HexColor("#0E3178");
  final Color bottomMenuNormalColor = HexColor("#BBC4DC");
  final BuildContext context;
  final BottomPage currentPage;
  BottomBar({this.context, this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 110,
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        bottom: 20,
        top: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (this.currentPage == BottomPage.Home) {
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getHomeIcon(this.currentPage == BottomPage.Home),
                SizedBox(height: 8),
                Text(
                  'Home',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: this.currentPage == BottomPage.Home
                        ? bottomMenuActiveColor
                        : bottomMenuNormalColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (this.currentPage == BottomPage.Wallet) {
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TravelerDetailsScreen()));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getWalletIcon(this.currentPage == BottomPage.Wallet),
                SizedBox(height: 8),
                Text(
                  'Wallet',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: this.currentPage == BottomPage.Wallet
                        ? bottomMenuActiveColor
                        : bottomMenuNormalColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (this.currentPage == BottomPage.Trips) {
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TripScreen()));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getTripIcon(this.currentPage == BottomPage.Trips),
                SizedBox(height: 8),
                Text(
                  'Trips',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: this.currentPage == BottomPage.Trips
                        ? bottomMenuActiveColor
                        : bottomMenuNormalColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (this.currentPage == BottomPage.Settings) {
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPageScreen()));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getSettingIcon(this.currentPage == BottomPage.Settings),
                SizedBox(height: 8),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: this.currentPage == BottomPage.Settings
                        ? bottomMenuActiveColor
                        : bottomMenuNormalColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getHomeIcon(bool isActive) {
    return Container(
      width: 25,
      height: 25,
      child: SvgImageWidget.asset(
        'assets/icons/home.svg',
        fit: BoxFit.fitHeight,
        color: isActive ? bottomMenuActiveColor : bottomMenuNormalColor,
      ),
    );
  }

  Widget getSettingIcon(bool isActive) {
    return Container(
      width: 25,
      height: 25,
      child: SvgImageWidget.asset(
        'assets/icons/settings.svg',
        fit: BoxFit.fitHeight,
        color: isActive ? bottomMenuActiveColor : bottomMenuNormalColor,
      ),
    );
  }

  Widget getTripIcon(bool isActive) {
    return Container(
      width: 25,
      height: 25,
      child: SvgImageWidget.asset(
        'assets/icons/trips.svg',
        fit: BoxFit.fitHeight,
        color: isActive ? bottomMenuActiveColor : bottomMenuNormalColor,
      ),
    );
  }

  Widget getWalletIcon(bool isActive) {
    return Container(
      width: 25,
      height: 25,
      child: SvgImageWidget.asset(
        'assets/icons/wallet.svg',
        fit: BoxFit.fitHeight,
        color: isActive ? bottomMenuActiveColor : bottomMenuNormalColor,
      ),
    );
  }
}

enum BottomPage { Home, Trips, Settings, Wallet }
