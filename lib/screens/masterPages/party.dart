import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/master.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:keepbilling/screens/masterPages/addPages/addParty.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../provider/authenticationProvider.dart';
import '../../widgets/infoPages/CustomExpansionTile.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../searchBarDelegate.dart';
import 'editPages/editParty.dart';

class PartyMaster extends StatefulWidget {
  const PartyMaster({Key? key}) : super(key: key);

  @override
  State<PartyMaster> createState() => _PartyMasterState();
}

class _PartyMasterState extends State<PartyMaster> {
  bool isLoading = false;
  List dataList = [];
  List stateList = [];

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
          await service.fetchDataList(userId, companyId, "party", product);
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
          await service.fetchDataList(userId, companyId, "party", product);
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
      "title": "party_name",
      "subtitle": "party_mobile",
      "entries": [
        {"fieldName": "Address", "fieldValue": "party_address"},
        {"fieldName": "Email", "fieldValue": "party_email"},
        {"fieldName": "Opening Balance", "fieldValue": "opening_bal"},
        {"fieldName": "GST No.", "fieldValue": "party_gst"}
      ]
    };
    return isLoading
        ? infoLoading(context)
        : ScreenTypeLayout(
            mobile: Scaffold(
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                  var navigationResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddPartyMaster(product: product, isTab: false),
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
                        text: "Party",
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
                              child: CustomExpansionTile(
                                data: e,
                                properties: propeties,
                                editAction: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPartyMaster(
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
                child: const Icon(Icons.add),
                onPressed: () async {
                  var navigationResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddPartyMaster(product: product, isTab: true),
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
                        text: "Party",
                        style: TextStyle(
                          fontSize: height * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ...dataList.map(
                        (e) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            child: Theme(
                              data: theme,
                              child: CustomExpansionTile(
                                data: e,
                                isTab: true,
                                properties: propeties,
                                editAction: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPartyMaster(
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
