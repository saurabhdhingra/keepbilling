import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/reports/general.dart';
import 'package:keepbilling/utils/functions.dart';
import 'package:keepbilling/widgets/formPages/submitButton.dart';
import 'package:provider/provider.dart';
import '../../../api/master.dart';
import '../../../provider/authenticationProvider.dart';
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
  dynamic fromDate = "";
  dynamic toDate = "";

  List sCreditorList = [];
  List sDebtorList = [];
  List itemList = [];

  String userId = "";
  String companyId = "";
  String product = "";

  MasterService service = MasterService();

  FixedExtentScrollController creditorController =
      FixedExtentScrollController();
  FixedExtentScrollController debtorController = FixedExtentScrollController();

  Future getData() async {
    setState(() => isLoading = true);

    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;

    try {
      sCreditorList =
          await service.fetchCredDeb("creditors", userId, companyId, product);
      sDebtorList =
          await service.fetchCredDeb("debitors", userId, companyId, product);
      itemList =
          await service.fetchDataList(userId, companyId, "item", product);
    } catch (e) {
      sCreditorList = [];
      sDebtorList = [];
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
                        sDebtorIndex = 0;
                        debtorController.animateTo(0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.decelerate);
                      }),
                      items: List.generate(sCreditors.length,
                          (index) => sCreditors[index]["party_name"]),
                      dropDownValue: sCreditors[sCreditorIndex]["party_name"],
                      scrollController: creditorController,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Sundry Debitor"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        sundryDebtor = sDebtors[value]["id"];
                        sDebtorIndex = value;
                        sCreditorIndex = 0;
                        creditorController.animateTo(0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.decelerate);
                      }),
                      items: List.generate(sDebtors.length,
                          (index) => sDebtors[index]["party_name"]),
                      dropDownValue: sDebtors[sDebtorIndex]["party_name"],
                      scrollController: debtorController,
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
                      initialDate: DateTime.now(),
                      setFunction: (value) => setState(() => fromDate = value),
                      reset: () => setState(() => fromDate = ""),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "To Date"),
                    CupertinoDateSelector(
                      initialDate: DateTime.now(),
                      setFunction: (value) => setState(() => toDate = value),
                      reset: () => setState(() => toDate = ""),
                    ),
                    SubmitButton(
                      text: "Get Report",
                      onSubmit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeneralReport(
                              sundryCreditor: sundryCreditor,
                              sundryDebitor: sundryDebtor,
                              itemId: itemId,
                              fromDate: fromDate == ""
                                  ? fromDate
                                  : formatDate(fromDate),
                              toDate:
                                  toDate == "" ? toDate : formatDate(toDate),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
