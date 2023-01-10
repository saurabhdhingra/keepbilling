import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants.dart';
import '../../widgets/navscreens/rowText.dart';

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
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Form(
                key: _formKey1,
                child: TextFormField(
                  cursorColor: Colors.black,
                  onChanged: (value) {
                    setState(() {
                      subject = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            const RowText(text: "Write your query", color: Colors.black87),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Form(
                key: _formKey2,
                child: TextFormField(
                  maxLines: 19,
                  cursorColor: Colors.black,
                  onChanged: (value) {
                    setState(() {
                      subject = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
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
