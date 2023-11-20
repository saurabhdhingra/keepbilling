import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/master.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/searchBarDelegate.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../provider/authenticationProvider.dart';
import '../../widgets/infoPages/CustomExpansionTile.dart';
import '../../widgets/infoPages/paddedText.dart';
import 'addPages/addBank.dart';
import 'editPages/editBank.dart';

class BankMaster extends StatefulWidget {
  const BankMaster({Key? key}) : super(key: key);

  @override
  State<BankMaster> createState() => _BankMasterState();
}

class _BankMasterState extends State<BankMaster> {
  bool isLoading = false;

  List dataList = [];

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
          await service.fetchDataList(userId, companyId, "bank", product);
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
          await service.fetchDataList(userId, companyId, "bank", product);
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

    final Map propeties = {
      "title": "bank_name",
      "subtitle": "balance",
      "entries": [
        {"fieldName": "Account Name", "fieldValue": "account_name"},
        {"fieldName": "Account Number", "fieldValue": "account_no"},
      ]
    };
    return isLoading
        ? infoLoading(context)
        : ScreenTypeLayout(
            mobile: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(3, 195, 237, 1),
                child: const Icon(Icons.add),
                onPressed: () async {
                  var navigationResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBankMaster(
                        product: product,
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
                        delegate: SearchBarDelegate(
                          dataList,
                          propeties,
                        ),
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
                      const PaddedText(
                        text: "Bank"
                        
                      ),
                      ...dataList.map(
                        (e) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, 0, width * 0.02, 0),
                            child: Theme(
                              data: theme,
                              child: CustomExpansionTile(
                                data: e,
                                isTab: false,
                                properties: propeties,
                                color: e["def"] == "Y" ? Colors.blue : null,
                                editAction: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditBankMaster(
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
                          );
                        },
                      ),
                      SizedBox(height: height * 0.1),
                    ],
                  ),
                ),
              ),
            ),
            tablet: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(3, 195, 237, 1),
                onPressed: () async {
                  var navigationResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBankMaster(
                        product: product,
                      ),
                    ),
                  );
                  if (navigationResult == "update") {
                    getUpdatedData();
                  }
                },
                child: const Icon(Icons.add),
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
                        delegate: SearchBarDelegate(
                          dataList,
                          propeties,
                        ),
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
                      const PaddedText(text: "Bank"),
                      ...dataList.map(
                        (e) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, 0, width * 0.02, 0),
                            child: Theme(
                              data: theme,
                              child: CustomExpansionTile(
                                data: e,
                                properties: propeties,
                                isTab: true,
                                color: e["def"] == "Y" ? Colors.blue : null,
                                editAction: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditBankMaster(
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
                          );
                        },
                      ),
                      SizedBox(height: height * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
