import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';

import '../../utils/constants.dart';
import '../../utils/functions.dart';

class CupertinoDateSelector extends StatefulWidget {
  final dynamic initialDate;
  final Function(DateTime) setFunction;
  final VoidCallback? reset;
  final bool showReset;
  const CupertinoDateSelector(
      {Key? key,
      required this.initialDate,
      required this.setFunction,
      this.reset,
      this.showReset = true})
      : super(key: key);

  @override
  State<CupertinoDateSelector> createState() => _CupertinoDateSelectorState();
}

class _CupertinoDateSelectorState extends State<CupertinoDateSelector> {
  bool isSet = false;
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSet = widget.initialDate == "" ? false : true;
    dateInput.text =
        widget.initialDate == "" ? "" : formatDate(widget.initialDate);
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return ScreenTypeLayout(
      mobile: Padding(
        padding: Platform.isIOS
            ? EdgeInsets.fromLTRB(
                width * 0.02, height * 0.01, width * 0.02, height * 0.02)
            : EdgeInsets.symmetric(horizontal: width * 0.05),
        child: columnChild(height, context, width),
      ),
      tablet: Padding(
        padding: Platform.isIOS
            ? EdgeInsets.fromLTRB(
                width * 0.08, height * 0.01, width * 0.08, height * 0.02)
            : EdgeInsets.symmetric(horizontal: width * 0.09),
        child: columnChild(height, context, width),
      ),
    );
  }

  Column columnChild(height, BuildContext context, width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height * 0.07,
          child: Platform.isIOS
              ? CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: isSet ? widget.initialDate : DateTime.now(),
                  onDateTimeChanged: (dateTime) {
                    widget.setFunction(dateTime);
                    setState(() => isSet = true);
                  },
                )
              : TextField(
                  controller: dateInput,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(Icons.calendar_today,
                          color: Colors.black), //icon of text field
                      hintText: "Enter Date" //label text of field
                      ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      setState(
                        () {
                          dateInput.text = formattedDate;
                          isSet = true;
                        },
                      );
                    } else {}
                  },
                ),
        ),
        widget.showReset
            ? SizedBox(
                height: height * 0.025,
                child: FittedBox(
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.02),
                      Text(
                        isSet ? "Date is set." : "No date is set.",
                      ),
                      isSet
                          ? GestureDetector(
                              onTap: () {
                                setState(() => isSet = false);
                                widget.reset;
                                dateInput.text = "";
                              },
                              child: const Text(
                                " Reset ?",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
