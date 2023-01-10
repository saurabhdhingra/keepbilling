// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../api/authentication.dart';
import '../../provider/authenticationProvider.dart';
import '../../utils/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/formPages/customField.dart';
import '../navScreen.dart';

class VerifyOTPPage extends StatefulWidget {
  final String username;
  final int timekey;

  const VerifyOTPPage({
    Key? key,
    required this.username,
    required this.timekey,
  }) : super(key: key);

  @override
  State<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  String otp = "";

  final _formKey1 = GlobalKey<FormState>();

  setUserData(
      String userId, String userName, String companyId, String cashId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
    prefs.setString('userName', userName);
    prefs.setString('companyId', companyId);
    prefs.setString('cashId', cashId);

    prefs.setBool('swipeStatus', false);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.12),
              imageLogo(width),
              SizedBox(height: height * 0.1),
              userNameField(width, height),
              SizedBox(height: height * 0.12),
              sendOTPButton(context, height, width),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox imageLogo(width) {
    return SizedBox(
      width: width * 0.6,
      height: width * 0.6,
      child: const Image(
        image: AssetImage('assets/mainlogo.png'),
      ),
    );
  }

  SizedBox userNameField(width, height) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Text(
                'Enter OTP',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: height * 0.02),
              ),
            ),
          ),
          CustomField(
            formKey: _formKey1,
            setValue: (value) => setState(() => otp = value),
          ),
        ],
      ),
    );
  }

  GestureDetector sendOTPButton(BuildContext context, height, width) {
    return GestureDetector(
      onTap: () {
        if (!mounted) return;
        verifyOTP().then((value) async {
          if (value["message"] == "OTP Verified and Login successfull") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const NavScreen()));
            await setUserData(value["userid"], value["username"],
                value["companyid"], value["cashid"]);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("OTP verified and logged in successfully.")));
            Provider.of<AuthenticationProvider>(context, listen: false)
                .setCredentials(
              value["companyid"],
              value["cashid"],
              value["userid"],
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value["message"]),
              ),
            );
            Navigator.pop(context);
          }
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color.fromRGBO(16, 196, 161, 1),
              Colors.blue,
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        height: height * 0.05,
        width: width * 0.9,
        child: const Center(
          child: Text(
            "Verify OTP",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Future verifyOTP() async {
    final AuthenticationService service = AuthenticationService();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: SizedBox()),
    );
    try {
      return await service.verifyOTP(widget.username, otp, widget.timekey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
