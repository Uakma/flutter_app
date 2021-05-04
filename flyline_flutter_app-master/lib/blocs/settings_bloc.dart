import 'package:flutter/widgets.dart';
import 'package:motel/models/currency_rates.dart';
import 'package:motel/blocs/bloc.dart';


import '../models/account.dart';


class SettingsBloc extends ChangeNotifier {

  Currency _selectedCurrency =  Currency.withDefault();

  Currency get selectedCurrency => _selectedCurrency;

  FlyLineBloc flyLineBloc = FlyLineBloc();

  void changeCurrency(Currency selectedCurrency) {
    _selectedCurrency = selectedCurrency;
    notifyListeners();
  }

  Future<void> logout() async {
    return await flyLineBloc.logout();
  }

  Future<Account> accountInfo() async {
    return await flyLineBloc.accountInfo();
  }

  Future<String> getAuthToken2() async {
    return flyLineBloc.getAuthToken();
  }
}
