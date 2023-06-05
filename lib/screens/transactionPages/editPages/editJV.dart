import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/transaction.dart';
import '../../../model/journalVoucher.dart';
import '../../../responsive/screen_type_layout.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/itemExpansionTile.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/submitButton.dart';

class EditJVTransaction extends StatefulWidget {
  final Map data;
  final List jvInput;
  final String product;
  const EditJVTransaction({Key? key, required this.data, required this.jvInput, required this.product})
      : super(key: key);

  @override
  State<EditJVTransaction> createState() => _EditJVTransactionState();
}

class _EditJVTransactionState extends State<EditJVTransaction> {
  String cashId = "";

  String jvNo = "";
  dynamic transferDate = "";
  String narration = "";
  String credit = "";
  int creditIndex = 0;
  String debit = "";
  int debitIndex = 0;
  String amount = "";

  List<Map> jvEntryList = [];

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cashId = prefs.getString('cashId') ?? "";
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    jvNo = widget.data["invoice_no"] ?? "";
    narration = widget.data["narration"] ?? "";
    amount = widget.data["amount"] ?? "";
    transferDate = DateTime.parse(widget.data["trans_date"]);
    credit = widget.data["c_type"] + "-" + widget.data["c_id"];
    debit = widget.data["d_type"] + "-" + widget.data["d_id"];
    creditIndex =
        findJVInputIndex(widget.data["c_type"] + "-" + widget.data["c_id"]);
    debitIndex =
        findJVInputIndex(widget.data["d_type"] + "-" + widget.data["d_id"]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
              const TitleText(text: "Edit Journal Voucher"),
              SizedBox(height: height * 0.02),
              const RowText(text: "JV no"),
              CustomField(
                setValue: (value) => setState(() => jvNo = value),
                formKey: _formKey1,
                readOnly: true,
                initialValue: widget.data["invoice_no"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Credit"),
              DropdownSelector(
                setState: (value) => setState(() {
                  credit = widget.jvInput[value]["id"];
                  creditIndex = value;
                }),
                items: List.generate(widget.jvInput.length,
                    (index) => widget.jvInput[index]["name"]),
                dropDownValue: widget.jvInput[creditIndex]["name"],
                scrollController:
                    FixedExtentScrollController(initialItem: creditIndex),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Debit"),
              DropdownSelector(
                setState: (value) => setState(() {
                  debit = widget.jvInput[value]["id"];
                  debitIndex = value;
                }),
                items: List.generate(widget.jvInput.length,
                    (index) => widget.jvInput[index]["name"]),
                dropDownValue: widget.jvInput[debitIndex]["name"],
                scrollController:
                    FixedExtentScrollController(initialItem: debitIndex),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Transfer Date"),
              CupertinoDateSelector(
                initialDate: transferDate,
                setFunction: (value) => setState(() => transferDate = value),
                showReset: false,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Amount"),
              CustomField(
                setValue: (value) => setState(() => amount = value),
                formKey: _formKey3,
                initialValue: widget.data["amount"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Narration"),
              CustomField(
                setValue: (value) => setState(() => narration = value),
                formKey: _formKey2,
                initialValue: widget.data["narration"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              SubmitButton(
                text: "Edit Entry",
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

  Future edit() async {
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
        "product": widget.product,
        "id": widget.data["id"],
        "transfer_date":
            transferDate == "" ? transferDate : formatDate(transferDate),
        "amount": amount,
        "credit": credit,
        "debit": debit,
        "narration": narration
      }, "jv");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  int findJVInputIndex(String jvId) {
    int ans = 1;
    for (int i = 0; i < widget.jvInput.length; i++) {
      if (widget.jvInput[i]["id"] == jvId) {
        ans += i;
        break;
      }
    }
    return ans;
  }
}
