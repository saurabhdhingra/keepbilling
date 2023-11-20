import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/transactionPages/addPages/addJV.dart';
import 'package:keepbilling/screens/transactionPages/editPages/editJV.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../provider/authenticationProvider.dart';
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
  String product = "";

  String jvNo = "";

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;

    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
    try {
      dataList = await service.fetchDataList("JV", userId, companyId, product);
      jvNo = await service.fetchJVInvNo(userId, companyId, product);
      jvInput =
          await service.fetchDataList("jv_input", userId, companyId, product);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  Future getUpdatedData() async {
    setState(() => isLoading = true);
    try {
      jvNo = await service.fetchJVInvNo(userId, companyId, product);
      dataList = await service.fetchDataList("JV", userId, companyId, product);
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
              backgroundColor: const Color.fromRGBO(3, 195, 237, 1),
              child: const Icon(Icons.add),
              onPressed: () async {
                var navigationResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddJVTransaction(
                      jvInput: jvInput,
                      jvNo: int.parse(jvNo),
                      product: product,
                    ),
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
                      delegate: SearchBarDelegate(dataList, propeties),
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
                    const PaddedText(text: "Journal Voucher"),
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
                                    builder: (context) => EditJVTransaction(
                                      jvInput: jvInput,
                                      data: e,
                                      product: product,
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
