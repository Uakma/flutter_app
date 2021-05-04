import 'package:flutter/material.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';

class AddCabinClass extends StatefulWidget {
  final String selectedCabin;

  const AddCabinClass({Key key, this.selectedCabin}) : super(key: key);
  @override
  _AddCabinClassState createState() => _AddCabinClassState();
}

class _AddCabinClassState extends State<AddCabinClass> {
  String _buildCabin = "";

  @override
  void initState() {
    _buildCabin = widget.selectedCabin ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FC),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: <Widget>[
                  MenuItemAppBar(title: 'Preferred Cabin Class'),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 32.0, bottom: 11.0),
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Select Prefered Cabin Class",
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
                    padding: const EdgeInsets.only(top: 0.0, bottom: 17.0),
                    margin: const EdgeInsets.only(left: 18),
                    child: Divider(height: 1.5, color: Color(0xffe7e9f0)),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/preferences_icons/seat.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Economy",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _buildCabin == "Economy"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(0, 174, 239, 1),
                                      size: 23,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                    ),
                              onTap: () {
                                if (_buildCabin != "Economy") {
                                  setState(() {
                                    _buildCabin = "Economy";
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/preferences_icons/seat.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Business",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _buildCabin == "Business"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(0, 174, 239, 1),
                                      size: 23,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                    ),
                              onTap: () {
                                if (_buildCabin != "Business") {
                                  setState(() {
                                    _buildCabin = "Business";
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/preferences_icons/seat.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "First Class",
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      color: Color(0xffBBC4DC),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _buildCabin == "First_Class"
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(0, 174, 239, 1),
                                      size: 23,
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                    ),
                              onTap: () {
                                if (_buildCabin != "First_Class") {
                                  setState(() {
                                    _buildCabin = "First_Class";
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
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
                    onPressed: () => Navigator.pop(context, _buildCabin),
                    splashColor: Colors.transparent,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(0, 174, 239, 1)),
                      child: Text(
                        'Save Selection(s)',
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
        ),
      ),
    );
  }
}
