import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/models/price_data.dart';
import 'package:motel/models/locations.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../blocs/bloc.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class PricePreferences extends StatefulWidget {
  final int price;
  PricePreferences(
    this.price, {
    Key key,
  }) : super(key: key);

  @override
  _PricePreferencesState createState() => _PricePreferencesState();
}

class _PricePreferencesState extends State<PricePreferences> {

  final min = 100;
  final max = 1500;
  final low = 10;
  final high = 95;
  int price;

  @override
  void initState() {
    super.initState();
    price = widget.price;

    flyLinebloc.setProbability(_calculateProbability(price));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ScreenTypeLayout(
        mobile: buildMobileContent(),
        desktop: buildWebContent(),
      ),
    );
  }

  Widget buildMobileContent() {
    var increment = 50;
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Set Max Price Preference',
                style: TextStyle(
                  color: Color(0xff0e3178),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Text(
              'Below, set the maximum price you are willing to \npay for this Autopilot reservation. ',
              style: TextStyle(
                color: Color(0xff8e969f),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                height: 1.7,
              ),
            ),
            SizedBox(height: 34),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (price <= min) return;
                    setState(() {
                      price -= increment;
                      flyLinebloc
                          .setProbability(_calculateProbability(price));
                      flyLinebloc.setMaxPrice(price);
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 247, 254, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                        child: Text(
                      '-',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '\$$price',
                    style: TextStyle(
                      color: Color.fromRGBO(68, 207, 87, 1),
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (price >= max) return;
                    setState(() {
                      price += increment;
                      flyLinebloc
                          .setProbability(_calculateProbability(price));
                      flyLinebloc.setMaxPrice(price);
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 247, 254, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                        child: Text(
                      '+',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                )
              ],
            )
          ],
        ),
      );
  }

  Widget buildWebContent() {
    var increment = 50;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 56.w, vertical: 20),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50.w,
                  child: InkWell(
                    onTap: () {
                      if (price <= min) return;
                      setState(() {
                        price -= increment;
                        flyLinebloc
                            .setProbability(_calculateProbability(price));
                        flyLinebloc.setMaxPrice(price);
                      });
                    },
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(229, 247, 254, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Text(
                        '-',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 32.w,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                Expanded(
                  // padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    '\$$price',
                    style: TextStyle(
                      color: Color.fromRGBO(68, 207, 87, 1),
                      fontSize: 60.w,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 50.w,
                  child: InkWell(
                    onTap: () {
                      if (price >= max) return;
                      setState(() {
                        price += increment;
                        flyLinebloc
                            .setProbability(_calculateProbability(price));
                        flyLinebloc.setMaxPrice(price);
                      });
                    },
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(229, 247, 254, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Text(
                        '+',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 32.w,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 34.w),
            Text(
              'Select your pricing preferences below, If you see the probability number go to low, change the preferences ',
              style: TextStyle(
                color: Color.fromRGBO(142, 150, 159, 1),
                fontSize: 14.w,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                height: 1.7,
              ),
            ),
          ],
        ),
      );
  }

  double _calculateProbability(int price) {
    PriceDataResponse priceDateResponse = flyLinebloc.outPriceDataResponse.value;
    double probability = 0.0;
    if (priceDateResponse != null) {
      List<PriceData> priceDataList = priceDateResponse.priceDataResults;
      priceDataList.sort((a, b) =>
          a.price.compareTo(b.price));

      if ( priceDataList.length > 0 ) {
        for (var i = 0; i < priceDataList.length; i++) {
          if (priceDataList[i].price > price) {
            probability = (i + 1) / priceDataList.length * 100.0;
            break;
          }
        }
        if (probability == 0) {
          if (priceDataList[0].price > price) {
            probability = 0.0;
          } else {
            probability = 100.0;
          }
        }
      }
    }

    print(price);
    print(probability.toString() + "%");

    /*
    if (increase)
      probability = flyLinebloc.outProbability.value + 2.5;
    else
      probability = flyLinebloc.outProbability.value - 2.5;
     */

    return probability < low ? low.toDouble() : probability > high ? high.toDouble() : probability;
  }
}
