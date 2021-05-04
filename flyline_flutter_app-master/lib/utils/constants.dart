import 'package:motel/models/payment_info.dart';

class SortOptions {
  static const String directFlights = 'directFlights';
  static const String singlecarier = 'singlecarier';
  static const String cheapest = 'cheapest';
  static const String soonest = 'soonest';
  static const String quickest = 'quickest';
  static const String legacyFlagCarriers = 'legacyFlagCarriers';
  static const String lowCostCarriers = 'lowCostCarriers';
  static const String ultraLowCostCarriers = 'ultraLowCostCarriers';

  static const String takeOffMorning = 'takeOffMorning';
  static const String takeOffEvening = 'takeOffEvening';
  static const String takeOffAfterNoon = 'takeOffAfterNoon';

  static const String landingMorning = 'landingMorning';
  static const String landingEvening = 'landingEvening';
  static const String landingAfterNoon = 'landingAfterNoon';

  static const String dest_takeOffMorning = 'dest_takeOffMorning';
  static const String dest_takeOffEvening = 'dest_takeOffEvening';
  static const String dest_takeOffAfterNoon = 'dest_takeOffAfterNoon';

  static const String dest_landingMorning = 'dest_landingMorning';
  static const String dest_landingEvening = 'dest_landingEvening';
  static const String dest_landingAfterNoon = 'dest_landingAfterNoon';

  static PaymentInformation paymentInfo = PaymentInformation();

}



List<String> legacyAirlines = [
  "AA",
  "BA",
  "DL",
  "UA",
  "AS",
  "AC",
  "AZ",
  "AF",
  "NZ",
  "AI",
  "AM",
  "NH",
  "TN",
  "OS",
  "FJ",
  "LD",
  "SU",
  "PX",
  "OZ",
  "CA",
  "BA",
  "CX",
  "CI",
  "MU",
  "CZ",
  "MS",
  "BR",
  "AY",
  "KA",
  "IR",
  "JL",
  "EG",
  "KL",
  "KE",
  "LH",
  "MH",
  "PR",
  "PK",
  "QF",
  "SK",
  "SQ",
  "LX",
  "FM",
  "TG",
  "TK",
  "HY",
  "VN",
  "VS",

];

List<String> lowCostAirlines = [
  "WN",
  "B6",
  "SY",
  "WS",
  "EW",
  "E2",
  "DY",
  "FR",
  "W6",
  "40",
  "Y4",


];

List<String> ultraLowCostAirlines = [
  "F9",
  "NK",
  "G4",
  "AK",
  "I5",
  "JW",
  "D7",
  "Z2",
  "IX",
  "RS",
  "5J",
  "PN",
  "QG",
  "G8",
  "UO",
  "6E",
  "QZ",
  "GK",
  "U2",
  "F8",
  "W6",
  "8Z",
  "WU",
  "WU",
  "GO",

];

class Cabin {
  static const int ECONOMY = 0;
  static const int BUSINESS = 10;
  static const int FIRST_CLASS = 20;

  static int getValue(String type) {
    switch (type.toUpperCase()) {
      case "ECONOMY":
        return ECONOMY;
        break;
      case "BUSINESS":
        return BUSINESS;
        break;
      case "FIRST_CLASS":
        return FIRST_CLASS;
        break;
      default:
        return null;
    }
  }

  static String getKey(int value) {
    switch (value) {
      case 0:
        return "Economy";
      case 10:
        return "Business";
      case 20:
        return "First Class";
      default:
        return null;
    }
  }
}

class DurationPricePreference {
  static const CHEAPEST = 0;
  static const SHORTEST = 1;

  static int getValue(String type) {
    switch (type.toLowerCase()) {
      case "cheapest_flights":
        return CHEAPEST;
      case "shortest_flight":
        return SHORTEST;
      default:
        return null;
    }
  }

  static String getKey(int value) {
    switch (value) {
      case 0:
        return "cheapest_flights";
      case 1:
        return "shortest_flight";
      default:
        return null;
    }
  }
}

class CarrierPreference {
  static const SINGLE = 0;
  static const MULTI = 1;

  static int getValue(String type) {
    switch (type.toLowerCase()) {
      case "single_carrier":
        return SINGLE;
      case "multi_carrier":
        return MULTI;
      default:
        return null;
    }
  }

  static String getKey(int value) {
    switch (value) {
      case 0:
        return "single_carrier";
      case 1:
        return "multi_carrier";
      default:
        return null;
    }
  }
}

class FlightType {
  static const KIWI = "kiwi";
  static const DUFFEL = "duffel";
}

Map<String, String> airlineNames = {
  'AA': 'American Airlines',
  'AS': 'Alaska Airlines',
  'NK': 'Spirirt Airlines',
  'F9': 'Frontier Airlines',
  'B6': 'JetBlue Airlines',
  'UA': 'United Airlines',
  'G4': 'Allegiant Airlines',
  'AC': 'Air Canada',
  'AZ': 'Air Italia',
  'AF': 'Air France',
  'NZ': 'Air New Zeland',
  'AM': 'Aeromexico',
  'TN': 'Air Tahiti',
  'SU': 'Aeroflot',
  'OZ': 'Asiana Airlines',
  'CA': 'Air China',
  'BA': 'British Airways',
  'CX': 'Cathay Pacific',
  'CI': 'China Airlines',
  'MU': 'China Eastern Airlines',
  'CZ': 'China Southern Airlines',
  'DL': 'Delta Airlines',
  'MS': 'Egypt Air',
  'BR': 'Eva Airways',
  'AY': 'Finnair',
  'JL': 'Japan Airlines',
  'KE': 'Korean Airlines',
  'LH': 'Lufthansa Airlines',
  'QF': 'Qantas Airways',
  'SQ': 'Singapore Airlines',
  'LX': 'Swiss Airlines',
  'TK': 'Turkish Airlines',
  'VN': 'Vietnam Airlines',
  'VS': 'Virgin Atlantic',
  'A3': 'Aegean Airlines',
  'EI': 'Aer Lingus',
  'SM': 'Air Cairo',
  'I5': 'Air Asia India',
  'AK': 'Air Asia Berhad',
  'DJ': 'Air Asia Japan',
  'D7': 'Air Asia X',
  'AD': 'Azul Airlines',
  '4B': 'Boutique Air',
  'SN': 'Brussels Airlines',
  'U2': 'Easyjet Airlines',
  'EK': 'Emirates Airlines',
};