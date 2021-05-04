import 'dart:math';

import 'package:flutter/material.dart';
import 'package:motel/models/account.dart';
import 'package:motel/screens/home/local_widgets/auto_pilot_widget.dart';
import 'package:motel/screens/home/local_widgets/intro_text_box_widget.dart';
import 'package:motel/screens/home/local_widgets/search_box_widget.dart';
import 'package:motel/blocs/bloc.dart';

typedef void XCall(int value);
/// Intro widget display on [Home] initially
///


class HomeIntroWidget extends StatefulWidget {
  final FocusNode navigator;
  final XCall setTab;

  HomeIntroWidget({this.navigator, this.setTab});

  @override
  _HomeIntroWidgetState createState() => _HomeIntroWidgetState();
}

class _HomeIntroWidgetState extends State<HomeIntroWidget> {
  bool isIntroModeOn = true;
  AnimationController _transitionController;
  ScrollController _controller = ScrollController();
  double _imageOffset = 1;
  void changeIntroMode(bool showIntro) {
    if (isIntroModeOn == showIntro) return;

    // hiding any open keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    showIntro
        ? _transitionController.reverse()
        : _transitionController.forward();
    setState(() {
      isIntroModeOn = showIntro;
    });
  }

  @override
  void initState() {
    // _transitionController.dispose();
    _controller.addListener(() {
      setState(() {
        _imageOffset = 1.0 -
            min(max(0.0, (248.0 - _controller.position.extentAfter) / 248.0),
                1.0);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _controller,
            slivers: [
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    widget.navigator.requestFocus();
                    widget.setTab(1);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18.0, top: 22),
                    child: IntroTextBoxWidget(
                      "Start searching to save up to 60%",
                      "Find the best airfare by searching flights from 250+ airlines, meta searches and more from one spot",
                      "assets/svg/home/save_money.svg",
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: (){
                      widget.navigator.requestFocus();
                      widget.setTab(2);
                    },
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 18.0, right: 18.0, top: 22),
                        child: IntroTextBoxWidget(
                          "Put your search on Autopilot",
                          "Set your preferences and we’ll alert you when we find a deal. Never miss out on a great fare. ",
                          "assets/svg/home/auto_pilot.svg",
                        ),
                      ),
                    ),

                ),

              SliverToBoxAdapter(
                child: StreamBuilder(
                  stream: flyLinebloc.outAccount,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData &&
                        flyLinebloc.isLoggedIn &&
                        !(snapshot.data as Account).isPremium)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18.0, top: 22),
                        child: IntroTextBoxWidget(
                          "FlyLine Premium?",
                          "Wanna get away? Check out our deal feed to find the best deals online. Find a deal you like? Tap on the dealto view and book.",
                          "assets/icons/emoji_icon/notifications_icon_one.svg",
                        ),
                      );
                    return Container();
                  },
                ),
              ),
              // if (flyLinebloc.isLoggedIn)
              //   Padding(
              //     padding:
              //         const EdgeInsets.only(left: 18.0, right: 18.0, top: 22),
              //     child: IntroTextBoxWidget(
              //       "Upcoming trip",
              //       "The typical traveler saves up to 60% when booking on FlyLine. Book with confidence knowing you can cancel or change the booking",
              //       "assets/icons/upcoming_icon.png",
              //     ),
              //   ),
              if (flyLinebloc.isLoggedIn) AutoPilotAlertWidget(),
              if (flyLinebloc.isLoggedIn)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18.0, top: 22),
                    child: RecentSearchBoxWidget(index: 0),
                  ),
                ),


              if (flyLinebloc.isLoggedIn)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18.0, top: 22),
                    child: RecentSearchBoxWidget(index: 1),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
