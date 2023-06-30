import 'package:flutter/material.dart';
import 'package:keepbilling/widgets/formPages/submitButton.dart';
import 'package:keepbilling/widgets/infoPages/infoText.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/profile.dart';
import '../../provider/authenticationProvider.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/titleText.dart';
import '../loadingScreens.dart';

class LicenseDetails extends StatefulWidget {
  const LicenseDetails({Key? key}) : super(key: key);

  @override
  State<LicenseDetails> createState() => _LicenseDetailsState();
}

class _LicenseDetailsState extends State<LicenseDetails> {
  bool isLoading = false;
  Map data = {};

  ProfileService service = ProfileService();

  String userId = "";
  String product = "";

  int days = 0;

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
    try {
      data = await service.fetchLicenseDetails(userId,product);
    } catch (e) {
      data = {
        "CustomerID": "",
        "Name": "",
        "Companyname": "",
        "Version": "",
        "Licencekey": "",
        "Expiry_date": "2020-01-01",
        "Package": ""
      };
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    days = -(DateTime.now()
                .difference(DateTime.parse(data["Expiry_date"]))
                .inHours /
            24)
        .round();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future openBrowserURL({
    required String url,
    bool inApp = false,
  }) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return isLoading
        ? infoLoading(context)
        : Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(text: "License Details"),
                  InfoText(title: "Customer ID", info: data["CustomerID"]),
                  InfoText(title: "Name", info: data["Name"]),
                  InfoText(title: "Company Name", info: data["Companyname"]),
                  InfoText(title: "Version", info: data["Version"]),
                  InfoText(title: "Licence Key", info: data["Licencekey"]),
                  InfoText(title: "Expiry Date", info: data["Expiry_date"]),
                  InfoText(title: "Package", info: data["Package"]),
                  SizedBox(height: height * 0.02),
                  data["Expiry_date"] == "2020-01-01"
                      ? const SizedBox()
                      : renewLink(height, width, days),
                ],
              ),
            ),
          );
  }

  Widget renewLink(double height, double width, int days) {
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
      child: SizedBox(
        width: width * 0.9,
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                text: "Your package expires in ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: height * 0.025,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: "$days ",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: height * 0.025,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                      text:
                          "days. Follow the link given below to renew your package.")
                ],
              ),
            ),
            SubmitButton(
              text: "Renew",
              isEndIndent: false,
              onSubmit: () async {
                const url = 'https://www.google.com';
                openBrowserURL(url: url, inApp: true);
              },
            )
          ],
        ),
      ),
    );
  }
}
