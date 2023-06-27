import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/master.dart';
import 'package:keepbilling/model/item.dart';
import 'package:keepbilling/widgets/formPages/dropdownSelector.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../responsive/screen_type_layout.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/statusButton.dart';
import '../../../widgets/formPages/submitButton.dart';
import '../item.dart';

class EditItemMaster extends StatefulWidget {
  final List groups;
  final List units;
  final Map data;
  final String product;

  const EditItemMaster({
    Key? key,
    required this.groups,
    required this.units,
    required this.data,
    required this.product,
  }) : super(key: key);

  @override
  State<EditItemMaster> createState() => _EditItemMasterState();
}

class _EditItemMasterState extends State<EditItemMaster> {
  String itemName = "";
  String itemId = "";
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
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();
  final _formKey8 = GlobalKey<FormState>();
  final _formKey9 = GlobalKey<FormState>();
  final _formKey10 = GlobalKey<FormState>();
  final _formKey11 = GlobalKey<FormState>();
  final _formKey12 = GlobalKey<FormState>();
  final _formKey13 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    itemName = widget.data["item_name"] ?? "";
    itemId = widget.data["id"] ?? "";
    underIndex = findUnderIndex(widget.data["under"] ?? "");
    under = widget.groups[underIndex]["id"] ?? "";
    itemStock = widget.data["item_stock"] ?? "";
    hsnSac = widget.data["hsn_sac"] ?? "";
    tax = widget.data["tax"] ?? "";
    unitIndex = findUnitIndex(widget.data["per"] ?? "");
    per = widget.units[unitIndex]["id"] ?? "";
    opStock = widget.data["op_stock"] ?? "";
    opRate = widget.data["op_rate"] ?? "";
    sRate = widget.data["s_rate"] ?? "";
    pRate = widget.data["p_rate"] ?? "";
    itemType = widget.data["item_type"] ?? "";
    trackable = widget.data["trackable"] ?? "";
    stockLimit = widget.data["stock_limit"] ?? "";
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ScreenTypeLayout(
                    mobile: SizedBox(width: width * 0.8),
                    tablet: SizedBox(width: width * 0.9),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: height * 0.015),
                    ),
                  )
                ],
              ),
              const TitleText(text: "Edit Item"),
              SizedBox(height: height * 0.02),
              const RowText(text: "Item Name"),
              CustomField(
                setValue: (value) => setState(() => itemName = value),
                formKey: _formKey1,
                initialValue: widget.data["item_name"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Item Group"),
              DropdownSelector(
                setState: (value) => setState(() {
                  under = widget.groups[value]["id"];
                  underIndex = value;
                }),
                items: List.generate(widget.groups.length,
                    (index) => widget.groups[index]["item_group_name"]),
                dropDownValue: widget.groups[underIndex]["item_group_name"],
                scrollController:
                    FixedExtentScrollController(initialItem: underIndex),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Stock"),
              CustomField(
                setValue: (value) => setState(() => itemStock = value),
                formKey: _formKey3,
                initialValue: widget.data["item_stock"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "HSN SAC"),
              CustomField(
                setValue: (value) => setState(() => hsnSac = value),
                formKey: _formKey4,
                initialValue: widget.data["hsn_sac"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Tax Percentage"),
              CustomField(
                setValue: (value) => setState(() => tax = value),
                formKey: _formKey5,
                initialValue: widget.data["tax"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Unit"),
              DropdownSelector(
                setState: (value) => setState(() {
                  under = widget.units[value]["id"];
                  underIndex = value;
                }),
                items: List.generate(widget.units.length,
                    (index) => widget.units[index]["item_uom_name"]),
                dropDownValue: widget.units[unitIndex]["item_uom_name"],
                scrollController:
                    FixedExtentScrollController(initialItem: unitIndex),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Operational Stock"),
              CustomField(
                setValue: (value) => setState(() => opStock = value),
                formKey: _formKey7,
                initialValue: widget.data["op_stock"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Operational Rate"),
              CustomField(
                setValue: (value) => setState(() => opRate = value),
                formKey: _formKey8,
                initialValue: widget.data["op_rate"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Sale Rate"),
              CustomField(
                setValue: (value) => setState(() => sRate = value),
                formKey: _formKey9,
                initialValue: widget.data["s_rate"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Purchase Rate"),
              CustomField(
                setValue: (value) => setState(() => pRate = value),
                formKey: _formKey10,
                initialValue: widget.data["p_rate"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Item Type"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatusButton(
                    isSelected: itemType == "Goods" ? true : false,
                    setState: (String value) =>
                        setState(() => itemType = "Goods"),
                    text: "Goods",
                  ),
                  StatusButton(
                    isSelected: itemType == "Services" ? true : false,
                    setState: (String value) =>
                        setState(() => itemType = "Services"),
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
                    setState: (String value) => setState(() => trackable = "Y"),
                    text: "Yes",
                  ),
                  StatusButton(
                    isSelected: trackable == "N" ? true : false,
                    setState: (String value) => setState(() => trackable = "N"),
                    text: "No",
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Stock Limit"),
              CustomField(
                setValue: (value) => setState(() => stockLimit = value),
                formKey: _formKey13,
                initialValue: widget.data["stock_limit"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              SubmitButton(
                onSubmit: () {
                  edit().then(
                    (value) {
                      if (value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Error with placing request. Please try again."),
                          ),
                        );
                      }
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future edit() async {
    final MasterService service = MasterService();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      return await service.editMaster({
        "userid": widget.data["user_id"],
        "companyid": widget.data["company_id"],
        "product": widget.product,
        "item_id": itemId,
        "item_name": itemName,
        "under": under,
        "item_stock": itemStock,
        "hsn_sac": hsnSac,
        "tax": tax,
        "per": per,
        "old_current_stock": widget.data["item_stock"],
        "old_op_stock": widget.data["op_stock"],
        "current_stock": itemStock,
        "op_stock": opStock,
        "op_rate": opRate,
        "s_rate": sRate,
        "p_rate": pRate,
        "item_type": itemType,
        "trackable": trackable,
        "stock_limit": stockLimit
      }, "item");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  int findUnderIndex(String groupId) {
    int ans = 0;
    for (int i = 0; i < widget.groups.length; i++) {
      if (widget.groups[i]["id"] == groupId) {
        ans = i;
        break;
      }
    }
    return ans;
  }

  int findUnitIndex(String groupId) {
    int ans = 0;
    for (int i = 0; i < widget.units.length; i++) {
      if (widget.units[i]["id"] == groupId) {
        ans = i;
        break;
      }
    }
    return ans;
  }
}
