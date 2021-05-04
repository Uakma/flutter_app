import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/blocs/settings_bloc.dart';
import 'package:motel/models/currency_rates.dart';
import 'package:motel/screens/app_settings/help_center.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/utils/sliver_fixed_header_delegate.dart';
import 'package:motel/widgets/button_bar_widget.dart';
import 'package:motel/widgets/svg_image_widget.dart';
import 'package:provider/provider.dart';

import '../log_in/log_in.dart';
import 'choose_currency.dart';
import 'choose_region.dart';

class SettingsPageScreen extends StatefulWidget {
  @override
  _SettingsPageScreenState createState() => _SettingsPageScreenState();
}

class _SettingsPageScreenState extends State<SettingsPageScreen> {
  final Color bottomMenuActiveColor = HexColor("#0E3178");
  final Color bottomMenuNormalColor = HexColor("#BBC4DC");
  bool _pushNotifications = false;
  bool _emailNotifications = false;
  bool _smsNotifications = false;

  Currency selectedCurrency;
  String selectedRegion = "";
  String accountType = '';

  @override
  void initState() {
    super.initState();
    getAccountType();
    selectedCurrency = Currency.withDefault();
  }

  getAccountType() async {
    //first get token
    var token = await SettingsBloc().getAuthToken2();

    if (token == "logout") {
      setState(() {
        accountType = "no-user";
      });
    } else {
      var user = await SettingsBloc().accountInfo();
      // print(user.subscription);
      if (user.subscription == null) {
        //free user
        setState(() {
          accountType = "free";
        });
      } else {
        //premium user
        setState(() {
          accountType = "premium";
        });
      }
    }
  }

  Widget getSelectedRegion(String selectedRegion) {
    String regionName = "";
    String regionIconImageLocation = "";
    TextStyle txtStyle = TextStyle(
      fontFamily: 'Gilroy',
      color: Color(0xffBBC4DC),
      fontSize: 15,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
    );
    if (selectedRegion == "" || selectedRegion == null || selectedRegion == "United States") {
      regionName = "United States";
      regionIconImageLocation = "assets/images/region_flags/united_states.png";
    }else{
      regionName=selectedRegion.toLowerCase();
      regionIconImageLocation = "assets/images/region_flags/${selectedRegion.replaceAll(" ", "_").toLowerCase()}.png";
    }

    return Row(
      children: <Widget>[
        Image.asset(
          regionIconImageLocation,
          height: 26,
          width: 26,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          regionName,
          style: txtStyle,
        ),
      ],
    );
  }

  void _awaitSelectedCurrencyFromCurrencyScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseCurrencyScreen(
          selectedCurrency: selectedCurrency,
        ),
      ),
    );

    var settingsBloc = Provider.of<SettingsBloc>(context, listen: false);
    if (result != null) {
      settingsBloc.changeCurrency(result);
    }

    selectedCurrency = settingsBloc.selectedCurrency;

    setState(() {
      selectedCurrency = settingsBloc.selectedCurrency;
    });
  }

  void _awaitSelectedRegionFromRegionScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseRegionScreen(
          selectedRegion: selectedRegion,
        ),
      ),
    );
    setState(() {
      selectedRegion = result ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF2F5FA),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverFixedHeaderDelegate(
                maxHeight: AppBar().preferredSize.height + 50,
                child: MenuItemAppBar(title: 'Settings'),
              ),
            ),
          ],
          body: Container(
            padding: const EdgeInsets.only(top: 18.0, left: 18.0, right: 18.0),
            color: Color(0xFFF7F9FC),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 20.0, bottom: 11.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Notifications",
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
                    padding: const EdgeInsets.only(top: 0.0, bottom: 17.0),
                    child: Divider(height: 1.5, color: Color(0xffe7e9f0)),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: ListTile(
                      title: new Text(
                        "In App Push Notifications",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xffBBC4DC),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      trailing: Transform.scale(
                        scale: .7,
                        child: CupertinoSwitch(
                          trackColor: Color(0xFFFF0000),
                          activeColor: Color(0xFF44CF57),
                          value: _pushNotifications,
                          onChanged: (value) =>
                              setState(() => _pushNotifications = value),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: ListTile(
                      title: new Text(
                        "Email Notifications",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xffBBC4DC),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      trailing: Transform.scale(
                        scale: .7,
                        child: CupertinoSwitch(
                          trackColor: Color(0xFFFF0000),
                          activeColor: Color(0xFF44CF57),
                          value: _emailNotifications,
                          onChanged: (value) =>
                              setState(() => _emailNotifications = value),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: ListTile(
                      title: new Text(
                        "Flight Status SMS",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xffBBC4DC),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      trailing: Transform.scale(
                        scale: .7,
                        child: CupertinoSwitch(
                          trackColor: Color(0xFFFF0000),
                          activeColor: Color(0xFF44CF57),
                          value: _smsNotifications,
                          onChanged: (value) =>
                              setState(() => _smsNotifications = value),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 30.0, bottom: 11.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Account",
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
                    padding: const EdgeInsets.only(top: 0.0, bottom: 17.0),
                    child: Divider(height: 1.5, color: Color(0xffe7e9f0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                  ),
                  _accountSection(context),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 30.0, bottom: 11.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Region",
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
                    padding: const EdgeInsets.only(top: 0.0, bottom: 17.0),
                    child: Divider(height: 1.5, color: Color(0xffe7e9f0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: ListTile(
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        title: new Text(
                          selectedCurrency == null
                              ? "Select Currency"
                              : selectedCurrency.name,
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Color(0xffBBC4DC),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        trailing: SvgImageWidget.asset(
                          'assets/svg/navigation/forward-arrow.svg',
                          height: 14,
                          width: 14,
                        ),
                        onTap: () =>
                            _awaitSelectedCurrencyFromCurrencyScreen(context)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: ListTile(
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                      title: getSelectedRegion(selectedRegion),
                      trailing: SvgImageWidget.asset(
                        'assets/svg/navigation/forward-arrow.svg',
                        height: 14,
                        width: 14,
                      ),
                      onTap: () =>
                          _awaitSelectedRegionFromRegionScreen(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 40.0, bottom: 11.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Contact",
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
                    padding: const EdgeInsets.only(top: 0.0, bottom: 17.0),
                    child: Divider(height: 1.5, color: Color(0xffe7e9f0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: ListTile(
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                      title: new Text(
                        "Need Help?",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xffBBC4DC),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      trailing: SvgImageWidget.asset(
                        'assets/svg/navigation/forward-arrow.svg',
                        height: 14,
                        width: 14,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpCenterScreen(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: ListTile(
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                      title: new Text(
                        "Rate FlyLine App",
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Color(0xffBBC4DC),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      trailing: SvgImageWidget.asset(
                        'assets/svg/navigation/forward-arrow.svg',
                        height: 14,
                        width: 14,
                      ),
                      //    onTap: flyLinePremiumAction(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(
          currentPage: BottomPage.Settings,
          context: context,
        ),
      ),
    );
  }

  Widget _accountSection(context) {
    if (this.accountType == "no-user") {
      return Column(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
              title: new Text(
                "Create an Account",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff40CE53),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              trailing: SvgImageWidget.asset(
                'assets/svg/navigation/forward-arrow.svg',
                height: 14,
                width: 14,
              ),
              //    onTap: flyLinePremiumAction(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
              title: new Text(
                "Log In",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff40CE53),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              trailing: SvgImageWidget.asset(
                'assets/svg/navigation/forward-arrow.svg',
                height: 14,
                width: 14,
              ),
              //    onTap: flyLinePremiumAction(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
          ),
        ],
      );
    } else if (accountType == "free") {
      return Column(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: ListTile(
              onTap: () {
                SettingsBloc().logout().then(
                      (_) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                      ),
                    );
              },
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
              title: new Text(
                "Log Out",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xffFF0005),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              trailing: SvgImageWidget.asset(
                'assets/svg/navigation/forward-arrow.svg',
                height: 14,
                width: 14,
              ),
              //    onTap: flyLinePremiumAction(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: ListTile(
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
              title: new Text(
                "Delete Account",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xffFF0005),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              trailing: SvgImageWidget.asset(
                'assets/svg/navigation/forward-arrow.svg',
                height: 14,
                width: 14,
              ),
              //    onTap: flyLinePremiumAction(context),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: ListTile(
              onTap: () {
                SettingsBloc().logout().then(
                      (_) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                      ),
                    );
              },
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
              title: new Text(
                "Log Out",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xffFF0005),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              trailing: SvgImageWidget.asset(
                'assets/svg/navigation/forward-arrow.svg',
                height: 14,
                width: 14,
              ),
              //    onTap: flyLinePremiumAction(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: ListTile(
//                          contentPadding: EdgeInsets.symmetric(vertical: 18),
              title: new Text(
                "Delete Account",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xffFF0005),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              trailing: SvgImageWidget.asset(
                'assets/svg/navigation/forward-arrow.svg',
                height: 14,
                width: 14,
              ),
              //    onTap: flyLinePremiumAction(context),
            ),
          ),
        ],
      );
    }
  }
}
