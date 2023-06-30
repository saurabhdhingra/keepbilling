import 'package:flutter/material.dart';
import 'package:keepbilling/widgets/formPages/switch.dart';
import 'package:provider/provider.dart';
import '../../api/settings.dart';
import '../../api/transaction.dart';
import '../../provider/authenticationProvider.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/customField.dart';
import '../../widgets/formPages/rowText.dart';
import '../../widgets/formPages/submitButton.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../loadingScreens.dart';

class ExtraFieldsSetings extends StatefulWidget {
  const ExtraFieldsSetings({Key? key}) : super(key: key);

  @override
  State<ExtraFieldsSetings> createState() => _ExtraFieldsSetingsState();
}

class _ExtraFieldsSetingsState extends State<ExtraFieldsSetings> {
  bool isLoading = false;

  String userId = "";
  String companyId = "";
  String cashId = "";
  String product = "";

  String extra1 = "";
  String extra2 = "";
  String extra3 = "";
  String extra4 = "";

  bool enable1 = false;
  bool enable2 = false;
  bool enable3 = false;
  bool enable4 = false;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  Map data = {};
  TransactionsService service = TransactionsService();

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    cashId = Provider.of<AuthenticationProvider>(context, listen: false).cashid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
    data = await service.fetchExtraFieldData(userId, companyId,product);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      extra1 = data["extra_1"];
      extra2 = data["extra_2"];
      extra3 = data["extra_3"];
      extra4 = data["extra_4"];
      enable1 = data["flag_1"] == "N" ? true : false;
      enable2 = data["flag_2"] == "N" ? true : false;
      enable3 = data["flag_3"] == "N" ? true : false;
      enable4 = data["flag_4"] == "N" ? true : false;
    });
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaddedText(
                    text: "Adjust Extra Fields in Bills",
                    style: TextStyle(
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  const RowText(text: "Extra Field 1"),
                  CustomField(
                    initialValue: extra1,
                    setValue: (value) => setState(() => extra1 = value),
                    formKey: _formKey1,
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 0.8),
                      SwitchButton(
                        setState: (value) => setState((() => enable1 = value)),
                        value: enable1,
                      )
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  const RowText(text: "Extra Field 2"),
                  CustomField(
                    initialValue: extra2,
                    setValue: (value) => setState(() => extra2 = value),
                    formKey: _formKey2,
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 0.8),
                      SwitchButton(
                        setState: (value) => setState((() => enable2 = value)),
                        value: enable2,
                      )
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  const RowText(text: "Extra Field 3"),
                  CustomField(
                    initialValue: extra3,
                    setValue: (value) => setState(() => extra3 = value),
                    formKey: _formKey3,
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 0.8),
                      SwitchButton(
                        setState: (value) => setState((() => enable3 = value)),
                        value: enable3,
                      )
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  const RowText(text: "Extra Field 4"),
                  CustomField(
                    initialValue: extra4,
                    setValue: (value) => setState(() => extra4 = value),
                    formKey: _formKey4,
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 0.8),
                      SwitchButton(
                        setState: (value) => setState((() => enable4 = value)),
                        value: enable4,
                      )
                    ],
                  ),
                  SizedBox(width: width * 0.75),
                  SizedBox(height: height * 0.02),
                  SubmitButton(
                    onSubmit: () {
                      apiCall().then(
                        (value) {
                          print(value);
                          if (value["type"] == "success") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value["message"]),
                              ),
                            );
                            Navigator.pop(context);
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
          );
  }

  Future apiCall() async {
    final SettingsService service = SettingsService();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Processing")));
    try {
      return await service.adjustExtrafields(
        userId,
        companyId,
        product,
        cashId,
        extra1,
        extra2,
        extra3,
        extra4,
        extra1 != ""
            ? enable1
                ? "Yes"
                : "No"
            : "",
        extra2 != ""
            ? enable2
                ? "Yes"
                : "No"
            : "",
        extra3 != ""
            ? enable3
                ? "Yes"
                : "No"
            : "",
        extra4 != ""
            ? enable4
                ? "Yes"
                : "No"
            : "",
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
