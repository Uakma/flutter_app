import 'package:flutter/material.dart';
import 'package:motel/models/currency_rates.dart';


class ChooseCurrencyScreen extends StatefulWidget {
  final Currency selectedCurrency;

  const ChooseCurrencyScreen({
    Key key,
    this.selectedCurrency
  })
      : super(key: key);
  @override
  _ChooseCurrencyScreenState createState() => _ChooseCurrencyScreenState();
}

class _ChooseCurrencyScreenState extends State<ChooseCurrencyScreen> {
  Currency _setCurrency;
  @override
  void initState() {
    _setCurrency = widget.selectedCurrency;
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
          "Select your Currency",
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
                  //MenuItemAppBar(title: 'Select your Currency'),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, top: 32.0, bottom: 11.0),
                    margin: const EdgeInsets.symmetric( horizontal: 18),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Tap to add your currency",
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
                              title: Text("American Dollar (USD)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "American Dollar (USD)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ):Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                  _setCurrency = Currency.withDefault();
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
                              title: Text("Euro (EUR)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "Euro (EUR)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
        
                                  _setCurrency = Currency(name :"Euro (EUR)", abbr: CurrencyAbbr.EUR, sign: "\€");
                                
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
                              title: Text("Canadian Dollar (CAD)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "Canadian Dollar (CAD)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                 
                                   _setCurrency = Currency(name :"Canadian Dollar (CAD)", abbr: CurrencyAbbr.CAD, sign: "CA\$");
                                
                                  
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
                              title: Text("British Pound (GBP)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "British Pound (GBP)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                  
                                   _setCurrency = Currency(name :"British Pound (GBP)", abbr: CurrencyAbbr.GBP, sign: "\£");
                                
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
                              title: Text("Australian Dollar (AUD)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "Australian Dollar (AUD)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                  
                                   _setCurrency = Currency(name :"Australian Dollar (AUD)", abbr: CurrencyAbbr.AUD, sign: "AU\$");
                                
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
                              title: Text("Chinese Yuan (CNY)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "Chinese Yuan (CNY)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                 
                                   _setCurrency = Currency(name :"Chinese Yuan (CNY)", abbr: CurrencyAbbr.CNY, sign: "\¥");
                                
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
                              title: Text("Indian Rupee (INR)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "Indian Rupee (INR)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                 
                                   _setCurrency = Currency(name :"Indian Rupee (INR)", abbr: CurrencyAbbr.INR, sign: "\₹");
                                
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
                              title: Text("Indoenesian Rupiah (IDR)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "Indoenesian Rupiah (IDR)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                  
                                   _setCurrency = Currency(name :"Indoenesian Rupiah (IDR)", abbr: CurrencyAbbr.IDR, sign: "Rp");
                                
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
                              title: Text("Japanese Yen (JPY)",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Color(0xffBBC4DC),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              trailing: _setCurrency.name == "Japanese Yen (JPY)" ?
                              Icon(Icons.check_circle,
                                color: Color.fromRGBO(0, 174, 239, 1),
                                size: 23,
                              ): Container(width: 20, height: 20,),

                              onTap: (){
                                setState(() {
                                 
                                   _setCurrency = Currency(name :"Japanese Yen (JPY)", abbr: CurrencyAbbr.JPY, sign: "JP\¥");
                                
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
                    onPressed: () {
                      Navigator.pop(context,_setCurrency);
                    },
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