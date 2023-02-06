import 'package:flutter/material.dart';
import 'package:keepbilling/widgets/infoPages/infoText.dart';
import 'package:keepbilling/widgets/infoPages/paddedText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/profile.dart';
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

  String companyId = "";
  String userId = "";

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    data = await service.fetchLicenseDetails(userId);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getData();
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
                ],
              ),
            ),
          );
  }

  // Container renewLink(double height, double width, String date) {
  //   return Container(
  //     height: height * 0.2,
  //     width: width * 0.9,
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: height * 0.1,
  //           child: FittedBox(
  //             child: RichText(),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
