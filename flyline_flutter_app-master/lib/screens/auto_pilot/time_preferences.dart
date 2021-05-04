import 'package:flutter/material.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../screens/auto_pilot/local_widgets/auto_pilot_probability.dart';
import 'local_widgets/time_preferences.dart' as widget;


class TimePreferences extends StatefulWidget {
  @override
  _TimePreferencesState createState() => _TimePreferencesState();
}

class _TimePreferencesState extends State<TimePreferences> {
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
        Expanded(child: widget.TimePreferences()),
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
      child: Expanded(child: widget.TimePreferences()),
    );
  }
}
