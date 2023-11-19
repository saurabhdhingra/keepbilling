import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:provider/provider.dart';
import '../../api/reports.dart';
import '../../provider/authenticationProvider.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/statusButton.dart';
import '../../widgets/infoPages/paddedText.dart';

class GeneralReport extends StatefulWidget {
  final String sundryCreditor;
  final String sundryDebitor;
  final String itemId;
  final String fromDate;
  final String toDate;
  const GeneralReport(
      {Key? key,
      required this.sundryCreditor,
      required this.sundryDebitor,
      required this.itemId,
      required this.fromDate,
      required this.toDate})
      : super(key: key);

  @override
  State<GeneralReport> createState() => _GeneralReportState();
}

class _GeneralReportState extends State<GeneralReport> {
  bool isLoading = false;
  bool isSale = true;
  List saleList = [];
  List purchaseList = [];
  Map data = {};

  Map purchaseTotal = {};

  String userId = "";
  String companyId = "";
  String product = "";
  ReportsService service = ReportsService();
  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
    try {
      data = await service.fetchGeneralReport(
          userId,
          companyId,
          widget.sundryCreditor,
          widget.sundryDebitor,
          widget.itemId,
          widget.fromDate,
          widget.toDate,
          product);
      saleList = data["saleData"];
      purchaseList = data["purchaseData"];
    } catch (e) {
      saleList = [];
      purchaseList = [];
      // ignore: use_build_context_synchronously
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
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return isLoading
        ? reportsLoading(context)
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              // actions: [
              //   IconButton(
              //     onPressed: () {
              //       showSearch(
              //         context: context,
              //         delegate: SearchBar(purchaseList, propeties),
              //       );
              //     },
              //     icon: const Icon(Icons.search),
              //   ),
              // ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PaddedText(
                      text: "General Report",
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatusButton(
                          isSelected: isSale,
                          setState: (String value) => setState(() {
                            isSale = true;
                          }),
                          text: "Sale",
                        ),
                        StatusButton(
                          isSelected: !isSale,
                          setState: (String value) => setState(() {
                            isSale = false;
                          }),
                          text: "Purchase",
                        ),
                      ],
                    ),
                    isSale
                        ? Flexible(
                            fit: FlexFit.loose,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: <DataColumn>[
                                  customDataColumn('Date'),
                                  customDataColumn('Invoice Number'),
                                  customDataColumn('Amount'),
                                  customDataColumn('Tax Amount'),
                                  customDataColumn('Voucher Type'),
                                  customDataColumn('Credit'),
                                  customDataColumn('Debit'),
                                ],
                                rows: List.generate(
                                  saleList.length,
                                  (index) {
                                    return customDataRow(saleList[index]);
                                  },
                                ),
                              ),
                            ),
                          )
                        : Flexible(
                            fit: FlexFit.loose,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: <DataColumn>[
                                  customDataColumn('Date'),
                                  customDataColumn('Invoice Number'),
                                  customDataColumn('Amount'),
                                  customDataColumn('Tax Amount'),
                                  customDataColumn('Voucher Type'),
                                  customDataColumn('Credit'),
                                  customDataColumn('Debit'),
                                ],
                                rows: List.generate(
                                  purchaseList.length,
                                  (index) {
                                    return customDataRow(purchaseList[index]);
                                  },
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }

  DataRow customDataRow(Map data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data["Date"] ?? "")),
        DataCell(Text(data["Inv_No"] ?? "")),
        DataCell(Text(data["Amount"].toString())),
        DataCell(Text(data["Tax_Amt"].toString())),
        DataCell(Text(data["Voucher_type"] ?? "")),
        DataCell(Text(data["Credit"].toString())),
        DataCell(Text(data["Debit"].toString())),
      ],
    );
  }

  DataColumn customDataColumn(String text) {
    return DataColumn(
      label: Expanded(
        child: Text(
          text,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
