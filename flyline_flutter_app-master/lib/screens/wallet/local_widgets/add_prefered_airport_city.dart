import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motel/models/locations.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';
import 'package:motel/widgets/location_search_ui.dart';

class AddPreferredAirport extends StatefulWidget {
  @override
  _AddPreferredAirportState createState() => _AddPreferredAirportState();
}

class _AddPreferredAirportState extends State<AddPreferredAirport> {
  LocationObject _selectedAirportObj;
  TextEditingController tController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FC),
      body: Container(
          child: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                MenuItemAppBar(title: 'Preferred City or Airports'),
                Container(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 32.0, bottom: 11.0),
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Select Preferred Airport or City",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 17,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 0),
                  margin: const EdgeInsets.only(left: 18),
                  child: Divider(height: 1.5, color: Color(0xffe7e9f0)),
                ),
                Container(
                  height: 300,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: Focus(
                          child: LocationSearchUI(
                            controller: tController,
                            fillColor: Colors.white,
                            hintText: "Type to add preferred city or airport",
                            onChange: (value) =>
                                setState(() => _selectedAirportObj = value),
                            style: const TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff333333),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Gilroy",
                                color: Color(0xFFBBC4DC)),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: -5,
            left: 0,
            right: 0,
            height: 100,
            child: Material(
              color: Colors.white,
              elevation: 10,
              child: Center(
                child: FlatButton(
                  onPressed: () {
                    if (_selectedAirportObj.runtimeType == LocationObject) {
                      Navigator.pop(context, _selectedAirportObj);
                    }
                  },
                  splashColor: Colors.transparent,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(0, 174, 239, 1)),
                    child: Text(
                      'Save Selection',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          getAppBarWithBackButton(context)
        ],
      )),
    );
  }
}
