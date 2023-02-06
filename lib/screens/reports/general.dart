import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/reports.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/rowText.dart';
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
  List saleList = [];
  List purchaseList = [];
  Map data = {};

  Map purchaseTotal = {};

  String userId = "";
  String companyId = "";
  ReportsService service = ReportsService();
  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    data = await service.fetchGeneralReport(
      userId,
      companyId,
      widget.sundryCreditor,
      widget.sundryDebitor,
      widget.itemId,
      widget.fromDate,
      widget.toDate,
    );
    saleList = data["saleData"];
    purchaseList = data["purchaseData"];
    print(data);
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
                    RowText(
                      text: "Purchase",
                      style: TextStyle(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(
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
                    SizedBox(height: height * 0.02),
                    RowText(
                      text: "Sale",
                      style: TextStyle(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Flexible(
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
