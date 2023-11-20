import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/api/master.dart';
import 'package:keepbilling/screens/loadingScreens.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../provider/authenticationProvider.dart';
import '../../widgets/infoPages/paddedText.dart';
import '../searchBarDelegate.dart';

class BillMaster extends StatefulWidget {
  const BillMaster({Key? key}) : super(key: key);

  @override
  State<BillMaster> createState() => _BillMasterState();
}

class _BillMasterState extends State<BillMaster> {
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
      dataList = await service.fetchDataList(userId, companyId, "billprefix",product);
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
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    final Map propeties = {
      "title": "prefix_name",
      "subtitle": "is_default",
      "entries": [
        {"fieldName": "Flag", "fieldValue": "flag"},
      ]
    };
    return isLoading
        ? infoLoading(context)
        : Scaffold(
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
                    const PaddedText(
                      text: "Bill Prefix"
                      
                    ),
                    ...dataList.map(
                      (e) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, 0, width * 0.02, 0),
                          child: ListTile(
                            title: Text(
                              e["prefix_name"],
                            ),
                            subtitle: e["is_default"] == "YES"
                                ? const Text("DEFAULT")
                                : const SizedBox(),
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
