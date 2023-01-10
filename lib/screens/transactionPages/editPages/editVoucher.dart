import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/screens/transactionPages/voucher.dart';
import 'package:keepbilling/utils/functions.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/voucher.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/statusButton.dart';

class EditVoucherTransaction extends StatefulWidget {
  final List partyList;
  final List ledgerList;
  final Map data;
  const EditVoucherTransaction(
      {Key? key,
      required this.partyList,
      required this.ledgerList,
      required this.data})
      : super(key: key);

  @override
  State<EditVoucherTransaction> createState() => _EditVoucherTransactionState();
}

class _EditVoucherTransactionState extends State<EditVoucherTransaction> {
  String cashId = "";

  String amount = "";
  String gstApplicable = "";
  String ledger = "";
  int ledgerIndex = 0;
  String gstPercent = "";
  String narration = "";
  String party = "";
  int partyIndex = 0;
  String totalAmount = "";
  DateTime voucherDate = DateTime.now();

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();

  TextEditingController gstController = TextEditingController();
  TextEditingController tAmountController = TextEditingController();

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cashId = prefs.getString('cashId') ?? "";
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    amount = widget.data["amount"] ?? "";
    gstApplicable = widget.data["v_gst"] ?? "";
    ledger = widget.data["amount"] ?? "";
    ledgerIndex = findIndex(widget.ledgerList, ledger);
    gstPercent = widget.data["v_gstper"] ?? "";
    narration = widget.data["narration"] ?? "";
    party = widget.data["party_id"] ?? "";
    partyIndex = findIndex(widget.partyList, party);
    totalAmount = findTotalAmount();
    voucherDate = DateTime.parse(widget.data["trans_date"] ?? "2020-01-01");
    gstController = TextEditingController(text: widget.data["v_gstper"] ?? "");
    tAmountController = TextEditingController(text: totalAmount);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    gstController.dispose();
    tAmountController.dispose();
    super.dispose();
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
                  SizedBox(width: width * 0.8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  )
                ],
              ),
              const TitleText(text: "Add Voucher"),
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
                scrollController: FixedExtentScrollController(
                    initialItem:
                        findIndex(widget.partyList, widget.data["party_id"])),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Ledger"),
              DropdownSelector(
                setState: (value) => setState(() {
                  ledger = widget.ledgerList[value]["id"];
                  ledgerIndex = value;
                }),
                items: List.generate(widget.ledgerList.length,
                    (index) => widget.ledgerList[index]["ledger"]),
                dropDownValue: widget.ledgerList[partyIndex]["ledger"],
                scrollController: FixedExtentScrollController(
                    initialItem:
                        findIndex(widget.ledgerList, widget.data["acc_of"])),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Voucher Date"),
              CupertinoDateSelector(
                initialDate: voucherDate,
                setFunction: (value) => setState(() => voucherDate = value),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Amount"),
              CustomField(
                setValue: (value) {
                  setState(() => amount = value);
                  updateValues();
                },
                formKey: _formKey1,
                initialValue: widget.data["amount"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "GST Applicable"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatusButton(
                    isSelected: gstApplicable == "Yes" ? true : false,
                    setState: (String value) =>
                        setState(() => gstApplicable = "Yes"),
                    text: "Yes",
                  ),
                  StatusButton(
                    isSelected: gstApplicable == "No" ? true : false,
                    setState: (String value) => setState(() {
                      gstApplicable = "No";
                      gstController.text = "0";
                      gstPercent = "0";
                      updateValues();
                    }),
                    text: "No",
                  ),
                ],
              ),
              gstApplicable == "Yes"
                  ? SizedBox(height: height * 0.02)
                  : const SizedBox(),
              gstApplicable == "Yes"
                  ? const RowText(text: "GST %")
                  : const SizedBox(),
              gstApplicable == "Yes"
                  ? CustomField(
                      setValue: (value) {
                        setState(() => gstPercent = value);
                        updateValues();
                      },
                      formKey: _formKey3,
                      controller: gstController,
                    )
                  : const SizedBox(),
              SizedBox(height: height * 0.02),
              const RowText(text: "Total Amount"),
              CustomField(
                setValue: (value) => setState(() => totalAmount = value),
                formKey: _formKey6,
                readOnly: true,
                controller: tAmountController,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Narration"),
              CustomField(
                setValue: (value) => setState(() => narration = value),
                formKey: _formKey4,
                initialValue: widget.data["narration"] ?? "",
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.8),
                  TextButton(
                    onPressed: () {
                      add().then(
                        (value) {
                          print(value);
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

  void updateValues() async {
    double gst = double.parse(gstPercent == "" ? "0" : gstPercent);
    double amt = double.parse(amount == "" ? "0" : amount);
    double tAmount = (amt * (1 + gst / 100)).toDouble();
    setState(() {
      totalAmount = tAmount.toString();
      tAmountController.text = totalAmount;
    });
  }

  String findTotalAmount() {
    double tax = double.parse(gstPercent == "" ? "0" : gstPercent);
    double amouNt = double.parse(amount == "" ? "0" : amount);

    return (amouNt * (1.00 + tax / 100)).toString();
  }

  int findIndex(List list, String id) {
    int ans = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i]["id"] == id) {
        ans += i;
        break;
      }
    }
    return ans;
  }

  Future add() async {
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Processing"),
      ),
    );
    try {
      return await service.editTransaction({
        "userid": widget.data["user_id"],
        "companyid": widget.data["company_id"],
        "cash_id": cashId,
        "product": "1",
        "party": party,
        "id": widget.data["id"],
        "voucher_date": formatDate(voucherDate),
        "ledger": ledger,
        "amount": amount,
        "gst_applicable": gstApplicable,
        "gst_percent": gstPercent,
        "total_amount": totalAmount,
        "narration": narration
      }, "voucher");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
