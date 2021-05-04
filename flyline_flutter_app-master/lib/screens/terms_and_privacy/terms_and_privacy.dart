import 'package:flutter/material.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';
import 'package:motel/widgets/menu_item_tab_bar.dart';
import 'package:motel/screens/terms_and_privacy/privacy_policy.dart';
import 'package:motel/screens/terms_and_privacy/terms_of_use.dart';
import 'package:motel/utils/sliver_fixed_header_delegate.dart';

class TermsOfUsePage extends StatefulWidget {
  TermsOfUsePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _TermsOfUsePageState createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
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
                child: MenuItemAppBar(title: 'Terms and Privacy'),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverFixedHeaderDelegate(
                maxHeight: 60,
                child: MenuItemTabBar(
                  color: Colors.white,
                  tabs: ["Terms of Use", "Privacy Policy"],
                  isTripScreen: false,
                ),
              ),
            ),
          ],
          body: Container(
            child: TabBarView(
              children: [
                UseTermsPage(),
                PrivacyPolicyPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
