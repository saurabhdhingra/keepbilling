import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/master.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants.dart';
import '../../widgets/infoPages/CustomExpansionTile.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../searchBarDelegate.dart';
import 'addPages/addQuotation.dart';
import 'editPages/editQuotation.dart';

class QuotationMaster extends StatefulWidget {
  const QuotationMaster({Key? key}) : super(key: key);

  @override
  State<QuotationMaster> createState() => _QuotationMasterState();
}

class _QuotationMasterState extends State<QuotationMaster> {
  bool isLoading = false;
  List dataList = [];
  List partyList = [];
  List itemList = [];

  String userId = "";
  String companyId = "";
  MasterService service = MasterService();
  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    dataList = await service.fetchDataList(userId, companyId, "quotation");
    partyList = await service.fetchDataList(userId, companyId, "party");
    itemList = await service.fetchDataList(userId, companyId, "item");
    setState(() => isLoading = false);
  }

  Future getUpdatedData() async {
    setState(() => isLoading = true);
    dataList = await service.fetchDataList(userId, companyId, "quotation");
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
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    final Map propeties = {
      "title": "subject",
      "subtitle": "build_date",
      "entries": [
        {"fieldName": "Comment", "fieldValue": "comment"},
      ]
    };
    List parties = [
      {"id": "", "party_name": "Unselected"},
      ...partyList
    ];
    List items = [
      {
        "id": "",
        "item_name": "Unselected",
        "s_rate": "",
        "tax": "",
      },
      ...itemList
    ];

    return isLoading
        ? infoLoading(context)
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                var navigationResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddQuotationMaster(
                      partyList: parties,
                      itemList: items,
                    ),
                  ),
                );
                if (navigationResult == "update") {
                  getUpdatedData();
                }
              },
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
                      text: "Quotation",
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ...dataList.map(
                      (e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
                          child: Theme(
                            data: theme,
                            child: CustomExpansionTile(
                              data: e,
                              properties: propeties,
                              editAction: () async {
                                var navigationResult = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditQuotationMaster(
                                      itemList: items,
                                      partyList: parties,
                                      data: e,
                                    ),
                                  ),
                                );
                                if (navigationResult == "update") {
                                  getUpdatedData();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: height * 0.2),
                  ],
                ),
              ),
            ),
          );
  }
}
