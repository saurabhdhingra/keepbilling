import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reports/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/titleText.dart';

class StockStatementFilters extends StatefulWidget {
  const StockStatementFilters({Key? key}) : super(key: key);

  @override
  State<StockStatementFilters> createState() => _StockStatementFiltersState();
}

class _StockStatementFiltersState extends State<StockStatementFilters> {
  bool isLoading = false;

  String itemName = "";
  int itemIndex = 0;
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
      {"id": "", "item_name": "Unselected"},
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
                    const RowText(text: "Select Item"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        itemName = items[value]["item_name"];
                        itemIndex = value;
                      }),
                      items: List.generate(itemList.length,
                          (index) => items[index]["item_name"]),
                      dropDownValue: items[itemIndex]["item_name"],
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
                    Row(
                      children: [
                        SizedBox(width: width * 0.8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StockStatement(
                                  itemName: itemName,
                                  fromDate:
                                      DateFormat("yyyy-MM-dd").format(fromDate),
                                  toDate:
                                      DateFormat("yyyy-MM-dd").format(toDate),
                                ),
                              ),
                            );
                            print(itemName);
                            print(DateFormat("yyyy-MM-dd").format(fromDate));
                            print(DateFormat("yyyy-MM-dd").format(toDate));
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
