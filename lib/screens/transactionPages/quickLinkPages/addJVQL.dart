import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/transaction.dart';
import '../../../model/journalVoucher.dart';
import '../../../provider/authenticationProvider.dart';
import '../../../responsive/screen_type_layout.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../widgets/formPages/datePicker.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/itemExpansionTile.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/submitButton.dart';
import '../../loadingScreens.dart';

class AddJVTransactionQL extends StatefulWidget {
  const AddJVTransactionQL({Key? key}) : super(key: key);

  @override
  State<AddJVTransactionQL> createState() => _AddJVTransactionQLState();
}

class _AddJVTransactionQLState extends State<AddJVTransactionQL> {
  bool isLoading = false;

  String userId = "";
  String companyId = "";
  String cashId = "";
  String product = "";
  List jvInput = [];
  String jvNoAPI = "";
  int jvNum = 0;

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

  TextEditingController jvNoController = TextEditingController();
  TextEditingController amountController = TextEditingController(text: "0");
  TextEditingController narrationController = TextEditingController();

  FixedExtentScrollController creditController = FixedExtentScrollController();
  FixedExtentScrollController debitController = FixedExtentScrollController();

  final Map propeties = {
    "title": "narration",
    "subtitle": "amount",
    "entries": [
      {"fieldName": "Journal Voucher no.", "fieldValue": "jv_no"},
      {"fieldName": "Transfer Date", "fieldValue": "transfer_date"},
      {"fieldName": "Credit", "fieldValue": "credit"},
      {"fieldName": "Debit", "fieldValue": "debit"},
    ]
  };

  TransactionsService service = TransactionsService();

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    cashId = Provider.of<AuthenticationProvider>(context, listen: false).cashid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
    try {
      jvNoAPI = await service.fetchJVInvNo(userId, companyId,product);
      jvNum = int.parse(jvNoAPI);
      jvInput = await service.fetchDataList("jv_input", userId, companyId, product);
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return isLoading
        ? quickLinksLoading(context, 5, "Create Bill")
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
                    const TitleText(text: "New Journal Voucher"),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Item Array"),
                    ...jvEntryList.map(
                      (e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                          child: Theme(
                            data: theme,
                            child: ItemExpansionTile(
                              data: e,
                              properties: propeties,
                              deleteFunc: () =>
                                  setState(() => jvEntryList.remove(e)),
                              updateFunc: () {
                                setState(() {
                                  jvNo = e["jv_no"];
                                  transferDate =
                                      DateTime.parse(e["transfer_date"]);
                                  narration = e["narration"];
                                  credit = e["credit"];
                                  creditIndex = findJVInputIndex(e["credit"]);
                                  debit = e["debit"];
                                  debitIndex = findJVInputIndex(e["debit"]);
                                  amount = e["amount"];
                                  amountController.text = e["amount"];
                                  narrationController.text = e["narration"];
                                });
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  enableDrag: false,
                                  isDismissible: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => addOrEditEntry(
                                      context,
                                      (Map value) => setState(() =>
                                          jvEntryList = [
                                            ...jvEntryList,
                                            value
                                          ]),
                                      false,
                                      creditIndex,
                                      debitIndex,
                                      DateTime.parse(e["transfer_date"])),
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
                          setJvNo();
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: false,
                            isDismissible: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => addOrEditEntry(
                                context,
                                (Map value) => setState(() =>
                                    jvEntryList = [...jvEntryList, value]),
                                true,
                                0,
                                0,
                                DateTime.now()),
                          );
                        },
                        child: const Text("Add item"),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    SubmitButton(
                      text: "Add Entry",
                      onSubmit: () {
                        add().then(
                          (value) {
                            if(value == null){
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error with placing request. Please try again."),
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

  Future add() async {
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Processing"),
      ),
    );
    try {
      return await service.addJournalVoucher(
        JournalVoucher(
          userid: userId,
          companyid: companyId,
          product: product,
          cashId: cashId,
          jvEntry: jvArray(jvEntryList),
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

  void setJvNo() {
    setState(() {
      jvNo = (jvNum + jvEntryList.length).toString();
      jvNoController.text = jvNo;
    });
  }

  int findJVInputIndex(String jvId) {
    int ans = 1;
    for (int i = 0; i < jvInput.length; i++) {
      if (jvInput[i]["id"] == jvId) {
        ans += i;
        break;
      }
    }
    return ans;
  }

  Widget addOrEditEntry(context, Function(Map) function, bool addOrEdit,
      int creditInd, int debitInd, dynamic currentDate) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          builder: (_, controller) {
            var height = SizeConfig.getHeight(context);
            var width = SizeConfig.getWidth(context);
            List jvInputList = [
              {"id": "", "name": "Unselected"},
              ...jvInput
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
                              jvNo = "";
                              transferDate = DateTime.now();
                              narration = "";
                              narrationController.text = "";
                              credit = "";
                              creditController.animateTo(0,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.decelerate);
                              debit = "";
                              debitController.animateTo(0,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.decelerate);
                            },
                          );
                        },
                      ),
                    ),
                    const RowText(text: "JV no"),
                    CustomField(
                      setValue: (value) => setState(() => jvNo = value),
                      formKey: _formKey1,
                      readOnly: true,
                      controller: jvNoController,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Credit"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        credit = jvInputList[value]["id"];
                        creditIndex = value;
                      }),
                      items: List.generate(jvInputList.length,
                          (index) => jvInputList[index]["name"]),
                      dropDownValue: jvInputList[creditInd]["name"],
                      scrollController:
                          FixedExtentScrollController(initialItem: creditInd),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Debit"),
                    DropdownSelector(
                      setState: (value) => setState(() {
                        debit = jvInputList[value]["id"];
                        debitIndex = value;
                      }),
                      items: List.generate(jvInputList.length,
                          (index) => jvInputList[index]["name"]),
                      dropDownValue: jvInputList[debitInd]["name"],
                      scrollController:
                          FixedExtentScrollController(initialItem: debitInd),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Transfer Date"),
                    CupertinoDateSelector(
                      initialDate: DateTime.now(),
                      setFunction: (value) =>
                          setState(() => transferDate = value),
                      reset: () => setState(() => transferDate = ""),
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Amount"),
                    CustomField(
                      setValue: (value) => setState(() => amount = value),
                      formKey: _formKey3,
                      controller: amountController,
                    ),
                    SizedBox(height: height * 0.02),
                    const RowText(text: "Narration"),
                    CustomField(
                      setValue: (value) => setState(() => narration = value),
                      formKey: _formKey2,
                      controller: narrationController,
                    ),
                    SizedBox(height: height * 0.02),
                    SubmitButton(
                      text: addOrEdit ? "Add Entry" : "Edit Entry",
                      onSubmit: () {
                        
                        if (credit == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Credit is a mandatory field."),
                            ),
                          );
                        } else if (debit == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Debit is a mandatory field."),
                            ),
                          );
                        } else if (amount == "" || amount == "0") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Amount can't be zero."),
                            ),
                          );
                        } else if (credit == debit) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Same Credit and Debit values are not allowed."),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          setState(
                            () {
                              function(
                                {
                                  "jv_no": jvNo,
                                  "transfer_date": transferDate == ""
                                      ? transferDate
                                      : formatDate(transferDate),
                                  "amount": amount,
                                  "credit": credit,
                                  "debit": debit,
                                  "narration": narration,
                                },
                              );
                              jvNo = "";
                              transferDate = "";
                              narrationController.text = "";
                              amountController.text = "";
                              narration = "";
                              credit = "";
                              debit = "";
                            },
                          );
                        }
                      },
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
}
