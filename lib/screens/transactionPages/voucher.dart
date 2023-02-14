import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/transactionPages/editPages/editVoucher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants.dart';
import '../../api/master.dart';
import '../../widgets/infoPages/CustomExpansionTile.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../searchBarDelegate.dart';
import 'addPages/addVoucher.dart';

class VoucherTransaction extends StatefulWidget {
  const VoucherTransaction({Key? key}) : super(key: key);

  @override
  State<VoucherTransaction> createState() => _VoucherTransactionState();
}

class _VoucherTransactionState extends State<VoucherTransaction> {
  bool isLoading = false;
  List dataList = [];
  List partyList = [];
  List ledgers = [];

  TransactionsService service = TransactionsService();
  MasterService serviceM = MasterService();

  String companyId = "";
  String userId = "";

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    dataList = await service.fetchDataList("voucher", userId, companyId);
    ledgers = await service.fetchLedgerList(userId, companyId);
    partyList = await serviceM.fetchDataList(userId, companyId, "party");
    setState(() => isLoading = false);
  }

  Future getUpdatedData() async {
    setState(() => isLoading = true);
    dataList = await service.fetchDataList("voucher", userId, companyId);
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
      "title": "party_name",
      "subtitle": "inv_date",
      "entries": [
        {"fieldName": "Amount", "fieldValue": "amount"},
        {"fieldName": "Transaction Date", "fieldValue": "trans_date"},
      ]
    };
    List parties = [
      {"id": "", "party_name": "Unselected"},
      ...partyList
    ];
    List ledgerList = [
      {"id": "", "ledger": "Unselected"},
      ...ledgers
    ];
    return isLoading
        ? infoLoading(context)
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                var navigationResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVoucherTransaction(
                        partyList: parties, ledgerList: ledgerList),
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
                      text: "Voucher",
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
                              data: e,
                              properties: propeties,
                              editAction: () async {
                                var navigationResult = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditVoucherTransaction(
                                      data: e,
                                      ledgerList: ledgerList,
                                      partyList: parties,
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
