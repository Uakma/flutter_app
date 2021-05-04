import 'package:flutter/material.dart';

class CategoryTileWidget extends StatelessWidget {
  const CategoryTileWidget({
    @required this.title,
    @required this.description,
    @required this.minimumPrice,
    @required this.maximumPrice,
    @required this.departureDate,
    @required this.onSelectAction,
    @required this.color,
  });

  final String title;
  final String description;
  final Widget minimumPrice;
  final Widget maximumPrice;
  final DateTime departureDate;
  // final Widget routeToPush;
  final onSelectAction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 174, 239, .1),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Price Range  ',
                      style: TextStyle(
                        fontFamily: "Gilroy",
                        color: Color.fromRGBO(0, 174, 239, 1),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    minimumPrice,
                    maximumPrice
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    '$description',
                    style: TextStyle(
                      fontFamily: "Gilroy",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(142, 150, 159, 1),
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: FlatButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  onPressed: () => onSelectAction(),
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (BuildContext context) => routeToPush,
                  // )),
                  color: Color.fromRGBO(0, 174, 239, 1),
                  child: Text(
                    'Sort Flights',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
