import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/pdfView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants.dart';

import '../../api/master.dart';
import '../../widgets/infoPages/CustomExpansionTile.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../searchBarDelegate.dart';
import 'addPages/createBill.dart';
import 'editPages/editBill.dart';

class PurchaseTransaction extends StatefulWidget {
  const PurchaseTransaction({Key? key}) : super(key: key);

  @override
  State<PurchaseTransaction> createState() => _PurchaseTransactionState();
}

class _PurchaseTransactionState extends State<PurchaseTransaction> {
  bool isLoading = false;

  List dataList = [];
  Map extraFieldsData = {};
  List partyList = [];
  List paymentTerms = [];
  List itemList = [];

  TransactionsService service = TransactionsService();
  MasterService serviceM = MasterService();

  String userId = "";
  String companyId = "";
  String cashId = "";

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    cashId = prefs.getString('cashId') ?? "";
    dataList = await service.fetchBills("P", userId, companyId);
    partyList = await serviceM.fetchDataList(userId, companyId, "party");
    paymentTerms =
        await service.fetchDataList('payment_term', userId, companyId);
    extraFieldsData = await service.fetchExtraFieldData(userId, companyId);
    itemList = await serviceM.fetchDataList(userId, companyId, "item");
    setState(() => isLoading = false);
  }

  Future getUpdatedData() async {
    setState(() => isLoading = true);
    dataList = await service.fetchBills("P", userId, companyId);
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
      "title": "totalamount",
      "subtitle": "inv_date",
       
      "entries": [
        {"fieldName": "Tax Amount", "fieldValue": "tax_amount"},
        {"fieldName": "Discount Amount", "fieldValue": "disc_amount"},
      ]
    };
    List parties = [
      {"id": "", "party_name": "Unselected"},
      ...partyList
    ];
    List items = [
      {
        "id": "",
        "item_name": "Unselected",
        "s_rate": "",
        "tax": "",
      },
      ...itemList
    ];
    List pTerms = ["Unseleceted", ...paymentTerms];
    return isLoading
        ? infoLoading(context)
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                var navigationResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateBill(
                      extraFieldData: extraFieldsData,
                      billType: 'P',
                      partyList: partyList,
                      paymentTerms: pTerms,
                      invoiceNo: '',
                      itemList: itemList,
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
                      text: "Purchase Bills",
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
                                var navigationResult =
                                    await getBillData(e).then(
                                  (value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditBill(
                                        data: value,
                                        cashId: cashId,
                                        companyId: companyId,
                                        extraFieldData: extraFieldsData,
                                        itemList: items,
                                        partyList: parties,
                                        paymentTerms: pTerms,
                                        userId: userId,
                                      ),
                                    ),
                                  ),
                                );
                                if (navigationResult == "update") {
                                  getUpdatedData();
                                }
                              },
                              pdfAction: () async {
                                await generatePDF(e["id"]);
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

  Future generatePDF(String billID) async {
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please wait...."),
      ),
    );
    try {
      return await service.fetchBillPDF('P', userId, companyId, billID).then(
        (value) async {
          if (value["type"] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("PDF genereated successfully."),
              ),
            );
            await TransactionsService.loadPDF(value["response_data"]).then(
              (value) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewPage(file: value),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error : ${value["message"]}"),
              ),
            );
          }
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future getBillData(Map bill) async {
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please wait...."),
      ),
    );
    try {
      return await service.fetchBillById(companyId, bill);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
