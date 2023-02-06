import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/dashboard.dart';
import '../../api/settings.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/dropdownSelector.dart';
import '../../widgets/formPages/rowText.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../loadingScreens.dart';

class QuickLinksSettings extends StatefulWidget {
  const QuickLinksSettings({Key? key}) : super(key: key);

  @override
  State<QuickLinksSettings> createState() => _QuickLinksSettingsState();
}

class _QuickLinksSettingsState extends State<QuickLinksSettings> {
  bool isLoading = false;

  String userId = "";
  String companyId = "";
  String cashId = "";

  String fav1 = "";
  String fav2 = "";
  String fav3 = "";
  String fav4 = "";
  String fav5 = "";
  String fav6 = "";
  int index1 = 0;
  int index2 = 0;
  int index3 = 0;
  int index4 = 0;
  int index5 = 0;
  int index6 = 0;

  DashboardService service = DashboardService();
  List data = [];

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    cashId = prefs.getString('cashId') ?? "";

    data = await service.fetchQuickLinks(userId, companyId);

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      index1 = quickLinks.indexOf(data[0]);
      index2 = quickLinks.indexOf(data[1]);
      index3 = quickLinks.indexOf(data[2]);
      index4 = quickLinks.indexOf(data[3]);
      index5 = quickLinks.indexOf(data[4]);
      index6 = quickLinks.indexOf(data[5]);
    });
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaddedText(
                      text: "Set Quick Links",
                      style: TextStyle(
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Quick Link 1"),
                    SizedBox(height: height * 0.02),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        fav1 = quickLinks[value];
                        index1 = value;
                      }),
                      items: quickLinks,
                      dropDownValue: quickLinks[index1],
                      scrollController:
                          FixedExtentScrollController(initialItem: index1),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Quick Link 2"),
                    SizedBox(height: height * 0.02),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        fav2 = quickLinks[value];
                        index2 = value;
                      }),
                      items: quickLinks,
                      dropDownValue: quickLinks[index2],
                      scrollController:
                          FixedExtentScrollController(initialItem: index2),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Quick Link 3"),
                    SizedBox(height: height * 0.02),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        fav3 = quickLinks[value];
                        index3 = value;
                      }),
                      items: quickLinks,
                      dropDownValue: quickLinks[index3],
                      scrollController:
                          FixedExtentScrollController(initialItem: index3),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Quick Link 4"),
                    SizedBox(height: height * 0.02),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        fav4 = quickLinks[value];
                        index4 = value;
                      }),
                      items: quickLinks,
                      dropDownValue: quickLinks[index4],
                      scrollController:
                          FixedExtentScrollController(initialItem: index4),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Quick Link 5"),
                    SizedBox(height: height * 0.02),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        fav5 = quickLinks[value];
                        index5 = value;
                      }),
                      items: quickLinks,
                      dropDownValue: quickLinks[index5],
                      scrollController:
                          FixedExtentScrollController(initialItem: index5),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Quick Link 6"),
                    SizedBox(height: height * 0.02),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        fav6 = quickLinks[value];
                        index6 = value;
                      }),
                      items: quickLinks,
                      dropDownValue: quickLinks[index6],
                      scrollController:
                          FixedExtentScrollController(initialItem: index6),
                    ),
                    Row(
                      children: [
                        SizedBox(width: width * 0.75),
                        TextButton(
                          onPressed: () {
                            apiCall().then(
                              (value) {
                                if (value["type"] == "success") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value["message"]),
                                    ),
                                  );
                                  Navigator.pop(context, "update");
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
                          child: const Text("Submit"),
                        )
                      ],
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
      return await service.setQuickLinks(
          userId, companyId, cashId, fav1, fav2, fav3, fav4, fav5, fav6);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
