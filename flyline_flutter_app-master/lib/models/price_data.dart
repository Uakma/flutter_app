import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class PriceDataRepository {
  PriceDataApi _helper = PriceDataApi();

  Future<Map<DateTime, PriceLevel>> fetchPriceDataList(
      String origin,
      String destination,
      DateTime departureFrom,
      DateTime departureTo,
      int adultCount,
      int childCount) async {
    final response = await _helper.get(origin, destination, departureFrom,
        departureTo, adultCount, childCount);
    List<PriceData> _rawList =
        PriceDataResponse.fromJson(response).priceDataResults;
    _rawList.sort((a, b) => a.price.compareTo(b.price));
    PriceDataCollection _listWithLabels = PriceDataCollection(_rawList);
    return _listWithLabels.getLabeledPrices;
  }

  Future<Map<DateTime, PriceLevel>> fetchRoundTripPriceData(
      String origin,
      String destination,
      DateTime departureDateFrom,
      DateTime departureDateTo,
      DateTime returnDateFrom,
      DateTime returnDateTo,
      int adultCount,
      int childCount) async {
    List<PriceData> _roundTripPrices = List<PriceData>();
    var initialResponse = await _helper.getRound(
        origin,
        destination,
        departureDateFrom,
        departureDateTo,
        returnDateFrom,
        returnDateTo,
        adultCount,
        childCount);

    if (initialResponse != null) {
      List<PriceData> _departure =
          PriceDataResponse.fromJson(initialResponse[0]).priceDataResults;
      List<PriceData> _return =
          PriceDataResponse.fromJson(initialResponse[1]).priceDataResults;

      Map<DateTime, double> _departureMap = Map.fromIterable(_departure,
          key: (e) => e.date, value: (e) => e.price);
      Map<DateTime, double> _returnMap =
          Map.fromIterable(_return, key: (e) => e.date, value: (e) => e.price);

      Map _minPrices = Map<DateTime, double>();
      DateTime _lastReturnDate = _returnMap.keys
          .reduce((value, element) => value.isAfter(element) ? value : element);
      double _currMinPrice = _returnMap[_lastReturnDate];

      while (_lastReturnDate.isAfter(returnDateFrom)) {
        // loop through date range

        if (_returnMap[_lastReturnDate] == null) {
          _minPrices[_lastReturnDate] = _currMinPrice;
        }

        if (_returnMap[_lastReturnDate] != null &&
            _returnMap[_lastReturnDate] < _currMinPrice) {
          _currMinPrice = _returnMap[_lastReturnDate];
          _minPrices[_lastReturnDate] = _returnMap[_lastReturnDate];
        }

        double _findDepPrice = _departureMap[_lastReturnDate];

        if (_findDepPrice != null) {
          PriceData _foundPrice = new PriceData();

          _foundPrice.date = _lastReturnDate;
          _foundPrice.price = _findDepPrice +
              _currMinPrice; //dep_prices[d] + min(ret_prices[d+1:])

          _roundTripPrices.add(_foundPrice);
        }
        _lastReturnDate = _lastReturnDate.subtract(Duration(days: 1));
      }
      _roundTripPrices
          .sort((a, b) => a.price.compareTo(b.price)); //Sort the final result

    }

    PriceDataCollection _listWithLabels = PriceDataCollection(_roundTripPrices);

    return _listWithLabels.getLabeledPrices;
  }
}

class PriceDataApi {
  final String _baseUrl =
      "https://api.flyline.io/api/booking/price-per-date/";

  Future<dynamic> get(String flyFrom, String flyTo, DateTime departureFrom,
      DateTime departureTo, int adultCount, int childCount) async {
    var responseJson;
    Dio dio = new Dio();

    try {
      final response = await dio.get(_baseUrl, queryParameters: {
        "fly_from": flyFrom,
        "fly_to": flyTo,
        "date_from": DateFormat("dd/MM/yyyy").format(departureFrom),
        "date_to": DateFormat("dd/MM/yyyy").format(departureTo),
        "adults": adultCount ?? 1,
        "children": childCount ?? 0
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      print("Not internet connection");
    }

    return responseJson;
  }

  Future<List<dynamic>> getRound(
      String flyFrom,
      String flyTo,
      DateTime dateFrom1,
      DateTime dateTo1,
      DateTime dateFrom2,
      DateTime dateTo2,
      int adultCount,
      int childCount) async {
    var depResponseJson, retResponseJson;
    Dio dio = new Dio();

    try {
      final response = await Future.wait([
        dio.get(_baseUrl, queryParameters: {
          "fly_from": flyFrom,
          "fly_to": flyTo,
          "date_from": DateFormat("dd/MM/yyyy").format(dateFrom1).toString(),
          "date_to": DateFormat("dd/MM/yyyy").format(dateTo1).toString(),
          "adults": adultCount ?? 1,
          "children": childCount ?? 0
        }),
        dio.get(_baseUrl, queryParameters: {
          "fly_from": flyTo,
          "fly_to": flyFrom,
          "date_from": DateFormat("dd/MM/yyyy").format(dateFrom2).toString(),
          "date_to": DateFormat("dd/MM/yyyy").format(dateTo2).toString(),
          "adults": adultCount ?? 1,
          "children": childCount ?? 0
        })
      ]);

      depResponseJson = _returnResponse(response[0]);
      retResponseJson = _returnResponse(response[1]);
    } on SocketException {
      print("Not internet connection");
    } catch (e) {
      print(e.message);
    }

    return [depResponseJson, retResponseJson];
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class PriceDataCollection {
  List<PriceData> _sortedPriceData;

  PriceDataCollection(this._sortedPriceData);

  Map<DateTime, PriceLevel> get getLabeledPrices {
    double _priceA, _priceB;

    Map _finalLabeledPrices = Map<DateTime, PriceLevel>();

    if (_sortedPriceData.length > 0) {
      _priceA = _sortedPriceData[_sortedPriceData.length ~/ 3].price;
      _priceB = _sortedPriceData[2 * _sortedPriceData.length ~/ 3].price;

      _sortedPriceData.forEach((element) {
        if (element.price < _priceA) {
          _finalLabeledPrices[element.date] = PriceLevel.low;
        }
        if (element.price > _priceA && element.price < _priceA) {
          _finalLabeledPrices[element.date] = PriceLevel.mid;
        }
        if (element.price > _priceB) {
          _finalLabeledPrices[element.date] = PriceLevel.high;
        }
      });
      return _finalLabeledPrices;
    }
    return null;
  }
}

enum PriceLevel { high, mid, low }

class PriceDataResponse {
  List<PriceData> priceDataResults;

  PriceDataResponse({this.priceDataResults});

  PriceDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      priceDataResults = List<PriceData>();
      for (var result in json['data']) {
        priceDataResults.add(new PriceData.fromJson(result));
      }

    }
  }
}

class PriceData {
  DateTime date;
  double price;

  PriceData({this.date, this.price});

  PriceData.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    price = json['price'].toDouble();
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
