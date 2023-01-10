import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reportsPages/tdsReport.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/statusButton.dart';
import '../../../widgets/formPages/titleText.dart';

class TDSFilters extends StatefulWidget {
  const TDSFilters({Key? key}) : super(key: key);

  @override
  State<TDSFilters> createState() => _TDSFiltersState();
}

class _TDSFiltersState extends State<TDSFilters> {
  bool isLoading = false;
  String type = "";

  String party = "";
  int partyIndex = 0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List gstList = ["Payble", "Receivable"];
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
      {"id": "", "party_name": "Unselected"},
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
                        party = parties[value]["id"];
                        partyIndex = value;
                      }),
                      items: List.generate(parties.length,
                          (index) => parties[index]["party_name"]),
                      dropDownValue: parties[partyIndex]["party_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Type"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatusButton(
                          isSelected: type == "p" ? true : false,
                          setState: (String value) =>
                              setState(() => type = "p"),
                          text: "Payables",
                        ),
                        StatusButton(
                          isSelected: type == "s" ? true : false,
                          setState: (String value) => setState(
                            () => type = "s",
                          ),
                          text: "Receivables",
                        ),
                      ],
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
                                builder: (context) => TDSreport(
                                  party: party,
                                  type: type,
                                  fromDate: formatDate(fromDate),
                                  toDate: formatDate(toDate),
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
