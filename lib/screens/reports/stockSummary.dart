import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/reports.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/rowText.dart';
import '../../widgets/infoPages/paddedText.dart';

class StockSummary extends StatefulWidget {
  final String itemName;
  final String stockLimit;
  final String stockSign;
  const StockSummary({
    Key? key,
    required this.itemName,
    required this.stockLimit,
    required this.stockSign,
  }) : super(key: key);

  @override
  State<StockSummary> createState() => _StockSummaryState();
}

class _StockSummaryState extends State<StockSummary> {
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
    data = await service.fetchStockSummary(
      userId,
      companyId,
      widget.itemName,
      widget.stockLimit,
      widget.stockSign,
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
                   mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaddedText(
                      text: "Stock Summary",
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Flexible(
                       fit: FlexFit.loose,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: <DataColumn>[
                            customDataColumn('Item Name'),
                            customDataColumn('Group'),
                            customDataColumn('Stock'),
                            customDataColumn('Last Purchase Amt.'),
                            customDataColumn('Total Amt.'),
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
        DataCell(Text(data["Item Name"] ?? "")),
        DataCell(Text(data["Group"] ?? "")),
        DataCell(Text(data["Stock"].toString())),
        DataCell(Text(data["Last Purchase Amt"].toString())),
        DataCell(Text(data["Total Amt"].toString())),
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
