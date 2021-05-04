import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:motel/helper/helper.dart';

import 'locations.dart';

class TravelerInfo {
  final int id;
  final DateTime lastLogin;
  final bool isSuperuser;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateJoined;
  final Subscription subscription;
  final Market market;
  final int gender;
  final String phoneNumber;
  final DateTime dob;
  final dynamic tsaPrecheckNumber;
  final String zip;
  final String countryCode;
  final int role;
  final String passportNumber;
  final String passportExpiration;
  final String globalEntryNumber;
  final List<LocationObject> preferredAirports;
  final List<String> preferredAirlines;
  final int cabinPreference;
  final int durationPricePreference;
  final bool directFlightPreference;
  final int carrierPreference;

  TravelerInfo(
      {this.id,
      this.lastLogin,
      this.isSuperuser,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.dateJoined,
      this.subscription,
      this.market,
      this.gender,
      this.phoneNumber,
      this.dob,
      this.tsaPrecheckNumber,
      this.zip,
      this.countryCode,
      this.role,
      this.passportNumber,
      this.passportExpiration,
      this.globalEntryNumber,
      this.preferredAirports,
      this.preferredAirlines,
      this.cabinPreference,
      this.durationPricePreference,
      this.directFlightPreference,
      this.carrierPreference});

  factory TravelerInfo.fromRawJson(String str) =>
      TravelerInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static int getGenderValue(String gender) {
    if (gender.toUpperCase() == 'MALE') return 0;
    if (gender.toUpperCase() == 'FEMALE') return 1;
    return -1;
  }

  static String getGenderString(int gender) {
    if (gender == 0) return 'Male';
    if (gender == 1) return 'Female';
    return "";
  }

  static String getDobString(DateTime dob) =>
      dob != null ? DateFormat('MM/dd/yyyy').format(dob) : '';

  String get ageCategory {
    try {
      var age = Helper.age(this.dob);
      if (age <= 7) {
        return "infant";
      } else if (age <= 18) {
        return "child";
      }

      return "adult";
    } catch (e) {
      return null;
    }
  }

  factory TravelerInfo.fromJson(Map<String, dynamic> json) => TravelerInfo(
      id: json["id"] == null ? null : json["id"],
      lastLogin: json["last_login"] == null
          ? null
          : DateTime.parse(json["last_login"]),
      isSuperuser: json["is_superuser"] == null ? null : json["is_superuser"],
      username: json["username"] == null ? null : json["username"],
      firstName: json["first_name"] == null ? null : json["first_name"],
      lastName: json["last_name"] == null ? null : json["last_name"],
      email: json["email"] == null ? null : json["email"],
      dateJoined: json["date_joined"] == null
          ? null
          : DateTime.parse(json["date_joined"]),
      subscription: json["subscription"] == null
          ? null
          : Subscription.fromJson(json["subscription"]),
      market: json["market"] == null ? null : Market.fromJson(json["market"]),
      gender: json["gender"] == null ? null : json["gender"],
      phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
      dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
      tsaPrecheckNumber: json["tsa_precheck_number"],
      zip: json["zip"] == null ? null : json["zip"],
      countryCode: json["country_code"] == null ? null : json["country_code"],
      role: json["role"] == null ? null : json["role"],
      passportNumber:
          json["passport_number"] == null ? null : json["passport_number"],
      passportExpiration: json["passport_expiration"] == null
          ? null
          : json["passport_expiration"],
      globalEntryNumber: json["global_entry_number"] == null
          ? null
          : json["global_entry_number"],
      preferredAirports: json['preferred_airports'] == null
          ? null
          : (json['preferred_airports'] as List)
              .map((e) => LocationObject.fromJson(e))
              .toList(),
      preferredAirlines: json['preferred_airlines'] == null
          ? []
          : (json['preferred_airlines'] as List)
              .map((e) => e.toString())
              .toList(),
      cabinPreference: json['cabin_class_preference'] == null
          ? null
          : json['cabin_class_preference'],
      durationPricePreference: json['duration_price_preference'] == null
          ? null
          : json['duration_price_preference'],
      directFlightPreference: json['direct_flight_preference'] == null
          ? null
          : json['direct_flight_preference'],
      carrierPreference: json['carrier_preference'] == null
          ? null
          : json['carrier_preference']);

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "last_login": lastLogin == null ? null : lastLogin.toIso8601String(),
        "is_superuser": isSuperuser == null ? null : isSuperuser,
        "username": username == null ? null : username,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "email": email == null ? null : email,
        "date_joined": dateJoined == null ? null : dateJoined.toIso8601String(),
        "subscription": subscription == null ? null : subscription.toJson(),
        "market": market == null ? null : market.toJson(),
        "gender": gender == null ? null : gender,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "dob": dob == null
            ? null
            : "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "tsa_precheck_number": tsaPrecheckNumber,
        "zip": zip == null ? null : zip,
        "country_code": countryCode == null ? null : countryCode,
        "role": role == null ? null : role,
        "passport_number": passportNumber == null ? null : passportNumber,
        "global_entry_number":
            globalEntryNumber == null ? null : globalEntryNumber,
      };
}

class Market {
  final String code;
  final String name;
  final String type;
  final Country country;
  final Subdivision subdivision;

  Market({
    this.code,
    this.name,
    this.type,
    this.country,
    this.subdivision,
  });

  factory Market.fromRawJson(String str) => Market.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Market.fromJson(Map<String, dynamic> json) => Market(
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

class Subscription {
  final String plan;
  final String period;
  final dynamic coupon;

  Subscription({
    this.plan,
    this.period,
    this.coupon,
  });

  factory Subscription.fromRawJson(String str) =>
      Subscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        plan: json["plan"] == null ? null : json["plan"],
        period: json["period"] == null ? null : json["period"],
        coupon: json["coupon"],
      );

  Map<String, dynamic> toJson() => {
        "plan": plan == null ? null : plan,
        "period": period == null ? null : period,
        "coupon": coupon,
      };
}
