import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reportsPages/gstDetailed.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/titleText.dart';

class GSTDetailedFilters extends StatefulWidget {
  const GSTDetailedFilters({Key? key}) : super(key: key);

  @override
  State<GSTDetailedFilters> createState() => _GSTDetailedFiltersState();
}

class _GSTDetailedFiltersState extends State<GSTDetailedFilters> {
  bool isLoading = false;
  String gstType = "";
  int gstIndex = 0;
  String party = "";
  int partyIndex = 0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List gstList = [
    "Unselected",
    "GSTR-1 (Sale)",
    "GSTR-2A (Purchase)",
    "Detailed GSTR-1 (Sale)",
    "Detailed GSTR-2 (Purchase)",
  ];

  List gstValues = [
    "",
    "GST!",
    "GST@",
    "DGST1",
    "DGST2",
  ];
  List partyList = [];

  String userId = "";
  String companyId = "";
  MasterService service = MasterService();

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    partyList = await service.fetchDataList(userId, companyId, "party");
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    List parties = [
      {
        "id": "",
        "party_name": "Unselected",
      },
      ...partyList
    ];
    return isLoading
        ? filtersLoading(context, 4)
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
                    const TitleText(text: "Filters"),
                    const RowText(text: "Party"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        party = parties[value]["party_name"];
                        partyIndex = value;
                      }),
                      items: List.generate(parties.length,
                          (index) => parties[index]["party_name"]),
                      dropDownValue: parties[partyIndex]["party_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "GST Type"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        gstType = gstList[value];
                        gstIndex = value;
                      }),
                      items: List.generate(
                          gstList.length, (index) => gstList[index]),
                      dropDownValue: gstList[gstIndex],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Start Date"),
                    CupertinoDateSelector(
                      initialDate: fromDate,
                      setFunction: (value) => setState(() => fromDate = value),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "End Date"),
                    CupertinoDateSelector(
                      initialDate: toDate,
                      setFunction: (value) => setState(() => toDate = value),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        SizedBox(width: width * 0.8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GSTdetailedReport(
                                  party: party,
                                  gstType: gstType,
                                  fromDate:
                                      DateFormat("yyyy-MM-dd").format(fromDate),
                                  toDate:
                                      DateFormat("yyyy-MM-dd").format(toDate),
                                ),
                              ),
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
}
