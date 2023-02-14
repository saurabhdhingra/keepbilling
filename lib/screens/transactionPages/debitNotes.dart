import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants.dart';
import '../../provider/authenticationProvider.dart';
import '../../widgets/infoPages/CustomExpansionTile.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../searchBarDelegate.dart';

class DebitNoteTransaction extends StatefulWidget {
  const DebitNoteTransaction({Key? key}) : super(key: key);

  @override
  State<DebitNoteTransaction> createState() => _DebitNoteTransactionState();
}

class _DebitNoteTransactionState extends State<DebitNoteTransaction> {
  bool isLoading = false;
  List dataList = [];

  TransactionsService service = TransactionsService();

  String companyId = "";
  String userId = "";

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    dataList = await service.fetchDataList("debitnote", userId, companyId);

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

    final Map propeties = {
      "title": "invoice_no",
      "subtitle": "inv_date",
      "entries": [
        {"fieldName": "Amount", "fieldValue": "amount"},
        {"fieldName": "Bill Type", "fieldValue": "bill_type"},
        {"fieldName": "Refund", "fieldValue": "refund"},
      ]
    };
    return isLoading
        ? infoLoading(context)
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchBar(
                        dataList,
                        propeties,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaddedText(
                      text: "Debit Note",
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ...dataList.map(
                      (e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, 0, width * 0.02, 0),
                          child: Theme(
                              data: theme,
                              child: CustomExpansionTile(
                                  data: e, properties: propeties)),
                        );
                      },
                    ),
                    SizedBox(height: height * 0.1),
                  ],
                ),
              ),
            ),
          );
  }
}
