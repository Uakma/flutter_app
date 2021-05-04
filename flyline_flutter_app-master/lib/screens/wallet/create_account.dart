import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/screens/sign_up/sign_up.dart';

class NoDataCreateAccountPage extends StatelessWidget {

  final String title;
  final String description;
  final String imageShow;

  const NoDataCreateAccountPage({
    Key key,
    @required this.title,
    @required this.description,
    @required this.imageShow,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .1,
              color: Color(0xFFF7F9FC),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    imageShow != null ? imageShow :"assets/images/on_boarding_mocs/illustration_one.png",
                    height: 325, width: 325,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .025,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      color: Color.fromRGBO(14, 49, 120, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * .05),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.8,
                        color: Color.fromRGBO(142, 150, 159, 1),
                      ),
                    ),
                  ),

                  InkResponse(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Container(
                      width: 262,
                      height: 50,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .04, bottom: MediaQuery.of(context).size.height * .04),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(27)
                          ),
                          color: const Color(0xff00aeef)
                      ),
                      child: Text("Create An Account", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Gilroy",)),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
