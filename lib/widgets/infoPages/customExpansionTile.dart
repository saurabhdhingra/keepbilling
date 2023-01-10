import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keepbilling/utils/functions.dart';
import 'description.dart';

class CustomExpansionTile extends StatelessWidget {
  final Map properties;
  final VoidCallback? editAction;
  final Map data;
  const CustomExpansionTile(
      {Key? key, required this.properties, required this.data, this.editAction})
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
      children: fields(properties["entries"]),
    );
  }

  List<Widget> fields(List<Map> properties) {
    List<Widget> widgets = [];
    for (int i = 0; i < properties.length + 1; i++) {
      if (i == properties.length && editAction != null) {
        widgets.add(
          Align(
            alignment: const AlignmentDirectional(0.9, 0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.pencil),
              onPressed: editAction,
            ),
          ),
        );
      } else if (i == properties.length && editAction == null) {
        continue;
      } else {
        widgets.add(
          Description(
            text: properties[i]["fieldName"] +
                " : " +
                data["${properties[i]["fieldValue"]}"],
          ),
        );
      }
    }
    return widgets;
  }
}
