import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reports/hsnSac.dart';
import 'package:keepbilling/utils/functions.dart';
import 'package:keepbilling/widgets/formPages/submitButton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../provider/authenticationProvider.dart';
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
  dynamic fromDate = "";
  dynamic toDate = "";

  List itemList = [];

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
      itemList =
          await service.fetchDataList(userId, companyId, "item", product);
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
                          return;
                        } else {
                          return items[index]["hsn_sac"];
                        }
                      }),
                      dropDownValue: items[hsnIndex]["hsn_sac"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Start Date"),
                    CupertinoDateSelector(
                      initialDate: DateTime.now(),
                      setFunction: (value) => setState(() => fromDate = value),
                      reset: () => setState(() => fromDate = ""),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "End Date"),
                    CupertinoDateSelector(
                      initialDate: DateTime.now(),
                      setFunction: (value) => setState(() => toDate = value),
                      reset: () => setState(() => toDate = ""),
                    ),
                    SizedBox(height: height * 0.02),
                    SubmitButton(
                      text: "Get Report",
                      onSubmit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HSNreport(
                              hsn: hsn,
                              fromDate: fromDate == ""
                                  ? fromDate
                                  : formatDate(fromDate),
                              toDate:
                                  toDate == "" ? toDate : formatDate(toDate),
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
