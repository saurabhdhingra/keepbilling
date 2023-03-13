import 'package:flutter/cupertino.dart';

class AuthenticationProvider with ChangeNotifier {
  late String _companyid;
  late String _cashid;
  late String _userid;
  late String _product;

  void setCredentials(
    String companyid,
    String cashid,
    String userid,
    String product,
  ) {
    _companyid = companyid;
    _cashid = cashid;
    _userid = userid;
    _product = product;

    notifyListeners();
  }

  String get companyid => _companyid;
  String get cashid => _cashid;
  String get userid => _userid;
  String get product => _product;
}
