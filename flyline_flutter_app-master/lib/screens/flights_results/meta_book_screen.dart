import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:motel/widgets/loading_screen.dart';

class MetaBookScreen extends StatefulWidget {
  final String url;
  final Map<String, dynamic> retailInfo;

  const MetaBookScreen({
    Key key,
    this.url,
    this.retailInfo,
  }) : super(key: key);

  @override
  _MetaBookScreenState createState() => _MetaBookScreenState();
}

Widget getAppBarUI(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/back-arrow.png',
                        scale: 28,
                      )),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 17),
              alignment: Alignment.center,
              child: new Text(
                "Meta Fare",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Color(0xff0E3178),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

class _MetaBookScreenState extends State<MetaBookScreen> {
  String get baseUrl => 'https://api.flyline.io';
  int _stackToView = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _stackToView,
        children: [
          Column(
            children: <Widget>[
              // MenuItemAppBar(title: 'Meta Fare'),
              getAppBarUI(context),
              Expanded(
                child: Container(
                  child: InAppWebView(
                    onLoadStart: (controller, str) =>
                        setState(() => _stackToView = 1),
                    onLoadStop: (controller, url) =>
                        setState(() => _stackToView = 0),
                    initialUrl: '$baseUrl${widget.url}',
                    initialOptions: InAppWebViewWidgetOptions(
                      inAppWebViewOptions: InAppWebViewOptions(
                        horizontalScrollBarEnabled: false,
                        verticalScrollBarEnabled: false,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          LoadingScreen(
            message: "Loading Booking Details",
          ),
        ],
      ),
    );
  }
}
