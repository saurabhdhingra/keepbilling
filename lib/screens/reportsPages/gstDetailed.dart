import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/reports.dart';
import '../../utils/constants.dart';
import '../../widgets/infoPages/paddedText.dart';

class GSTdetailedReport extends StatefulWidget {
  final String party;
  final String gstType;
  final String fromDate;
  final String toDate;
  const GSTdetailedReport(
      {Key? key,
      required this.party,
      required this.gstType,
      required this.fromDate,
      required this.toDate})
      : super(key: key);

  @override
  State<GSTdetailedReport> createState() => _GSTdetailedReportState();
}

class _GSTdetailedReportState extends State<GSTdetailedReport> {
  bool isLoading = false;
  List data = [];

  String userId = "";
  String companyId = "";
  ReportsService service = ReportsService();

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    data = await service.fetchGSTdetailedStatement(
      userId,
      companyId,
      widget.party,
      widget.gstType,
      widget.fromDate,
      widget.toDate,
    );
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
                  children: [
                    PaddedText(
                      text: "GST Detailed Report",
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      height: height * 0.056 * (data.length + 1),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: <DataColumn>[
                            customDataColumn('Invoice Date'),
                            customDataColumn('Invoice NO.'),
                            customDataColumn('Party Name'),
                            customDataColumn('Party GST'),
                            customDataColumn('Taxable AMT.'),
                            customDataColumn('IGST @0%'),
                            customDataColumn('IGST @5%'),
                            customDataColumn('IGST @12%'),
                            customDataColumn('IGST @18%'),
                            customDataColumn('CGST @0%'),
                            customDataColumn('SGST @0%'),
                            customDataColumn('CGST @2.5%'),
                            customDataColumn('SGST @2.5%'),
                            customDataColumn('CGST @6%'),
                            customDataColumn('SGST @6%'),
                            customDataColumn('CGST @9%'),
                            customDataColumn('SGST @9%'),
                            customDataColumn('IGST'),
                            customDataColumn('CGST'),
                            customDataColumn('SGST'),
                            customDataColumn('Tax AMT.'),
                            customDataColumn('Amount'),
                            customDataColumn('Round Off'),
                            customDataColumn('Total'),
                          ],
                          rows: List.generate(
                            data.length,
                            (index) {
                              return customDataRow(data[index]);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          );
  }

  DataRow customDataRow(Map data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data["Inv Date"] ?? "")),
        DataCell(Text(data["Inv No"] ?? "")),
        DataCell(Text(data["Party_name"] ?? "")),
        DataCell(Text(data["party_gst"] ?? "")),
        DataCell(Text(data["TAXABLE AMT"].toString())),
        DataCell(Text(data["IGST @0%"].toString())),
        DataCell(Text(data["IGST @5%"].toString())),
        DataCell(Text(data["IGST @12%"].toString())),
        DataCell(Text(data["IGST @18%"].toString())),
        DataCell(Text(data["CGST @0%"].toString())),
        DataCell(Text(data["SGST @0%"].toString())),
        DataCell(Text(data["CGST @2.5%"].toString())),
        DataCell(Text(data["SGST @2.5%"].toString())),
        DataCell(Text(data["CGST @6%"].toString())),
        DataCell(Text(data["SGST @6%"].toString())),
        DataCell(Text(data["CGST @9%\t"].toString())),
        DataCell(Text(data["SGST @9%"].toString())),
        DataCell(Text(data["IGST"].toString())),
        DataCell(Text(data["CGST"].toString())),
        DataCell(Text(data["SGST"].toString())),
        DataCell(Text(data["Tax Amt"].toString())),
        DataCell(Text(data["Amount"].toString())),
        DataCell(Text(data["Round Off"].toString())),
        DataCell(Text(data["Total"].toString())),
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
