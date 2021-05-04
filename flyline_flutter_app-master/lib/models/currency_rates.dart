import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CurrencyRates {
  final Map<String, dynamic> rates;

  CurrencyRates({this.rates});

  factory CurrencyRates.fromJson(Map<String, dynamic> json) =>
      CurrencyRates(rates: json);
}

class Currency extends Equatable{
  final String name;
  final String abbr;
  final String sign;

  const Currency( {@required this.name, @required this.abbr,  this.sign,});

  Currency.withDefault() : name = "American Dollar (USD)", abbr = CurrencyAbbr.USD, sign = "\$";

  @override
  List<Object> get props => [this.name, this.abbr];
}

class CurrencyAbbr {
  static const String CAD = 'CAD';
  static const String EUR = 'EUR';
  static const String GBP = 'GBP';
  static const String AUD = 'AUD';
  static const String CNY = 'CNY';
  static const String INR = 'INR';
  static const String IDR = 'IDR';
  static const String JPY = 'JPY';
  static const String USD = 'USD';
}
