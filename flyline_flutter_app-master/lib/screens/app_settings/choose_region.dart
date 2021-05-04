import 'package:flutter/material.dart';

class ChooseRegionScreen extends StatefulWidget {
  final String selectedRegion;

  const ChooseRegionScreen({
    Key key,
    this.selectedRegion = "United States"
  })
      : super(key: key);
  @override
  _ChooseRegionScreenState createState() => _ChooseRegionScreenState();
}

class _ChooseRegionScreenState extends State<ChooseRegionScreen> {
  String _setRegion = "";

  @override
  void initState() {
    _setRegion = widget.selectedRegion;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: Text(
          "Select your Region",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Gilroy',
            color: Color(0xff0E3178),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: <Widget>[
                  //MenuItemAppBar(title: 'Select your Region'),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, top: 32.0, bottom: 11.0),
                    margin: const EdgeInsets.symmetric( horizontal: 18),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Tap to add your region",
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
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/united_states.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("United States",
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
                              trailing: _setRegion == "United States" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ):Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                  _setRegion = "United States";
                                });
                              },
                            ),
                          ),


                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/australia.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Australia",
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
                              trailing: _setRegion == "Australia" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                  _setRegion = "Australia";
                                });
                              },
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/canada.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Canada",
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
                              trailing: _setRegion == "Canada" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                setState(() {
                                  _setRegion = "Canada";
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/china.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("China",
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
                              trailing: _setRegion == "China" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                setState(() {
                                  _setRegion = "China";
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/germany.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Germany",
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
                              trailing: _setRegion == "Germany" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                setState(() {
                                  _setRegion = "Germany";
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Spain",
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
                              trailing: _setRegion == "Spain" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                setState(() {
                                  _setRegion = "Spain";
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/france.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("France",
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
                              trailing: _setRegion == "France" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                setState(() {
                                  _setRegion = "France";
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/greece.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Greece",
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
                              trailing: _setRegion == "Greece" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                setState(() {
                                  _setRegion = "Greece";
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/india.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("India",
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
                              trailing: _setRegion == "India" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                setState(() {
                                  _setRegion = "India";
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Image.asset("assets/images/region_flags/indonesia.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Indonesia",
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
                              trailing: _setRegion == "Indonesia" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                setState(() {
                                  _setRegion = "Indonesia";
                                });
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
                    onPressed: () =>  Navigator.pop(context,_setRegion),
                    splashColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(0, 174, 239, 1)),
                      child: Text(
                        'Save Selection',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}