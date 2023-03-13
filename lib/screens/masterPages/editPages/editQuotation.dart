import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/master.dart';
import '../../../model/quotation.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/itemExpansionTile.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/submitButton.dart';

class EditQuotationMaster extends StatefulWidget {
  final List partyList;
  final List itemList;
  final Map data;
  final String product;
  const EditQuotationMaster(
      {Key? key,
      required this.partyList,
      required this.itemList,
      required this.data, required this.product})
      : super(key: key);

  @override
  State<EditQuotationMaster> createState() => _EditQuotationMasterState();
}

class _EditQuotationMasterState extends State<EditQuotationMaster> {
  String partyId = "";
  int partyIndex = 0;
  dynamic buildDate = "";
  String subject = "";
  String grandTotal = "";
  String otherCharges = "";
  String extraComment = "";
  String grandQuantity = "";

  String itemName = "";
  int itemNameIndex = 0;
  String itemQty = "0";
  String itemDescription = "";
  String itemRate = "0";
  String itemAmount = "0";
  String itemDiscount = "0";
  String itemTax = "0";

  List items = [];

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

  TextEditingController rateController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController gQuantityController = TextEditingController();
  TextEditingController gTotalController = TextEditingController();

  final Map propeties = {
    "title": "item",
    "subtitle": "qntty",
    "entries": [
      {"fieldName": "Description", "fieldValue": "description"},
      {"fieldName": "Rate", "fieldValue": "rate"},
      {"fieldName": "Amount", "fieldValue": "amt"},
      {"fieldName": "Discount", "fieldValue": "disc"},
      {"fieldName": "GST", "fieldValue": "gst"}
    ]
  };

  @override
  void initState() {
    super.initState();
    partyId = widget.data["party_id"] ?? "";
    partyIndex = findPartyIndex(partyId);
    buildDate =
        DateTime.parse(widget.data["build_date"] ?? formatDate(DateTime.now()));
    subject = widget.data["subject"] ?? "";
    extraComment = widget.data["comment"] ?? "";
    items = widget.data["item_arr"];
    grandTotal = widget.data["grandtotal"].toString();
    grandQuantity = widget.data["grand_qty"].toString();
    gQuantityController = TextEditingController(
        text: widget.data["grand_qty"].toDouble().toString());
    gTotalController =
        TextEditingController(text: widget.data["grandtotal"].toString());
    print(items);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    rateController.dispose();
    taxController.dispose();
    amountController.dispose();
    gQuantityController.dispose();
    gTotalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    List parties = [
      {"id": "", "party_name": "Unselected"},
      ...widget.partyList
    ];
    return Scaffold(
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
              const TitleText(text: "Edit Quotation"),
              SizedBox(height: height * 0.02),
              const RowText(text: "Party"),
              DropdownSelector(
                setState: (value) => setState(() {
                  partyId = parties[value]["id"];
                  partyIndex = value;
                }),
                items: List.generate(
                    parties.length, (index) => parties[index]["party_name"]),
                dropDownValue: parties[partyIndex]["party_name"],
                scrollController:
                    FixedExtentScrollController(initialItem: partyIndex),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Date"),
              CupertinoDateSelector(
                initialDate: DateTime.parse(
                    widget.data["build_date"] ?? formatDate(DateTime.now())),
                setFunction: (value) => setState(() => buildDate = value),
                showReset: false,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Subject"),
              CustomField(
                setValue: (value) => setState(() => subject = value),
                formKey: _formKey3,
                initialValue: widget.data["subject"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Extra Comment"),
              CustomField(
                setValue: (value) => setState(() => extraComment = value),
                formKey: _formKey6,
                initialValue: widget.data["comment"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Item Array"),
              ...items.map(
                (e) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                    child: Theme(
                      data: theme,
                      child: ItemExpansionTile(
                        data: e,
                        properties: propeties,
                        itemName: widget.itemList[findItemIndex(e["item_name"])]
                            ["item_name"],
                        deleteFunc: () {
                          setState(() => items.remove(e));
                          updateMainValues();
                        },
                        updateFunc: () {
                          setState(
                            () {
                              itemName = e["item_name"];
                              itemNameIndex = findItemIndex(e["item_name"]);
                              itemQty = e["qntty"];
                              itemDescription = e["description"];
                              itemAmount = e["amt"];
                              itemDiscount = e["disc"];
                              itemRate = e["rate"];
                              itemTax = e["gst"];
                              rateController.text = e["rate"];
                              taxController.text = e["gst"];
                              amountController.text = e["amt"];
                            },
                          );
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: false,
                            isDismissible: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return addorEditEntry(
                                context,
                                (Map value) {
                                  setState(
                                      () => items[items.indexOf(e)] = value);
                                },
                                false,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: false,
                      isDismissible: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => addorEditEntry(
                        context,
                        (Map value) =>
                            setState(() => items = [...items, value]),
                        true,
                      ),
                    );
                  },
                  child: const Text("Add item"),
                ),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Grand Quantity"),
              CustomField(
                setValue: (value) => setState(() => grandQuantity = value),
                formKey: _formKey7,
                controller: gQuantityController,
                readOnly: true,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Other Charges"),
              CustomField(
                setValue: (value) {
                  setState(() => otherCharges = value);
                  updateMainValues();
                },
                formKey: _formKey5,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Grand Total"),
              CustomField(
                setValue: (value) => setState(() => grandTotal = value),
                formKey: _formKey4,
                controller: gTotalController,
                readOnly: true,
              ),
              SizedBox(height: height * 0.02),
              SubmitButton(
                onSubmit: () {
                  edit().then(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Bottom Sheet to add Item Array Entry

  Widget addorEditEntry(context, Function(Map) function, bool addOrEdit) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          builder: (_, controller) {
            var height = SizeConfig.getHeight(context);
            var width = SizeConfig.getWidth(context);
            List itemListValues = [
              {
                "id": "",
                "item_name": "Unselected",
                "s_rate": "",
                "tax": "",
              },
              ...widget.itemList
            ];

            return Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(
                            () {
                              itemName = "";
                              itemQty = "0";
                              itemDescription = "";
                              itemAmount = "0";
                              itemDiscount = "0";
                              itemRate = "0";
                              itemTax = "0";
                              rateController.text = "0";
                              taxController.text = "0";
                              amountController.text = "0";
                            },
                          );
                        },
                      ),
                    ),
                    const RowText(text: "Item Name"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        itemName = itemListValues[value]["id"];
                        itemRate = itemListValues[value]["s_rate"];
                        itemTax = itemListValues[value]["tax"];
                        rateController.text = itemListValues[value]["s_rate"];
                        taxController.text = itemListValues[value]["tax"];
                        itemNameIndex = value;
                        updateItemValues();
                      }),
                      items: List.generate(itemListValues.length,
                          (index) => itemListValues[index]["item_name"]),
                      dropDownValue: itemListValues[itemNameIndex]["item_name"],
                      scrollController: FixedExtentScrollController(
                          initialItem: itemNameIndex),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Quantity"),
                    CustomField(
                      setValue: (value) {
                        setState(() => itemQty = value);
                        updateItemValues();
                      },
                      formKey: _formKey8,
                      initialValue: itemQty,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Description"),
                    CustomField(
                      setValue: (value) =>
                          setState(() => itemDescription = value),
                      formKey: _formKey9,
                      initialValue: itemDescription,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Rate"),
                    CustomField(
                      setValue: (value) {
                        setState(() => itemRate = value);
                        updateItemValues();
                      },
                      formKey: _formKey10,
                      controller: rateController,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Discount"),
                    CustomField(
                      setValue: (value) {
                        setState(() => itemDiscount = value);
                        updateItemValues();
                      },
                      formKey: _formKey12,
                      initialValue: itemDiscount,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Tax"),
                    CustomField(
                      setValue: (value) {
                        setState(() => itemTax = value);
                        updateItemValues();
                      },
                      formKey: _formKey13,
                      controller: taxController,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Amount"),
                    CustomField(
                      setValue: (value) => setState(() => itemAmount = value),
                      formKey: _formKey11,
                      controller: amountController,
                      readOnly: true,
                    ),
                    SizedBox(height: height * 0.02),
                    SubmitButton(
                      onSubmit: () {
                        Navigator.pop(context);
                        if (double.parse(itemAmount == "" ? "0" : itemAmount) <
                            0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Amount can't be zero or negative")));
                        } else {
                          setState(
                            () {
                              function(
                                {
                                  "item_name": itemName,
                                  "qntty": itemQty,
                                  "description": itemDescription,
                                  "rate": itemRate,
                                  "amt": itemAmount,
                                  "disc": itemDiscount,
                                  "gst": itemTax,
                                },
                              );
                              itemName = "";
                              itemDescription = "";
                              itemQty = "0";
                              itemAmount = "0";
                              itemDiscount = "0";
                              itemRate = "";
                              itemTax = "";
                              rateController.text = "0";
                              taxController.text = "0";
                              amountController.text = "0";
                            },
                          );
                          updateMainValues();
                        }
                      },
                      text: addOrEdit ? "Add Entry" : "Edit Entry",
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
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
        "quot_id": widget.data["quot_no"],
        "oldparty_id": widget.data["party_id"],
        "party_id": partyId,
        "build_date": buildDate == "" ? buildDate : formatDate(buildDate),
        "subject": subject,
        "grandtotal": grandTotal,
        "extra_comment": extraComment,
        "grand_qty": grandQuantity,
        "item_array": itemArrayEditQuot(items),
      }, 'quotation');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Map itemArrayEditQuot(List items) {
    Map<String, Map> answer = {};
    for (int i = 0; i < items.length; i++) {
      answer["item$i"] = {
        "name": items[i]["item_name"],
        "qty": items[i]["qntty"],
        "descrip": items[i][""],
        "rate": items[i]["rate"],
        "amt": items[i]["amt"],
        "discount": items[i]["disc"],
        "tax": items[i]["gst"],
      };
    }
    return answer;
  }

  int findItemIndex(String itemName) {
    int ans = 0;
    for (int i = 0; i < widget.itemList.length; i++) {
      if (widget.itemList[i]["id"] == itemName) {
        ans += i;
        break;
      }
    }
    return ans;
  }

  int findPartyIndex(String partyId) {
    int ans = 1;
    for (int i = 0; i < widget.partyList.length; i++) {
      if (widget.partyList[i]["id"] == partyId) {
        ans += i;
        break;
      }
    }
    return ans;
  }

  void updateItemValues() {
    double quantity = double.parse(itemQty == "" ? "0" : itemQty);
    double rate = double.parse(itemRate == "" ? "0" : itemRate);
    setState(() {
      itemAmount = (quantity * rate).toDouble().toString();
      amountController.text = itemAmount;
    });
  }

  Map itemList(List items) {
    Map<String, Map> answer = {};
    for (int i = 0; i < items.length; i++) {
      answer["item$i"] = {
        "name": items[i]["item_name"],
        "qty": items[i]["qntty"],
        "descrip": items[i]["description"],
        "rate": items[i]["rate"],
        "amt": items[i]["totalamount"],
        "discount": items[i]["disc"],
        "tax": items[i]["gst"]
      };
    }
    return answer;
  }

  String findField(String field) {
    double ans = 0;
    for (int i = 0; i < widget.data["item_arr"].length; i++) {
      ans += double.parse(widget.data["item_arr"][i][field]);
    }
    return ans.toString();
  }

  void updateMainValues() {
    double oCharges = double.parse(otherCharges == "" ? "0" : otherCharges);
    double qtySum = 0;
    double totalSum = 0;
    for (int i = 0; i < items.length; i++) {
      double qty = double.parse(items[i]["qntty"]);
      double amt = double.parse(items[i]["amt"]);
      qtySum += qty;
      totalSum += amt;
    }

    setState(() {
      grandQuantity = qtySum.toString();
      grandTotal = (totalSum + oCharges).toString();

      gQuantityController.text = grandQuantity;
      gTotalController.text = grandTotal;
    });
  }
}
