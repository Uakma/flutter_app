import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/screens/home/home.dart';

class NoDataPage extends StatelessWidget {
  const NoDataPage({
    Key key,
    @required this.title,
    @required this.description,
    @required this.imageShow,
  }) : super(key: key);

  final String title;
  final String description;
  final String imageShow;

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
              padding: const EdgeInsets.symmetric( horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  imageShow != null ?  Image(image: AssetImage(imageShow), height: 325, width: 325,) :
                  Image.asset(
                    imageShow != null ? imageShow :"assets/images/on_boarding_mocs/illustration_one.png",
                    height: 325, width: 325,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .045,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromRGBO(14, 49, 120, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .02,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
