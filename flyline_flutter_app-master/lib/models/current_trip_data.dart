import 'package:flutter/material.dart';
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/flight_information.dart';
import 'package:motel/models/traveler_information.dart';

import 'book_request.dart';

class CurrentTripData {
  CurrentTripData({
    @required this.flightResponse,
    @required this.flight,
    @required this.totalPrice,
    @required this.typeOfTripSelected,
    @required this.selectedClassOfService,
    @required this.payment,
    this.travelersInfo,
    this.autoChecking,
  });

  CheckFlightResponse flightResponse;
  FlightInformationObject flight;
  num totalPrice;
  int typeOfTripSelected;
  String selectedClassOfService;
  List<TravelerInformation> travelersInfo;
  bool autoChecking = false;
  Payment payment;
}
