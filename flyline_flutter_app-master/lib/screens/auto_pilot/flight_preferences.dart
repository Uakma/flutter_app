import 'package:flutter/material.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../screens/auto_pilot/local_widgets/auto_pilot_probability.dart';
import 'local_widgets/flight_preferences.dart' as widget;


/// Author: Ali Dali
/// Last Updated: 28-07-2020

class FlightPreferences extends StatefulWidget {
  @override
  _FlightPreferencesState createState() => _FlightPreferencesState();
}

class _FlightPreferencesState extends State<FlightPreferences> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: buildMobileContent(),
      desktop: buildWebContent(),
    );
  }

  Widget buildMobileContent() {
    return Column(
      children: <Widget>[
        AutoPilotProbability(flyLinebloc.outProbability.value ?? 60),
        SizedBox(height: 8),
        Expanded(child: widget.FlightPreferences()),
      ],
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
      child: Expanded(child: widget.FlightPreferences()),
    );
  }
}
