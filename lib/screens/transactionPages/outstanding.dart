import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/transactionPages/addPages/outstandingPayment.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../api/master.dart';
import '../../provider/authenticationProvider.dart';
import '../../widgets/formPages/statusButton.dart';
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
  List partyList = [];

  String companyId = "";
  String userId = "";
  String product = "";

  TransactionsService service = TransactionsService();
  MasterService serviceM = MasterService();

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
    try {
      saleList =
          await service.fetchOutstanding("S", userId, companyId, product);
      purchaseList =
          await service.fetchOutstanding("P", userId, companyId, product);
      partyList =
          await serviceM.fetchDataList(userId, companyId, "party", product);
      addParty(saleList, partyList);
      addParty(purchaseList, partyList);
      dataList = saleList;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  Future updateSaleData() async {
    setState(() => isLoading = true);

    try {
      saleList =
          await service.fetchOutstanding("S", userId, companyId, product);
      addParty(saleList, partyList);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  Future updatePurchaseData() async {
    setState(() => isLoading = true);

    try {
      purchaseList =
          await service.fetchOutstanding("P", userId, companyId, product);
      addParty(purchaseList, partyList);
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
      "title": "party_name",
      "subtitle": "invoice_date",
      "entries": [
        {"fieldName": "Invoice no", "fieldValue": "invoice_no"},
        {"fieldName": "Amount", "fieldValue": "amount"},
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
                        StatusButton(
                          isSelected: listName == "Sale" ? true : false,
                          setState: (String value) => setState(() {
                            listName = "Sale";
                            dataList = saleList;
                          }),
                          text: "Sale",
                        ),
                        StatusButton(
                          isSelected: listName == "Purchase" ? true : false,
                          setState: (String value) => setState(() {
                            listName = "Purchase";
                            dataList = purchaseList;
                          }),
                          text: "Purchase",
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    ...dataList.map(
                      (e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, 0, width * 0.02, 0),
                          child: Theme(
                            data: theme,
                            child: ScreenTypeLayout(
                              mobile: CustomExpansionTile(
                                data: e,
                                properties: propeties,
                                payAction: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                        partyId: e["party_id"],
                                        billType: e["bill_type"],
                                        partyName: e["party_name"],
                                        receivable: listName == "Sale",
                                        selected: e,
                                      ),
                                    ),
                                  );

                                  if (navigationResult == "update" &&
                                      listName == "Sale") {
                                    updateSaleData();
                                  } else if (navigationResult == "update" &&
                                      listName == "Purchase") {
                                    updatePurchaseData();
                                  }
                                },
                              ),
                              tablet: CustomExpansionTile(
                                data: e,
                                properties: propeties,
                                isTab: true,
                                payAction: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                        partyId: e["party_id"],
                                        billType: e["bill_type"],
                                        partyName: e["party_name"],
                                        receivable: listName == "Sale",
                                        selected: e,
                                      ),
                                    ),
                                  );

                                  if (navigationResult == "update" &&
                                      listName == "Sale") {
                                    updateSaleData();
                                  } else if (navigationResult == "update" &&
                                      listName == "Purchase") {
                                    updatePurchaseData();
                                  }
                                },
                              ),
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

  void addParty(List dataList, List parties) {
    for (int i = 0; i < dataList.length; i++) {
      String partyId = dataList[i]["party_id"];
      String partyName = "";
      for (int j = 0; j < parties.length; j++) {
        if (parties[j]["id"] == partyId) {
          partyName = parties[j]["party_name"];
        }
      }
      dataList[i]["party_name"] = partyName;
    }
  }
}
