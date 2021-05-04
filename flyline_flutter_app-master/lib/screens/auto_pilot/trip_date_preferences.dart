import 'package:flutter/material.dart';
import 'package:motel/blocs/bloc.dart';
import 'package:motel/screens/auto_pilot/local_widgets/datepicker.dart';


class TripDatePreferences extends StatefulWidget {


  @override
  _TripDatePreferencesState createState() => _TripDatePreferencesState();
}

class _TripDatePreferencesState extends State<TripDatePreferences> {
  bool _bCheckedPriceDate = false;

  @override
  Widget build(BuildContext context) {
    return CustomDatePicker(
      shouldChooseMultipleDates: true,
      departurePlace: flyLinebloc.departureLocation,
      arrivalPlace: flyLinebloc.arrivalLocation,
      departure: flyLinebloc.departureDate == null
          ? DateTime.now()
          : flyLinebloc.departureDate,
      arrival: flyLinebloc.returnDate == null
          ? flyLinebloc.departureDate
          : flyLinebloc.returnDate,
      selected: flyLinebloc.departureDate == null ? false : true,
      showMonth: flyLinebloc.departureDate == null
          ? DateTime.now().month
          : flyLinebloc.departureDate.month,
      adults: flyLinebloc.outAdults.value,
      children: flyLinebloc.outChildren.value,
    );
  }
}
