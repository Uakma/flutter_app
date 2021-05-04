import 'package:flutter/material.dart';
import 'package:motel/widgets/menu_item_app_bar.dart';

class AddPreferredAirline extends StatefulWidget {
  final List<String> selectedAirlines;

  const AddPreferredAirline({
    Key key,
    this.selectedAirlines = const []
  })
      : super(key: key);
  @override
  _AddPreferredAirlineState createState() => _AddPreferredAirlineState();
}

class _AddPreferredAirlineState extends State<AddPreferredAirline> {
  List<String> _buildAirlineList = [];

  @override
  void initState() {
    _buildAirlineList = widget.selectedAirlines ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9FC),
        body: Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        MenuItemAppBar(title: 'Preferred Airlines'),
                        Container(
                          padding: const EdgeInsets.only(left: 15.0, top: 32.0, bottom: 11.0),
                          margin: const EdgeInsets.symmetric( horizontal: 18),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Set Flight Preferances",
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

                        Column(
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
                                    Text("Alaska Airlines (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline1") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ):Container(
                                  width: 20,
                                  height: 20,
                                ),

                                onTap: (){

                                  if(_buildAirlineList.contains("Airline1")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline1");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline1");
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
                                    Image.asset("assets/images/region_flags/australia.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Allegiant (Ultra Low Cost Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline2") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(width: 20, height: 20,),

                                onTap: (){
                                  if(_buildAirlineList.contains("Airline2")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline2");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline2");
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
                                    Image.asset("assets/images/region_flags/canada.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("American Airlines (Legacy/Flag Carrier",
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
                                trailing: _buildAirlineList.contains("Airline3") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(width: 20, height: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline3")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline3");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline3");
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
                                    Image.asset("assets/images/region_flags/china.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("British Airways (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline4") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(width: 20, height: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline4")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline4");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline4");
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
                                    Image.asset("assets/images/region_flags/germany.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Cathay Pacific (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline5") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(width: 20, height: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline5")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline5");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline5");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Delta Airlines (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Frontier (Ultra Low Cost Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Iberia (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("jetBlue (Low Cost Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Lufthansa (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Qatar Airways (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Singapore Airlines (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Southwest Airlines (Low Cost Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Spirit Airlines (Ultra Low Cost Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("United Airlines (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Virgin Atlantic (Legacy/Flag Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
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
                                    Image.asset("assets/images/region_flags/spain.png", height: 26, width: 26,),
                                    SizedBox(width: 10,),
                                    Text("Vueling/Level (Ultra Low Cost Carrier)",
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
                                trailing: _buildAirlineList.contains("Airline6") ?
                                Icon(Icons.check_circle,
                                  color: Color.fromRGBO(0, 174, 239, 1),
                                  size: 23,
                                ): Container(height: 20, width: 20,),
                                onTap: (){
                                  if(_buildAirlineList.contains("Airline6")){
                                    setState(() {
                                      _buildAirlineList.remove("Airline6");
                                    });
                                  }else{
                                    setState(() {
                                      _buildAirlineList.add("Airline6");
                                    });
                                  }

                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}