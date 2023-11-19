import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../api/settings.dart';
import '../provider/authenticationProvider.dart';
import '../widgets/formPages/customField.dart';
import '../widgets/formPages/submitButton.dart';
import '../widgets/navscreens/rowText.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  String userId = "";
  String companyId = "";
  String product = "";

  String subject = "";
  String query = "";

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Future getUserData() async {
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
   
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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
        child: SingleChildScrollView(
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
      ),
    );
  }

  Future apiCall() async {
    final SettingsService service = SettingsService();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      return await service.sendFeedback(userId, companyId, subject, query,product);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
