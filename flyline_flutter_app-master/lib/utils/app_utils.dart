import 'package:flutter/material.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/models/airline.dart';

abstract class AppUtils {
  static Map<String, String> airlinesCode = {
    "AS": "Alaska Airlines",
    "G4": "Allegiant Airlines",
    "AA": "American Airlines",
    "BA": "British Airways",
    "CX": "Cathay Pacific",
    "DL": "Delta Airlines",
    "F9": "Frontier",
    "I2": "Iberia",
    "B6": "JetBlue",
    "LH": "Lufthansa",
    "SQ": "Singapore Airlines",
    "WN": "Southwest Airlines",
    "NK": "Spirit Airlines",
    "UA": "United Airlines",
    "VS": "Virgin Atlantic",
  };

  static String getAirlineCode(BuildContext context, String name) {
    String code = "";
    AppUtils.airlinesCode.forEach((key, value) {
      if (name.toLowerCase() == value.toString().toLowerCase()) {
        code = key;
      }
    });
    return code;
  }

  static String getAirlineByCode(BuildContext context, String code) {
    String airline = "";
    AppUtils.airlinesCode.forEach((key, value) {
      if (code == key) {
        airline = value;
      }
    });
    return airline;
  }

  static String capitalize(String txt) {
    if (txt == null || txt.isEmpty) {
      return "";
    }
    return txt
        .trim()
        .split(" ")
        .where((e) => e.trim().length > 0)
        .map((e) => "${e[0].toUpperCase()}"
            "${e.length > 1 ? e.substring(1).toLowerCase() : ""}")
        .join(" ");
  }

  static FlightSelect createDurationFlight(int value) {
    return FlightSelect(
        flightName: DurationPricePreference.getKey(value),
        flightPictureUrl: value == DurationPricePreference.CHEAPEST
            ? "assets/images/preferences_icons/cheapest.png"
            : "assets/images/preferences_icons/shortest.png",
        flightDescription: AppUtils.capitalize(
            DurationPricePreference.getKey(value).replaceAll("_", " ")));
  }

  static FlightSelect createDirectFlight() {
    return FlightSelect(
        flightName: "direct_flight",
        flightPictureUrl: "assets/images/preferences_icons/direct.png",
        flightDescription: "Direct Flights");
  }

  static FlightSelect createCarrier(int value) {
    return FlightSelect(
        flightName: CarrierPreference.getKey(value),
        flightPictureUrl: "assets/images/preferences_icons/carrier.png",
        flightDescription: AppUtils.capitalize(
            DurationPricePreference.getKey(value).replaceAll("_", " ")));
  }
}
