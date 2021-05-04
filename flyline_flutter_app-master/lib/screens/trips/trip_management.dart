import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motel/screens/sign_up/sign_up.dart';
import 'package:motel/theme/appTheme.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';
import 'package:motel/widgets/menu_item_tab_bar.dart';
import 'package:motel/screens/trips/completed_trips.dart';
import 'package:motel/screens/trips/upcoming_trips.dart';
import 'package:motel/utils/sliver_fixed_header_delegate.dart';
import 'package:motel/widgets/button_bar_widget.dart';

class TripScreen extends StatefulWidget {
  @override
  _TripScreen createState() => _TripScreen();
}

class _TripScreen extends State<TripScreen> with SingleTickerProviderStateMixin {
  final Color bottomMenuActiveColor = HexColor("#0E3178");
  final Color bottomMenuNormalColor = HexColor("#BBC4DC");

  List<bool> _isDisabled = [false, true];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverFixedHeaderDelegate(
                maxHeight: AppBar().preferredSize.height + 50,
                child: MenuItemAppBar(title: 'Manage Trips'),
              ),
            ),
            SliverPersistentHeader(
              pinned: false,
              delegate: SliverFixedHeaderDelegate(
                maxHeight: 80,
                child: MenuItemTabBar(
                  color: Colors.white,
                  tabs: ["Upcoming Trips", "Completed Trips"],
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
                UpcomingTrips(),
                CompletedTrips(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(
          context: context,
          currentPage: BottomPage.Trips,
        ),
      ),
    );
  }


}
