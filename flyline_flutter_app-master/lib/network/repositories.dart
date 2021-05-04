import 'dart:async';

import 'package:motel/models/auto_pilot_alert.dart';
import 'package:motel/models/book_request.dart';
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/currency_rates.dart';
import 'package:motel/models/recent_flight_search.dart';
import 'package:motel/models/traveler_info.dart';
import 'package:motel/models/price_data.dart';

import '../models/account.dart';
import '../models/booked_flight.dart';
import '../models/flight_information.dart';
import '../models/flyline_deal.dart';
import '../models/locations.dart';
import 'providers.dart';

class FlyLineRepository {
  FlyLineProvider _flyLineProvider = FlyLineProvider();

  Future<bool> fcmToken(String fcmTokenTxt) {
    return _flyLineProvider.fcmNotificationTokenApi(fcmTokenTxt);
  }

  Future<String> login(email, password) {
    return _flyLineProvider.login(email, password);
  }

  Future<String> signup(email, password, activationCode) {
    return _flyLineProvider.signup(email, password, activationCode);
  }

  Future<List<LocationObject>> locationQuery(term) {
    return _flyLineProvider.locationQuery(term);
  }

  Future<CurrencyRates> currencyRatesQuery() {
    return _flyLineProvider.currencyRatesQuery();
  }

  Future<List<FlightInformationObject>> searchFlights(
    flyFrom,
    flyTo,
    dateFrom,
    dateTo,
    type,
    returnFrom,
    returnTo,
    adults,
    infants,
    children,
    selectedCabins,
    curr,
    offset,
    limit,
  ) {
    return _flyLineProvider.searchFlight(
      flyFrom,
      flyTo,
      dateFrom,
      dateTo,
      type,
      returnFrom,
      returnTo,
      adults,
      infants,
      children,
      selectedCabins,
      curr,
      offset,
      limit,
    );
  }

  Future<List<FlightInformationObject>> searchMetaFlights(
    String flyFrom,
    String flyTo,
    String startDate,
    String returnDate,
  ) {
    return _flyLineProvider
        .scrapperSearch(flyFrom, flyTo, startDate, returnDate, [
      // "skyscanner",
      // "kayak",
      "tripadvisor",
    ]);
  }

  Future<List<FlightInformationObject>> searchFareFlights(
    String flyFrom,
    String flyTo,
    String startDate,
    String returnDate,
  ) {
    return _flyLineProvider
        .scrapperSearch(flyFrom, flyTo, startDate, returnDate, [
      // "ndc",
      "duffel",
    ]);
  }

  Future<CheckFlightResponse> checkFlights(
      bookingId, infants, children, adults) {
    return _flyLineProvider.checkFlights(bookingId, infants, children, adults);
  }

  Future<Map> book(BookRequest bookRequest) {
    return _flyLineProvider.book(bookRequest);
  }

  Future<List<FlylineDeal>> randomDeals(int size) {
    return _flyLineProvider.randomDealsForGuest(size);
  }

  Future<List<BookedFlight>> pastOrUpcomingFlightSummary(
      bool isUpcoming) async {
    return await _flyLineProvider.pastOrUpcomingFlightSummary(isUpcoming);
  }

  Future<List<RecentFlightSearch>> flightSearchHistory() async {
    return await _flyLineProvider.flightSearchHistory();
  }

  Future<Account> accountInfo() {
    return _flyLineProvider.accountInfo();
  }

  Future<String> getAuthToken() {
    return _flyLineProvider.getAuthToken();
  }

  Future<TravelerInfo> travelerInfo(int accountId) {
    return _flyLineProvider.travelerInfo(accountId);
  }

  Future<void> updateAccountInfo(
      {String firstName,
      String lastName,
      String dob,
      String gender,
      String email,
      String phone,
      String passport,
      String passportExpiry,
      dynamic locationObject,
      String globalEntryNumber,
      dynamic preCheckNumber}) async {
    return await _flyLineProvider.updateAccountInfo(
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        gender: gender,
        email: email,
        phone: phone,
        passport: passport,
        passportExpiry: passportExpiry,
        globalEntryNumber: globalEntryNumber,
        locationObject: locationObject,
        preCheckNumber: preCheckNumber);
  }

  Future<void> updatePreferredAirports(List<LocationObject> airports) {
    return _flyLineProvider.updatePreferredAirports(airports);
  }

  Future<void> updateCabinType(int value) {
    return _flyLineProvider.updateCabin(value);
  }

  Future<void> updateAirlines(List<String> airlines) {
    return _flyLineProvider.updateAirlines(airlines);
  }

  Future<void> updateDirectFlightPreference(bool allow) {
    return _flyLineProvider.updateDirectFlightPreference(allow);
  }

  Future<void> updateDurationPricePreference(int value) {
    return _flyLineProvider.updateDurationPricePreference(value);
  }

  Future<void> updateCarrierPreference(int value) {
    return _flyLineProvider.updateCarrierPreference(value);
  }

  Future createAutopilot(
    LocationObject departureLocation,
    LocationObject arrivalLocation,
    DateTime departureDate,
    DateTime returnDate,
    int adults,
    int children,
    int maxPrice,
    List<String> airlines,
    List<String> departureStartTime,
    List<String> departureEndTime,
    List<String> returnStartTime,
    List<String> returnEndTime,
    bool preferShortest,
    bool preferSingleCarrier,
    List<String> flightPreferences,
  ) {
    return _flyLineProvider.createAutopilot(
      departureLocation,
      arrivalLocation,
      departureDate,
      returnDate,
      adults,
      children,
      maxPrice,
      airlines,
      departureStartTime,
      departureEndTime,
      returnStartTime,
      returnEndTime,
      preferShortest,
      preferSingleCarrier,
      flightPreferences,
    );
  }

  Future<List<AutoPilotAlert>> autopilotAlerts() async {
    return await _flyLineProvider.autopilotAlerts();
  }

  Future<Map> deleteAutopilotAlert(int id) async {
    return await _flyLineProvider.deleteAutopilotAlert(id);
  }

  Future<PriceDataResponse> getPriceData(String flyFrom, String flyTo, String flyType, String adults, String children) async{
    return await _flyLineProvider.getPriceData(flyFrom, flyTo, flyType, adults, children);
  }
}
