import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keepbilling/utils/functions.dart';
import '../../utils/constants.dart';
import 'description.dart';

class CustomExpansionTile extends StatefulWidget {
  final Map properties;

  final VoidCallback? editAction;
  final VoidCallback? pdfAction;
  final VoidCallback? payAction;
  final Map data;
  final List? groups;
  final String? partyName;
  final bool? isTab;
  const CustomExpansionTile({
    Key? key,
    required this.properties,
    required this.data,
    this.editAction,
    this.pdfAction,
    this.partyName = "",
    this.groups,
    this.payAction,
    this.isTab = false,
  }) : super(key: key);

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    var height = SizeConfig.getHeight(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.005),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: ExpansionTile(
          title: Text(
            widget.data["${widget.properties["title"]}"] ?? "",
            style: TextStyle(
                fontSize:
                    (widget.isTab ?? false) ? height * 0.025 : height * 0.03),
          ),
          subtitle: Text(
            widget.data["${widget.properties["subtitle"]}"],
            style: TextStyle(
                fontSize:
                    (widget.isTab ?? false) ? height * 0.022 : height * 0.02),
          ),
          textColor: Colors.black87,
          iconColor: Colors.black87,
          backgroundColor: const Color.fromARGB(255, 16, 196, 160),
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: fields(widget.properties["entries"], width),
        ),
      ),
    );
  }

  List<Widget> fields(List<Map> properties, double width) {
    List<Widget> widgets = [];
    for (int i = 0; i < properties.length + 1; i++) {
      if (i == properties.length &&
          widget.editAction != null &&
          widget.pdfAction == null) {
        widgets.add(
          Align(
            alignment:
                AlignmentDirectional((widget.isTab ?? false) ? 0.95 : 0.9, 0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.pencil),
              onPressed: widget.editAction,
            ),
          ),
        );
      } else if (i == properties.length &&
          widget.editAction != null &&
          widget.pdfAction != null) {
        widgets.add(
          Row(
            children: [
              SizedBox(
                width: width * 0.7,
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.doc),
                onPressed: widget.pdfAction,
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.pencil),
                onPressed: widget.editAction,
              ),
            ],
          ),
        );
      } else if (i == properties.length && widget.payAction != null) {
        widgets.add(
          Align(
            alignment: const AlignmentDirectional(0.9, 0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.money_dollar),
              onPressed: widget.payAction,
            ),
          ),
        );
      } else if (i == properties.length && widget.editAction == null) {
        continue;
      } else {
        if (properties[i]["fieldName"] == "under" && widget.groups != null) {
          widgets.add(
            Description(
              property: properties[i]["fieldName"] + " : ",
              value: widget
                  .groups![widget.data["${properties[i]["fieldValue"]}"]]
                  .toString(),
            ),
          );
        } else if (properties[i]["fieldName"] == "party_name" &&
            widget.partyName != null) {
          widgets.add(
            Description(
              property: "Party : ",
              value: widget.partyName ?? "",
            ),
          );
        } else {
          widgets.add(
            Description(
              property: properties[i]["fieldName"] + " : ",
              value: widget.data["${properties[i]["fieldValue"]}"].toString(),
            ),
          );
        }
      }
    }
    return widgets;
  }
}
