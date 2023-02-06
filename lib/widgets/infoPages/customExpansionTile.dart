import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keepbilling/utils/functions.dart';
import '../../utils/constants.dart';
import 'description.dart';

class CustomExpansionTile extends StatelessWidget {
  final Map properties;

  final VoidCallback? editAction;
  final VoidCallback? pdfAction;
  final Map data;
  const CustomExpansionTile({
    Key? key,
    required this.properties,
    required this.data,
    this.editAction,
    this.pdfAction,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    return ExpansionTile(
      title:  Text(data["${properties["title"]}"]),
      subtitle: Text(data["${properties["subtitle"]}"]),
      textColor: Colors.black87,
      iconColor: Colors.black87,
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: fields(properties["entries"], width),
    );
  }

  List<Widget> fields(List<Map> properties, double width) {
    List<Widget> widgets = [];
    for (int i = 0; i < properties.length + 1; i++) {
      if (i == properties.length && editAction != null && pdfAction == null) {
        widgets.add(
          Align(
            alignment: const AlignmentDirectional(0.9, 0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.pencil),
              onPressed: editAction,
            ),
          ),
        );
      } else if (i == properties.length &&
          editAction != null &&
          pdfAction != null) {
        widgets.add(
          Row(
            children: [
              SizedBox(
                width: width * 0.7,
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.doc),
                onPressed: pdfAction,
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.pencil),
                onPressed: editAction,
              ),
            ],
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
