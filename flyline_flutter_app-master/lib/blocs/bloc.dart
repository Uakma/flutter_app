import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:motel/utils/constants.dart';
import 'package:motel/models/auto_pilot_alert.dart';
import 'package:motel/models/book_request.dart';
import 'package:motel/models/currency_rates.dart';
import 'package:motel/models/current_trip_data.dart';
import 'package:motel/models/recent_flight_search.dart';
import 'package:motel/models/traveler_info.dart';
import 'package:motel/models/price_data.dart';
import 'package:motel/screens/home/local_widgets/loading_overlay.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account.dart';
import '../models/booked_flight.dart';
import '../models/check_flight_response.dart';
import '../models/flight_information.dart';
import '../models/flyline_deal.dart';
import '../models/locations.dart';
import '../network/repositories.dart';

enum SearchType { FARE, EXCLUSIVE, META }

class FlyLineBloc {
  final FlyLineRepository _repository = FlyLineRepository();
  CurrencyRates _currencyRates;

  bool isStoreAvailable;
  List<ProductDetails> subscriptions;
  // var purchaseUpdated = InAppPurchaseConnection.instance.purchaseUpdatedStream
  //   ..listen((purchaseDetailsList) {
  //     InAppPurchaseConnection.instance
  //         .completePurchase(purchaseDetailsList.last);
  //   });

  BehaviorSubject<String> _token = BehaviorSubject<String>();

  LoadingOverlay loadingOverlay = LoadingOverlay();

  set token(String value) {
    _token.add(value);
  }

  bool get isLoggedIn => _token.value != null;

  int get numberOfPassengers => _adultSubject.value + _childrenSubject.value;

  BehaviorSubject<String> get tokenData => _token;
  final BehaviorSubject<List<LocationObject>> _subjectlocationItems =
      BehaviorSubject<List<LocationObject>>();

  final BehaviorSubject<CurrentTripData> _currentTripDataSubject =
      BehaviorSubject<CurrentTripData>();

  ValueStream<CurrentTripData> get outCurrentTripData =>
      _currentTripDataSubject.stream;

  Function(CurrentTripData) get setCurrentTripData =>
      _currentTripDataSubject.sink.add;

  CurrentTripData get getCurrentTripData => _currentTripDataSubject.value;

  final BehaviorSubject<int> _adultSubject = BehaviorSubject<int>();

  ValueStream get outAdults => _adultSubject.stream;

  Function(int) get setAdults => _adultSubject.sink.add;

  final BehaviorSubject<Account> _accountSubject = BehaviorSubject<Account>();

  final BehaviorSubject<bool> bookingProgressSubject = BehaviorSubject<bool>();

  Function(bool) get setProgress => bookingProgressSubject.sink.add;

  ValueStream get outAccount => _accountSubject.stream;

  Function(Account) get setAccount => _accountSubject.sink.add;

  Account get account => _accountSubject.value;

  final BehaviorSubject<TravelerInfo> _travelerInfoSubject =
      BehaviorSubject<TravelerInfo>();

  ValueStream get outTravelerInfo => _travelerInfoSubject.stream;

  Function(TravelerInfo) get setTravelerInfo => _travelerInfoSubject.sink.add;

  TravelerInfo get travelerInfoValue => _travelerInfoSubject.value;

  final BehaviorSubject<int> _childrenSubject = BehaviorSubject<int>();

  ValueStream get outChildren => _childrenSubject.stream;

  Function(int) get setChildren => _childrenSubject.sink.add;

  final BehaviorSubject<int> _maxPriceSubject = BehaviorSubject<int>();

  ValueStream get outMaxPrice => _maxPriceSubject.stream;

  Function(int) get setMaxPrice => _maxPriceSubject.sink.add;

  final BehaviorSubject<double> _probabilitySubject = BehaviorSubject<double>();

  ValueStream get outProbability => _probabilitySubject.stream;

  Function(double) get setProbability => _probabilitySubject.sink.add;

  ValueStream get outPriceDataResponse => __subjectPriceDataResponse.stream;

  Function(PriceDataResponse) get setPriceDataResponse => __subjectPriceDataResponse.sink.add;

  final BehaviorSubject<List<FlightInformationObject>>
      _subjectExclusiveFlightItems =
      BehaviorSubject<List<FlightInformationObject>>();

  final BehaviorSubject<List<FlightInformationObject>> _subjectMetaFlightItems =
      BehaviorSubject<List<FlightInformationObject>>();

  final BehaviorSubject<List<FlightInformationObject>> _subjectFareFlightItems =
      BehaviorSubject<List<FlightInformationObject>>();

  final BehaviorSubject<List<BookedFlight>> _subjectUpcomingFlights =
      BehaviorSubject<List<BookedFlight>>();
  final BehaviorSubject<List<BookedFlight>> _subjectPastFlights =
      BehaviorSubject<List<BookedFlight>>();

  final BehaviorSubject<List<RecentFlightSearch>> _subjectRecentFlightSearch =
      BehaviorSubject<List<RecentFlightSearch>>();

  final BehaviorSubject<List<AutoPilotAlert>> __subjectAutopilotAlert =
      BehaviorSubject<List<AutoPilotAlert>>();

  final BehaviorSubject<List<FlylineDeal>> _subjectRandomDeals =
      BehaviorSubject<List<FlylineDeal>>();

  final BehaviorSubject<CheckFlightResponse> _subjectCheckFlight =
      BehaviorSubject<CheckFlightResponse>();

  final BehaviorSubject<Map> _subjectBookFlight = BehaviorSubject<Map>();

  Function(Map) get setBookFlight => _subjectBookFlight.sink.add;

  final BehaviorSubject<CurrencyRates> _subjectCurrencyRates =
      BehaviorSubject<CurrencyRates>();

  final BehaviorSubject<Currency> _subjectCurrency =
      BehaviorSubject<Currency>();

  final BehaviorSubject<PriceDataResponse> __subjectPriceDataResponse = BehaviorSubject<PriceDataResponse>();

  tryLogin(String email, String password) async {
    String response = await _repository.login(email, password);
    _token.sink.add(response);
  }

  initStore() async {
    // if (kIsWeb) {
    //   isStoreAvailable = false;
    // } else {
      isStoreAvailable = await InAppPurchaseConnection.instance.isAvailable();
    // }
    if (isStoreAvailable) {
      const Set<String> _kIds = {
        'io_flyline_premium_monthly',
        'io_flyline_premium'
      };
      final ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      print(response.notFoundIDs);
      subscriptions = response.productDetails;
    }
  }

  purchase(int sub) async {
    if (isStoreAvailable) {
      await InAppPurchaseConnection.instance.buyNonConsumable(
          purchaseParam: PurchaseParam(
              productDetails: flyLinebloc.subscriptions[sub - 1]));
    }
  }

  trySignup({String email, String password, String activationCode}) async {
    String response = await _repository.signup(email, password, activationCode);
    if (response != "") {
      String responseLogin = await _repository.login(email, password);
      _token.sink.add(responseLogin);
    }
    return response;
  }

  Future<bool> tryFcmToken(String fcmToken) async {
   return await _repository.fcmToken(fcmToken);
  }

  Future curencyRatesQuery() async {
    _currencyRates = await _repository.currencyRatesQuery();
  }

  Future<Currency> changeCurrency(Currency curr) async {
    _subjectCurrency.sink.add(curr);

    return curr;
  }

  // Price_in_target = price_in_usd * rates[target] / rates[usd]

  Future convertCurrency() async {
    CurrencyRates currencyRates = await _repository.currencyRatesQuery();

    // Stream<List<FlightInformationObject>> exclusive;

    // exclusive = _subjectExclusiveFlightItems.stream;

    _subjectCurrency.listen((curr) async {
      // exclusive =
      _subjectExclusiveFlightItems
          .map<List<FlightInformationObject>>((flightsList) {
        List<FlightInformationObject> list = flightsList.map((flightInfo) {
          double convertedPrice =
              _calculateConversion(flightInfo, currencyRates, curr);
          return FlightInformationObject(
              flightInfo.flyFrom,
              flightInfo.flyTo,
              flightInfo.cityFrom,
              flightInfo.cityTo,
              flightInfo.nightsInDest,
              flightInfo.localArrival,
              flightInfo.localDeparture,
              flightInfo.routes,
              flightInfo.durationDeparture,
              flightInfo.durationReturn,
              flightInfo.durationDepartureInSeconds,
              flightInfo.durationReturnInSeconds,
              flightInfo.bookingToken,
              flightInfo.airlines,
              convertedPrice,
              flightInfo.distance,
              flightInfo.deepLink,
              flightInfo.kind,
              flightInfo.departures,
              flightInfo.returns,
              flightInfo.raw,
              flightInfo.source);
        }).toList();

        return list;
      });

      // exclusive.listen((event) {
      //   event.forEach((element) {
      //     print("price" + element.price.toString());
      //   });
      // });
    });
  }

  double _calculateConversion(FlightInformationObject flightInfo,
      CurrencyRates currencyRates, Currency curr) {
    double priceInUsd = flightInfo.price;

    double ratesInTarget = currencyRates.rates[curr.abbr].toDouble();
    double ratesInUsd = currencyRates.rates["USD"];

    double priceInTarget = priceInUsd * (ratesInTarget / ratesInUsd);

    return priceInTarget;
  }

  Future<List<LocationObject>> locationQuery(String term) async {
    List<LocationObject> response = await _repository.locationQuery(term);
    _subjectlocationItems.sink.add(response);
    return response;
  }

  Future searchFlight(
    flyFrom,
    flyTo,
    DateTime dateFrom,
    DateTime dateTo,
    type,
    DateTime returnFrom,
    DateTime returnTo,
    adults,
    infants,
    children,
    selectedCabins,
    curr,
    offset,
    limit,
  ) async {
    _repository
        .searchFlights(
          flyFrom,
          flyTo,
          DateFormat("dd/MM/yyyy").format(dateFrom),
          DateFormat("dd/MM/yyyy").format(dateTo),
          type,
          returnFrom != null
              ? DateFormat("dd/MM/yyyy").format(returnFrom)
              : null,
          returnTo != null ? DateFormat("dd/MM/yyyy").format(returnTo) : null,
          adults,
          infants,
          children,
          selectedCabins,
          curr,
          offset,
          limit,
        )
        .then((value) => _subjectExclusiveFlightItems.sink.add(value))
        .catchError((e) => print(e));

    _repository
        .searchMetaFlights(
          flyFrom,
          flyTo,
          DateFormat("yyyy-MM-dd").format(dateFrom),
          returnFrom != null
              ? DateFormat("yyyy-MM-dd").format(returnFrom)
              : null,
        )
        .then((value) => _subjectMetaFlightItems.sink.add(value))
        .catchError((e) => print(e));

    await _repository
        .searchFareFlights(
          flyFrom,
          flyTo,
          DateFormat("yyyy-MM-dd").format(dateFrom),
          returnFrom != null
              ? DateFormat("yyyy-MM-dd").format(returnFrom)
              : null,
        )
        .then((value) => _subjectFareFlightItems.sink.add(value))
        .catchError((e) => print(e));
  }

  Future<CheckFlightResponse> checkFlights(
      bookingId, int infants, int children, int adults) async {
    CheckFlightResponse response = await _repository
        .checkFlights(bookingId, infants, children, adults)
        .catchError((e) => throw e);

    _subjectCheckFlight.sink.add(response);

    _subjectRecentFlightSearch.add(null);
    flightSearchHistory();
    return response;
  }

  Future<Map> book(BookRequest bookRequest) async {
    bookingProgressSubject.sink.add(true);
    Map response = await _repository.book(bookRequest);
    bookingProgressSubject.sink.add(false);
    _subjectBookFlight.sink.add(response);
    return response;
  }

  Future<List<FlylineDeal>> randomDeals() async {
    List<FlylineDeal> response = await _repository.randomDeals(50);
    _subjectRandomDeals.sink.add(response);

    return response;
  }

  Future<List<BookedFlight>> pastFlightSummary() async {
    List<BookedFlight> response =
        await _repository.pastOrUpcomingFlightSummary(false);
    _subjectPastFlights.add(response);
    return response;
  }

  Future<List<BookedFlight>> upcomingFlightSummary() async {
    List<BookedFlight> response =
        await _repository.pastOrUpcomingFlightSummary(true);
    _subjectUpcomingFlights.add(response);
    return response;
  }

  Future<List<RecentFlightSearch>> flightSearchHistory() async {
    List<RecentFlightSearch> response;
    try {
      response = await _repository.flightSearchHistory();
      _subjectRecentFlightSearch.add(response);
    } catch (e) {
      print(e);
      _subjectRecentFlightSearch.add([]);
    }
    return response;
  }

  Future<Account> accountInfo() async {
    Account account = await _repository.accountInfo();
    _accountSubject.sink.add(account);
    return account;
  }

  Future<String> getAuthToken() {
    return _repository.getAuthToken();
  }

  Future<TravelerInfo> travelerInfo() async {
    TravelerInfo traveler =
        await _repository.travelerInfo(_accountSubject.value.id);
    _travelerInfoSubject.sink.add(traveler);
    return traveler;
  }

  Future<void> updateAccountInfo({
    String firstName,
    String lastName,
    String dob,
    String gender,
    String email,
    String phone,
    String passport,
    String passportExpiry,
    String globalEntryNumber,
    dynamic locationObject,
    dynamic preCheckNumber,
  }) async {
    return await _repository.updateAccountInfo(
      firstName: firstName,
      lastName: lastName,
      dob: dob,
      gender: gender,
      email: email,
      phone: phone,
      passport: passport,
      passportExpiry: passportExpiry,
      globalEntryNumber: globalEntryNumber,
      preCheckNumber: preCheckNumber,
      locationObject: locationObject,
    );
  }

  Future<void> updatePreferredAirPorts(List<LocationObject> airports) {
    return _repository.updatePreferredAirports(airports);
  }

  Future<void> updateCabinType(String cabinType) {
    return _repository.updateCabinType(Cabin.getValue(cabinType));
  }

  Future<void> updateAirlines(List<String> airlines) {
    return _repository.updateAirlines(airlines);
  }

  Future<void> updateDurationPricePreference(String value) {
    return _repository
        .updateDurationPricePreference(DurationPricePreference.getValue(value));
  }

  Future<void> updateCarrierPreference(String value) {
    return _repository
        .updateCarrierPreference(CarrierPreference.getValue(value));
  }

  Future<void> updateDirectFlightPreference(bool allow) {
    return _repository.updateDirectFlightPreference(allow);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    flyLinebloc.token = null;
    _accountSubject.add(Account());
    return;
  }

  dynamic flightsExclusiveItems(
      Currency curr, List<String> sortOptions, bool isRoundTrip) {
    return _subjectExclusiveFlightItems
        .map<List<FlightInformationObject>>((flightsList) {
      List<FlightInformationObject> list = flightsList.map((flightInfo) {
        double convertedPrice =
            _calculateConversion(flightInfo, _currencyRates, curr);
        return FlightInformationObject(
            flightInfo.flyFrom,
            flightInfo.flyTo,
            flightInfo.cityFrom,
            flightInfo.cityTo,
            flightInfo.nightsInDest,
            flightInfo.localArrival,
            flightInfo.localDeparture,
            flightInfo.routes,
            flightInfo.durationDeparture,
            flightInfo.durationReturn,
            flightInfo.durationDepartureInSeconds,
            flightInfo.durationReturnInSeconds,
            flightInfo.bookingToken,
            flightInfo.airlines,
            convertedPrice,
            flightInfo.distance,
            flightInfo.deepLink,
            flightInfo.kind,
            flightInfo.departures,
            flightInfo.returns,
            flightInfo.raw,
            flightInfo.source);
      }).toList();

      return list;
    }).map((flights) => _filterFlights(flights, sortOptions, isRoundTrip));
  }

  dynamic flightsMetaItems(
      Currency curr, List<String> sortOptions, bool isRoundTrip) {
    return _subjectMetaFlightItems
        .map<List<FlightInformationObject>>((flightsList) {
      List<FlightInformationObject> list = flightsList.map((flightInfo) {
        double convertedPrice =
            _calculateConversion(flightInfo, _currencyRates, curr);
        return FlightInformationObject(
            flightInfo.flyFrom,
            flightInfo.flyTo,
            flightInfo.cityFrom,
            flightInfo.cityTo,
            flightInfo.nightsInDest,
            flightInfo.localArrival,
            flightInfo.localDeparture,
            flightInfo.routes,
            flightInfo.durationDeparture,
            flightInfo.durationReturn,
            flightInfo.durationDepartureInSeconds,
            flightInfo.durationReturnInSeconds,
            flightInfo.bookingToken,
            flightInfo.airlines,
            convertedPrice,
            flightInfo.distance,
            flightInfo.deepLink,
            flightInfo.kind,
            flightInfo.departures,
            flightInfo.returns,
            flightInfo.raw,
            flightInfo.source);
      }).toList();

      return list;
    }).map((flights) => _filterFlights(flights, sortOptions, isRoundTrip));
  }

  List<FlightInformationObject> _filterFlights(
      List<FlightInformationObject> flights,
      List<String> sortOptions,
      bool isRoundTrip) {
    List<FlightInformationObject> allFlights = flights;

    if (sortOptions.contains(SortOptions.singlecarier)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.airlines.length == 1;
      }).toList();
    }

    if (isRoundTrip) {
      print("round trip");
      if (sortOptions.contains(SortOptions.directFlights)) {
        allFlights = allFlights.where((flightObject) {
          return flightObject.routes.length == 2;
        }).toList();
      }
    } else {
      print("one way");
      if (sortOptions.contains(SortOptions.directFlights)) {
        allFlights = allFlights.where((flightObject) {
          return flightObject.routes.length == 1;
        }).toList();
      }
    }

    if (sortOptions.contains(SortOptions.landingMorning)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes[0].localArrival.hour >= 6 &&
            flightObject.routes[0].localArrival.hour <= 12;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.landingAfterNoon)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes[0].localArrival.hour > 12 &&
            flightObject.routes[0].localArrival.hour <= 18;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.landingEvening)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes[0].localArrival.hour > 18 ||
            flightObject.routes[0].localArrival.hour < 6;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.takeOffMorning)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes[0].localDeparture.hour >= 6 &&
            flightObject.routes[0].localDeparture.hour <= 12;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.takeOffAfterNoon)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes[0].localDeparture.hour > 12 &&
            flightObject.routes[0].localDeparture.hour <= 18;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.takeOffEvening)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes[0].localDeparture.hour > 18 ||
            flightObject.routes[0].localDeparture.hour < 6;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.dest_landingMorning)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes.last.localArrival.hour >= 6 &&
            flightObject.routes.last.localArrival.hour <= 12;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.dest_landingAfterNoon)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes.last.localArrival.hour > 12 &&
            flightObject.routes.last.localArrival.hour <= 18;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.dest_landingEvening)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes.last.localArrival.hour > 18 ||
            flightObject.routes.last.localArrival.hour < 6;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.dest_takeOffMorning)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes.last.localDeparture.hour >= 6 &&
            flightObject.routes.last.localDeparture.hour <= 12;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.dest_takeOffAfterNoon)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes.last.localDeparture.hour > 12 &&
            flightObject.routes.last.localDeparture.hour <= 18;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.dest_takeOffEvening)) {
      allFlights = allFlights.where((flightObject) {
        return flightObject.routes.last.localDeparture.hour > 18 ||
            flightObject.routes.last.localDeparture.hour < 6;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.lowCostCarriers)) {
      allFlights = allFlights.where((flightObject) {
        bool belongs;
        for (var airline in flightObject.airlines) {
          if (lowCostAirlines.contains(airline) == false) {
            belongs = false;
          } else {
            belongs = true;
          }
        }
        return belongs;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.legacyFlagCarriers)) {
      allFlights = allFlights.where((flightObject) {
        bool belongs;
        for (var airline in flightObject.airlines) {
          if (legacyAirlines.contains(airline) == false) {
            belongs = false;
          } else {
            belongs = true;
          }
        }
        return belongs;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.ultraLowCostCarriers)) {
      allFlights = allFlights.where((flightObject) {
        bool belongs;
        for (var airline in flightObject.airlines) {
          if (ultraLowCostAirlines.contains(airline) == false) {
            belongs = false;
          } else {
            belongs = true;
          }
        }
        return belongs;
      }).toList();
    }

    if (sortOptions.contains(SortOptions.soonest)) {
      allFlights.sort((a, b) => a.localDeparture.compareTo(b.localDeparture));
    }

    if (sortOptions.contains(SortOptions.cheapest)) {
      allFlights.sort((a, b) => a.price.compareTo(b.price));
    }

    if (sortOptions.contains(SortOptions.quickest)) {
      allFlights.sort((a, b) =>
          a.durationDepartureInSeconds.compareTo(b.durationDepartureInSeconds));
    }

    print(allFlights.length);
    return allFlights;
  }

  dynamic flightsFareItems(
      Currency curr, List<String> sortOptions, bool isRoundTrip) {
    return _subjectFareFlightItems
        .map<List<FlightInformationObject>>((flightsList) {
      List<FlightInformationObject> list = flightsList.map((flightInfo) {
        double convertedPrice =
            _calculateConversion(flightInfo, _currencyRates, curr);
        return FlightInformationObject(
            flightInfo.flyFrom,
            flightInfo.flyTo,
            flightInfo.cityFrom,
            flightInfo.cityTo,
            flightInfo.nightsInDest,
            flightInfo.localArrival,
            flightInfo.localDeparture,
            flightInfo.routes,
            flightInfo.durationDeparture,
            flightInfo.durationReturn,
            flightInfo.durationDepartureInSeconds,
            flightInfo.durationReturnInSeconds,
            flightInfo.bookingToken,
            flightInfo.airlines,
            convertedPrice,
            flightInfo.distance,
            flightInfo.deepLink,
            flightInfo.kind,
            flightInfo.departures,
            flightInfo.returns,
            flightInfo.raw,
            flightInfo.source);
      }).toList();

      return list;
    }).map((flights) => _filterFlights(flights, sortOptions, isRoundTrip));
  }

  BehaviorSubject<String> get loginResponse => _token;

  BehaviorSubject<List<LocationObject>> get locationItems =>
      _subjectlocationItems;

  BehaviorSubject<List<FlylineDeal>> get randomDealItems => _subjectRandomDeals;

  BehaviorSubject<Account> get accountInfoItem => _accountSubject;

  BehaviorSubject<CheckFlightResponse> get checkFlightData =>
      _subjectCheckFlight;

  BehaviorSubject<List<RecentFlightSearch>> get recentFlightSearches =>
      _subjectRecentFlightSearch;

  BehaviorSubject<List<AutoPilotAlert>> get autopilotAlert =>
      __subjectAutopilotAlert;

  BehaviorSubject<List<BookedFlight>> get pastFlights => _subjectPastFlights;

  BehaviorSubject<List<BookedFlight>> get upcomingFlights =>
      _subjectUpcomingFlights;

  BehaviorSubject<Map> get bookFlight => _subjectBookFlight;

  final BehaviorSubject<LocationObject> _departureLocationSubject =
      BehaviorSubject<LocationObject>();

  LocationObject get departureLocation =>
      _departureLocationSubject.stream.value;

  Function(LocationObject) get setDepartureLocation =>
      _departureLocationSubject.sink.add;

  final BehaviorSubject<LocationObject> _arrivalLocationSubject =
      BehaviorSubject<LocationObject>();

  LocationObject get arrivalLocation => _arrivalLocationSubject.stream.value;

  Function(LocationObject) get setArrivalLocation =>
      _arrivalLocationSubject.sink.add;

  final BehaviorSubject<DateTime> _departureDateSubject =
      BehaviorSubject<DateTime>();

  DateTime get departureDate => _departureDateSubject.stream.value;

  Function(DateTime) get setDepartureDate => _departureDateSubject.sink.add;

  final BehaviorSubject<DateTime> _returnDateSubject =
      BehaviorSubject<DateTime>();

  DateTime get returnDate => _returnDateSubject.stream.value;

  Function(DateTime) get setReturnDate => _returnDateSubject.sink.add;

  final BehaviorSubject<List<String>> _preferredAirlinesSubject =
      BehaviorSubject<List<String>>();

  List<String> get preferredAirlines => _preferredAirlinesSubject.stream.value;

  Function(List<String>) get setPreferredAirlines =>
      _preferredAirlinesSubject.sink.add;

  final BehaviorSubject<List<String>> _flightPreferencesSubject =
      BehaviorSubject<List<String>>();

  List<String> get flightPreferences => _flightPreferencesSubject.stream.value;

  Function(List<String>) get setFlightPreferences =>
      _flightPreferencesSubject.sink.add;

  final BehaviorSubject<List<String>> _departureStartTimeSubject =
      BehaviorSubject<List<String>>();

  List<String> get departureStartTime =>
      _departureStartTimeSubject.stream.value;

  Function(List<String>) get setDepartureStartTime =>
      _departureStartTimeSubject.sink.add;

  final BehaviorSubject<List<String>> _departureEndTimeSubject =
      BehaviorSubject<List<String>>();

  List<String> get departureEndTime => _departureEndTimeSubject.stream.value;

  Function(List<String>) get setDepartureEndTime =>
      _departureEndTimeSubject.sink.add;

  final BehaviorSubject<List<String>> _returnStartTimeSubject =
      BehaviorSubject<List<String>>();

  List<String> get returnStartTime => _returnStartTimeSubject.stream.value;

  Function(List<String>) get setReturnStartTime =>
      _returnStartTimeSubject.sink.add;

  final BehaviorSubject<List<String>> _returnEndTimeSubject =
      BehaviorSubject<List<String>>();

  List<String> get returnEndTime => _returnEndTimeSubject.stream.value;

  Function(List<String>) get setReturnEndTime => _returnEndTimeSubject.sink.add;

  Future<Map> createAutopilot(
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
  ) async {
    return _repository.createAutopilot(
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
    List<AutoPilotAlert> response;
    try {
      response = await _repository.autopilotAlerts();
      __subjectAutopilotAlert.add(response);
    } catch (e) {
      print(e);
      __subjectAutopilotAlert.add([]);
    }
    return response;
  }

  Future<Map> deleteAutopilotAlert(int id) async {
    return _repository.deleteAutopilotAlert(id);
  }

  Future<PriceDataResponse> getPriceData(String flyFrom, String flyTo, String flyType, String adults, String children) async {
    PriceDataResponse priceDateResponse = await _repository.getPriceData(flyFrom, flyTo, flyType, adults, children);
    try{
      setPriceDataResponse(priceDateResponse);

      List<PriceData> priceDataList = priceDateResponse.priceDataResults;
      priceDataList.sort((a, b) =>
          a.price.compareTo(b.price));

      int medianPrice = 0;
      int centralIndex = priceDataList.length ~/ 2 + 1;
      if ( priceDataList.length % 2 == 1 ){
        medianPrice = priceDataList[centralIndex].price.toInt();
      }else{
        medianPrice = (priceDataList[centralIndex-1].price + priceDataList[centralIndex].price) ~/ 2;
      }

      flyLinebloc.setMaxPrice(medianPrice);
      print("fetched..." + medianPrice.toString() );
    }catch(e){
    }
    return priceDateResponse;
  }



  dispose() {
    _token.close();
    _subjectCurrencyRates.close();
    _subjectCurrency.close();
    _subjectlocationItems.close();
    _subjectExclusiveFlightItems.close();
    _subjectRandomDeals.close();
    _accountSubject.close();
    _subjectCheckFlight.close();
    _subjectRecentFlightSearch.close();
    __subjectAutopilotAlert.close();
    _subjectPastFlights.close();
    _subjectUpcomingFlights.close();
    _subjectBookFlight.close();
    _subjectFareFlightItems.close();
    _subjectMetaFlightItems.close();
    _adultSubject.close();
    _childrenSubject.close();
    _travelerInfoSubject.close();
    _currentTripDataSubject.close();
    bookingProgressSubject.close();

    _departureLocationSubject.close();
    _arrivalLocationSubject.close();
    _departureDateSubject.close();
    _returnDateSubject.close();
    _preferredAirlinesSubject.close();
    _flightPreferencesSubject.close();
    _departureStartTimeSubject.close();
    _departureEndTimeSubject.close();
    _returnStartTimeSubject.close();
    _returnEndTimeSubject.close();

    _probabilitySubject.close();
    _maxPriceSubject.close();

  }
}

final flyLinebloc = FlyLineBloc();

class SearchFlightObject {

  SearchFlightObject(
    String flyFrom,
    String flyTo,
    DateTime dateFrom,
    DateTime dateTo,
    String type,
    DateTime returnFrom,
    DateTime returnTo,
    int adults,
    int infants,
    int children,
    String selectedCabins,
    String curr,
    String offset,
    String limit,
  ) {
    this.flyFrom = flyFrom;
    this.flyTo = flyTo;
    this.dateFrom = dateFrom;
    this.dateTo = dateTo;
    this.type = type;
    this.returnFrom = returnFrom;
    this.returnTo = returnTo;
    this.adults = adults;
    this.infants = infants;
    this.children = children;
    this.selectedCabins = selectedCabins;
    this.curr = curr;
    this.offset = offset;
    this.limit = limit;
  }

  String flyFrom;
  String flyTo;
  DateTime dateFrom;
  DateTime dateTo;
  String type;
  DateTime returnFrom;
  DateTime returnTo;
  int adults;
  int infants;
  int children;
  String selectedCabins;
  String curr;
  String offset;
  String limit;
}