import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/transactionPages/addPages/createBill.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../api/master.dart';
import '../../provider/authenticationProvider.dart';
import '../../widgets/infoPages/CustomExpansionTile.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../pdfView.dart';
import '../searchBarDelegate.dart';
import 'editPages/editBill.dart';

class SaleTransaction extends StatefulWidget {
  const SaleTransaction({Key? key}) : super(key: key);

  @override
  State<SaleTransaction> createState() => _SaleTransactionState();
}

class _SaleTransactionState extends State<SaleTransaction> {
  bool isLoading = false;

  List dataList = [];
  Map extraFieldsData = {};
  List partyList = [];
  List paymentTerms = [];
  List itemList = [];
  String invoiceNo = "";

  TransactionsService service = TransactionsService();
  MasterService serviceM = MasterService();

  String userId = "";
  String companyId = "";
  String cashId = "";
  String product = "";

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;

    cashId = Provider.of<AuthenticationProvider>(context, listen: false).cashid;
    try {
      dataList = await service.fetchBills("S", userId, companyId, product);
      paymentTerms = await service.fetchDataList(
          'payment_term', userId, companyId, product);
      partyList =
          await serviceM.fetchDataList(userId, companyId, "party", product);
      extraFieldsData =
          await service.fetchExtraFieldData(userId, companyId, product);
      itemList =
          await serviceM.fetchDataList(userId, companyId, "item", product);
      invoiceNo = await service.fetchSaleInvNo(userId, companyId, product);
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
      dataList = await service.fetchBills("S", userId, companyId, product);
      invoiceNo = await service.fetchSaleInvNo(userId, companyId, product);
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
      "subtitle": "inv_date",
      "entries": [
        {"fieldName": "Invoice Number", "fieldValue": "s_invoice_no"},
        {"fieldName": "Base Amount", "fieldValue": "totalamount"},
        {"fieldName": "Tax Amount", "fieldValue": "tax_amount"},
      ]
    };
    List parties = [
      {"id": "", "party_name": "Unselected"},
      ...partyList
    ];

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
                    builder: (context) => CreateBill(
                      extraFieldData: extraFieldsData,
                      billType: 'S',
                      partyList: parties,
                      paymentTerms: paymentTerms,
                      invoiceNo: invoiceNo,
                      itemList: itemList,
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
                    const PaddedText(text: "Sale Bills"),
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
                                editAction: () async {
                                  var navigationResult =
                                      await getBillData(companyId, e).then(
                                    (value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditBill(
                                          data: value,
                                          cashId: cashId,
                                          companyId: companyId,
                                          extraFieldData: extraFieldsData,
                                          itemList: itemList,
                                          partyList: parties,
                                          paymentTerms: paymentTerms,
                                          userId: userId,
                                          product: product,
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
                              tablet: CustomExpansionTile(
                                data: e,
                                properties: propeties,
                                isTab: true,
                                editAction: () async {
                                  var navigationResult =
                                      await getBillData(companyId, e).then(
                                    (value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditBill(
                                          data: value,
                                          cashId: cashId,
                                          companyId: companyId,
                                          extraFieldData: extraFieldsData,
                                          itemList: itemList,
                                          partyList: parties,
                                          paymentTerms: paymentTerms,
                                          userId: userId,
                                          product: product,
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

  Future getBillData(String compId, Map bill) async {
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please wait...."),
      ),
    );
    try {
      return await service.fetchBillById(compId, bill, product);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future generatePDF(String billID) async {
    final TransactionsService service = TransactionsService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please wait...."),
      ),
    );
    try {
      return await service
          .fetchBillPDF('S', userId, companyId, billID, product)
          .then(
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
}
