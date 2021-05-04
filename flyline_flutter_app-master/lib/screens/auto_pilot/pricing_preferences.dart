import 'package:flutter/material.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/models/price_data.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../screens/auto_pilot/local_widgets/auto_pilot_probability.dart';
import 'local_widgets/price_preferences.dart';


class PricingPreferences extends StatefulWidget {
  @override
  _PricingPreferencesState createState() => _PricingPreferencesState();
}

class _PricingPreferencesState extends State<PricingPreferences> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("PRICE SCREEN");
    return ScreenTypeLayout(
       mobile: buildMobileContent(),
       desktop: buildWebContent(),
    );
  }

  Widget buildWebContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: Color.fromRGBO(237, 238, 246, 1)
        )
      ),
      child: PricePreferences(flyLinebloc.outMaxPrice.value ?? 550),
    );
  }

  Widget buildMobileContent() {
    return Column(
      children: <Widget>[
        AutoPilotProbability(flyLinebloc.outProbability.value ?? 60),
        SizedBox(height: 8),
        Expanded(child: PricePreferences(flyLinebloc.outMaxPrice.value ?? 550)),
      ],
    );
  }
}
