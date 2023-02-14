import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/reports.dart';
import '../../utils/constants.dart';
import '../../widgets/infoPages/paddedText.dart';

class HSNreport extends StatefulWidget {
  final String hsn;
  final String fromDate;
  final String toDate;

  const HSNreport(
      {Key? key,
      required this.hsn,
      required this.fromDate,
      required this.toDate})
      : super(key: key);

  @override
  State<HSNreport> createState() => _HSNreportState();
}

class _HSNreportState extends State<HSNreport> {
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
    data = await service.fetchHSNReport(
      userId,
      companyId,
      widget.hsn,
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
                   mainAxisSize: MainAxisSize.min,
                  children: [
                    PaddedText(
                      text: "HSN Report",
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
                            customDataColumn('HSN'),
                            customDataColumn('Item Name'),
                            customDataColumn('Purchase'),
                            customDataColumn('Taxable AMT.'),
                            customDataColumn('Total AMT.'),
                            customDataColumn('Sale'),
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
        DataCell(Text(data["HSN Code"] ?? "")),
        DataCell(Text(data["ITEM NAME"] ?? "")),
        DataCell(Text(data["PURCHASE"].toString())),
        DataCell(Text(data["TAXABLE AMT"].toString())),
        DataCell(Text(data["TOTAL AMT"].toString())),
        DataCell(Text(data["SALE"].toString())),
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