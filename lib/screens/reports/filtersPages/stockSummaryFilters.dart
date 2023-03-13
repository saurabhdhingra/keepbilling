import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reports/export.dart';
import 'package:keepbilling/widgets/formPages/submitButton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../provider/authenticationProvider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/titleText.dart';

class StockSummaryFilters extends StatefulWidget {
  const StockSummaryFilters({Key? key}) : super(key: key);

  @override
  State<StockSummaryFilters> createState() => _StockSummaryFiltersState();
}

class _StockSummaryFiltersState extends State<StockSummaryFilters> {
  bool isLoading = false;

  String stockLimit = "";
  int sLimitIndex = 0;
  String magnitude = "";
  int magindex = 0;
  String itemName = "";
  int itemIndex = 0;

  List itemList = [];

  List stockLimitList = ["Unselected", "Below", "Above"];
  List stockLimitListValues = ["Unselected", "Below", "Above"];
  List magnitudeList = ["Unselected", "Positive", "Negative", "Both", "All"];
  List magnitudeListValues = [
    "Unselected",
    "Positive",
    "Negative",
    "Both",
    "All"
  ];
  String userId = "";
  String companyId = "";
  String product = "";

  MasterService service = MasterService();

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;

    try {
      itemList = await service.fetchDataList(userId, companyId, "item",product);
    } catch (e) {
      itemList = [];
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
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
                    const RowText(text: "Stock Limit"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        stockLimit = stockLimitListValues[value];
                        sLimitIndex = value;
                      }),
                      items: List.generate(stockLimitList.length,
                          (index) => stockLimitList[index]),
                      dropDownValue: stockLimitListValues[sLimitIndex],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Stock Sign"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        magnitude = magnitudeListValues[value];
                        magindex = value;
                      }),
                      items: List.generate(magnitudeList.length,
                          (index) => magnitudeList[index]),
                      dropDownValue: magnitudeListValues[magindex],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Select Item"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        itemName = items[value]["item_name"];
                        itemIndex = value;
                      }),
                      items: List.generate(
                          items.length, (index) => items[index]["item_name"]),
                      dropDownValue: items[itemIndex]["item_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    SubmitButton(
                      text: "Get Report",
                      onSubmit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StockSummary(
                              itemName: itemName,
                              stockLimit: stockLimit,
                              stockSign: magnitude,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
