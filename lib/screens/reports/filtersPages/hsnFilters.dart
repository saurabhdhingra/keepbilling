import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reports/hsnSac.dart';
import 'package:keepbilling/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/titleText.dart';

class HSNFilters extends StatefulWidget {
  const HSNFilters({Key? key}) : super(key: key);

  @override
  State<HSNFilters> createState() => _HSNFiltersState();
}

class _HSNFiltersState extends State<HSNFilters> {
  bool isLoading = false;

  String hsn = "";
  int hsnIndex = 0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List itemList = [];

  String userId = "";
  String companyId = "";
  MasterService service = MasterService();

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
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
    List items = [
      {
        "hsn_sac": "",
      },
      ...itemList
    ];
    return isLoading
        ? filtersLoading(context, 3)
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
                    const RowText(text: "HSN Code"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        hsn = items[value]["hsn_sac"];
                        hsnIndex = value;
                      }),
                      items: List.generate(items.length, (index) {
                        if (index == 0 || items[index]["hsn_sac"] == "") {
                          return "Unselected";
                        } else {
                          return items[index]["hsn_sac"];
                        }
                      }),
                      dropDownValue: items[hsnIndex]["hsn_sac"],
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HSNreport(
                                  hsn: hsn,
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
