import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:motel/models/auto_pilot_alert.dart';
import 'package:motel/models/book_request.dart';
import 'package:motel/models/booked_flight.dart';
import 'package:motel/models/check_flight_response.dart';
import 'package:motel/models/currency_rates.dart';
import 'package:motel/models/recent_flight_search.dart';
import 'package:motel/models/traveler_info.dart';
import 'package:motel/models/price_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account.dart';
import '../models/flight_information.dart';
import '../models/flyline_deal.dart';
import '../models/locations.dart';
import 'package:http/http.dart' as http;

class FlyLineProvider {

  final baseUrl = "https://api.flyline.io";

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";

    if (token.isNotEmpty) {
      return token;
    } else {
      var email = prefs.getString('email') ?? "";
      var password = prefs.getString('password') ?? "";

      if (email.isNotEmpty && password.isNotEmpty) {
        return await login(email, password);
      } else
        return "logout";
    }
  }

//  app must send notification token to backend (by sending PATCH request to /api/users/me with {"notification_token": <value>} payload


  Future<bool> fcmNotificationTokenApi(String fcmToken) async {

    var token = await getAuthToken();

    if (token != null) {
      Dio dio = Dio();

      Response response;
      dio.options.headers["Authorization"] = "Token $token";
      var url = "$baseUrl/api/users/me/";
      print("5555");
      try {
        var data = {
          "notification_token": fcmToken
        };
        response = await dio.patch(url, data: data);
      } on DioError catch (e) {
        print("object6565");
      log(e.response.toString());
      }

      if (response?.statusCode == 200) {
        print("");
        return true;
      } else {
        return false;
      }


      /*Response response;

      String authorizationHeader;

      authorizationHeader = 'Token $token';

      var headers;

      headers = {
//        HttpHeaders.acceptHeader: acceptHeader,
//        HttpHeaders.contentTypeHeader: contentTypeHeader,
        HttpHeaders.authorizationHeader: authorizationHeader
      };

      BaseOptions options = new BaseOptions(
          baseUrl: baseUrl + '/api/users/me',
          connectTimeout: 20000,
          receiveTimeout: 3000,
          headers: headers);

      dio.options = options;

      await dio
          .post("", data: json.encode({"notification_token": fcmToken}))
          .then((response) {
        print("data $response");
      });*/

//      final payload = (kind) => {
////        "kind": kind,
//        "notification_token": fcm
//      };

//      final response = await http.get('https://api.flyline.io/api/users/me',
//          headers: {"Authorization": "Token 77e790ff02ca1170957acb2c98569235103cc745a23044fc54582ee5fc11eec9" ,
//            "Content-Type" : "application/x-www-form-urlencoded"});


//      var response1 = await http.get(baseUrl + "/api/users/me",
//          headers: {"Authorization": "Token $token", "Content-Type":"application/x-www-form-urlencoded"},
////          body: {"notification_token": fcmToken}
//          );

        print("object55");

      var response1 = await http.patch(baseUrl + "/api/users/me/",
          headers: {HttpHeaders.authorizationHeader: "Token $token","Content-Type":"application/json"},
          body: {"notification_token": fcmToken});

//      print("data 41  : $response1");
      print("object5511");
      print(response1);

      if (response1 != null && response1.statusCode == 200) {
        print("Neel Sachala");
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }


  }

 /* Future<bool> fcmNotificationTokenApi(String fcmToken) async {
    var token = await getAuthToken();

    if (token != null) {
      Dio dio = Dio();
      Response response;

     *//*   var url = "$baseUrl/api/users/me";
      dio.options.headers['Authorization'] = "Token $token";

      FormData formData = FormData.fromMap({
        "notification_token": fcmToken,
      });

//      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
//      dio.options.headers["Authorization"] = "Token $token";

      try {
        var data = {"notification_token": fcmToken};
        response = await dio.post(url, data: {"notification_token": fcmToken});
      } on DioError catch (e) {
        log(e.response.toString());
      }*//*


      String authorizationHeader;

      authorizationHeader = 'Token $token';

      var headers;

      headers = {
//        HttpHeaders.acceptHeader: acceptHeader,
//        HttpHeaders.contentTypeHeader: contentTypeHeader,
        HttpHeaders.authorizationHeader: authorizationHeader
      };

      BaseOptions options = new BaseOptions(
          baseUrl: baseUrl + '/api/users/me',
          connectTimeout: 20000,
          receiveTimeout: 3000,
          headers: headers);

      dio.options = options;

      await dio.post("", data: json.encode({"notification_token": fcmToken})).then((response) {
        print("data $response");
      });

      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }*/

  Future<String> login(email, password) async {
    var url = "$baseUrl/api/auth/login/";
    var result = "";

    var response;
    // Dio dio = Dio();
    var client = http.Client();

    String credentials = email + ":" + password;
    //print('logging in with ' + credentials);
    String encoded = base64Encode(utf8.encode(credentials));
    var auth = "Basic $encoded";

    // dio.options.headers["Authorization"] = auth;
    Map<String, String> requestHeaders = {
       'Authorization': auth
     };

    try {
      // response = await dio.post(url, data: json.encode({}));
      response = await http.post(url, body: json.encode({}), headers: requestHeaders);
      print(response);
    } on DioError catch (e) {
      result = e.toString();
    } on Error catch (e) {
      //print(e);
    }

    if (response != null && response.statusCode == 200) {
      result = response.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response.data["token"]);
      prefs.setString('user_email', email);
      prefs.setString('user_password', password);
      this.accountInfo();
    } else {
      result = "";
    }
    return result;
  }

  // Future<String> login(email, password) async {
  //   var url = "$baseUrl/api/auth/login/";
  //   var result = "";

  //   Response response;
  //   Dio dio = Dio();

  //   String credentials = email + ":" + password;
  //   //print('logging in with ' + credentials);
  //   String encoded = base64Encode(utf8.encode(credentials));
  //   var auth = "Basic $encoded";

  //   dio.options.headers["Authorization"] = auth;

  //   try {
  //     response = await dio.post(url, data: json.encode({}));
  //     print(response);
  //   } on DioError catch (e) {
  //     result = e.toString();
  //   } on Error catch (e) {
  //     //print(e);
  //   }

  //   if (response != null && response.statusCode == 200) {
  //     result = response.toString();
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('token', response.data["token"]);
  //     prefs.setString('user_email', email);
  //     prefs.setString('user_password', password);
  //     this.accountInfo();
  //   } else {
  //     result = "";
  //   }
  //   return result;
  // }

  Future<String> signup(email, password, activationCode) async {
    var url = "$baseUrl/api/get-started/";
    var result = "";

    Response response;
    Dio dio = Dio();
    String credentials = email + ":" + password + ":" + activationCode;
    //print('siging in with ' + credentials);

    try {
      response = await dio.post(url,
          data: json.encode({
            "email": email,
            "password": password,
            "activation_code": activationCode
          }));
      //print('response: ${response.toString()}');
    } on DioError catch (e) {
      result = e.toString();
      //print(result);
      //print(e.response.data);
    } on Error catch (e) {
      //print(e);
    }

    if (response != null && response.statusCode == 200) {
      result = response.toString();
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('token', response.data["token"]);

      // prefs.setString('user_email', email);
      // prefs.setString('user_password', password);
      // this.accountInfo();
    } else {
      result = "";
    }
    return result;
  }

  Future<CurrencyRates> currencyRatesQuery() async {
    CurrencyRates currency = CurrencyRates();
    Dio dio = Dio(BaseOptions(
      baseUrl: "$baseUrl/api/",
      contentType: "application/json;charset=utf-8",
    ));

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    try {
      Response response = await dio.get('/currency');

      if (response?.statusCode == 200) {
        currency = CurrencyRates.fromJson(response.data['rates']);
      }
    } catch (e) {
      log(e.toString());
    }

    return currency;
  }

  Future<List<LocationObject>> locationQuery(term) async {
    Response response;
    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charset=utf-8",
        followRedirects: true,
        headers: {
          "Connection": "keep-alive",
          "Accept-Encoding": "gzip, deflate, br",
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    List<LocationObject> locations = List<LocationObject>();

    term = term.toString().replaceAll(" ", "+");
    var url =
        "$baseUrl/api/locations/query/?term=$term&locale=en-US&location_types=city&location_types=airport";
    try {
      response = await dio.get(url);
    } catch (e) {
      log(e.toString());
    }

    if (response?.statusCode == 200) {
      for (dynamic i in response.data["locations"]) {
        if (i['type'] != 'subdivision') {
          locations.add(LocationObject.fromJson(i));
        }
      }
    }
    return locations;
  }

  Future<List<FlightInformationObject>> searchFlight(
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
  ) async {
    var token = await getAuthToken();
    print('searchFlight');
    var headers = {
      "Connection": "keep-alive",
      "Accept-Encoding": "gzip, deflate, br",
    };
    if (token != "logout") {
      headers["Authorization"] = "Token $token";
    }
    Response response;
    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charset=utf-8",
        followRedirects: true,
        headers: headers,
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));

    List<FlightInformationObject> flights = List<FlightInformationObject>();
    try {
      response = await dio.get("/search/", queryParameters: {
        "fly_from": flyFrom,
        "fly_to": flyTo,
        "date_from": dateFrom,
        "date_to": dateTo,
        "type": type,
        "return_from": returnFrom,
        "return_to": returnTo,
        "adults": adults,
        "infants": infants,
        "children": children,
        "selectedCabins": selectedCabins,
        "curr": "USD",
        "subdivision": "NY",
      });
    } catch (e) {
      log(e.toString());
    }

    if (response != null && response.statusCode == 200) {
      print('search flight success');
      for (dynamic i in response.data["data"]) {
        flights.add(FlightInformationObject.fromJson(i));
      }
    }
    return flights;
  }

  Future<List<FlightInformationObject>> scrapperSearch(
    String flyFrom,
    String flyTo,
    String startDate,
    String returnDate,
    List<String> scrappers,
  ) async {
    var token = await getAuthToken();

    var headers = {
      "Connection": "keep-alive",
      "Accept-Encoding": "gzip, deflate, br",
    };
    if (token != "logout") {
      headers["Authorization"] = "Token $token";
    }
    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charseot=utf-8",
        followRedirects: true,
        headers: headers,
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
    List<FlightInformationObject> flightResults = [];

    final payload = (kind) => {
          "kind": kind,
          "fly_from": flyFrom.split(':').last,
          "fly_to": flyTo.split(':').last,
          "start_date": startDate,
          "return_date": returnDate
        };

    try {
      List<Response> workers = List.from(await Future.wait([
        ...scrappers.map((e) => dio.post("/request-scraper/", data: payload(e)))
      ]));

      workers.retainWhere((worker) => worker?.statusCode == 200);

      Map<String, Map<String, dynamic>> taskScrapper = workers.fold({}, (a, b) {
        a.addAll({
          b.data["id"]: {"kind": b.request.data["kind"]}
        });
        return a;
      });

      List ids = [...taskScrapper.keys];
      List completedIds = [];
      if (workers.length > 0) {
        List<Response> flightResponses;
        int retryCount = 10;

        do {
          List idsToScan = ids.where((i) => !completedIds.contains(i)).toList();
          if (idsToScan.isEmpty) break;
          await Future.delayed(Duration(seconds: math.min(retryCount + 1, 5)));
          flightResponses = List.from(await Future.wait([
            ...idsToScan.map((id) => dio.get(
                  "/check-scraper-result/",
                  queryParameters: {"id": id},
                ).catchError((error) => error.response))
          ]));

          for (int i = 0; i < idsToScan.length; i++) {
            Response r = flightResponses[i];
            String id = idsToScan[i];
            if (r.statusCode != 200) {
              completedIds.add(id);
            }
            if (r.data["status"] == "success") {
              taskScrapper[id]["data"] = r.data["data"];
              completedIds.add(id);
            } else if (r.data["status"] == "not-ready") {
              print("Scheduling id=$id for retrial");
            } else if (r.data["status"] == "failure") {
              completedIds.add(id);
            }
          }
        } while (retryCount-- > 0);

        taskScrapper.values.forEach((f) {
          if (f["data"] != null)
            for (dynamic i in f["data"]) {
              i["kind"] = f["kind"];
              flightResults.add(FlightInformationObject.fromJson(i));
            }
        });
      } else {
        log('worker is empty');
      }
    } catch (e) {
      log(e.toString());
    }
    return flightResults;
  }

  Future<CheckFlightResponse> checkFlights(
      bookingId, infants, children, adults) async {
    Response response;
    var token = await getAuthToken();
    var headers = {
      "Connection": "keep-alive",
      "Accept-Encoding": "gzip, deflate, br",
    };
    if (token != "logout") {
      headers["Authorization"] = "Token $token";
    }
    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charset=utf-8",
        followRedirects: true,
        headers: headers,
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));

    CheckFlightResponse flightResponse;
    var url = "$baseUrl/api/booking/check_flights/";
    var queryParameters = {
      "currency": "USD",
      "booking_token": bookingId,
      "bnum": 0,
      "infants": infants,
      "children": children,
      "adults": adults,
      "pnum": (infants ?? 0) + (children ?? 0) + (adults ?? 1),
    };
    try {
      response = await dio.get(url, queryParameters: queryParameters);
    } catch (e) {
      log(e.toString());
    }

    if (response?.statusCode == 200) {
      flightResponse = CheckFlightResponse.fromJson(response.data);
    }
    return flightResponse;
  }

  Future<Map> book(BookRequest bookRequest) async {
    var token = await getAuthToken();

    Response response;
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.headers["Authorization"] = "Token $token";
    var url = "$baseUrl/api/book/";

    try {
      print('BOOKING INFO: ' + json.encode(bookRequest.jsonSerialize));
      response =
          await dio.post(url, data: json.encode(bookRequest.jsonSerialize));
      return {"status": 200};
    } on DioError catch (e) {
      return {"status": e.response.statusCode};
    } catch (e) {
      //todo  need to throw exception as per error code just dummy mapping
      return {"status": 400};
    }
  }

  Future<List<FlylineDeal>> randomDealsForGuest(int size) async {
    Response response;
    Dio dio = Dio();

    List<FlylineDeal> deals = List<FlylineDeal>();
    var url = "https://api.flyline.io/api/deals/?size=" + size.toString();

    try {
      response = await dio.get(url);
    } on DioError catch (e) {
      log(e.response.toString());
    } catch (e) {
      //print(e.toString());
      log(e.toString());
    }

    if (response?.statusCode == 200) {
      for (dynamic i in response.data["results"]) {
        deals.add(FlylineDeal.fromJson(i));
      }
    }
    return deals;
  }

  Future<List<FlylineDeal>> randomDeals(int size) async {
    var token = await getAuthToken();

    Response response;
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Token $token";

    List<FlylineDeal> deals = List<FlylineDeal>();
    var url = "$baseUrl/api/deals/?size=" + size.toString();

    try {
      response = await dio.get(url);
    } on DioError catch (e) {
      log(e.response.toString());
    } catch (e) {
      log(e.toString());
    }

    if (response?.statusCode == 200) {
      for (dynamic i in response.data["results"]) {
        deals.add(FlylineDeal.fromJson(i));
      }
    }
    return deals;
  }

  Future<Account> accountInfo() async {
    var token = await getAuthToken();

    Response response;
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Token $token";

    var url = "$baseUrl/api/users/me";
    try {
      response = await dio.get(url);
    } catch (e) {
      log(e.toString());
    }

    if (response?.statusCode == 200) {
      Account account = Account.fromJson(response.data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('account', jsonEncode(response.data));

      return account;
    }

    return null;
  }

  Future<TravelerInfo> travelerInfo(int accountId) async {
    var token = await getAuthToken();

    Response response;
    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charset=utf-8",
        followRedirects: true,
        headers: {
          "Authorization": "Token $token",
          "Connection": "keep-alive",
          "Accept-Encoding": "gzip, deflate, br",
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    try {
      response = await dio.get('/users/me/');
    } catch (e) {
      log(e.toString());
    }

    if (response?.statusCode == 200) {
      TravelerInfo travelerInfo = TravelerInfo.fromJson(response.data);
      return travelerInfo;
    }
    return null;
  }

  Future<List<BookedFlight>> pastOrUpcomingFlightSummary(
      bool isUpcoming) async {
    List<BookedFlight> flights = List<BookedFlight>();
    var pastFlightsURL = '/bookings/?kind=past';
    var upcomingFlightsURL = '/bookings/?kind=upcoming';

    var token = await getAuthToken();

    Response response;

    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charset=utf-8",
        followRedirects: true,
        headers: {
          "Authorization": "Token $token",
          "Connection": "keep-alive",
          "Accept-Encoding": "gzip, deflate, br",
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    try {
      response =
          await dio.get(isUpcoming ? upcomingFlightsURL : pastFlightsURL);

      log(response.toString());
    } catch (e) {
      log(e.toString());
    }
    if (response?.statusCode == 200) {
      for (Map<String, dynamic> i in response.data) {
        flights.add(BookedFlight.fromJson(i));
      }
    }
    return flights;
  }

  Future<List<RecentFlightSearch>> flightSearchHistory() async {
    var searchHistoryURL = '/search-history/';

    List<RecentFlightSearch> flights = List<RecentFlightSearch>();
    var token = await getAuthToken();

    Response response;

    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charset=utf-8",
        followRedirects: true,
        headers: {
          "Authorization": "Token $token",
          "Connection": "keep-alive",
          "Accept-Encoding": "gzip, deflate, br",
        },
      ),
    );
    try {
      response = await dio.get(searchHistoryURL);
    } catch (e) {
      log(e.toString());
    }
    if (response?.statusCode == 200) {
      for (dynamic i in response.data) {
        flights.add(RecentFlightSearch.fromJson(i));
      }
    }
    return flights;
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
      String globalEntryNumber,
      dynamic locationObject,
      dynamic preCheckNumber}) async {
    var token = await getAuthToken();

    Response response;
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Token $token";

    var url = "$baseUrl/api/users/me/";

    try {
      var data = {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phone,
        "passport_number": passport,
        "global_entry_number": globalEntryNumber,
        "tsa_precheck_number": preCheckNumber,
//        "market": locationObject,
      };

      if (gender.length > 0) {
        gender = (gender.toLowerCase() == 'male' ? 0 : 1).toString();
        data.addAll({"gender": gender});
      }
      if (passportExpiry.isNotEmpty) {
        data.addAll({"passport_expiration length": passportExpiry.length});
      }
      if (dob.length > 0) {
        data.addAll({"dob": dob});
      }
      if (locationObject.toString().length > 0) {
        data.addAll({
          "market": {
            "code": "${locationObject["code"]}",
            "name": "${locationObject["name"]}",
            "type": "${locationObject["type"]}"
          }
        });
      }
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
//      log(e.response.toString());
    }

    if (response?.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('first_name', firstName);
      prefs.setString('last_name', lastName);
      prefs.setString('email', email);
      prefs.setString('gender', gender);
      prefs.setString('phone_number', phone);
      prefs.setString('dob', dob);
      prefs.setString('passport_number', passport);
      prefs.setString("passport_expiration", passportExpiry);
      prefs.setString("global_entry_number", globalEntryNumber);
      prefs.setString("tsa_precheck_number", preCheckNumber);
    }
  }

  Future<void> updatePreferredAirports(List<LocationObject> airports) async {
    var token = await getAuthToken();
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    Response response;
    dio.options.headers['Authorization'] = "Token $token";
    var url = "$baseUrl/api/users/me/";

    try {
      var data = {
        "preferred_airports": airports.map((e) => e.toJson()).toList()
      };
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
      log(e.response.toString());
    }
  }

  Future<void> updatePreferredAirlines(List<String> airlines) async {
    var token = await getAuthToken();
    Dio dio = Dio();
    Response response;
    dio.options.headers['Authorization'] = "Token $token";
    var url = "$baseUrl/api/users/me/";
    try {
      var data = {"preferred_airlines": jsonEncode(airlines)};
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
      log(e.response.toString());
    }
  }

  Future<void> updateCabin(int value) async {
    var token = await getAuthToken();
    Dio dio = Dio();
    Response response;
    dio.options.headers['Authorization'] = "Token $token";
    var url = "$baseUrl/api/users/me/";
    try {
      var data = {"cabin_class_preference": value};
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
      //print(e.response.toString());
    }
  }

  Future<void> updateAirlines(List<String> airlines) async {
    var token = await getAuthToken();
    Dio dio = Dio();
    Response response;
    dio.options.headers['Authorization'] = "Token $token";
    var url = "$baseUrl/api/users/me/";
    try {
      var data = {"preferred_airlines": airlines};
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
      log(e.response.toString());
    }
  }

  Future<void> updateDirectFlightPreference(bool allow) async {
    var token = await getAuthToken();
    Dio dio = Dio();
    Response response;
    dio.options.headers['Authorization'] = "Token $token";
    var url = "$baseUrl/api/users/me/";
    try {
      var data = {"direct_flight_preference": allow};
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
      log(e.response.toString());
    }
  }

  Future<void> updateDurationPricePreference(int value) async {
    var token = await getAuthToken();
    Dio dio = Dio();
    Response response;
    dio.options.headers['Authorization'] = "Token $token";
    var url = "$baseUrl/api/users/me/";
    try {
      var data = {"duration_price_preference": value};
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
      log(e.response.toString());
    }
  }

  Future<void> updateCarrierPreference(int value) async {
    var token = await getAuthToken();
    Dio dio = Dio();
    Response response;
    dio.options.headers['Authorization'] = "Token $token";
    var url = "$baseUrl/api/users/me/";
    try {
      var data = {"carrier_preference": value};
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
      log(e.response.toString());
    }
  }

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
    var token = await getAuthToken();
    var headers = {
      "Connection": "keep-alive",
      "Accept-Encoding": "gzip, deflate, br",
    };
    if (token != "logout") {
      headers["Authorization"] = "Token $token";
    }
    Response response;
    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json; charset=utf-8",
        followRedirects: true,
        headers: headers,
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    dynamic data = {
      'origin': {
        'code': departureLocation.code,
        'name': departureLocation.name,
        'type': departureLocation.type,
        'country': {'code': departureLocation.countryCode},
        'subdivision': {'name': departureLocation.subdivisionName},
      },
      'destination': {
        'code': arrivalLocation.code,
        'name': arrivalLocation.name,
        'type': arrivalLocation.type,
        'country': {'code': arrivalLocation.countryCode},
        'subdivision': {'name': arrivalLocation.subdivisionName},
      },
      'departure_date': DateFormat('yyyy-MM-dd').format(departureDate),
      'adults': adults,
      'children': children,
      'max_price': maxPrice,
      'airlines': airlines,
    };

    if (returnDate != null) {
      data['return_date'] = DateFormat('yyyy-MM-dd').format(returnDate);
    }

    if (departureStartTime != null) {
      data['departure_start_time'] = getTimeString(departureStartTime);
    }

    if (departureEndTime != null) {
      data['departure_end_time'] = getTimeString(departureEndTime);
    }

    if (returnStartTime != null) {
      data['return_start_time'] = getTimeString(returnStartTime);
    }

    if (returnEndTime != null) {
      data['return_end_time'] = getTimeString(returnEndTime);
    }

    bool preferShortest = false;
    bool preferSingleCarrier = false;
    if (flightPreferences != null) {
      if (flightPreferences.contains('Quickest (Durration)')) {
        preferShortest = true;
      }
      if (flightPreferences.contains('Single Carrier')) {
        preferSingleCarrier = true;
      }
      if (flightPreferences.contains('Direct Flight')) {
        data['max_stops'] = 0;
      }
      if (flightPreferences.contains('Economy')) {
        data['cabin_class'] = 1;
      }
      if (flightPreferences.contains('Economy Premium')) {
        data['cabin_class'] = 2;
      }
      if (flightPreferences.contains('Business Class')) {
        data['cabin_class'] = 3;
      }
      if (flightPreferences.contains('First Class')) {
        data['cabin_class'] = 4;
      }
    }
    data['prefer_shortest'] = preferShortest;
    data['prefer_single_carrier'] = preferSingleCarrier;

    try {
      response = await dio.post("/autopilot/", data: data);
    } on DioError catch (e) {
      log(e.toString());
      return {
        'success': false,
        'status': e.response.statusCode,
        'message': e.response.data.toString(),
      };
    } on Error catch (e) {
      log(e.toString());
      return {'success': false};
    }

    return {
      'success': true,
      'status': response.statusCode,
    };
  }

  Future<List<AutoPilotAlert>> autopilotAlerts() async {
    var autopilotAlertURL = '/autopilot/';
    List<AutoPilotAlert> alerts = List<AutoPilotAlert>();
    var token = await getAuthToken();

    Response response;

    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charset=utf-8",
        followRedirects: true,
        headers: {
          "Authorization": "Token $token",
          "Connection": "keep-alive",
          "Accept-Encoding": "gzip, deflate, br",
        },
      ),
    );
    try {
      response = await dio.get(autopilotAlertURL);
    } catch (e) {
      log(e.toString());
    }
    if (response?.statusCode == 200) {
      for (dynamic i in response.data) {
        alerts.add(AutoPilotAlert.fromJson(i));
      }
    }
    return alerts;
  }

  Future<Map> deleteAutopilotAlert(int id) async {
    var autopilotAlertURL = '/autopilot/$id/';
    var token = await getAuthToken();

    Response response;

    Dio dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
        contentType: "application/json;charset=utf-8",
        followRedirects: true,
        headers: {
          "Authorization": "Token $token",
          "Connection": "keep-alive",
          "Accept-Encoding": "gzip, deflate, br",
        },
      ),
    );
    try {
      response = await dio.delete(autopilotAlertURL);
    } on DioError catch (e) {
      log(e.toString());
      return {
        'success': false,
        'status': e.response.statusCode,
        'message': e.response.data.toString(),
      };
    } on Error catch (e) {
      log(e.toString());
      return {'success': false};
    }

    return {
      'success': true,
      'status': response.statusCode,
    };
  }

  Future<PriceDataResponse> getPriceData(String flyFrom, String flyTo,
      String flightType, String adults, String children) async {
    var url =
        '$baseUrl/api/booking/price-per-date/?fly_from=$flyFrom&fly_to=$flyTo&flight_type=round&adults=$adults&children=$children&limit=30';
    Response response;
    print(url);

    PriceDataResponse result = new PriceDataResponse();

    Dio dio = Dio(
      BaseOptions(
        contentType: "application/json;charset=utf-8",
      ),
    );
    try {
      response = await dio.get(url);
    } catch (e) {
      print("error");
      log(e.toString());
    }

    if (response?.statusCode == 200) {
      result = PriceDataResponse.fromJson(response.data);
    }
    return result;
  }

  String getTimeString(List<String> times) {
    String timeString = times.join(', ');
    timeString = timeString.replaceAll('Morning', '6:00 am - 11:59 am');
    timeString = timeString.replaceAll('Afternoon', '12:00 pm - 5:59 pm');
    timeString = timeString.replaceAll('Evening', '6:00 pm - 5:59 am');
    return timeString;
  }
}
