import 'package:flutter/material.dart';
import 'package:keepbilling/widgets/formPages/submitButton.dart';
import 'package:provider/provider.dart';
import '../../api/settings.dart';
import '../../provider/authenticationProvider.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/customField.dart';
import '../../widgets/formPages/dropdownSelector.dart';
import '../../widgets/formPages/notes.dart';
import '../../widgets/formPages/rowText.dart';
import '../../widgets/infoPages/paddedText.dart';

class ChangeRefNoSettings extends StatefulWidget {
  const ChangeRefNoSettings({Key? key}) : super(key: key);

  @override
  State<ChangeRefNoSettings> createState() => _ChangeRefNoSettingsState();
}

class _ChangeRefNoSettingsState extends State<ChangeRefNoSettings> {
  String userId = "";
  String companyId = "";
  String cashId = "";
  String product = "";

  String type = "";
  int typeIndex = 0;
  String number = "";

  final _formKey1 = GlobalKey<FormState>();

  final List<String> typeValues = [
    "Unselected",
    "Sale",
    "Receipt",
    "Quotation",
    "Credit",
    "Debit",
    "JV",
    "Voucher"
  ];
  Future getUserData() async {
   userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    cashId = Provider.of<AuthenticationProvider>(context, listen: false).cashid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaddedText(
              text: "Change Reference Number",
              style: TextStyle(
                fontSize: height * 0.03,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: height * 0.02),
            const RowText(text: "Type"),
            SizedBox(height: height * 0.02),
            DropdownSelector(
              setState: (value) => setState(() {
                type = typeValues[value];
                typeIndex = value;
              }),
              items: typeValues,
              dropDownValue: typeValues[typeIndex],
            ),
            SizedBox(height: height * 0.02),
            const RowText(text: "Number"),
            CustomField(
              setValue: (value) => setState(() => number = value),
              formKey: _formKey1,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: height * 0.02),
            SubmitButton(
              onSubmit: () {
                apiCall().then(
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
             SizedBox(height: height * 0.02),
                  const NotesSettings(text: changeRefnoNote),
          ],
        ),
      ),
    );
  }

  Future apiCall() async {
    final SettingsService service = SettingsService();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      return await service.changeReferenceNo(
          userId, companyId, cashId, type, number,product);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
