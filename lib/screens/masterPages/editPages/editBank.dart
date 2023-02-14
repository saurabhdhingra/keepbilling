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

class EditBankMaster extends StatefulWidget {
  final Map data;

  const EditBankMaster({Key? key, required this.data}) : super(key: key);

  @override
  State<EditBankMaster> createState() => _EditBankMasterState();
}

class _EditBankMasterState extends State<EditBankMaster> {
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

  @override
  void initState() {
    super.initState();
    bankName = widget.data["bank_name"] ?? "";
    accountName = widget.data["account_name"] ?? "";
    accountNo = widget.data["account_no"] ?? "";
    bankBranch = widget.data["bank_branch"] ?? "";
    acType = widget.data["ac_type"] ?? "";
    acTypeIndex = acTypeValues.indexOf(widget.data["ac_type"] ?? "");
    bankIfsc = widget.data["bank_ifsc"] ?? "";
    bankMicr = widget.data["bank_micr"] ?? "";
    balance = widget.data["balance"] ?? "";
    defaultt = widget.data["def"] ?? "";
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
              const TitleText(text: "Edit Bank"),
              SizedBox(height: height * 0.02),
              const RowText(text: "Bank"),
              CustomField(
                setValue: (value) => setState(() => bankName = value),
                formKey: _formKey1,
                initialValue: widget.data["bank_name"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Account Name"),
              CustomField(
                setValue: (value) => setState(() => accountName = value),
                formKey: _formKey2,
                initialValue: widget.data["account_name"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Account No."),
              CustomField(
                setValue: (value) => setState(() => accountNo = value),
                formKey: _formKey3,
                initialValue: widget.data["account_no"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Branch"),
              CustomField(
                setValue: (value) => setState(() => bankBranch = value),
                formKey: _formKey4,
                initialValue: widget.data["bank_branch"] ?? "",
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
                scrollController:
                    FixedExtentScrollController(initialItem: acTypeIndex),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Bank IFSC"),
              CustomField(
                setValue: (value) => setState(() => bankIfsc = value),
                formKey: _formKey6,
                initialValue: widget.data["bank_ifsc"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Bank MICR"),
              CustomField(
                setValue: (value) => setState(() => bankMicr = value),
                formKey: _formKey7,
                initialValue: widget.data["bank_micr"] ?? "",
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
    final MasterService service = MasterService();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      return await service.editMaster({
        "userid": widget.data["user_id"],
        "companyid": widget.data["company_id"],
        "product": "1",
        "bank_id": widget.data["id"],
        "bank_name": bankName,
        "account_name": accountName,
        "account_no": accountNo,
        "bank_branch": bankBranch,
        "ac_type": acType,
        "bank_ifsc": bankIfsc,
        "bank_micr": bankMicr,
        "old_balance": widget.data["balance"],
        "balance": balance,
        "default": defaultt,
      }, "bank");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
