import 'package:flutter/material.dart';
import '../../../widgets/infoPages/description.dart';

class ItemExpansionTile extends StatelessWidget {
  final Map properties;
  final Map data;
  final VoidCallback deleteFunc;
  final VoidCallback updateFunc;
  const ItemExpansionTile(
      {Key? key,
      required this.properties,
      required this.data,
      required this.deleteFunc,
      required this.updateFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(data["${properties["title"]}"]),
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
          text: properties[i]["fieldName"] +
              " : " +
              data["${properties[i]["fieldValue"]}"],
        ),
      );
    }
    return widgets;
  }
}
