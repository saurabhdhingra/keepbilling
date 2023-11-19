
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/widgets/formPages/titleText.dart';
import '../../../api/master.dart';
import '../../../responsive/screen_type_layout.dart';
import '../../../utils/constants.dart';
import '../../../widgets/formPages/dropdownSelector.dart';
import '../../../widgets/formPages/customField.dart';
import '../../../widgets/formPages/rowText.dart';
import '../../../widgets/formPages/statusButton.dart';
import '../../../widgets/formPages/submitButton.dart';

class EditPartyMaster extends StatefulWidget {
  final Map data;
  final String product;
  
  const EditPartyMaster(
      {Key? key,
      required this.data,
      required this.product,
      })
      : super(key: key);

  @override
  State<EditPartyMaster> createState() => _EditPartyMasterState();
}

class _EditPartyMasterState extends State<EditPartyMaster> {
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
  String tds = "";
  String tdsPercent = "";
  String paymentType = "";
  String payValue = "";
  String thirdParty = "";

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();
  final _formKey8 = GlobalKey<FormState>();
  final _formKey10 = GlobalKey<FormState>();
  final _formKey11 = GlobalKey<FormState>();
  final _formKey13 = GlobalKey<FormState>();
  final _formKey14 = GlobalKey<FormState>();
  final _formKey15 = GlobalKey<FormState>();
  final _formKey17 = GlobalKey<FormState>();

  List gstTypes = ["Unselected", "Composite", "Unregistered", "Regular"];
  List gstTypesV = ["", "Composite", "Unregistered", "Regular"];

  @override
  void initState() {
    super.initState();
    partyName = widget.data["party_name"] ?? "";
    partyAddress = widget.data["party_address"] ?? "";
    state = widget.data["state"] ?? "";
    stateIndex = int.parse(state);
    pincode = widget.data["pincode"] ?? "";
    partyPhone = widget.data["party_phone"] ?? "";
    partyMobile = widget.data["party_mobile"] ?? "";
    partyEmail1 = widget.data["party_email"] ?? "";
    partyEmail2 = widget.data["email2"] ?? "";
    gstType = widget.data["gst_type"] ?? "";
    gstIndex = gstTypes.indexOf(gstType);
    partyGst = widget.data["party_gst"] ?? "";
    pan = widget.data["pan"] ?? "";
    pType = widget.data["p_type"] ?? "";
    openingBal = widget.data["opening_bal"] ?? "";
    deliveryAdd = widget.data["delivery_add"] ?? "";
    partnerLimit = widget.data["partnerlimit"] ?? "";
    tds = widget.data["tds"] ?? "";
    tdsPercent = widget.data["percent"] ?? "";
    paymentType = widget.data["paymenttype"] ?? "";
    payValue = widget.data["payvalue"] ?? "";
    thirdParty = widget.data["thirdparty"] ?? "";
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
              const TitleText(text: "Edit Party"),
              SizedBox(height: height * 0.02),
              const RowText(text: "Party Name"),
              CustomField(
                setValue: (value) => setState(() => partyName = value),
                formKey: _formKey1,
                initialValue: widget.data["party_name"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Party Address"),
              CustomField(
                setValue: (value) => setState(() => partyAddress = value),
                formKey: _formKey2,
                initialValue: widget.data["party_address"] ?? "",
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
                scrollController:
                    FixedExtentScrollController(initialItem: stateIndex),
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Pincode"),
              CustomField(
                setValue: (value) => setState(() => pincode = value),
                formKey: _formKey4,
                keyboardType: TextInputType.number,
                initialValue: widget.data["pincode"] ?? "",
              ),
              SizedBox(height: height * 0.02),
             
              const RowText(text: "Mobile"),
              CustomField(
                setValue: (value) => setState(() => partyMobile = value),
                formKey: _formKey6,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (partyMobile != "" &&
                      partyMobile != "0" &&
                      !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                          .hasMatch(partyMobile)) {
                    return 'Please enter a valid mobile number';
                  }
                  return null;
                },
                initialValue: widget.data["party_mobile"] == '0'
                    ? ""
                    : widget.data["party_mobile"],
              ),
              SizedBox(height: height * 0.02),
               const RowText(text: "Phone Number"),
              CustomField(
                setValue: (value) => setState(() => partyPhone = value),
                formKey: _formKey5,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (partyPhone != "" &&
                      partyPhone != "0" &&
                      !RegExp(r'((\+*)((0[ -]*)*|((91 )*))((\d{12})+|(\d{10})+))|\d{5}([- ]*)\d{6}')
                          .hasMatch(partyPhone)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                initialValue: widget.data["party_phone"] == '0'
                    ? ""
                    : widget.data["party_phone"],
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
                initialValue: widget.data["party_email"] ?? "",
              ),

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
                scrollController:
                    FixedExtentScrollController(initialItem: gstIndex),
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
                      initialValue: widget.data["party_gst"] ?? "",
                    )
                  : const SizedBox(),
              SizedBox(height: height * 0.02),
              const RowText(text: "PAN Number"),
              CustomField(
                setValue: (value) => setState(() => pan = value),
                formKey: _formKey11,
                initialValue: widget.data["pan"] ?? "",
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
                initialValue: widget.data["opening_bal"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Delivery Address"),
              CustomField(
                setValue: (value) => setState(() => deliveryAdd = value),
                formKey: _formKey14,
                initialValue: widget.data["delivery_add"] ?? "",
              ),
              SizedBox(height: height * 0.02),
              const RowText(text: "Partner Limit"),
              CustomField(
                setValue: (value) => setState(() => partnerLimit = value),
                formKey: _formKey15,
                keyboardType: TextInputType.number,
                initialValue: widget.data["partnerlimit"] ?? "",
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
                        tdsPercent = "0";
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
                      initialValue: widget.data["percent"] ?? "",
                    )
                  : const SizedBox(),
              // SizedBox(height: height * 0.02),
              // const RowText(text: "Payment Type"),
              // CustomField(
              //   setValue: (value) => setState(() => paymentType = value),
              //   formKey: _formKey18,
              //   initialValue: widget.data["paymenttype"]?? "",
              // ),
              // SizedBox(height: height * 0.02),
              // const RowText(text: "Pay Value"),
              // CustomField(
              //   setValue: (value) => setState(() => payValue = value),
              //   formKey: _formKey19,
              //   initialValue:  widget.data["payvalue"]?? "",
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
                  edit().then(
                    (value) {
                      print(value);
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

  Future edit() async {
    final MasterService service = MasterService();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      if (_formKey5.currentState!.validate() &&
          _formKey6.currentState!.validate() &&
          _formKey7.currentState!.validate()) {
        return await service.editMaster({
          "userid": widget.data["user_id"],
          "companyid": widget.data["company_id"],
          "product": widget.product,
          "party_id": widget.data["id"],
          "party_name": partyName,
          "party_address": partyAddress,
          "state": stateIndex.toString(),
          "pincode": pincode,
          "party_phone": partyPhone,
          "party_mobile": partyMobile,
          "party_email1": partyEmail1,
          "party_email2": partyEmail2,
          "gst_type": gstType,
          "party_gst": partyGst,
          "pan": pan,
          "p_type": pType,
          "opening_bal": openingBal,
          "delivery_add": deliveryAdd,
          "partnerlimit": partnerLimit,
          "tds": tds,
          "tdspercent": tdsPercent,
          "payment_type": paymentType,
          "pay_value": payValue,
          "third_party": thirdParty
        }, "party");
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
