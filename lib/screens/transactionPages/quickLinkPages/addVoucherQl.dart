import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/screens/transactionPages/voucher.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/master.dart';
import '../../../model/voucher.dart';
import '../../../provider/authenticationProvider.dart';
import '../../../responsive/screen_type_layout.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/statusButton.dart';
import '../../../widgets/formPages/submitButton.dart';
import '../../loadingScreens.dart';

class AddVoucherTransactionQL extends StatefulWidget {
  const AddVoucherTransactionQL({Key? key}) : super(key: key);

  @override
  State<AddVoucherTransactionQL> createState() =>
      _AddVoucherTransactionQLState();
}

class _AddVoucherTransactionQLState extends State<AddVoucherTransactionQL> {
  bool isLoading = false;

  String userId = "";
  String companyId = "";
  String cashId = "";
  String product = "";

  List partyList = [];
  List ledgers = [];

  String amount = '';
  String gstApplicable = "";
  String ledger = "";
  int ledgerIndex = 0;
  String gstPercent = "";
  String narration = "";
  String party = "";
  int partyIndex = 0;
  String totalAmount = "";
  dynamic voucherDate = DateTime.now();

  final _formKey1 = GlobalKey<FormState>();
  // final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  // final _formKey5 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  // final _formKey7 = GlobalKey<FormState>();

  TextEditingController gstController = TextEditingController(text: "0");
  TextEditingController tAmountController = TextEditingController(text: "0");

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
      ledgers = await service.fetchLedgerList(userId, companyId, product);
      partyList =
          await serviceM.fetchDataList(userId, companyId, "party", product);
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
    List parties = [
      {"id": "", "party_name": "Unselected"},
      ...partyList
    ];
    List ledgerList = [
      {"id": "", "ledger": "Unselected"},
      ...ledgers
    ];

    return isLoading
        ? quickLinksLoading(context, 5, "New Voucher")
        : Scaffold(
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
                    const TitleText(text: "New Voucher"),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Party"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        party = parties[value]["id"];
                        partyIndex = value;
                      }),
                      items: List.generate(parties.length,
                          (index) => parties[index]["party_name"]),
                      dropDownValue: parties[partyIndex]["party_name"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Ledger"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        ledger = ledgerList[value]["id"];
                        ledgerIndex = value;
                      }),
                      items: List.generate(ledgerList.length,
                          (index) => ledgerList[index]["ledger"]),
                      dropDownValue: ledgerList[ledgerIndex]["ledger"],
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Voucher Date"),
                    CupertinoDateSelector(
                      initialDate: DateTime.now(),
                      setFunction: (value) =>
                          setState(() => voucherDate = value),
                      reset: () => setState(() => voucherDate = ""),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Amount"),
                    CustomField(
                      setValue: (value) {
                        setState(() => amount = value);
                        updateValues();
                      },
                      formKey: _formKey1,
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
                          isSelected: gstApplicable == "N" ? true : false,
                          setState: (String value) => setState(() {
                            gstApplicable = "N";
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
                    ),
                    SizedBox(height: height * 0.02),
                    SubmitButton(
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

  Future add() async {
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Processing"),
      ),
    );
    try {
      return await service.addVoucher(Voucher(
        userid: userId,
        companyid: companyId,
        product: product,
        cashId: cashId,
        amount: amount,
        gstApplicable: gstApplicable,
        ledger: ledger,
        gstPercent: gstPercent,
        narration: narration,
        party: party,
        totalAmount: totalAmount,
        voucherDate: voucherDate == "" ? voucherDate : formatDate(voucherDate),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
