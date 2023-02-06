import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/master.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/searchBarDelegate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/widgets/infoPages/CustomExpansionTile.dart';
import '../../../utils/constants.dart';
import '../../widgets/infoPages/paddedText.dart';
import 'addPages/addItem.dart';
import 'editPages/editItem.dart';

class ItemMaster extends StatefulWidget {
  const ItemMaster({Key? key}) : super(key: key);

  @override
  State<ItemMaster> createState() => _ItemMasterState();
}

class _ItemMasterState extends State<ItemMaster> {
  bool isLoading = false;
  List dataList = [];
  List groups = [];
  List units = [];

  String userId = "";
  String companyId = "";
  MasterService service = MasterService();
  Future getData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    companyId = prefs.getString('companyId') ?? "";
    dataList = await service.fetchDataList(userId, companyId, "item");
    groups = await service.fetchDataList(userId, companyId, "allgroup");
    units = await service.fetchDataList(userId, companyId, "allunit");
    setState(() => isLoading = false);
  }

  Future getUpdatedData() async {
    setState(() => isLoading = true);
    dataList = await service.fetchDataList(userId, companyId, "item");
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
    List groupsList = [
      {"item_group_name": "Unselected", "id": ""},
      ...groups
    ];
    List unitsList = [
      {"id": "", "item_uom_name": "Unselected"},
      ...units
    ];
    final Map propeties = {
      "title": "item_name",
      "subtitle": "item_stock",
       
      "entries": [
        {"fieldName": "Type", "fieldValue": "item_type"},
        {"fieldName": "HSN_SAC", "fieldValue": "hsn_sac"},
      ]
    };
    return isLoading
        ? infoLoading(context)
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                var navigationResult = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemMaster(
                      groups: groupsList,
                      units: unitsList,
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
                      text: "Item",
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
                                    builder: (context) => EditItemMaster(
                                      groups: groupsList,
                                      units: unitsList,
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
                    SizedBox(height: height * 0.1),
                  ],
                ),
              ),
            ),
          );
  }
}
