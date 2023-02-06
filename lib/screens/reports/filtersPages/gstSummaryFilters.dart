import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reports/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/titleText.dart';

class GSTSummaryFilters extends StatefulWidget {
  const GSTSummaryFilters({Key? key}) : super(key: key);

  @override
  State<GSTSummaryFilters> createState() => _GSTSummaryFiltersState();
}

class _GSTSummaryFiltersState extends State<GSTSummaryFilters> {
  bool isLoading = false;
  String gstType = "";
  int gstIndex = 0;
  String party = "";
  int partyIndex = 0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List gstList = [
    "Unselected",
    "GSTR-1",
    "GSTR-2A",
    "GSTR-2B",
    "GSTR-3B",
    "GSTR-1 (Sale) GST PORTAL Report",
    "Detailed GSTR-2A (Purchase) GST PORTAL Report",
    "GSTR-1 (Sale) HSN report",
    "GSTR-2A (Purchase) HSN report"
  ];

  List gstValues = [
    "",
    "GST!",
    "GST@",
    "GST&",
    "GST#",
    "GST!!",
    "GST@@",
    "GST##",
    "GST\$\$",
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
        ?filtersLoading(context, 4)
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
                                builder: (context) => GSTreport(
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
