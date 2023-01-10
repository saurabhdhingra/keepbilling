import 'package:flutter/cupertino.dart';

class AuthenticationProvider with ChangeNotifier {
  late String _companyid;
  late String _cashid;
  late String _userid;
  

  void setCredentials(
    String companyid, 
    String cashid,
    String userid,

  ) {
    _companyid = companyid;
    _cashid = cashid;
    _userid = userid;
    
    notifyListeners();
  }

  String get companyid => _companyid;
  String get cashid => _cashid;
  String get userid => _userid;

}
