import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedFlatButtonForNetworkRequest extends StatefulWidget {
  final Function networkRequest;
  final String btnTxt;

  const AnimatedFlatButtonForNetworkRequest(
      {Key key, this.networkRequest, this.btnTxt})
      : super(key: key);

  @override
  _AnimatedFlatButtonForNetworkRequestState createState() =>
      _AnimatedFlatButtonForNetworkRequestState();
}

class _AnimatedFlatButtonForNetworkRequestState
    extends State<AnimatedFlatButtonForNetworkRequest> {
  bool _networkRequestInProgress = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        _networkRequestInProgress = true;
        setState(() {});
        _networkRequestInProgress = await widget.networkRequest();
        setState(() {});
      },
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color.fromRGBO(0, 174, 239, 1)),
        child: Stack(
          children: <Widget>[
            Text(
              widget.btnTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                  color: _networkRequestInProgress
                      ? Colors.transparent
                      : Colors.white),
            ),
            if (_networkRequestInProgress)
              Center(
                heightFactor: 1.0,
                widthFactor: 7.0,
                child: Theme(
                    data: ThemeData(
                        cupertinoOverrideTheme:
                        CupertinoThemeData(brightness: Brightness.dark)),
                    child: CupertinoActivityIndicator()),
              )
          ],
        ),
      ),
    );
  }
}