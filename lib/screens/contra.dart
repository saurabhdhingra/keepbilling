import 'package:flutter/material.dart';
import 'package:keepbilling/api/transaction.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../provider/authenticationProvider.dart';
import '../widgets/infoPages/CustomExpansionTile.dart';
import '../widgets/infoPages/paddedText.dart';
import 'searchBarDelegate.dart';

class ContraTransaction extends StatefulWidget {
  const ContraTransaction({Key? key}) : super(key: key);

  @override
  State<ContraTransaction> createState() => _ContraTransactionState();
}

class _ContraTransactionState extends State<ContraTransaction> {
  bool isLoading = false;
  List dataList = [];

  TransactionsService service = TransactionsService();

  String companyId = "";
  String userId = "";

  Future getData() async {
    setState(() => isLoading = true);

    dataList = await service.fetchDataList("contra", "1", "2");

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    final Map propeties = {
      "title": "narration",
      "subtitle": "inv_date",
      "entries": [
        {"fieldName": "Amount", "fieldValue": "amount"},
        {"fieldName": "via", "fieldValue": "via"},
        {"fieldName": "Payment Type", "fieldValue": "pymnt_type"},
      ]
    };
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
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
                      delegate: SearchBar(dataList, propeties),
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
                    PaddedText(
                      text: "Contra",
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.9,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                            child: Theme(
                              data: theme,
                              child: CustomExpansionTile(
                                data: dataList[index],
                                properties: propeties,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
