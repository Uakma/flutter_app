import 'dart:convert';

class AutoPilotAlert {
  final int id;
  final Place placeFrom;
  final Place placeTo;
  final DateTime departureDate;
  final DateTime returnDate;
  final int price;

  AutoPilotAlert({
    this.id,
    this.placeFrom,
    this.placeTo,
    this.departureDate,
    this.returnDate,
    this.price,
  });

  factory AutoPilotAlert.fromRawJson(String str) =>
      AutoPilotAlert.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AutoPilotAlert.fromJson(Map<String, dynamic> json) => AutoPilotAlert(
        id: json["id"],
        placeFrom:
            json["origin"] == null ? null : Place.fromJson(json["origin"]),
        placeTo: json["destination"] == null
            ? null
            : Place.fromJson(json["destination"]),
        departureDate: json["departure_date"] == null
            ? null
            : DateTime.parse(json["departure_date"]),
        returnDate: json["return_date"] == null
            ? null
            : DateTime.parse(json["return_date"]),
        price: json["max_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "origin": placeFrom == null ? null : placeFrom.toJson(),
        "destination": placeTo == null ? null : placeTo.toJson(),
        "departure_date": departureDate == null
            ? null
            : "${departureDate.year.toString().padLeft(4, '0')}-${departureDate.month.toString().padLeft(2, '0')}-${departureDate.day.toString().padLeft(2, '0')}",
        "return_date": returnDate == null
            ? null
            : "${returnDate.year.toString().padLeft(4, '0')}-${returnDate.month.toString().padLeft(2, '0')}-${returnDate.day.toString().padLeft(2, '0')}",
        "max_price": price
      };
}

class Place {
  final String code;
  final String name;
  final String type;
  final Country country;
  final Subdivision subdivision;

  Place({
    this.code,
    this.name,
    this.type,
    this.country,
    this.subdivision,
  });

  factory Place.fromRawJson(String str) => Place.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        subdivision: json["subdivision"] == null
            ? null
            : Subdivision.fromJson(json["subdivision"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "country": country == null ? null : country.toJson(),
        "subdivision": subdivision == null ? null : subdivision.toJson(),
      };
}

class Country {
  final String code;

  Country({
    this.code,
  });

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
      };
}

class Subdivision {
  final String name;

  Subdivision({
    this.name,
  });

  factory Subdivision.fromRawJson(String str) =>
      Subdivision.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subdivision.fromJson(Map<String, dynamic> json) => Subdivision(
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
      };
}
