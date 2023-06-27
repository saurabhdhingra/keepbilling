import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import 'package:provider/provider.dart';
import '../../../api/master.dart';
import '../../../api/transaction.dart';
import '../../../provider/authenticationProvider.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../utils/textFormatters/decimal.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/submitButton.dart';
import '../../loadingScreens.dart';

class PaymentPage extends StatefulWidget {
  final String partyId;
  final String partyName;
  final String billType;
  final bool receivable;
  final Map selected;

  const PaymentPage(
      {super.key,
      required this.partyId,
      required this.billType,
      required this.selected,
      required this.receivable,
      required this.partyName});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;
  List dataList = [];
  List partyList = [];
  List bankList = [];
  String partyName = "";

  List data = [];

  String paymentOpt = "";
  int paymentOptInd = 0;

  String companyId = "";
  String userId = "";
  String cashId = "";
  String product = "";

  double amount = 0;
  dynamic transferDate = DateTime.now();
  String comment = "";
  String bankName = "";
  String bankId = "";
  int bankNameInd = 0;
  String checqueNo = "";
  String partyBankName = "";
  int partyBankNameInd = 0;
  String branchName = "";

  List<String> paymentOpts = ["Unselected", "Cash", "Checque", "Online"];

  bool showEssentials = false;
  bool showSelectBank = false;
  bool showChecqueNo = false;
  bool showBranchName = false; // Only for Sale Page

  TextEditingController amountController = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  TransactionsService service = TransactionsService();
  MasterService serviceM = MasterService();

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    cashId = Provider.of<AuthenticationProvider>(context, listen: false).cashid;

    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
    try {
      dataList = await service.fetchOutstandingList(
          userId, companyId, product, widget.billType, widget.partyId);

      partyList =
          await serviceM.fetchDataList(userId, companyId, "party", product);
      bankList =
          await serviceM.fetchDataList(userId, companyId, "bank", product);
      bankName = bankList[0]["bank_name"];
      bankId = bankList[0]["id"];
      data = List.generate(
        dataList.length,
        (index) {
          return {
            "id": dataList[index]["id"],
            "selected": dataList[index]["id"] == widget.selected["id"],
            "party_name": partyName,
            "user_id": userId,
            "party_id": widget.partyId,
            "inv_no": dataList[index]["invoice_date"],
            "inv_date": dataList[index]["invoice_date"],
            "tds": false,
            "tds_round": false,
            "tds_percent": 0.0,
            "amount": dataList[index]["amount"],
            "base_amount": double.parse(dataList[index]["base_amount"]),
            "tax_amount": dataList[index]["tax_amount"],
            "bill_type": dataList[index]["bill_type"],
            "flag": dataList[index]["flag"],
            "company_id": companyId,
            "callid": dataList[index]["callid"],
          };
        },
      );
    } catch (e) {
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
    partyName = widget.partyName;
    amount = double.parse(widget.selected["amount"]);
    amountController.text = widget.selected["amount"];

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  List banks = ["IDBI", "HDFC"];

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return isLoading
        ? infoLoading(context)
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Amount : $amount",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: width * 0.05),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    ...data.map((e) {
                      return receit(e, data.indexOf(e), width, height);
                    }),
                    // Flexible(
                    //   fit: FlexFit.loose,
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: DataTable(
                    //       columns: <DataColumn>[
                    //         customDataColumn('Select'),
                    //         customDataColumn('#'),
                    //         customDataColumn('Party Name'),
                    //         customDataColumn('Invoice Number'),
                    //         customDataColumn('Invoice Date'),
                    //         customDataColumn('Amount'),
                    //         customDataColumn('TDS'),
                    //         customDataColumn('TDS Percent'),
                    //         customDataColumn('Round of TDS'),
                    //       ],
                    //       rows: List.generate(
                    //         data.length,
                    //         (index) {
                    //           return customDataRow(data[index], index);
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Payment Option"),
                    DropdownSelector(
                      setState: (value) {
                        setState(() {
                          paymentOpt = paymentOpts[value];
                          paymentOptInd = value;
                        });
                        setFields();
                      },
                      items: List.generate(4, (index) => paymentOpts[index]),
                      dropDownValue: paymentOpts[paymentOptInd],
                    ),
                    showEssentials
                        ? SizedBox(height: height * 0.02)
                        : const SizedBox(),
                    showEssentials
                        ? const RowText(text: "Enter Amount")
                        : const SizedBox(),
                    showEssentials
                        ? CustomField(
                            setValue: (value) =>
                                setState(() => amount = double.parse(value)),
                            formKey: _formKey1,
                            controller: amountController,
                          )
                        : const SizedBox(),
                    showEssentials
                        ? SizedBox(height: height * 0.02)
                        : const SizedBox(),
                    showEssentials
                        ? RowText(
                            text: showChecqueNo
                                ? "Checque Date"
                                : "Transfer Date")
                        : const SizedBox(),
                    showEssentials
                        ? CupertinoDateSelector(
                            initialDate: DateTime.now(),
                            setFunction: (value) =>
                                setState(() => transferDate = value),
                            showReset: false,
                          )
                        : const SizedBox(),
                    showEssentials
                        ? SizedBox(height: height * 0.02)
                        : const SizedBox(),
                    showEssentials
                        ? const RowText(text: "Comment")
                        : const SizedBox(),
                    showEssentials
                        ? CustomField(
                            setValue: (value) =>
                                setState(() => comment = value),
                            formKey: _formKey2,
                          )
                        : const SizedBox(),
                    showSelectBank
                        ? SizedBox(height: height * 0.02)
                        : const SizedBox(),
                    showSelectBank
                        ? const RowText(text: "Select Bank")
                        : const SizedBox(),
                    showSelectBank
                        ? DropdownSelector(
                            setState: (value) => setState(() {
                              bankName = bankList[value]["bank_name"];
                              bankId = bankList[value]["id"];
                              bankNameInd = value;
                            }),
                            items: List.generate(banks.length,
                                (index) => bankList[index]["bank_name"]),
                            dropDownValue: bankList[bankNameInd]["bank_name"],
                          )
                        : const SizedBox(),
                    showChecqueNo && widget.receivable
                        ? SizedBox(height: height * 0.02)
                        : const SizedBox(),
                    showChecqueNo && widget.receivable
                        ? const RowText(text: "Branch Name")
                        : const SizedBox(),
                    showChecqueNo && widget.receivable
                        ? CustomField(
                            setValue: (value) =>
                                setState(() => branchName = value),
                            formKey: _formKey3,
                          )
                        : const SizedBox(),
                    showChecqueNo
                        ? SizedBox(height: height * 0.02)
                        : const SizedBox(),
                    showChecqueNo
                        ? const RowText(text: "Enter Cheque/UTR No")
                        : const SizedBox(),
                    showChecqueNo
                        ? CustomField(
                            setValue: (value) =>
                                setState(() => checqueNo = value),
                            formKey: _formKey4,
                          )
                        : const SizedBox(),
                    showChecqueNo && widget.receivable
                        ? SizedBox(height: height * 0.02)
                        : const SizedBox(),
                    showChecqueNo && widget.receivable
                        ? const RowText(text: "Party Bank")
                        : const SizedBox(),
                    showChecqueNo && widget.receivable
                        ? DropdownSelector(
                            setState: (value) => setState(() {
                              partyBankName = banks[value];
                              partyBankNameInd = value;
                            }),
                            items: List.generate(
                                banks.length, (index) => banks[index]),
                            dropDownValue: banks[bankNameInd],
                          )
                        : const SizedBox(),
                    showEssentials
                        ? SizedBox(height: height * 0.02)
                        : const SizedBox(),
                    showEssentials
                        ? SubmitButton(
                            onSubmit: () {
                              add().then(
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
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
  }

  Future add() async {
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      return await service.addPayment(createPostData());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Map createPostData() {
    List<String> roundtdsOff = [];
    List<String> tds = [];
    List<String> tdsPercent = [];
    List<String> bills = [];
    List<String> billTypes = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i]["selected"]) {
        roundtdsOff.add(data[i]["tds_round"] && data[i]["tds"] ? "on" : "off");
        tds.add(data[i]["tds"] ? "yes" : "no");
        tdsPercent.add(data[i]["tds_percent"].toString());
        bills.add(data[i]["id"]);
        billTypes.add(data[i]["bill_type"]);
      }
    }
    return {
      "userid": userId,
      "companyid": companyId,
      "cash_id": cashId,
      "product": product,
      "pay_type": "bill",
      "bill_type": widget.billType,
      "party_id": widget.partyId,
      "total_amount": amount.toString(),
      "via": paymentOpt,
      "party_bank": partyBankName,
      "bank_name": bankId,
      "chq_date": formatDate(transferDate),
      "input_date": formatDate(DateTime.now()),
      "chq_no": checqueNo,
      "branch": branchName,
      "comment": comment,
      "allLdgr": "",
      "roundtds_off": roundtdsOff,
      "tds": tds,
      "tdspercent": tdsPercent,
      "bills": bills,
      "multi_billtype": billTypes
    };
  }

  void setFields() {
    switch (paymentOpt) {
      case "Unselected":
        setState(() {
          showEssentials = false;
          showSelectBank = false;
          showChecqueNo = false;
          showBranchName = false;
        });
        return;
      case "Cash":
        setState(() {
          showEssentials = true;
          showSelectBank = false;
          showChecqueNo = false;
          showBranchName = false;
        });
        return;
      case "Checque":
        setState(() {
          showEssentials = true;
          showSelectBank = true;
          showChecqueNo = true;
          showBranchName = true;
        });
        return;
      case "Online":
        setState(() {
          showEssentials = true;
          showSelectBank = true;
          showChecqueNo = false;
          showBranchName = false;
        });
        return;
    }
  }

  Widget receit(Map rowData, int index, double width, double height) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return ScreenTypeLayout(
      mobile: Padding(
        padding: EdgeInsets.fromLTRB(width * 0.02, 0, width * 0.02, 0),
        child: Theme(
          data: theme,
          child: ExpansionTile(
            leading: IconButton(
              icon: rowData["selected"]
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
              onPressed: () {
                setState(() {
                  data[index]["selected"] = !data[index]["selected"];
                });
                updateAmount();
              },
            ),
            title: Text(
              rowData["party_name"],
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text("Amount : ${rowData["amount"]}"),
            textColor: Colors.black87,
            iconColor: Colors.black87,
            expandedAlignment: Alignment.centerLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: width * 0.07),
                  Text("Invoice No. : ${rowData["party_name"]}")
                ],
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.07),
                  Text("Invoice Date : ${rowData["inv_date"]}"),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.07),
                  const Text("TDS :"),
                  IconButton(
                    icon: rowData["tds"]
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        data[index]["tds"] = !data[index]["tds"];
                      });
                    },
                  ),
                  SizedBox(
                    width: width * 0.3,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      onChanged: (value) {
                        setState(() =>
                            data[index]["tds_percent"] = double.parse(value));
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Platform.isIOS
                            ? const Color.fromRGBO(235, 235, 235, 1)
                            : Colors.white,
                        border: Platform.isIOS
                            ? const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))
                            : const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                        hintText: "0.00",
                      ),
                    ),
                  )
                ],
              ),
              // Row(
              //   children: [
              //     SizedBox(width: width * 0.07),
              //     const Text("TDS Round ? : "),
              //     IconButton(
              //       icon: rowData["tds_round"]
              //           ? const Icon(Icons.check_box)
              //           : const Icon(Icons.check_box_outline_blank),
              //       onPressed: () {
              //         setState(() {
              //           data[index]["tds_round"] = !data[index]["tds_round"];
              //         });
              //       },
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
      tablet: Padding(
        padding: EdgeInsets.fromLTRB(width * 0.065, 0, width * 0.065, 0),
        child: Theme(
          data: theme,
          child: ExpansionTile(
            leading: IconButton(
              icon: rowData["selected"]
                  ? const Icon(Icons.check_box, size: 35)
                  : const Icon(Icons.check_box_outline_blank, size: 35),
              onPressed: () {
                setState(() {
                  data[index]["selected"] = !data[index]["selected"];
                });
                updateAmount();
              },
            ),
            title: Text(
              rowData["party_name"],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: height * 0.025),
            ),
            subtitle: Text("Amount : ${rowData["amount"]}",
                style: TextStyle(fontSize: height * 0.02)),
            textColor: Colors.black87,
            iconColor: Colors.black87,
            expandedAlignment: Alignment.centerLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: width * 0.07),
                  Text("Invoice No. : ${rowData["party_name"]}",
                      style: TextStyle(fontSize: height * 0.017))
                ],
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.07),
                  Text("Invoice Date : ${rowData["inv_date"]}",
                      style: TextStyle(fontSize: height * 0.017)),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.05),
                  IconButton(
                    icon: rowData["tds"]
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        data[index]["tds"] = !data[index]["tds"];
                      });
                      updateAmount();
                    },
                  ),
                  Text("TDS ", style: TextStyle(fontSize: height * 0.017)),
                  SizedBox(width: width * 0.35),
                  SizedBox(
                    width: width * 0.3,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: height * 0.017),
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      onChanged: (value) {
                        setState(() =>
                            data[index]["tds_percent"] = double.parse(value));
                        updateAmount();
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Platform.isIOS
                            ? const Color.fromRGBO(235, 235, 235, 1)
                            : Colors.white,
                        border: Platform.isIOS
                            ? const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))
                            : const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                        hintText: "0.00",
                      ),
                    ),
                  )
                ],
              ),
              // Row(
              //   children: [
              //     SizedBox(width: width * 0.07),
              //     const Text("TDS Round ? : "),
              //     IconButton(
              //       icon: rowData["tds_round"]
              //           ? const Icon(Icons.check_box)
              //           : const Icon(Icons.check_box_outline_blank),
              //       onPressed: () {
              //         setState(() {
              //           data[index]["tds_round"] = !data[index]["tds_round"];
              //         });
              //       },
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  // DataRow customDataRow(Map rowData, int index) {
  //   return DataRow(
  //     cells: <DataCell>[
  //       DataCell(IconButton(
  //         icon: rowData["selected"]
  //             ? const Icon(Icons.check_box)
  //             : const Icon(Icons.check_box_outline_blank),
  //         onPressed: () {
  //           setState(() {
  //             data[index]["selected"] = !data[index]["selected"];
  //           });
  //         },
  //       )),
  //       DataCell(Text((index + 1).toString())),
  //       DataCell(Text(rowData["party_name"].toString())),
  //       DataCell(Text(rowData["inv_no"].toString())),
  //       DataCell(Text(rowData["inv_date"].toString())),
  //       DataCell(Text(rowData["amount"].toString())),
  //       DataCell(IconButton(
  //         icon: rowData["tds"]
  //             ? const Icon(Icons.check_box)
  //             : const Icon(Icons.check_box_outline_blank),
  //         onPressed: () {
  //           setState(() {
  //             data[index]["tds"] = !data[index]["tds"];
  //             data[index]["tds_percent"] = 0;
  //           });
  //         },
  //       )),
  //       DataCell(tdsInput(index)),
  //       DataCell(IconButton(
  //         icon: rowData["tds_round"]
  //             ? const Icon(Icons.check_box)
  //             : const Icon(Icons.check_box_outline_blank),
  //         onPressed: () {
  //           setState(() {
  //             data[index]["tds_round"] = !data[index]["tds_round"];
  //           });
  //         },
  //       )),
  //     ],
  //   );
  // }

  // Widget tdsInput(int index, double width) {

  // return Row(
  //   children: [
  //     IconButton(
  //       onPressed: () {
  //         setState(() {
  //           data[index]["tds_percent"]++;
  //         });
  //       },
  //       icon: const Icon(Icons.add),
  //     ),
  //     IconButton(
  //       onPressed: () {
  //         setState(() {
  //           data[index]["tds_percent"] += 0.1;
  //         });
  //       },
  //       icon: const Icon(Icons.add, color: Colors.red),
  //     ),
  //     const SizedBox(width: 3),
  //     Text(data[index]["tds_percent"].toString()),
  //     const SizedBox(width: 3),
  //     IconButton(
  //       onPressed: () {
  //         setState(() {
  //           if (data[index]["tds_percent"] > 0) {
  //             data[index]["tds_percent"] -= 0.1;
  //           }
  //         });
  //       },
  //       icon: const Icon(CupertinoIcons.minus, color: Colors.red),
  //     ),
  //     IconButton(
  //       onPressed: () {
  //         setState(() {
  //           if (data[index]["tds_percent"] > 0) data[index]["tds_percent"]--;
  //         });
  //       },
  //       icon: const Icon(CupertinoIcons.minus),
  //     ),
  //   ],
  // );
  // }

  void updateAmount() {
    double temp = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i]["selected"]) {
        if (data[i]["tds"]) {
          temp += (data[i]["base_amount"] * (1 - data[i]["tds_percent"] / 100) +
              data[i]["tax_amount"]);
        } else {
          temp += data[i]["base_amount"] + data[i]["tax_amount"];
        }
      }
    }
    setState(() {
      amount = temp;
      amountController.text = temp.toString();
    });
  }

  DataColumn customDataColumn(String text) {
    return DataColumn(
      label: Expanded(
        child: Text(
          text,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
