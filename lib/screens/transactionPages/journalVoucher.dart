import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/transactionPages/addPages/addJV.dart';
import 'package:keepbilling/screens/transactionPages/editPages/editJV.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants.dart';

import '../../widgets/infoPages/CustomExpansionTile.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../searchBarDelegate.dart';

class JournalVoucherTransaction extends StatefulWidget {
  const JournalVoucherTransaction({Key? key}) : super(key: key);

  @override
  State<JournalVoucherTransaction> createState() =>
      _JournalVoucherTransactionState();
}

class _JournalVoucherTransactionState extends State<JournalVoucherTransaction> {
  bool isLoading = false;
  List dataList = [];
  List jvInput = [];

  TransactionsService service = TransactionsService();
  String companyId = "";
  String userId = "";
  String jvNo = "";

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    dataList = await service.fetchDataList("JV", userId, companyId);
    jvNo = await service.fetchJVInvNo(userId, companyId);
    jvInput = await service.fetchDataList("jv_input", userId, companyId);

    setState(() => isLoading = false);
  }

  Future getUpdatedData() async {
    setState(() => isLoading = true);
    jvNo = await service.fetchJVInvNo(userId, companyId);
    dataList = await service.fetchDataList("JV", userId, companyId);
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
      "title": "narration",
      "subtitle": "inv_date",
      "entries": [
        {"fieldName": "Amount", "fieldValue": "amount"},
        {"fieldName": "Transaction Date", "fieldValue": "trans_date"},
      ]
    };
    return isLoading
        ? infoLoading(context)
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                var navigationResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddJVTransaction(
                        jvInput: jvInput, jvNo: int.parse(jvNo)),
                  ),
                );
                if (navigationResult == "update") {
                  getUpdatedData();
                }
              },
            ),
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
                      delegate: SearchBar(dataList, propeties),
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
                      text: "Journal Voucher",
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ...dataList.map(
                      (e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                          child: Theme(
                            data: theme,
                            child: CustomExpansionTile(
                              data: e,
                              properties: propeties,
                              editAction: () async {
                                var navigationResult = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditJVTransaction(
                                      jvInput: jvInput,
                                      data: e,
                                    ),
                                  ),
                                );
                                if (navigationResult == "update") {
                                  getUpdatedData();
                                }
                              },
                            ),
                          ),
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
