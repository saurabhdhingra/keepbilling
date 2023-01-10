import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/constants.dart';

class Settings extends StatefulWidget {
  
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

    @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          height * 0.0,
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SizedBox(
        width: width,
        height: height * 0.8,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          padding: EdgeInsets.zero,
          itemBuilder: (context, int index) {
            return ListTile(
              // leading: Image.asset(
              //   tabs[index]["icon"],
              //   height: height * 0.04,
              // ),
              title: Text(
                tabs[index]["title"],
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
            );
          },
          separatorBuilder: (context, index) => Container(
            color: Colors.grey.shade300,
            height: height * 0.005,
          ),
        ),
      ),
    );
  }
}
