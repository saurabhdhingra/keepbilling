import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/widgets/formPages/datePicker.dart';
import 'package:keepbilling/widgets/formPages/customField.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/bill.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/itemExpansionTile.dart';
import '../../../widgets/formPages/rowText.dart';

class CreateBill extends StatefulWidget {
  final String billType;
  final List paymentTerms;
  final List partyList;
  final List itemList;
  final Map extraFieldData;
  final String invoiceNo;
  const CreateBill(
      {Key? key,
      required this.billType,
      required this.paymentTerms,
      required this.partyList,
      required this.invoiceNo,
      required this.itemList,
      required this.extraFieldData})
      : super(key: key);

  @override
  State<CreateBill> createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  String userId = "";
  String companyId = "";
  String cashId = "";

  String party = "";
  int partyIndex = 0;
  String invoiceNo = "";
  String orderBy = "";
  String orderNo = "";
  DateTime orderDate = DateTime.now();
  DateTime invoiceDate = DateTime.now();
  String despatchNo = "";
  String despatchThrough = "";
  String paymentTerm = "";
  int paymentTermIndex = 0;
  DateTime dueDate = DateTime.now();
  String deliveryNote = "";
  String deliveryType = "";
  String ewaybillNo = "";
  String extraF1 = "";
  String extraF2 = "";
  String extraF3 = "";
  String extraF4 = "";
  String vendorCode = "";
  String grandTotal = "";
  String tax = "";
  String otherCharges = "";
  String extraDiscount = "";
  String round = "";

  String itemName = "";
  int itemNameIndex = 0;
  String itemQty = "";
  String itemDescription = "";
  String itemRate = "";
  String itemAmount = "";
  String itemDiscount = "";
  String itemTax = "";

  List<Map> items = [];

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
  final _formKey14 = GlobalKey<FormState>();
  final _formKey15 = GlobalKey<FormState>();
  final _formKey16 = GlobalKey<FormState>();
  final _formKey17 = GlobalKey<FormState>();
  final _formKey18 = GlobalKey<FormState>();
  final _formKey19 = GlobalKey<FormState>();
  final _formKey20 = GlobalKey<FormState>();
  final _formKey21 = GlobalKey<FormState>();
  final _formKey22 = GlobalKey<FormState>();

  TextEditingController rateController = TextEditingController(text: "0");
  TextEditingController taxController = TextEditingController(text: "0");
  TextEditingController amountController = TextEditingController(text: "0");
  TextEditingController totalTaxController = TextEditingController(text: "0");
  TextEditingController gTotalController = TextEditingController(text: "0");

  final Map propeties = {
    "title": "name",
    "subtitle": "qty",
    "entries": [
      {"fieldName": "description", "fieldValue": "descrip"},
      {"fieldName": "Rate", "fieldValue": "rate"},
      {"fieldName": "Amount", "fieldValue": "amt"},
      {"fieldName": "Discount", "fieldValue": "discount"},
      {"fieldName": "Tax", "fieldValue": "tax"}
    ]
  };

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    cashId = prefs.getString('cashId') ?? "";
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    rateController.dispose();
    taxController.dispose();
    amountController.dispose();
    totalTaxController.dispose();
    gTotalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
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
                  SizedBox(width: width * 0.8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  )
                ],
              ),
              const TitleText(text: "Create Bill"),
              SizedBox(height: height * 0.02),
              const RowText(text: "Party"),
              DropdownSelector(
                setState: (value) => setState(() {
                  party = widget.partyList[value]["id"];
                  partyIndex = value;
                }),
                items: List.generate(widget.partyList.length,
                    (index) => widget.partyList[index]["party_name"]),
                dropDownValue: widget.partyList[partyIndex]["party_name"],
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Invoice Number"),
              CustomField(
                setValue: (value) => setState(() => invoiceNo = value),
                formKey: _formKey2,
                initialValue: widget.invoiceNo,
                readOnly: widget.billType == "S" ? true : false,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Invoice Date"),
              CupertinoDateSelector(
                initialDate: invoiceDate,
                setFunction: (value) => setState(() => invoiceDate = value),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Order By"),
              CustomField(
                setValue: (value) => setState(() => orderBy = value),
                formKey: _formKey3,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Order Number"),
              CustomField(
                setValue: (value) => setState(() => orderNo = value),
                formKey: _formKey4,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Order Date"),
              CupertinoDateSelector(
                initialDate: orderDate,
                setFunction: (value) => setState(() => orderDate = value),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Despatch Number"),
              CustomField(
                setValue: (value) => setState(() => despatchNo = value),
                formKey: _formKey6,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Despatch through"),
              CustomField(
                setValue: (value) => setState(() => despatchThrough = value),
                formKey: _formKey7,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Payment terms"),
              DropdownSelector(
                setState: (value) => setState(() {
                  paymentTerm = widget.paymentTerms[value];
                  paymentTermIndex = value;
                }),
                items: List.generate(widget.paymentTerms.length - 1,
                    (index) => widget.paymentTerms[index]),
                dropDownValue: widget.paymentTerms[paymentTermIndex],
              ),
              // SizedBox(height: height * 0.02),
              // const RowText(text: "Due Date"),
              // CupertinoDateSelector(
              //   initialDate: dueDate,
              //   setFunction: (value) => setState(() => dueDate = value),
              // ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Delivery note"),
              CustomField(
                setValue: (value) => setState(() => deliveryNote = value),
                formKey: _formKey10,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Delivery type"),
              CustomField(
                setValue: (value) => setState(() => deliveryType = value),
                formKey: _formKey1,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "E-Way Bill Number"),
              CustomField(
                setValue: (value) => setState(() => ewaybillNo = value),
                formKey: _formKey12,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Vendor Code"),
              CustomField(
                setValue: (value) => setState(() => vendorCode = value),
                formKey: _formKey13,
              ),
              // Extra fields. Depeends on values set by user
              widget.extraFieldData["flag_1"] == "N"
                  ? SizedBox(height: height * 0.02)
                  : const SizedBox(),
              widget.extraFieldData["flag_1"] == "N"
                  ? RowText(text: widget.extraFieldData["extra_1"])
                  : const SizedBox(),
              widget.extraFieldData["flag_1"] == "N"
                  ? CustomField(
                      setValue: (value) => setState(() => extraF1 = value),
                      formKey: _formKey5,
                    )
                  : const SizedBox(),
              widget.extraFieldData["flag_2"] == "N"
                  ? SizedBox(height: height * 0.02)
                  : const SizedBox(),
              widget.extraFieldData["flag_2"] == "N"
                  ? RowText(text: widget.extraFieldData["extra_2"])
                  : const SizedBox(),
              widget.extraFieldData["flag_2"] == "N"
                  ? CustomField(
                      setValue: (value) => setState(() => extraF2 = value),
                      formKey: _formKey8,
                    )
                  : const SizedBox(),
              widget.extraFieldData["flag_3"] == "N"
                  ? SizedBox(height: height * 0.02)
                  : const SizedBox(),
              widget.extraFieldData["flag_3"] == "N"
                  ? RowText(text: widget.extraFieldData["extra_3"])
                  : const SizedBox(),
              widget.extraFieldData["flag_3"] == "N"
                  ? CustomField(
                      setValue: (value) => setState(() => extraF3 = value),
                      formKey: _formKey9,
                    )
                  : const SizedBox(),
              widget.extraFieldData["flag_4"] == "N"
                  ? SizedBox(height: height * 0.02)
                  : const SizedBox(),
              widget.extraFieldData["flag_4"] == "N"
                  ? RowText(text: widget.extraFieldData["extra_4"])
                  : const SizedBox(),
              widget.extraFieldData["flag_4"] == "N"
                  ? CustomField(
                      setValue: (value) => setState(() => extraF4 = value),
                      formKey: _formKey11,
                    )
                  : const SizedBox(),
              SizedBox(height: height * 0.02),
              const RowText(text: "Extra Discount"),
              CustomField(
                setValue: (value) {
                  setState(() => extraDiscount = value);
                  updateMainValues();
                },
                formKey: _formKey16,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Other Charges"),
              CustomField(
                setValue: (value) {
                  setState(() => otherCharges = value);
                  updateMainValues();
                },
                formKey: _formKey15,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Grand Total"),
              CustomField(
                setValue: (value) => setState(() => invoiceNo = value),
                formKey: _formKey14,
                controller: gTotalController,
                readOnly: true,
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
                        deleteFunc: () {
                          setState(() => items.remove(e));
                          updateMainValues();
                        },
                        updateFunc: () {
                          setState(
                            () {
                              itemName = e["name"];
                              itemNameIndex = findItemIndex(e["id"]);
                              itemQty = e["qty"];
                              itemDescription = e["descrip"];
                              itemAmount = e["amt"];
                              itemDiscount = e["discount"];
                              itemRate = e["rate"];
                              itemTax = e["tax"];
                              rateController.text = e["rate"];
                              taxController.text = e["tax"];
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
                              return addorEditEntry(context, (Map value) {
                                setState(() => items[items.indexOf(e)] = value);
                              }, false);
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
                          true),
                    );
                  },
                  child: const Text("Add item"),
                ),
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
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Processing"),
      ),
    );
    try {
      return await service.createBill(
        Bill(
          userid: userId,
          companyid: companyId,
          product: '1',
          cashId: cashId,
          billType: widget.billType,
          deliveryNote: deliveryNote,
          deliveryType: deliveryType,
          despatchNo: despatchNo,
          despatchThrough: despatchThrough,
          dueDate: dueDateCalc(orderDate, paymentTerm),
          ewaybillNo: ewaybillNo,
          extraF1: extraF1,
          extraF2: extraF2,
          extraF3: extraF3,
          extraF4: extraF4,
          extraDiscount: extraDiscount,
          grandTotal: grandTotal,
          invoiceDate: invoiceDate,
          invoiceNo: invoiceNo,
          itemArray: itemArray(items),
          orderDate: orderDate,
          orderNo: orderNo,
          orderby: orderNo,
          otherCharges: otherCharges,
          party: party,
          paymentTerms: paymentTerm,
          round: round,
          vendorCode: vendorCode,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

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
                        itemName = itemListValues[value]["item_name"];
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
                      formKey: _formKey17,
                      initialValue: itemQty,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Description"),
                    CustomField(
                      setValue: (value) =>
                          setState(() => itemDescription = value),
                      formKey: _formKey18,
                      initialValue: itemDescription,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Rate"),
                    CustomField(
                      setValue: (value) {
                        setState(() => itemRate = value);
                        updateItemValues();
                      },
                      formKey: _formKey19,
                      controller: rateController,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Discount"),
                    CustomField(
                      setValue: (value) {
                        setState(() => itemDiscount = value);
                        updateItemValues();
                      },
                      formKey: _formKey20,
                      initialValue: itemDiscount,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Tax"),
                    CustomField(
                      setValue: (value) {
                        setState(() => itemTax = value);
                        updateItemValues();
                      },
                      formKey: _formKey21,
                      controller: taxController,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Amount"),
                    CustomField(
                      setValue: (value) => setState(() => itemAmount = value),
                      formKey: _formKey22,
                      controller: amountController,
                      readOnly: true,
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        SizedBox(width: width * 0.7),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (int.parse(itemAmount == "" ? "0" : itemAmount) <
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
                                      "name": itemName,
                                      "qty": itemQty,
                                      "descrip": itemDescription,
                                      "rate": itemRate,
                                      "amt": itemAmount,
                                      "discount": itemDiscount,
                                      "tax": itemTax,
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
                          child: Text(addOrEdit ? "Add Entry" : "Edit Entry"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  int findItemIndex(String itemId) {
    int ans = 0;
    for (int i = 0; i < widget.itemList.length; i++) {
      if (widget.itemList[i]["id"] == itemId) {
        ans += i;
        break;
      }
    }
    return ans;
  }

  void updateItemValues() {
    int quantity = int.parse(itemQty == "" ? "0" : itemQty);
    int rate = int.parse(itemRate == "" ? "0" : itemRate);
    int discount = int.parse(itemDiscount == "" ? "0" : itemDiscount);
    int tax = int.parse(itemTax == "" ? "0" : itemTax);
    setState(() {
      itemAmount = (quantity * (rate * (1 - discount / 100)) * (1 + tax / 100))
          .toInt()
          .toString();
      amountController.text = itemAmount;
    });
  }

  DateTime dueDateCalc(DateTime orderDate, String term) {
    switch (term) {
      case "Cash":
        return orderDate;
      case "Current":
        return orderDate;
      default:
        int days = int.parse(term);
        return orderDate.add(Duration(days: days));
    }
  }

  void updateMainValues() {
    int oCharges = int.parse(otherCharges == "" ? "0" : otherCharges);
    int eDiscount = int.parse(extraDiscount == "" ? "0" : extraDiscount);

    int totalTax = 0;
    int totalSum = 0;

    for (int i = 0; i < items.length; i++) {
      int amt = int.parse(items[i]["amt"]);
      int tax = int.parse(items[i]["tax"]);
      totalTax += (amt * (tax / 100)).toInt();
      totalSum += amt;
    }

    setState(() {
      grandTotal = ((totalSum + oCharges) * (1 - eDiscount / 100)).toString();
      tax = totalTax.toString();

      gTotalController.text = grandTotal;
      totalTaxController.text = tax;
    });
  }
}
