import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/profile.dart';
import '../../utils/constants.dart';
import '../../widgets/formPages/titleText.dart';
import '../loadingScreens.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({Key? key}) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  bool isLoading = false;
  List data = [];

  ProfileService service = ProfileService();

  String companyId = "";
  String userId = "";

  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    data = await service.fetchTransactions(userId, companyId);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return isLoading
        ? reportsLoading(context)
        : Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const TitleText(text: "Transactions"),
                  SizedBox(
                    height: height * 0.056 * (data.length + 1),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: <DataColumn>[
                          customDataColumn('Date'),
                          customDataColumn('Invoice Number'),
                          customDataColumn('Amount'),
                          customDataColumn('Status'),
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
                ],
              ),
            ),
          );
  }

  DataRow customDataRow(Map data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data["tx_date"] ?? "")),
        DataCell(Text(data["txnid"] ?? "")),
        DataCell(Text(data["amt_deducted"] ?? "")),
        DataCell(Text(data["txn_status"] ?? "")),
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
