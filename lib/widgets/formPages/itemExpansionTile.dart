import 'package:flutter/material.dart';
import '../../../widgets/infoPages/description.dart';

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
    return ExpansionTile(
      title: properties["title"] == "item"
          ? Text(itemName)
          : Text(data["${properties["title"]}"]),
      subtitle: Text(data["${properties["subtitle"]}"]),
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
