import 'package:flutter/cupertino.dart';
import 'package:motel/models/locations.dart';

class DataHelper with ChangeNotifier {
  
  /// Selected Locations
  /// 01-07-2020
  LocationObject _selectedDepartureLocation;
  LocationObject _selectedArrivalLocation;

  LocationObject get selectedDepartureLocation => _selectedDepartureLocation;
  LocationObject get selectedArrivalLocation => _selectedArrivalLocation;

  void selectDepartureLocation(LocationObject location) {
    // Add validation (if needed)
    _selectedDepartureLocation = location;
  }

  void selectArrivalLocation(LocationObject location) {
    // Add validation (if needed)
    _selectedArrivalLocation = location;
  }
}
