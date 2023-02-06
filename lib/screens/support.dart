import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';
import '../widgets/formPages/customField.dart';
import '../widgets/navscreens/rowText.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  String subject = "";
  String query = "";

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

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
            Padding(
              padding: EdgeInsets.fromLTRB(width * 0.04, 0, 0, 0),
              child: Text(
                "Contact Support",
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.04),
              ),
            ),
            SizedBox(height: height * 0.02),
            const RowText(text: "Subject", color: Colors.black87),
            CustomField(
              setValue: (value) => setState(() => subject = value),
              formKey: _formKey1,
            ),
            SizedBox(height: height * 0.02),
            const RowText(text: "Write your query", color: Colors.black87),
            CustomField(
              setValue: (value) => setState(() => query = value),
              formKey: _formKey2,
              maxLines: 21,
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, height * 0.01),
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.7,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Send Query",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
