import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:provider/provider.dart';
import '../../api/reports.dart';
import '../../provider/authenticationProvider.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/rowText.dart';
import '../../widgets/formPages/titleText.dart';
import '../../widgets/infoPages/paddedText.dart';

class GSTreport extends StatefulWidget {
  final String party;
  final String gstType;
  final String fromDate;
  final String toDate;
  const GSTreport(
      {Key? key,
      required this.party,
      required this.gstType,
      required this.fromDate,
      required this.toDate})
      : super(key: key);

  @override
  State<GSTreport> createState() => _GSTreportState();
}

class _GSTreportState extends State<GSTreport> {
  bool isLoading = false;
  Map data = {};
  List inward = [];
  List outward = [];
  String sales = "";
  String purchase = "";
  String toBePaid = "";

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
      data = await service.fetchGSTStatement(userId, companyId, widget.party,
          "GST#", widget.fromDate, widget.toDate, product);
      inward = data["inward"];
      outward = data["outward"];
      sales = data["final"][0]["Sales GST"].toString();
      purchase = data["final"][0]["Purchase GST"].toString();
      toBePaid = data["final"][0]["GST To be Paid"].toString();
    } catch (e) {
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
                    const TitleText(text: "GST Summary"),
                    SizedBox(height: height * 0.02),
                    RowText(
                      text: "Inward",
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
                            customDataColumn('Supply'),
                            customDataColumn('TAXABLE VALUE'),
                            customDataColumn('IGST'),
                            customDataColumn('CGST'),
                            customDataColumn('SGST'),
                            customDataColumn('TOTAL TAX AMT'),
                          ],
                          rows: List.generate(
                            data.length,
                            (index) {
                              return customDataRow(inward[index]);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    RowText(
                      text: "Outward",
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
                            customDataColumn('Supply'),
                            customDataColumn('TAXABLE VALUE'),
                            customDataColumn('IGST'),
                            customDataColumn('CGST'),
                            customDataColumn('SGST'),
                            customDataColumn('TOTAL TAX AMT'),
                          ],
                          rows: List.generate(
                            data.length,
                            (index) {
                              return customDataRow(outward[index]);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    PaddedText(
                      text: "Final",
                      style: TextStyle(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RowText(text: "Sales GST : $sales"),
                    RowText(text: "Sales GST : $purchase"),
                    RowText(text: "Sales GST : $toBePaid")
                  ],
                ),
              ),
            ),
          );
  }

  DataRow customDataRow(Map data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data["Supply"] ?? "")),
        DataCell(Text(data["TAXABLE VALUE"].toString())),
        DataCell(Text(data["IGST"].toString())),
        DataCell(Text(data["CGST"].toString())),
        DataCell(Text(data["SGST"].toString())),
        DataCell(Text(data["TOTAL TAX AMT"].toString())),
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
