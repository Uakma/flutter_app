import 'package:flutter/material.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';
import 'package:motel/widgets/menu_item_tab_bar.dart';
import 'package:motel/screens/wallet/personal_information.dart';
import 'package:motel/screens/wallet/travel_preferences.dart';
import 'package:motel/utils/sliver_fixed_header_delegate.dart';
import 'package:motel/widgets/button_bar_widget.dart';

class TravelerDetailsScreen extends StatefulWidget {
  @override
  _TravelerDetailsScreenState createState() => _TravelerDetailsScreenState();
}

class _TravelerDetailsScreenState extends State<TravelerDetailsScreen> with SingleTickerProviderStateMixin {
  final Color bottomMenuActiveColor = HexColor("#0E3178");
  final Color bottomMenuNormalColor = HexColor("#BBC4DC");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        body: NestedScrollView(
          physics: ClampingScrollPhysics(),
          headerSliverBuilder: (context, value) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverFixedHeaderDelegate(
                maxHeight: AppBar().preferredSize.height + 50,
                child: MenuItemAppBar(title: 'Traveler Wallet'),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverFixedHeaderDelegate(
                maxHeight: 80,
                child: MenuItemTabBar(
                  color: Colors.white,
                  tabs: ["Personal Information", "Travel Preferences"],
                  isTripScreen: true,
                ),
              ),
            ),
          ],
          body: Container(
            child: TabBarView(
              physics: isGustLogin ? NeverScrollableScrollPhysics() : null,
              controller: isGustLogin ? TabController(vsync: this, length: 2) : null,

              children: [
                PersonalInformation(),
                TravelPreferences(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(
          context: context,
          currentPage: BottomPage.Wallet,
        ),
      ),
    );
  }

}
