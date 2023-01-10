import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';

class CupertinoDateSelector extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) setFunction;
  const CupertinoDateSelector(
      {Key? key, required this.initialDate, required this.setFunction})
      : super(key: key);

  @override
  State<CupertinoDateSelector> createState() => _CupertinoDateSelectorState();
}

class _CupertinoDateSelectorState extends State<CupertinoDateSelector> {
  TextEditingController dateInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Padding(
      padding: Platform.isIOS
          ? EdgeInsets.fromLTRB(
              width * 0.02, height * 0.01, width * 0.02, height * 0.02)
          : EdgeInsets.symmetric(horizontal: width * 0.05),
      child: SizedBox(
        height: height * 0.07,
        child: Platform.isIOS
            ? CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: widget.initialDate,
                onDateTimeChanged: (dateTime) {
                  widget.setFunction(dateTime);
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

                    setState(() {
                      dateInput.text = formattedDate;
                    });
                  } else {}
                },
              ),
      ),
    );
  }
}
