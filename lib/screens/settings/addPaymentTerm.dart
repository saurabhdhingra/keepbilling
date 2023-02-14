import 'package:flutter/material.dart';
import 'package:keepbilling/widgets/formPages/submitButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/settings.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/customField.dart';
import '../../widgets/infoPages/paddedText.dart';

class AddPaymentTermSettings extends StatefulWidget {
  const AddPaymentTermSettings({Key? key}) : super(key: key);

  @override
  State<AddPaymentTermSettings> createState() => _AddPaymentTermSettingsState();
}

class _AddPaymentTermSettingsState extends State<AddPaymentTermSettings> {
  String userId = "";
  String companyId = "";
  String cashId = "";

  String term = "";

  final _formKey1 = GlobalKey<FormState>();

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    cashId = prefs.getString('cashId') ?? "";
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Scaffold(
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
              text: "Add Payment Term",
              style: TextStyle(
                fontSize: height * 0.03,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: height * 0.02),
            CustomField(
              setValue: (value) => setState(() => term = value),
              formKey: _formKey1,
            ),
            SizedBox(height: height * 0.02),
            SubmitButton(
              onSubmit: () {
                apiCall().then(
                  (value) {
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
      return await service.setPaymentTerm(userId, companyId, cashId, term);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
