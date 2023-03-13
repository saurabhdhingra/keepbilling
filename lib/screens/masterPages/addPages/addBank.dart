import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/model/bank.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/statusButton.dart';
import '../../../widgets/formPages/submitButton.dart';
import '../bank.dart';

class AddBankMaster extends StatefulWidget {
  final String product;
  const AddBankMaster({Key? key, required this.product}) : super(key: key);

  @override
  State<AddBankMaster> createState() => _AddBankMasterState();
}

class _AddBankMasterState extends State<AddBankMaster> {
  String userId = "";
  String companyId = "";

  String bankName = "";
  String accountName = "";
  String accountNo = "";
  String bankBranch = "";
  String acType = "";
  int acTypeIndex = 0;
  String bankIfsc = "";
  String bankMicr = "";
  String balance = "";
  String defaultt = "";

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();
  final _formKey8 = GlobalKey<FormState>();

  List acTypeValues = [
    "",
    "Credit",
    "Overdraft",
    "Savings",
    "Current",
  ];
  List acTypeList = [
    "Unselected",
    "Credit Current",
    "Overdraft",
    "Savings",
    "Current",
  ];

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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
                  SizedBox(width: width * 0.8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  )
                ],
              ),
              const TitleText(text: "New Bank"),
              SizedBox(height: height * 0.02),
              const RowText(text: "Bank"),
              CustomField(
                setValue: (value) => setState(() => bankName = value),
                formKey: _formKey1,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Account Name"),
              CustomField(
                setValue: (value) => setState(() => accountName = value),
                formKey: _formKey2,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Account No."),
              CustomField(
                setValue: (value) => setState(() => accountNo = value),
                formKey: _formKey3,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Branch"),
              CustomField(
                setValue: (value) => setState(() => bankBranch = value),
                formKey: _formKey4,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Account Type"),
              DropdownSelector(
                setState: (value) => setState(() {
                  acType = acTypeValues[value];
                  acTypeIndex = value;
                }),
                items: List.generate(
                    acTypeValues.length, (index) => acTypeList[index]),
                dropDownValue: acTypeList[acTypeIndex],
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Bank IFSC"),
              CustomField(
                setValue: (value) => setState(() => bankIfsc = value),
                formKey: _formKey6,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Bank MICR"),
              CustomField(
                setValue: (value) => setState(() => bankMicr = value),
                formKey: _formKey7,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Opening Balance"),
              CustomField(
                setValue: (value) => setState(() => balance = value),
                formKey: _formKey8,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Set as default ? "),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatusButton(
                    isSelected: defaultt == "Y" ? true : false,
                    setState: (String value) => setState(() => defaultt = "Y"),
                    text: "Yes",
                  ),
                  StatusButton(
                    isSelected: defaultt == "N" ? true : false,
                    setState: (String value) => setState(() => defaultt = "N"),
                    text: "No",
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              SubmitButton(
                onSubmit: () {
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
        Bank(
          userid: userId,
          companyid: companyId,
          acType: acType,
          accountName: accountName,
          accountNo: accountNo,
          balance: balance,
          bankBranch: bankBranch,
          bankDefault: defaultt,
          bankIfsc: bankIfsc,
          bankName: bankName,
          bankMicr: bankMicr,
          product: widget.product,
        ).toMap(),
        "bank",
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
