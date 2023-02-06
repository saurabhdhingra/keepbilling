import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reports/general.dart';
import 'package:keepbilling/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/titleText.dart';

class GeneralFilters extends StatefulWidget {
  const GeneralFilters({Key? key}) : super(key: key);

  @override
  State<GeneralFilters> createState() => _GeneralFiltersState();
}

class _GeneralFiltersState extends State<GeneralFilters> {
  bool isLoading = false;

  String sundryCreditor = "";
  int sCreditorIndex = 0;
  String sundryDebtor = "";
  int sDebtorIndex = 0;
  String itemId = "";
  int itemIndex = 0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List sCreditorList = [];
  List sDebtorList = [];
  List itemList = [];

  String userId = "";
  String companyId = "";
  MasterService service = MasterService();

  FixedExtentScrollController creditorController =
      FixedExtentScrollController();
  FixedExtentScrollController debtorController = FixedExtentScrollController();

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    sCreditorList = await service.fetchCredDeb("creditors", userId, companyId);
    sDebtorList = await service.fetchCredDeb("debitors", userId, companyId);
    itemList = await service.fetchDataList(userId, companyId, "item");
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
    List sCreditors = [
      {
        "id": "",
        "party_name": "Unselected",
      },
      ...sCreditorList
    ];
    List sDebtors = [
      {
        "id": "",
        "party_name": "Unselected",
      },
      ...sDebtorList
    ];
    List items = [
      {"id": "", "item_name": "Unselected"},
      ...itemList
    ];
    return isLoading
        ? filtersLoading(context, 5)
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
                    const RowText(text: "Sundry Creditor"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        sundryCreditor = sCreditors[value]["id"];
                        sCreditorIndex = value;
                      }),
                      items: List.generate(sCreditors.length,
                          (index) => sCreditors[index]["party_name"]),
                      dropDownValue: sCreditors[sCreditorIndex]["party_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Sundry Debitor"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        sundryDebtor = sDebtors[value]["id"];
                        sDebtorIndex = value;
                      }),
                      items: List.generate(sDebtors.length,
                          (index) => sDebtors[index]["party_name"]),
                      dropDownValue: sDebtors[sDebtorIndex]["party_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Select Item"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        itemId = items[value]["id"];
                        itemIndex = value;
                      }),
                      items: List.generate(
                          items.length, (index) => items[index]["item_name"]),
                      dropDownValue: items[itemIndex]["item_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "From Date"),
                    CupertinoDateSelector(
                      initialDate: fromDate,
                      setFunction: (value) => setState(() => fromDate = value),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "To Date"),
                    CupertinoDateSelector(
                      initialDate: toDate,
                      setFunction: (value) => setState(() => toDate = value),
                    ),
                    Row(
                      children: [
                        SizedBox(width: width * 0.7),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GeneralReport(
                                  sundryCreditor: sundryCreditor,
                                  sundryDebitor: sundryDebtor,
                                  itemId: itemId,
                                  fromDate:
                                      DateFormat("yyyy-MM-dd").format(fromDate),
                                  toDate:
                                      DateFormat("yyyy-MM-dd").format(toDate),
                                ),
                              ),
                            );
                          },
                          child: const Text("Get Report"),
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
