import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/master.dart';
import '../../../model/party.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/statusButton.dart';
import '../../../widgets/formPages/submitButton.dart';

class AddPartyMaster extends StatefulWidget {
  final String product;
  final bool isTab;
  const AddPartyMaster({Key? key, required this.product, required this.isTab})
      : super(key: key);

  @override
  State<AddPartyMaster> createState() => _AddPartyMasterState();
}

class _AddPartyMasterState extends State<AddPartyMaster> {
  String userId = "";
  String companyId = "";

  String partyName = "";
  String partyAddress = "";
  String state = "";
  int stateIndex = 0;
  String pincode = "";
  String partyPhone = "";
  String partyMobile = "";
  String partyEmail1 = "";
  String partyEmail2 = "";
  String gstType = "";
  int gstIndex = 0;
  String partyGst = "";
  String pan = "";
  String pType = "";
  String openingBal = "";
  String deliveryAdd = "";
  String partnerLimit = "";
  String tds = "No";
  String tdsPercent = "";
  String paymentType = "";
  String payValue = "";
  String thirdParty = "";

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  // final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();
  final _formKey8 = GlobalKey<FormState>();
  // final _formKey9 = GlobalKey<FormState>();
  final _formKey10 = GlobalKey<FormState>();
  final _formKey11 = GlobalKey<FormState>();
  // final _formKey12 = GlobalKey<FormState>();
  final _formKey13 = GlobalKey<FormState>();
  final _formKey14 = GlobalKey<FormState>();
  final _formKey15 = GlobalKey<FormState>();
  // final _formKey16 = GlobalKey<FormState>();
  final _formKey17 = GlobalKey<FormState>();
  // final _formKey18 = GlobalKey<FormState>();
  // final _formKey19 = GlobalKey<FormState>();

  List gstTypes = ["Unselected", "Unregistered", "Regular", "Composite"];
  List gstTypesV = ["", "Unregistered", "Regular", "Composite"];

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
                  SizedBox(width: widget.isTab ? width * 0.9 : width * 0.8),
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
              const TitleText(text: "New Party"),
              SizedBox(height: height * 0.02),
              const RowText(text: "Party Name"),
              CustomField(
                setValue: (value) => setState(() => partyName = value),
                formKey: _formKey1,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Party Address"),
              CustomField(
                setValue: (value) => setState(() => partyAddress = value),
                formKey: _formKey2,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "State"),
              DropdownSelector(
                setState: (value) => setState(() {
                  state = states[value];
                  stateIndex = value;
                }),
                items: states,
                dropDownValue: states[stateIndex],
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Pincode"),
              CustomField(
                setValue: (value) => setState(() => pincode = value),
                formKey: _formKey4,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Mobile"),
              CustomField(
                setValue: (value) => setState(() => partyMobile = value),
                formKey: _formKey6,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (partyMobile != "" &&
                      !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                          .hasMatch(partyMobile)) {
                    return 'Please enter a valid mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Phone Number"),
              CustomField(
                setValue: (value) => setState(() => partyPhone = value),
                formKey: _formKey5,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (partyPhone != "" &&
                      !RegExp(r'((\+*)((0[ -]*)*|((91 )*))((\d{12})+|(\d{10})+))|\d{5}([- ]*)\d{6}')
                          .hasMatch(partyPhone)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              SizedBox(height: height * 0.02),
              const RowText(text: "Email"),
              CustomField(
                setValue: (value) => setState(() => partyEmail1 = value),
                formKey: _formKey7,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (partyEmail1 != "" &&
                      !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(partyEmail1)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              // SizedBox(height: height * 0.02),
              // const RowText(text: "Email 2"),
              // CustomField(
              //   setValue: (value) => setState(() => partyEmail2 = value),
              //   formKey: _formKey8,
              //   keyboardType: TextInputType.emailAddress,
              //   validator: (value) {
              //     if (partyEmail2 != "" &&
              //         !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
              //             .hasMatch(partyEmail2)) {
              //       return 'Please enter a valid email address';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: height * 0.02),
              const RowText(text: "GST Type"),
              DropdownSelector(
                setState: (value) {
                  if (gstTypesV[value] == "" ||
                      gstTypesV[value] == "Unregistered") {
                    setState(() {
                      partyGst = "";
                    });
                  }
                  setState(() {
                    gstType = gstTypesV[value];
                    gstIndex = value;
                  });
                },
                items: gstTypes,
                dropDownValue: gstTypes[gstIndex],
              ),
              gstType == "Regular" || gstType == "Composite"
                  ? SizedBox(height: height * 0.02)
                  : const SizedBox(),
              gstType == "Regular" || gstType == "Composite"
                  ? const RowText(text: "GST Number")
                  : const SizedBox(),
              gstType == "Regular" || gstType == "Composite"
                  ? CustomField(
                      setValue: (value) => setState(() => partyGst = value),
                      formKey: _formKey10,
                    )
                  : const SizedBox(),
              SizedBox(height: height * 0.02),
              const RowText(text: "PAN Number"),
              CustomField(
                setValue: (value) => setState(() => pan = value),
                formKey: _formKey11,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Partner Type"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatusButton(
                    isSelected: pType == "17" ? true : false,
                    setState: (String value) => setState(() => pType = "17"),
                    text: "Sundry\nCreditor",
                  ),
                  StatusButton(
                    isSelected: pType == "24" ? true : false,
                    setState: (String value) => setState(() => pType = "24"),
                    text: "Sundry\nDebtor",
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Opening Balance"),
              CustomField(
                setValue: (value) => setState(() => openingBal = value),
                formKey: _formKey13,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Delivery Address"),
              CustomField(
                setValue: (value) => setState(() => deliveryAdd = value),
                formKey: _formKey14,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Partner Limit"),
              CustomField(
                setValue: (value) => setState(() => partnerLimit = value),
                formKey: _formKey15,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "TDS"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatusButton(
                    isSelected: tds == "Yes" ? true : false,
                    setState: (String value) => setState(() => tds = "Yes"),
                    text: "Yes",
                  ),
                  StatusButton(
                    isSelected: tds == "No" ? true : false,
                    setState: (String value) => setState(
                      () {
                        tds = "No";
                        tdsPercent = "";
                      },
                    ),
                    text: "No",
                  ),
                ],
              ),
              tds == "Yes" ? SizedBox(height: height * 0.02) : const SizedBox(),
              tds == "Yes"
                  ? const RowText(text: "TDS Percent")
                  : const SizedBox(),
              tds == "Yes"
                  ? CustomField(
                      setValue: (value) => setState(() => tdsPercent = value),
                      formKey: _formKey17,
                      keyboardType: TextInputType.number,
                    )
                  : const SizedBox(),
              SizedBox(height: height * 0.02),
              // const RowText(text: "Payment Type"),
              // CustomField(
              //   setValue: (value) => setState(() => paymentType = value),
              //   formKey: _formKey18,
              // ),
              // SizedBox(height: height * 0.02),
              // const RowText(text: "Pay Value"),
              // CustomField(
              //   setValue: (value) => setState(() => payValue = value),
              //   formKey: _formKey19,
              // ),
              // SizedBox(height: height * 0.02),
              // const RowText(text: "Third Party"),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     StatusButton(
              //       isSelected: thirdParty == "Y" ? true : false,
              //       setState: (String value) =>
              //           setState(() => thirdParty = "Y"),
              //       text: "Yes",
              //     ),
              //     StatusButton(
              //       isSelected: thirdParty == "N" ? true : false,
              //       setState: (String value) =>
              //           setState(() => thirdParty = "N"),
              //       text: "No",
              //     ),
              //   ],
              // ),
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
      if (_formKey5.currentState!.validate() &&
          _formKey6.currentState!.validate() &&
          _formKey7.currentState!.validate() &&
          // _formKey8.currentState!.validate() &&
          stateIndex != 0) {
        return await service.addMaster(
            Party(
              userid: userId,
              companyid: companyId,
              deliveryAdd: deliveryAdd,
              gstType: gstType,
              openingBal: openingBal,
              pType: pType,
              pan: pan,
              partyEmail1: partyEmail1,
              partyEmail2: partyEmail2,
              product: widget.product,
              partyAddress: partyAddress,
              partnerlimit: partnerLimit,
              partyGst: partyGst,
              partyMobile: partyMobile,
              partyName: partyName,
              partyPhone: partyPhone,
              pincode: pincode,
              payValue: payValue,
              paymentType: paymentType,
              state: "$stateIndex",
              tds: tds,
              tdspercent: tdsPercent,
              thirdParty: thirdParty,
            ).toMap(),
            "party");
      } else if (_formKey5.currentState!.validate() &&
          _formKey6.currentState!.validate() &&
          _formKey7.currentState!.validate() &&
          // _formKey8.currentState!.validate() &&
          stateIndex == 0) {
        return {"type": "error", "message": "State is a mandatory field"};
      } else {
        return {"type": "error", "message": "Invalid Values"};
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
