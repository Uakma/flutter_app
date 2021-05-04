import 'package:flutter/material.dart';
import 'package:motel/helper/helper.dart';
import 'package:motel/models/check_flight_response.dart';

class TravelerInformation {
  String firstName;
  String lastName;
  String dob;
  String gender;
  String passportId;
  String passportExpiration;
  BagItem handBag;
  BagItem holdBag;
  bool autoChecking;
  String title;

  TravelerInformation({
    @required this.firstName,
    @required this.lastName,
    @required this.dob,
    @required this.gender,
    @required this.passportId,
    @required this.passportExpiration,
    this.handBag,
    this.holdBag,
    this.autoChecking,
    @required this.title
  });

  String get ageCategory {
    try {
      var age = Helper.age(DateTime.parse([
        this.dob.split('/').last,
        this.dob.split('/').first,
        this.dob.split('/')[1]
      ].join('-')));
      if (age <= 7) {
        return "infant";
      } else if (age <= 18) {
        return "child";
      }

      return "adult";
    } catch (e) {
      return 'adult';
    }
  }

  @override
  String toString() {
    return 'Traveler Information: { $firstName, $lastName, $dob, $gender, $passportId, $passportExpiration, $handBag, $holdBag }';
  }
}
