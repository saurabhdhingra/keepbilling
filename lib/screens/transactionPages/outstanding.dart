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

class OutstandingTransaction extends StatefulWidget {
  const OutstandingTransaction({Key? key}) : super(key: key);

  @override
  State<OutstandingTransaction> createState() => _OutstandingTransactionState();
}

class _OutstandingTransactionState extends State<OutstandingTransaction> {
  bool isLoading = false;

  String listName = "Sale";
  List dataList = [];

  List saleList = [];
  List purchaseList = [];

  String companyId = "";
  String userId = "";

  TransactionsService service = TransactionsService();

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    saleList = await service.fetchOutstanding("S", userId, companyId);
    purchaseList = await service.fetchOutstanding("P", userId, companyId);
    dataList = saleList;
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
      "subtitle": "invoice_date",
      "entries": [
        {"fieldName": "Amount", "fieldValue": "amount"},
        {"fieldName": "Party ID", "fieldValue": "party_id"},
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
                          listName == "Sale" ? saleList : purchaseList,
                          propeties),
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
                      text: "Outstanding",
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            listName = "Sale";
                            dataList = saleList;
                          }),
                          child: PaddedText(
                            text: "Sale",
                            style: TextStyle(
                                fontSize: height * 0.025,
                                fontWeight: FontWeight.w600,
                                color: listName == "Sale"
                                    ? Colors.blue
                                    : Colors.black87),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            listName = "Purchase";
                            dataList = purchaseList;
                          }),
                          child: PaddedText(
                            text: "Purchase",
                            style: TextStyle(
                                fontSize: height * 0.025,
                                fontWeight: FontWeight.w600,
                                color: listName == "Purchase"
                                    ? Colors.blue
                                    : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    ...dataList.map(
                      (e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
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
