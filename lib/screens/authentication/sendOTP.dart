import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/authentication/verifyOTP.dart';

import '../../api/authentication.dart';
import '../../utils/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/formPages/customField.dart';

class SendOTPPage extends StatefulWidget {
  final bool showAppBar;
  const SendOTPPage({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  State<SendOTPPage> createState() => _SendOTPPageState();
}

class _SendOTPPageState extends State<SendOTPPage> {
  String userName = "";

  final _formKey1 = GlobalKey<FormState>();

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
      appBar: widget.showAppBar
          ? AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
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
                'Enter your username(Email/Phone)',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: height * 0.02),
              ),
            ),
          ),
          CustomField(
            formKey: _formKey1,
            setValue: (value) => setState(() => userName = value),
          ),
        ],
      ),
    );
  }

  GestureDetector sendOTPButton(BuildContext context, height, width) {
    return GestureDetector(
      onTap: () {
        sendOTP().then(
          (value) {
            if (value["type"] == "success") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyOTPPage(
                    username: userName,
                    timekey: value["timekey"],
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value["message"]),
                ),
              );
              Navigator.pop(context);
            }
          },
        );
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
            "Send OTP",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Future sendOTP() async {
    final AuthenticationService service = AuthenticationService();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: SizedBox()),
    );
    try {
      return await service.sendOTP(userName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
