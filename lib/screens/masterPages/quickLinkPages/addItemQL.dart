import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/master.dart';
import 'package:keepbilling/model/item.dart';
import 'package:keepbilling/widgets/formPages/dropdownSelector.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/statusButton.dart';
import '../../loadingScreens.dart';

class AddItemMasterQL extends StatefulWidget {
  const AddItemMasterQL({Key? key}) : super(key: key);

  @override
  State<AddItemMasterQL> createState() => _AddItemMasterQLState();
}

class _AddItemMasterQLState extends State<AddItemMasterQL> {
  bool isLoading = false;

  String userId = "";
  String companyId = "";

  List groups = [];
  List units = [];

  String itemName = "";
  String under = "";
  int underIndex = 0;
  String itemStock = "";
  String hsnSac = "";
  String tax = "";
  String per = "";
  int unitIndex = 0;
  String opStock = "";
  String opRate = "";
  String sRate = "";
  String pRate = "";
  String itemType = "";
  String trackable = "";
  String stockLimit = "";

  final _formKey1 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();
  final _formKey8 = GlobalKey<FormState>();
  final _formKey9 = GlobalKey<FormState>();
  final _formKey10 = GlobalKey<FormState>();
  final _formKey13 = GlobalKey<FormState>();

  MasterService service = MasterService();

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    groups = await service.fetchDataList(userId, companyId, "allgroup");
    units = await service.fetchDataList(userId, companyId, "allunit");
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

    List groupsList = [
      {"item_group_name": "Unselected", "id": ""},
      ...groups
    ];
    List unitsList = [
      {"id": "", "item_uom_name": "Unselected"},
      ...units
    ];

    return isLoading
        ? quickLinksLoading(context, 5, "Add Item")
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: width * 0.8),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        )
                      ],
                    ),
                    const TitleText(text: "Add Item"),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Item Name"),
                    CustomField(
                      setValue: (value) => setState(() => itemName = value),
                      formKey: _formKey1,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Item Group"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        under = groupsList[value]["id"];
                        underIndex = value;
                      }),
                      items: List.generate(groupsList.length,
                          (index) => groupsList[index]["item_group_name"]),
                      dropDownValue: groupsList[underIndex]["item_group_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Stock"),
                    CustomField(
                      setValue: (value) => setState(() => itemStock = value),
                      formKey: _formKey3,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "HSN SAC"),
                    CustomField(
                      setValue: (value) => setState(() => hsnSac = value),
                      formKey: _formKey4,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Tax Percentage"),
                    CustomField(
                      setValue: (value) => setState(() => tax = value),
                      formKey: _formKey5,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Unit"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        per = unitsList[value]["id"];
                        unitIndex = value;
                      }),
                      items: List.generate(unitsList.length,
                          (index) => unitsList[index]["item_uom_name"]),
                      dropDownValue: unitsList[unitIndex]["item_uom_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Operational Stock"),
                    CustomField(
                      setValue: (value) => setState(() => opStock = value),
                      formKey: _formKey7,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Operational Rate"),
                    CustomField(
                      setValue: (value) => setState(() => opRate = value),
                      formKey: _formKey8,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Sale Rate"),
                    CustomField(
                      setValue: (value) => setState(() => sRate = value),
                      formKey: _formKey9,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Purchase Rate"),
                    CustomField(
                      setValue: (value) => setState(() => pRate = value),
                      formKey: _formKey10,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Item Type"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatusButton(
                          isSelected: itemType == "Goods" ? true : false,
                          setState: (String value) =>
                              setState(() => itemType == "Goods"),
                          text: "Goods",
                        ),
                        StatusButton(
                          isSelected: itemType == "Services" ? true : false,
                          setState: (String value) =>
                              setState(() => itemType == "Services"),
                          text: "Services",
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Trackable"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatusButton(
                          isSelected: trackable == "Y" ? true : false,
                          setState: (String value) =>
                              setState(() => trackable = "Y"),
                          text: "Yes",
                        ),
                        StatusButton(
                          isSelected: trackable == "N" ? true : false,
                          setState: (String value) =>
                              setState(() => trackable = "N"),
                          text: "No",
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Stock Limit"),
                    CustomField(
                      setValue: (value) => setState(() => stockLimit = value),
                      formKey: _formKey13,
                    ),
                    Row(
                      children: [
                        SizedBox(width: width * 0.8),
                        TextButton(
                          onPressed: () {
                            add().then(
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

  Future add() async {
    final MasterService service = MasterService();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      return await service.addMaster(
          Item(
            userid: userId,
            companyid: companyId,
            hsnSac: hsnSac,
            itemName: itemName,
            itemStock: itemStock,
            itemType: itemStock,
            opRate: opRate,
            opStock: opStock,
            pRate: pRate,
            per: per,
            product: '1',
            sRate: sRate,
            stockLimit: stockLimit,
            tax: tax,
            under: under,
            trackable: trackable,
          ).toMap(),
          "item");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
