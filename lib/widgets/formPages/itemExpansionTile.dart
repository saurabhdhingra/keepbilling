import 'package:flutter/material.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import '../../../widgets/infoPages/description.dart';
import '../../utils/constants.dart';

class ItemExpansionTile extends StatelessWidget {
  final Map properties;
  final Map data;
  final VoidCallback deleteFunc;
  final VoidCallback updateFunc;
  final String itemName;
  const ItemExpansionTile(
      {Key? key,
      required this.properties,
      required this.data,
      required this.deleteFunc,
      required this.updateFunc,
      this.itemName = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    var height = SizeConfig.getHeight(context);
    return ScreenTypeLayout(
      mobile: tileChild(height, width, false),
      tablet: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: tileChild(height, width, true),
      ),
    );
  }

  ExpansionTile tileChild(double height, double width, bool isTab) {
    return ExpansionTile(
      title: properties["title"] == "item"
          ? Text(
              itemName,
              style:
                  TextStyle(fontSize: isTab ? height * 0.025 : height * 0.03),
            )
          : Text(
              data["${properties["title"]}"],
              style:
                  TextStyle(fontSize: isTab ? height * 0.025 : height * 0.03),
            ),
      subtitle: Text(
        data["${properties["subtitle"]}"],
        style: TextStyle(fontSize: isTab ? height * 0.022 : height * 0.02),
      ),
      textColor: Colors.black87,
      iconColor: Colors.black87,
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...fields(properties["entries"]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: (() => deleteFunc()),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
            IconButton(
              onPressed: (() => updateFunc()),
              icon: const Icon(Icons.edit, color: Colors.grey),
            ),
          ],
        )
      ],
    );
  }

  List<Widget> fields(List<Map> properties) {
    List<Widget> widgets = [];
    for (int i = 0; i < properties.length; i++) {
      widgets.add(
        Description(
          property: properties[i]["fieldName"] + " : ",
          value: data["${properties[i]["fieldValue"]}"].toString(),
        ),
      );
    }
    return widgets;
  }
}
