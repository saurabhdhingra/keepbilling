import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/reports.dart';
import '../../utils/constants.dart';
import '../../widgets/infoPages/paddedText.dart';

class StockStatement extends StatefulWidget {
  final String itemName;
  final String fromDate;
  final String toDate;
  const StockStatement({
    Key? key,
    required this.itemName,
    required this.fromDate,
    required this.toDate,
  }) : super(key: key);

  @override
  State<StockStatement> createState() => _StockStatementState();
}

class _StockStatementState extends State<StockStatement> {
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

    data = await service.fetchStockStatement(
      userId,
      companyId,
      widget.itemName,
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
             
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaddedText(
                      text: "Stock Statement",
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
                            customDataColumn('Opening QTY.'),
                            customDataColumn('Rate'),
                            customDataColumn('Amount'),
                            customDataColumn('Purchase QTY.'),
                            customDataColumn('Purchase Rate'),
                            customDataColumn('Purchase Amount'),
                            customDataColumn('Sales Quantity'),
                            customDataColumn('Sale Rate'),
                            customDataColumn('Sale Amount'),
                            customDataColumn('Closing QTY.'),
                            customDataColumn('Closing Rate'),
                            customDataColumn('Closing AMT.'),
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
        DataCell(Text(data["ITEM"] ?? "")),
        DataCell(Text(data["OPENING QTY"].toString())),
        DataCell(Text(data["RATE"].toString())),
        DataCell(Text(data["AMT"].toString())),
        DataCell(Text(data["PURCHASE QTY"].toString())),
        DataCell(Text(data["P_RATE"].toString())),
        DataCell(Text(data["P_AMT"].toString())),
        DataCell(Text(data["SALES QTY"].toString())),
        DataCell(Text(data["S_RATE"].toString())),
        DataCell(Text(data["S_AMT"].toString())),
        DataCell(Text(data["CLOSING QTY"].toString())),
        DataCell(Text(data["C_RATE"].toString())),
        DataCell(Text(data["C_AMT"].toString())),
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
