import 'package:flutter/material.dart';
import 'package:motel/models/flight_information.dart';

class SearchProvider extends ChangeNotifier {
  Stream<List<FlightInformationObject>> flightsStream;
  bool isRoundTrip = true;
  bool isSearching = false;

  void setFlightsStream(Stream<List<FlightInformationObject>> stream) {
    flightsStream = stream;
    notifyListeners();
  }

  void setRoundTrip(bool _isRoundTrip) {
    isRoundTrip = _isRoundTrip;
    notifyListeners();
  }

  void setSearching(bool _isSearching) {
    isSearching = _isSearching;
    notifyListeners();
  }
}