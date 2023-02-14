import 'package:flutter/material.dart';
import 'package:keepbilling/widgets/formPages/submitButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/settings.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/customField.dart';
import '../../widgets/formPages/rowText.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../loadingScreens.dart';

class ChangePINSetings extends StatefulWidget {
  const ChangePINSetings({Key? key}) : super(key: key);

  @override
  State<ChangePINSetings> createState() => _ChangePINSetingsState();
}

class _ChangePINSetingsState extends State<ChangePINSetings> {
  bool isLoading = false;

  String userId = "";
  String companyId = "";

  String otpApi = "";
  String timeKey = "";

  String otp = "";
  String oldPin = "";
  String newPin = "";

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
  }

  final SettingsService service = SettingsService();

  Future getOTP() async {
    setState(() => isLoading = true);
    dynamic response = await service.sendOTPforPIN(userId, companyId);
    otpApi = response["OTP"].toString();
    timeKey = response["timekey"].toString();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getUserData().then((value) => getOTP());
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return isLoading
        ? infoLoading(context)
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaddedText(
                    text: "Change Login PIN",
                    style: TextStyle(
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  const RowText(text: "Enter OTP"),
                  CustomField(
                    setValue: (value) => setState(() => otp = value),
                    formKey: _formKey1,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: height * 0.02),
                  const RowText(text: "Enter Old PIN"),
                  CustomField(
                    setValue: (value) => setState(() => oldPin = value),
                    formKey: _formKey2,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: height * 0.02),
                  const RowText(text: "Enter New PIN"),
                  CustomField(
                    setValue: (value) => setState(() => newPin = value),
                    formKey: _formKey3,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: height * 0.02),
                  SubmitButton(
                    onSubmit: () {
                      apiCall().then(
                        (value) {
                          print(value);
                          if (value["type"] == "success") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value["message"]),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value["message"]),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                 
                 
                ],
              ),
            ),
          );
  }

  Future apiCall() async {
    final SettingsService service = SettingsService();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      return await service.verifyOTPandChangePIN(
          userId, companyId, otp, oldPin, newPin, timeKey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
