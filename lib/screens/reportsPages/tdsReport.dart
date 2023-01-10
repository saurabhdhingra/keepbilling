import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/reports.dart';
import '../../utils/constants.dart';
import '../../widgets/infoPages/paddedText.dart';

class TDSreport extends StatefulWidget {
  final String party;
  final String type;
  final String fromDate;
  final String toDate;

  const TDSreport(
      {Key? key,
      required this.party,
      required this.type,
      required this.fromDate,
      required this.toDate})
      : super(key: key);

  @override
  State<TDSreport> createState() => _TDSreportState();
}

class _TDSreportState extends State<TDSreport> {
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
    data = await service.fetchTDSReport(
      userId,
      companyId,
      widget.party,
      widget.type,
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
                      text: "TDS Report",
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
                            customDataColumn('Invoice Number'),
                            customDataColumn('Party Name'),
                            customDataColumn('Amount'),
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
        DataCell(Text(data["Amount"] ?? "")),
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
