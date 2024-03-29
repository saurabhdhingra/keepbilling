import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keepbilling/provider/authenticationProvider.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import 'package:keepbilling/screens/authentication/sendOTP.dart';
import 'package:keepbilling/screens/navScreen.dart';
import 'package:keepbilling/widgets/formPages/customField.dart';
import 'package:provider/provider.dart';

import '../../api/authentication.dart';
import '../../utils/constants.dart';

class LoginPage extends StatefulWidget {
  final String userId;
  final String userName;
  const LoginPage({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String passKey = "";

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
    return ScreenTypeLayout(
      mobile: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.1),
                imageLogo(width),
                SizedBox(height: height * 0.08),
                passKeyField(),
                SizedBox(height: height * 0.08),
                logInButton(context, height, width, false),
                SizedBox(height: height * 0.06),
                accountLogin(false),
                SizedBox(height: height * 0.06),
                changeAccount(false),
              ],
            ),
          ),
        ),
      ),
      tablet: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.1),
                imageLogo(width),
                SizedBox(height: height * 0.08),
                passKeyField(),
                SizedBox(height: height * 0.08),
                logInButton(context, height * 0.9, width * 0.7, true),
                SizedBox(height: height * 0.06),
                accountLogin(true),
                SizedBox(height: height * 0.06),
                changeAccount(true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox imageLogo(width) {
    return SizedBox(
      width: width * 0.4,
      height: width * 0.4,
      child: const Image(
        image: AssetImage('assets/mainlogo.png'),
      ),
    );
  }

  Widget passKeyField() {
    return CustomField(
      setValue: (value) => setState(() => passKey = value),
      formKey: _formKey1,
      hintText: 'Enter PIN',
      keyboardType: TextInputType.phone,
      obscureText: true,
    );
  }

  Text accountLogin(bool isTablet) {
    return Text(
      "Login for ${widget.userName}",
      style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: isTablet ? 25 : 15),
    );
  }

  Widget changeAccount(bool isTablet) {
    return TextButton(
        child: Text(
          "Change Account",
          style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w800,
              fontSize: isTablet ? 25 : 15),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: const Text('Change account ?'),
                      content: Text(
                          'Logged in for ${widget.userName}. Do you want to change the account.'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) =>
                                    const SendOTPPage(showAppBar: true)),
                              ),
                            );
                          },
                        ),
                        CupertinoDialogAction(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  : AlertDialog(
                      title: const Text('Change account ?'),
                      content: Text(
                          'Logged in for ${widget.userName}. Do you want to change the account.'),
                      actions: [
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) =>
                                    const SendOTPPage(showAppBar: true)),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
            },
          );
        });
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Text(
    //       "Login for ${widget.userName}",
    //       style: const TextStyle(
    //           color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13),
    //     ),
    //   ],
    // );
  }

  Row createAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13),
        ),
        TextButton(
            child: const Text(
              'Create Account',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 13),
            ),
            onPressed: () {}),
      ],
    );
  }

  GestureDetector logInButton(
      BuildContext context, height, width, bool isTablet) {
    return GestureDetector(
      onTap: () {
        logIn().then(
          (value) {
            if (value["type"] == "success") {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => const NavScreen())));
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged in successfully.")));
              Provider.of<AuthenticationProvider>(context, listen: false)
                  .setCredentials(value["companyid"], value["cashid"],
                      value["userid"], value["product"]);
            } else if (value["type"] == "error") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value["message"]),
                ),
              );
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
        child: Center(
          child: Text(
            "Log In",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? 20 : 15),
          ),
        ),
      ),
    );
  }

  Future logIn() async {
    final AuthenticationService service = AuthenticationService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Processing"),
      ),
    );
    try {
      return await service.login(passKey, widget.userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
