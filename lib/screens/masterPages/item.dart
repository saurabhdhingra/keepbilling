import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/master.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/searchBarDelegate.dart';
import 'package:provider/provider.dart';
import '../../provider/authenticationProvider.dart';
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
  String product = "";

  MasterService service = MasterService();

  Future getData() async {
    setState(() => isLoading = true);
    userId = Provider.of<AuthenticationProvider>(context, listen: false).userid;
    companyId =
        Provider.of<AuthenticationProvider>(context, listen: false).companyid;
    product =
        Provider.of<AuthenticationProvider>(context, listen: false).product;
    try {
      dataList =
          await service.fetchDataList(userId, companyId, "item", product);
      groups =
          await service.fetchDataList(userId, companyId, "allgroup", product);
      units =
          await service.fetchDataList(userId, companyId, "allunit", product);
      addGroup(dataList, groups);
    } catch (e) {
      dataList = [];
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  Future getUpdatedData() async {
    setState(() => isLoading = true);
    try {
      dataList =
          await service.fetchDataList(userId, companyId, "item", product);
       addGroup(dataList, groups);
    } catch (e) {
      dataList = [];
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    setState(() => isLoading = false);
  }

  Future getUpdatedGUs() async {
    setState(() => isLoading = true);
    try {
      groups =
          await service.fetchDataList(userId, companyId, "allgroup", product);
      units =
          await service.fetchDataList(userId, companyId, "allunit", product);
    } catch (e) {
      dataList = [];
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
        {"fieldName": "Group", "fieldValue": "group"},
        {"fieldName": "HSN_SAC", "fieldValue": "hsn_sac"},
        {"fieldName": "Tax %", "fieldValue": "tax"},
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
                      product: product,
                    ),
                  ),
                );
                if (navigationResult == "update") {
                  getUpdatedData();
                } else if (navigationResult == "update and gus") {
                  getUpdatedData();
                  getUpdatedGUs();
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
                      delegate: SearchBarDelegate(dataList, propeties),
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
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, 0, width * 0.02, 0),
                          child: Theme(
                            data: theme,
                            child: ScreenTypeLayout(
                              mobile: CustomExpansionTile(
                                data: e,
                                properties: propeties,
                                groups: groups,
                                editAction: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditItemMaster(
                                        groups: groupsList,
                                        units: unitsList,
                                        data: e,
                                        product: product,
                                      ),
                                    ),
                                  );
                                  if (navigationResult == "update") {
                                    getUpdatedData();
                                  }
                                },
                              ),
                              tablet: CustomExpansionTile(
                                data: e,
                                properties: propeties,
                                groups: groups,
                                isTab: true,
                                editAction: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditItemMaster(
                                        groups: groupsList,
                                        units: unitsList,
                                        data: e,
                                        product: product,
                                      ),
                                    ),
                                  );
                                  if (navigationResult == "update") {
                                    getUpdatedData();
                                  }
                                },
                              ),
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

  void addGroup(List dataList, List groups) {
    for (int i = 0; i < dataList.length; i++) {
      String groupId = dataList[i]["under"];
      String groupName = "";
      for (int j = 0; j < groups.length; j++) {
        if (groups[j]["id"] == groupId) {
          groupName = groups[j]["item_group_name"];
        }
      }
      dataList[i]["group"] = groupName;
    }
  }
}
