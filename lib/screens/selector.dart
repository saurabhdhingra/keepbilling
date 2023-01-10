import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/authentication/login.dart';
import 'package:keepbilling/screens/authentication/sendOTP.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectorPage extends StatefulWidget {
  const SelectorPage({Key? key}) : super(key: key);

  @override
  State<SelectorPage> createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  bool isLoading = false;
  String? userId = "";
  String? userName = "";

  getUserData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    userName = prefs.getString('userName');
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : userId == null
            ? const SendOTPPage()
            : LoginPage(userId: userId!, userName: userName!);
  }
}
