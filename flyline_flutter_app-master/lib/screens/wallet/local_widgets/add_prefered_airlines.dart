import 'package:flutter/material.dart';
import 'package:motel/models/airline.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';

class AddPreferredAirline extends StatefulWidget {
  final List<AirlineSelect> selectedAirlines;

  const AddPreferredAirline({
    Key key,
    this.selectedAirlines = const []
  })
      : super(key: key);
  @override
  _AddPreferredAirlineState createState() => _AddPreferredAirlineState();
}

class _AddPreferredAirlineState extends State<AddPreferredAirline> {
  List<AirlineSelect> _buildAirlineList = [];
  AirlineSelect _airlineObj = AirlineSelect();

  @override
  void initState() {
    _buildAirlineList = widget.selectedAirlines ?? [];
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
                  MenuItemAppBar(title: 'Airline Preferences'),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, top: 32.0, bottom: 11.0),
                    margin: const EdgeInsets.symmetric( horizontal: 18),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Select Preferred Airlines",
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
                                  Image.asset("assets/images/preferred_airline_logos/AS.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Alaska Airlines",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'alaska_airlines', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ):Container(
                                width: 20,
                                height: 20,
                              ),

                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'alaska_airlines', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'alaska_airlines');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"alaska_airlines",
                                      airlineDescription: "Alaska Airlines",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/AS.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/G4.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Allegiant Airlines",
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
                              trailing:_buildAirlineList.singleWhere((element) => element.airlineName == 'allegiant_airlines', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){


                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'allegiant_airlines', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'allegiant_airlines');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"allegiant_airlines",
                                      airlineDescription: "Allegiant Airlines",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/G4.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }



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
                                  Image.asset("assets/images/preferred_airline_logos/AA.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("American Airlines",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'american_airlines', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){


                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'american_airlines', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'american_airlines');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"american_airlines",
                                      airlineDescription: "American Airlines",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/AA.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }
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
                                  Image.asset("assets/images/preferred_airline_logos/BA.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("British Airways",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'british_airways', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){
                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'british_airways', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'british_airways');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"british_airways",
                                      airlineDescription: "British Airways",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/BA.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }
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
                                  Image.asset("assets/images/preferred_airline_logos/CX.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Cathay Pacific",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'cathay_pacific', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'cathay_pacific', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'cathay_pacific');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"cathay_pacific",
                                      airlineDescription: "Cathay Pacific",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/CX.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/DL.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Delta Airlines",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'delta_airlines', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'delta_airlines', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'delta_airlines');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"delta_airlines",
                                      airlineDescription: "Delta Airlines",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/DL.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/F9.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Frontier",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'frontier', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'frontier', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'frontier');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"frontier",
                                      airlineDescription: "Frontier",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/F9.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/IB.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Iberia",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'iberia', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'iberia', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'iberia');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"iberia",
                                      airlineDescription: "Iberia",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/IB.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/B6.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("jetBlue",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'jetBlue', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'jetBlue', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'jetBlue');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"jetBlue",
                                      airlineDescription: "jetBlue",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/B6.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/LH.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Lufthansa",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'lufthansa', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'lufthansa', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'lufthansa');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"lufthansa",
                                      airlineDescription: "Lufthansa",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/LH.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/SQ.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Singapore Airlines",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'singapore_airlines', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'singapore_airlines', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'singapore_airlines');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"singapore_airlines",
                                      airlineDescription: "Singapore Airlines",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/SQ.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/WN.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Southwest Airlines",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'southwest_airlines', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'southwest_airlines', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'southwest_airlines');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"southwest_airlines",
                                      airlineDescription: "Southwest Airlines",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/WN.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/NK.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Spirit Airlines",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'spirit_airlines', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'spirit_airlines', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'spirit_airlines');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"spirit_airlines",
                                      airlineDescription: "Spirit Airlines",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/NK.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/UA.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("United Airlines",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'united_airlines', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'united_airlines', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'united_airlines');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"united_airlines",
                                      airlineDescription: "United Airlines",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/UA.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/VS.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Virgin Atlantic",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'virgin_atlantic', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'virgin_atlantic', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'virgin_atlantic');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"virgin_atlantic",
                                      airlineDescription: "Virgin Atlantic",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/VS.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
                                  });
                                }

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
                                  Image.asset("assets/images/preferred_airline_logos/VY.png", height: 26, width: 26,),
                                  SizedBox(width: 10,),
                                  Text("Vueling/Level",
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
                              trailing: _buildAirlineList.singleWhere((element) => element.airlineName == 'vueling_or_level', orElse: ()=> null) != null ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),
                              onTap: (){

                                if(_buildAirlineList.singleWhere((element) => element.airlineName == 'vueling_or_level', orElse: ()=> null) != null){
                                  setState(() {
                                    _buildAirlineList.removeWhere((element) => element.airlineName == 'vueling_or_level');
                                  });
                                }else{
                                  _airlineObj = AirlineSelect(
                                      airlineName:"vueling_or_level",
                                      airlineDescription: "Vueling/Level",
                                      airlinePictureUrl: "assets/images/preferred_airline_logos/VY.png"
                                  );
                                  setState(() {
                                    _buildAirlineList.add(_airlineObj);
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
                    onPressed: () => Navigator.pop(context, _buildAirlineList),
                    splashColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100, vertical: 12),
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