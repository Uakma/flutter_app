// A Pojo class for FlightInformation
import 'package:motel/utils/date_utils.dart';

class FlightInformationObject {
  String flyFrom;
  String flyTo;
  String cityFrom;
  String cityTo;
  int nightsInDest;
  List<FlightRouteObject> routes;
  DateTime localArrival;
  DateTime localDeparture;
  String durationDeparture;
  String durationReturn;
  int durationDepartureInSeconds;
  int durationReturnInSeconds;
  String bookingToken;
  double price;
  List<dynamic> airlines;
  double distance;
  String deepLink;
  String kind;
  List<FlightRouteObject> departures;
  List<FlightRouteObject> returns;
  Map<String, dynamic> raw;
  String source;

  FlightInformationObject(
    String flyFrom,
    String flyTo,
    String cityFrom,
    String cityTo,
    int nightsInDest,
    DateTime localArrival,
    DateTime localDeparture,
    List<FlightRouteObject> routes,
    String durationDeparture,
    String durationReturn,
    int durationDepartureInSeconds,
    int durationReturnInSeconds,
    String bookingToken,
    List<dynamic> airlines,
    double price,
    double distance,
    String deepLink,
    String kind,
    List<FlightRouteObject> departures,
    List<FlightRouteObject> returns,
    Map<String, dynamic> raw,
    String source,
  ) {
    this.flyFrom = flyFrom;
    this.flyTo = flyTo;
    this.cityFrom = cityFrom;
    this.cityTo = cityTo;
    this.routes = routes;
    this.localArrival = localArrival;
    this.localDeparture = localDeparture;
    this.nightsInDest = nightsInDest;
    this.durationDeparture = durationDeparture;
    this.durationReturn = durationReturn;
    this.durationDepartureInSeconds = durationDepartureInSeconds;
    this.durationReturnInSeconds = durationReturnInSeconds;
    this.bookingToken = bookingToken;
    this.price = price;
    this.airlines = airlines;
    this.distance = distance;
    this.deepLink = deepLink;
    this.kind = kind;
    this.departures = departures;
    this.returns = returns;
    this.raw = raw;
    this.source = source;
  }

  factory FlightInformationObject.fromJson(Map<String, dynamic> json) {
    var list = json['route'] as List;

    List<FlightRouteObject> departures = List<FlightRouteObject>();
    List<FlightRouteObject> returns = List<FlightRouteObject>();

    for (dynamic route in list) {
      if (route["return"] == 0)
        departures.add(FlightRouteObject.fromJson(route));
    }

    for (dynamic route in list) {
      if (route["return"] == 1) returns.add(FlightRouteObject.fromJson(route));
    }

    List<FlightRouteObject> items = List<FlightRouteObject>();

    items = list.map((i) => FlightRouteObject.fromJson(i)).toList();

    String deepLink = "";
    String durationDeparture = "";
    String durationReturn = "";
    int _durationDepartureInSeconds = 0;
    int _durationReturnInSeconds = 0;

    final DateTime parsedDepartureDate =
        DateTime.parse(json["local_departure"]);
    final DateTime parsedArrivalDate = DateTime.parse(json["local_arrival"]);

    if (json["duration"] != null && json["duration"]["departure"] != null)
      durationDeparture = DateUtils.secs2hm(
          Duration(seconds: json["duration"]["departure"]).inSeconds);
    

    if (json["duration"] != null && json["duration"]["return"] != null)
      durationReturn = DateUtils.secs2hm(
          Duration(seconds: json["duration"]["return"]).inSeconds);
    
     if (json["duration"] != null && json["duration"]["departure"] != null){
        _durationDepartureInSeconds =  json["duration"]["departure"];
        // print(_durationDepartureInSeconds);
     }

     if (json["duration"] != null && json["duration"]["return"] != null){
        _durationReturnInSeconds =   Duration(seconds: json["duration"]["return"]).inSeconds;
     }
     


    if (json["deeplink"] != null) deepLink = json["deeplink"];



    return FlightInformationObject(
      json['flyFrom'],
      json["flyTo"],
      json['cityFrom'],
      json['cityTo'],
      json["nightsInDest"],
      parsedArrivalDate,
      parsedDepartureDate,
      items,
      durationDeparture,
      durationReturn,
      _durationDepartureInSeconds,
      _durationReturnInSeconds,
      json['booking_token'],
      json['airlines'],
      (json['price'] is String)
          ? double.parse(json['price'])
          : double.parse(json['price'].toString()),
      double.tryParse(json['distance'].toString() ?? ''),
      deepLink,
      json["kind"],
      departures,
      returns,
      json,
      json['source']
    );
  }

  @override
  String toString() {
    return 'FlightInformationObject{flyFrom: $flyFrom, flyTo: $flyTo, cityFrom: $cityFrom, cityTo: $cityTo, nightsInDest: $nightsInDest, routes: $routes, localArrival: $localArrival, localDeparture: $localDeparture, durationDeparture: $durationDeparture, durationReturn: $durationReturn}';
  }
}

// A Pojo class for Flight Route
class FlightRouteObject {
  String cityCodeTo;
  String cityCodeFrom;
  String cityFrom;
  String cityTo;
  String flyFrom;
  String flyTo;
  int flightNo;
  String airline;
  DateTime localArrival;
  DateTime localDeparture;
  DateTime utcArrival;
  DateTime utcDeparture;
  int returnFlight;

  FlightRouteObject(
    String cityCodeFrom,
    String flyFrom,
    String flyTo,
    String cityFrom,
    String cityTo,
    int flightNo,
    DateTime localArrival,
    DateTime localDeparture,
    DateTime utcArrival,
    DateTime utcDeparture,
    String airline,
    int returnFlight,
  ) {
    this.cityFrom = cityFrom;
    this.cityTo = cityTo;
    this.flyFrom = flyFrom;
    this.flyTo = flyTo;
    this.localArrival = localArrival;
    this.localDeparture = localDeparture;
    this.utcArrival = utcArrival;
    this.utcDeparture = utcDeparture;
    this.flightNo = flightNo;
    this.airline = airline;
    this.returnFlight = returnFlight;
  }

  factory FlightRouteObject.fromJson(Map<String, dynamic> json) {
    DateTime parsedDepartureDate = DateTime.parse(json["local_departure"]);
    DateTime parsedArrivalDate = DateTime.parse(json["local_arrival"]);
    DateTime parsedUTCDepartureDate;
    DateTime parsedUTCArrivalDate;
    if (json.containsKey('utc_departure'))
      parsedUTCDepartureDate = DateTime.parse(json["utc_departure"]);
    else
      parsedUTCDepartureDate = parsedDepartureDate.toUtc();
    if (json.containsKey('utc_arrival'))
      parsedUTCArrivalDate = DateTime.parse(json["utc_arrival"]);
    else
      parsedUTCArrivalDate = parsedArrivalDate.toUtc();

    return FlightRouteObject(
        json['cityCodeFrom'],
        json['flyFrom'],
        json["flyTo"],
        json['cityFrom'],
        json['cityTo'],
        (json["flight_no"] is String)
            ? int.parse(json["flight_no"])
            : json["flight_no"],
        parsedArrivalDate,
        parsedDepartureDate,
        parsedUTCArrivalDate,
        parsedUTCDepartureDate,
        json["airline"],
        json['return']);
  }

  get duration {
    return Duration(
        milliseconds: this.utcArrival.millisecondsSinceEpoch -
            this.utcDeparture.millisecondsSinceEpoch);
  }

  String durationString() {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    String result = '';
    if (hours > 0) {
      result += '${hours}h';
    }
    if (minutes > 0) {
      result += result.isEmpty ? '${minutes}m' : ' ${minutes}m';
    }
    return result;
  }

  @override
  String toString() {
    return 'FlightRouteObject{cityFrom: $cityFrom, cityTo: $cityTo, flyFrom: $flyFrom, flyTo: $flyTo, flightNo: $flightNo, airline: $airline, localArrival: $localArrival, localDeparture: $localDeparture}';
  }
}
